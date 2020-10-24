//
//  SaveXMLFile.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 23.10.2020.
//

import Foundation
import Cocoa

func saveXMLFile()  {
    let root = XMLElement(name: "root")
    let xml = XMLDocument(rootElement: root)
    root.addChild(XMLElement(name: "fuck"))
    let openPanel = NSOpenPanel()       // Authorize access in sandboxed mode
    openPanel.message = NSLocalizedString("Select folder where to create file\n(Necessary to manage security on this computer)", comment: "enableFileMenuItems")
    openPanel.prompt = NSLocalizedString("Select", comment: "enableFileMenuItems")
    openPanel.canChooseFiles = false    // Only select or create Directory here ; you can select the real Desktop
    openPanel.canChooseDirectories = true
    openPanel.canCreateDirectories = true
    openPanel.begin() {                              // In the completion, Save the file
        (result2) -> Void in
        if result2 == NSApplication.ModalResponse.OK {
            let savePanel = NSSavePanel()
            savePanel.title = NSLocalizedString("File to create", comment: "enableFileMenuItems")
            savePanel.nameFieldStringValue = ""
            savePanel.prompt = NSLocalizedString("Create", comment: "enableFileMenuItems")
            savePanel.allowedFileTypes = ["xml"]   // if you want to specify file signature
            let fileManager = FileManager.default
            
            savePanel.begin() { (result) -> Void in
                if result == NSApplication.ModalResponse.OK {
                    let fileWithExtensionURL = savePanel.url!  //  May test that file does not exist already
                    if fileManager.fileExists(atPath: fileWithExtensionURL.path) {
                        
                    } else {
                        do {
                            try xml.xmlString.write(to: fileWithExtensionURL, atomically: false, encoding: .utf8)
                        }
                        catch {
                            
                        }
                    }
                }
            }
        }
    }
}
