//
//  NewVarsController.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 25.10.2020.
//

import Cocoa

class EditBlockProsessViewController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var types: NSPopUpButton!
    @IBOutlet weak var textField: NSTextField!
    var typesArray = [ModelType]()
    var directoryItems = [ModelType]()
    var sentacis = [String]()
    var pModelBlock: UnsafePointer<ModelBlock>?
    var tag: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        directoryItems = AppDelegate.genModel.getArrayType()
       // sentacis = AppDelegate.genModel.nodeAt(index: tag!)?.value.values
        for value in directoryItems {
            typesArray.append(value)
            types.addItem(withTitle: value.name)
        }
        
    }
    
    @IBAction func add(_ sender: Any) {
       // AppDelegate.genModel.addType(name: textField.stringValue, type:  )
      //  directoryItems = AppDelegate.genModel.getArrayType()
        sentacis.append("\(typesArray[types.indexOfSelectedItem].name) := \(textField.stringValue)")
        AppDelegate.genModel.nodeAt(index: tag!)?.value.values = sentacis
        tableView.reloadData()
    }
    
    func dialogOKCancel(question: String, text: String) -> Bool {
        let alert: NSAlert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = NSAlert.Style.informational
        alert.addButton(withTitle: "Да")
        alert.addButton(withTitle: "Нет")
        let res = alert.runModal()
        if res == NSApplication.ModalResponse.alertFirstButtonReturn {
            return true
        }
        return false
    }

    @IBAction func close(_ sender: Any) {
        if let controller = self.storyboard?.instantiateController(withIdentifier: "ViewController") as? ViewController {
            self.view.window?.contentViewController = controller
        }
    }
}

extension EditBlockProsessViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return sentacis.count
    }
}

extension EditBlockProsessViewController: NSTableViewDelegate {
    func tableViewSelectionDidChange(_ notification: Notification) {
        let index = notification.object as! NSTableView
        if index.selectedRow == -1 {
            return
        }
        
        DispatchQueue.main.async { [self] in
            let answer = dialogOKCancel(question: "Удалить переменную", text: "Вы уверены, что хотите удалить переменную?")
            if answer == true {
                let selectedTableView = notification.object as! NSTableView
                AppDelegate.genModel.removeType(index: selectedTableView.selectedRow)
                directoryItems = AppDelegate.genModel.getArrayType()
                let indexSet = IndexSet(integer:selectedTableView.selectedRow)
                tableView.removeRows(at:indexSet, withAnimation:.effectFade)
                tableView.reloadData()
            }
        }
    }
    
    fileprivate enum CellIdentifiers {
        static let NameCell = "Cell1"
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let text: String = sentacis[row] 
        var cellIdentifier: String = ""
        cellIdentifier = CellIdentifiers.NameCell
        
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        
        return nil
    }
    
}
