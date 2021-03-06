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
    @IBOutlet weak var blockName: NSTextField!
    private var typesArray = [ModelType]()
    private var directoryItems = [ModelType]()
    private var sentacis = [String]()
    var myProcess: ModelBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blockName.stringValue = "Блок: \(myProcess?.name ?? "")"
        sentacis = myProcess?.values ?? []
        tableView.delegate = self
        tableView.dataSource = self
        directoryItems = GenModelController.shared.getArrayType()
        for value in directoryItems {
            typesArray.append(value)
            types.addItem(withTitle: value.name)
        }
    }
    
    @IBAction private func add(_ sender: Any) {
        if textField.stringValue.isEmpty || typesArray.isEmpty {
            let answer = Alert(question: "Ошибка данных", text: "Незаполненные данные")
            answer.showError()
            return
        }
        
        sentacis.append("\(typesArray[types.indexOfSelectedItem].name) := \(textField.stringValue)")
        myProcess?.values = sentacis
        tableView.reloadData()
    }
    
    
    @IBAction private func close(_ sender: Any) {
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
            let answer = Alert(question: "Удалить операцию", text: "Вы уверены, что хотите удалить операцию?")
            if answer.showDeleteAlert() == true {
                let selectedTableView = notification.object as! NSTableView
                myProcess?.values?.remove(at: selectedTableView.selectedRow)
                sentacis = myProcess?.values ?? []
                let indexSet = IndexSet(integer:selectedTableView.selectedRow)
                tableView.removeRows(at:indexSet, withAnimation:.effectFade)
                tableView.reloadData()
            }
        }
    }
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let text = sentacis[row] 
        let cellIdentifier: String = "Cell1"
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        return nil
    }
}
