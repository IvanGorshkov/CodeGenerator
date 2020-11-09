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
    
    @IBAction func export(_ sender: NSMenuItem) {
        let generation = Generation(generated: GenModelController.shared)
        if !generation.algIsCorrect() {
            let errorAlert = DeleteAlert(question: "Ошибка при генерации", text: generation.getError())
            errorAlert.showError()
            return
        }
        exportPasFile(pascal: generation.generat())
    }
    
    @IBAction func selectAnImageFromFile(sender: AnyObject) {
        let openPanel = NSOpenPanel()
        var xmlString = ""
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.begin { (result) -> Void in
            if result == .OK {
                xmlString = openPanel.url!.path
                let parseXMLFile = XMLParserAlg()
                GenModelController.shared.blocksList.removeAll()
                GenModelController.shared.removeTypeAll()
                parseXMLFile.parseXMLFile(path: xmlString)
                if let window = NSApplication.shared.mainWindow {
                    if let viewController = window.contentViewController as? ViewController {
                        viewController.reloadTable()
                    }
                }
            }
            
        }
    }
}
