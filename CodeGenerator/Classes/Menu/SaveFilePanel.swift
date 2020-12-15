//
//  SaveXMLFile.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 23.10.2020.
//

import Foundation
import Cocoa

class FileSystemWindow {
    private let message: String
    private let prompt: String
    private let title: String
    private let types: [String]
    private let save: String
    private let openPanel = NSOpenPanel()
    
    init(message: String, prompt: String, title: String, types: [String], save: String) {
        self.message = message
        self.prompt = prompt
        self.title = title
        self.types = types
        self.save = save
    }
    
    func saveDocument(completion: @escaping (URL)->()) {
        let openPanel = NSOpenPanel()
        openPanel.message = NSLocalizedString(message, comment: "enableFileMenuItems")
        openPanel.prompt = NSLocalizedString(prompt, comment: "enableFileMenuItems")
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = true
        openPanel.begin() {
            (result2) -> Void in
            if result2 == .OK {
                let savePanel = NSSavePanel()
                savePanel.title = NSLocalizedString(self.title, comment: "enableFileMenuItems")
                savePanel.nameFieldStringValue = ""
                savePanel.prompt = NSLocalizedString(self.save, comment: "enableFileMenuItems")
                savePanel.allowedFileTypes = self.types
                savePanel.begin() { (result) -> Void in
                    if result == .OK {
                        let fileWithExtensionURL = savePanel.url!
                        completion(fileWithExtensionURL)
                    }
                }
            }
        }
    }
    
    func openDocument(completion: @escaping (String)->()) {
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.allowedFileTypes = types
        openPanel.begin { (result) -> Void in
            if result == .OK {
                completion(self.openPanel.url!.path)
            }
        }
    }
}
