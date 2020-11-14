//
//  SaveFileMenu.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 23.10.2020.
//

import Cocoa

class SaveFileMenu: NSMenu {
    @IBAction func clearFile(_ sender: NSMenuItem) {
        GenModelController.shared.blocksList.removeAll()
        GenModelController.shared.removeTypeAll()
        if let window = NSApplication.shared.mainWindow {
            if let viewController = window.contentViewController as? ViewController {
                viewController.reloadTable()
            }
        }
    }
    
    @IBAction func saveFile(_ sender: NSMenuItem) {
        let xmlFile = CreateXML()
        let xmlDoc = xmlFile.generateXML()
        let saveMenu = SaveingFiles(message: "Сохранить документ", prompt: "Выбрать", title: "Введите название документа", types: ["btc"], save: "Сохранить")
        saveMenu.saveDocument { (url) in
            do {
                let xmlData = xmlDoc.xmlData(options: .nodePrettyPrint)
                try xmlData.write(to: url)
            }
            catch {
                print("Error when writing to file")
            }
        }
    }
    
    @IBAction func export(_ sender: NSMenuItem) {
        let generation = Generation(generated: GenModelController.shared)
        if !generation.algIsCorrect() {
            let errorAlert = DeleteAlert(question: "Ошибка при генерации", text: generation.getError())
            errorAlert.showError()
            return
        }
        let pascalFile = generation.generat()
        let saveMenu = SaveingFiles(message: "Выбретите диркеторию для экспорта документа", prompt: "Выбрать", title: "файл для экспорта", types: ["pas"], save: "Экспорт")
        saveMenu.saveDocument { (url) in
            do {
                try pascalFile.write(to: url, atomically: false, encoding: .utf8)
            }
            catch {
                print("Error when writing to file")
            }
        }
    }
    
    @IBAction func openFile(sender: AnyObject) {
        let saveMenu = SaveingFiles(message: "", prompt: "", title: "", types: ["btc"], save: "")
        saveMenu.openDocument { (path) in
            let parseXMLFile = XMLParserAlg(path: path)
            GenModelController.shared.blocksList.removeAll()
            GenModelController.shared.removeTypeAll()
            parseXMLFile.parseXMLFile()
            if let window = NSApplication.shared.mainWindow {
                if let viewController = window.contentViewController as? ViewController {
                    viewController.reloadTable()
                }
            }
        }
    }
}
