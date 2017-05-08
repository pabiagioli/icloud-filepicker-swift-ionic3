//
//  DocumentPickerSwift.swift
//  
//
//  Created by Pablo Biagioli on 5/5/17.
//
//

import Foundation


@objc(DocumentPickerSwift) class DocumentPickerSwift: CDVPlugin, UIDocumentMenuDelegate, UIDocumentPickerDelegate {
    var pluginResult: CDVPluginResult?
    var command: CDVInvokedUrlCommand?
    
    func isSupported () -> Bool {
        return NSClassFromString("UIDocumentPickerViewController") != nil
    }
    
    @objc(isAvailable:)func isAvailable(command: CDVInvokedUrlCommand) {
        print("isAvailable - begin")
        let supported: Bool = isSupported()
        commandDelegate.sendPluginResult(CDVPluginResult(status: CDVCommandStatus_OK, messageAsBool: supported), callbackId: command.callbackId)
        print("isAvailable - end")
    }
    
    @objc(pickFile:)func pickFile(command: CDVInvokedUrlCommand) {
        print("pickFile - begin")
        self.command = command
        let UTIsArray: [String]
        let UTIs: Any? = command.arguments[0]
        var supported: Bool = true
        //var UTIsArray: [Any]? = nil
        if(!( UTIs is NSNull)) {
            if (UTIs is String) {
                UTIsArray = [UTIs as! String]
            }else if (UTIs is [String]){
                UTIsArray = UTIs as! [String]
            }else {
                supported = false
                UTIsArray = ["not supported"]
                commandDelegate.sendPluginResult(CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: UTIsArray[0]), callbackId: self.command?.callbackId)
            }
        }else{
            UTIsArray = ["public.data"]
        }
        
        if !isSupported() {
            supported = false
            commandDelegate.sendPluginResult(CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: "your device can't show the file picker"), callbackId: self.command?.callbackId)
        }
        if supported {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_NO_RESULT)
            pluginResult?.keepCallback = true
            
            displayDocumentPicker(UTIsArray)
        }
        print("pickFile - end")
    }
    
    // MARK: - UIDocumentMenuDelegate
    
    func documentMenu(documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .FullScreen
        viewController.presentViewController(documentPicker, animated: true, completion: { _ in })
    }
    
    func documentMenuWasCancelled(documentMenu: UIDocumentMenuViewController) {
        pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: "canceled")
        pluginResult?.keepCallback = false
        commandDelegate.sendPluginResult(pluginResult, callbackId: command?.callbackId)
    }
    // MARK: - UIDocumentPickerDelegate
    //documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL)
    func documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL) {
        pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: url.path)
        pluginResult?.keepCallback = false
        commandDelegate.sendPluginResult(pluginResult, callbackId: command?.callbackId)
    }
    
    func documentPickerWasCancelled(controller: UIDocumentPickerViewController) {
        pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: "canceled")
        pluginResult?.keepCallback = false
        commandDelegate.sendPluginResult(pluginResult, callbackId: command?.callbackId)
    }
    
    func displayDocumentPicker(UTIs: [String]) {
        let importMenu = UIDocumentMenuViewController(documentTypes: UTIs, inMode: .Import)
        importMenu.delegate = self
        importMenu.popoverPresentationController?.sourceView = viewController.view
        viewController.presentViewController(importMenu, animated: true, completion: { _ in })
    }
}
