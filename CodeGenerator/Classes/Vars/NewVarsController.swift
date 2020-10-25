//
//  NewVarsController.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 25.10.2020.
//

import Cocoa

class NewVarsController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var types: NSPopUpButton!
    @IBOutlet weak var textField: NSTextField!
    var typesArray = [VarType]()
    var directoryItems = [ModelType]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        for value in VarType.allCases {
            typesArray.append(value)
            types.addItem(withTitle: value.name())
        }
        directoryItems = AppDelegate.genModel.getArrayType()
    }
    
    @IBAction func add(_ sender: Any) {
        AppDelegate.genModel.addType(name: textField.stringValue, type: typesArray[types.indexOfSelectedItem] )
        directoryItems = AppDelegate.genModel.getArrayType() 
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

extension NewVarsController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return directoryItems.count
    }
}

extension NewVarsController: NSTableViewDelegate {
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
        static let DateCell = "Cell2"
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var text: String = ""
        var cellIdentifier: String = ""
        let item = directoryItems[row]
        if tableColumn == tableView.tableColumns[0] {
            text = item.name
            cellIdentifier = CellIdentifiers.NameCell
        } else
        if tableColumn == tableView.tableColumns[1] {
            text = item.type.rawValue
            cellIdentifier = CellIdentifiers.DateCell
        }
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        
        return nil
    }
    
}
