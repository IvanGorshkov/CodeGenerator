//
//  DeleteAlert.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 30.10.2020.
//

import Cocoa

class Alert: NSAlert {
    private let question: String
    private let text: String
    init(question: String, text: String) {
        self.question = question
        self.text = text
        
    }
    
    func showDeleteAlert() -> Bool {
        messageText = question
        informativeText = text
        alertStyle = NSAlert.Style.informational
        addButton(withTitle: "Да")
        addButton(withTitle: "Нет")
        let res = runModal()
        if res == NSApplication.ModalResponse.alertFirstButtonReturn {
            return true
        }
        return false
    }
    
    func showError() {
        messageText = question
        informativeText = text 
        alertStyle = NSAlert.Style.informational
        addButton(withTitle: "Понятно")
        runModal()
    }
}
