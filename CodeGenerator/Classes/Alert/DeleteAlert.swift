//
//  DeleteAlert.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 30.10.2020.
//

import Cocoa

class DeleteAlert: NSAlert {
    init(question: String, text: String) {
        self.question = question
        self.text = text
        
    }
    func showAlrt() -> Bool {
        messageText = question ?? ""
        informativeText = text ?? ""
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
        messageText = question ?? ""
        informativeText = text ?? ""
        alertStyle = NSAlert.Style.informational
        addButton(withTitle: "Понятно")
        runModal()
    }
    
    let question: String?
    let text: String?
}
