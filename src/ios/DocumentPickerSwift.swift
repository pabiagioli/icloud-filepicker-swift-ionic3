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
        commandDelegate.send(CDVPluginResult(status: CDVCommandStatus_OK, messageAs: supported), callbackId: command.callbackId)
        print("isAvailable - end")
    }
    @available(iOS 8.0, *)
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
                commandDelegate.send(CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: UTIsArray[0]), callbackId: self.command?.callbackId)
            }
        }else{
            UTIsArray = ["public.data"]
        }
        
        if !isSupported() {
            supported = false
            commandDelegate.send(CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "your device can't show the file picker"), callbackId: self.command?.callbackId)
        }
        if supported {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_NO_RESULT)
            pluginResult?.keepCallback = true
            displayDocumentPicker(UTIsArray)
        }
        print("pickFile - end")
    }
    
    // MARK: - UIDocumentMenuDelegate
    @available(iOS 8.0, *)
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .fullScreen
        viewController.present(documentPicker, animated: true, completion: { _ in })
    }
    @available(iOS 8.0, *)
    func documentMenuWasCancelled(_ documentMenu: UIDocumentMenuViewController) {
        pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "canceled")
        pluginResult?.keepCallback = false
        commandDelegate.send(pluginResult, callbackId: command?.callbackId)
    }
    // MARK: - UIDocumentPickerDelegate
    @available(iOS 8.0, *)
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: url.path)
        pluginResult?.keepCallback = false
        commandDelegate.send(pluginResult, callbackId: command?.callbackId)
    }
    @available(iOS 8.0, *)
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "canceled")
        pluginResult?.keepCallback = false
        commandDelegate.send(pluginResult, callbackId: command?.callbackId)
    }
    @available(iOS 8.0, *)
    func displayDocumentPicker(_ UTIs: [String]) {
        let importMenu = UIDocumentMenuViewController(documentTypes: UTIs, in: .import)
        importMenu.delegate = self
        importMenu.popoverPresentationController?.sourceView = viewController.view
        viewController.present(importMenu, animated: true, completion: { _ in })
    }
}
