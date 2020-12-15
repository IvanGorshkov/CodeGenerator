//
//  EditBlockStreamViewController.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 29.10.2020.
//

import Cocoa

class EditBlockStreamViewController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var types: NSPopUpButton!
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var blockName: NSTextField!
    private var streamInArray = [inS]()
    private var streamOutArray = [outS]()
    private var sentacis = [String]()
    private var nameFunc = ""
    var myStream: ModelBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blockName.stringValue = "Блок: \(myStream?.name ?? "")"
        sentacis = myStream?.values ?? []
        tableView.delegate = self
        tableView.dataSource = self
        if myStream?.blocks == .instream {
            for value in inS.allCases {
                streamInArray.append(value)
                types.addItem(withTitle: value.name())
            }
        } else {
            for value in outS.allCases {
                streamOutArray.append(value)
                types.addItem(withTitle: value.name())
            }
        }
        
        nameFunc = types.selectedItem!.title
    }
    
    @IBAction private func popUpSelectionDidChange(_ sender: NSPopUpButton) {
        nameFunc = types.selectedItem!.title
    }
    
    private func findErrors() -> Bool {
        let answer = Alert(question: "Ошибка данных", text: "Незаполненные данные")
        if textField.stringValue.isEmpty {
            answer.showError()
            return true
        }
        return false;
    }
    
    @IBAction private func add(_ sender: Any) {
        if myStream?.blocks == .instream {
            if findErrors() {
                return
            }
        } else {
            if findErrors() {
                return
            }
        }
        sentacis.append("\(nameFunc)(\(textField.stringValue));")
        myStream?.values = sentacis
        tableView.reloadData()
    }
    
    @IBAction private func close(_ sender: Any) {
        if let controller = self.storyboard?.instantiateController(withIdentifier: "ViewController") as? ViewController {
            self.view.window?.contentViewController = controller
        }
    }
}

extension EditBlockStreamViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return sentacis.count
    }
}

extension EditBlockStreamViewController: NSTableViewDelegate {
    func tableViewSelectionDidChange(_ notification: Notification) {
        let selectedTableView = notification.object as! NSTableView
        if selectedTableView.selectedRow == -1 {
            return
        }
        
        DispatchQueue.main.async { [self] in
            let answer = Alert(question: "Удалить операцию", text: "Вы уверены, что хотите удалить операцию?")
            if answer.showDeleteAlert() == true {
                myStream?.values?.remove(at: selectedTableView.selectedRow)
                sentacis = myStream?.values ?? []
                let indexSet = IndexSet(integer:selectedTableView.selectedRow)
                tableView.removeRows(at:indexSet, withAnimation:.effectFade)
                tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let text = sentacis[row]
        let cellIdentifier = "Cell1"
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        
        return nil
    }
}
