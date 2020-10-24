//
//  SaveFileMenu.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 23.10.2020.
//

import Cocoa

class SaveFileMenu: NSMenu {
    
    @IBAction func saveFile(_ sender: NSMenuItem) {
        saveXMLFile()
    }
}
