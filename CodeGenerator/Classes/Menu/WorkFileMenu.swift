//
//  SaveFileMenu.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 23.10.2020.
//

import Cocoa

class WorkFileMenu: NSMenu {
    @IBAction private func clearFile(_ sender: NSMenuItem) {
        GenModelController.shared.blocksList.removeAll()
        GenModelController.shared.removeTypeAll()
        if let window = NSApplication.shared.mainWindow {
            if let viewController = window.contentViewController as? ViewController {
                viewController.reloadTable()
            }
        }
    }
    func generateCurrentTimeStamp () -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd hh:mm:ss.SSS"
        return (formatter.string(from: Date()) as NSString) as String
    }
    
    @IBAction private func saveFile(_ sender: NSMenuItem) {
        let xmlFile = CreateXML()
        print(generateCurrentTimeStamp())
        let xmlDoc = xmlFile.generateXML()
        print(generateCurrentTimeStamp())
        let saveMenu = FileSystemWindow(message: "Сохранить документ", prompt: "Выбрать", title: "Введите название документа", types: ["btc"], save: "Сохранить")
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
    
    @IBAction private func export(_ sender: NSMenuItem) {
        var text = ""
        let genManager = GenManager();
        
        if !genManager.generate(analyzer: AnalyserPascal(data: GenModelController.shared), generation: GenerationPascal(generated:  GenModelController.shared), text: &text) {
            let errorAlert = Alert(question: "Ошибка при генерации", text: text)
            errorAlert.showError()
            return
        }
        let pascalFile = text
        let saveMenu = FileSystemWindow(message: "Выбретите диркеторию для экспорта документа", prompt: "Выбрать", title: "файл для экспорта", types: ["pas"], save: "Экспорт")
        saveMenu.saveDocument { (url) in
            do {
                try pascalFile.write(to: url, atomically: false, encoding: .utf8)
            }
            catch {
                print("Error when writing to file")
            }
        }
    }
    
    @IBAction private func openFile(sender: AnyObject) {
        let saveMenu = FileSystemWindow(message: "", prompt: "", title: "", types: ["btc"], save: "")
        saveMenu.openDocument { (path) in
            let parseXMLFile = XMLParserAlg(path: path)
            GenModelController.shared.blocksList.removeAll()
            GenModelController.shared.removeTypeAll()
            print(self.generateCurrentTimeStamp())
            parseXMLFile.parseXMLFile()
            print(self.generateCurrentTimeStamp())
            if let window = NSApplication.shared.mainWindow {
                if let viewController = window.contentViewController as? ViewController {
                    viewController.reloadTable()
                }
            }
        }
    }
}
