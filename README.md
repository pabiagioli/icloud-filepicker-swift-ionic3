# icloud-filepicker-swift-ionic3
iCloud File Picker plugin for Ionic 3 made with Swift 3

This plugin makes possible to pick files from iCloud or other document providers


Installation:
============
```
cordova plugin add https://github.com/pabiagioli/icloud-filepicker-swift-ionic3.git
```

Usage:
=====

Pick a file
===========

If you don't pass any params, public.data UTI will be used

```ts
//first declare DocumentPickerSwift object in your *.ts file
declare var DocumentPickerSwift:any;
...
//Then check if the plugin is available and then open the file picker
var utis = ["public.image", "public.data", "com.adobe.pdf"];
DocumentPickerSwift.isAvailable((available)=>{
if(available){
    DocumentPickerSwift.pickFile(
    (file_path)=>{
        console.log("successfully picked a file "+file_path);
    }, 
    (errMsg)=>{
        console.log("No file picker, error: "+errMsg);
    }, utis);
}
});
```

You can pass the UTI as string
```ts
DocumentPickerSwift.pickFile(successCallback,errorCallback,"public.data");
```

If you want to pass more than one UTI you can pass an array of strings
```ts
var utis = ["public.data", "public.audio"];
DocumentPickerSwift.pickFile(successCallback,errorCallback,utis);
```

successCallback will bring the file url as string
errorCallback will bring an error message as string


See all the available UTIs https://developer.apple.com/library/ios/documentation/Miscellaneous/Reference/UTIRef/Articles/System-DeclaredUniformTypeIdentifiers.html

Prerequisites
=============

Before your app can use the document picker, you must turn on the iCloud Documents capabilities in Xcode.  

![](https://developer.apple.com/library/ios/documentation/FileManagement/Conceptual/DocumentPickerProgrammingGuide/Art/Enabling%20iCloud%20Documents_2x.png)

For more information:
[Apple Developer Guide: Document Picker Programming Guide - Introduction](https://developer.apple.com/library/ios/documentation/FileManagement/Conceptual/DocumentPickerProgrammingGuide/Introduction/Introduction.html)
