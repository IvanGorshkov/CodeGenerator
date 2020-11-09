//
//  EditBlockStreamViewController.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 29.10.2020.
//

import Cocoa

class EditBlockStreamViewController: NSViewController {
    private(set) var popUpInitiallySelectedItem: NSMenuItem?
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var types: NSPopUpButton!
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var blockName: NSTextField!
    var streamInArray = [inS]()
    var streamOutArray = [outS]()
    var sentacis = [String]()
    var nameFunc = ""
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
    
    @IBAction func popUpSelectionDidChange(_ sender: NSPopUpButton) {
        if sender.selectedItem === popUpInitiallySelectedItem {
            nameFunc = types.selectedItem!.title
        } else {
            nameFunc = types.selectedItem!.title
        }
    }
    
    @IBAction func add(_ sender: Any) {
        let answer = DeleteAlert(question: "Ошибка данных", text: "Незаполненные данные")
        if myStream?.blocks == .instream {
            if textField.stringValue.isEmpty || streamInArray.isEmpty {
                answer.showError()
                return
            }
        } else {
            if textField.stringValue.isEmpty || streamOutArray.isEmpty {
                answer.showError()
                return
            }
            
        }
        sentacis.append("\(nameFunc)(\(textField.stringValue));")
        myStream?.values = sentacis
        tableView.reloadData()
        
        
    }
    
    @IBAction func close(_ sender: Any) {
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
        let index = notification.object as! NSTableView
        if index.selectedRow == -1 {
            return
        }
        
        DispatchQueue.main.async { [self] in
            let answer = DeleteAlert(question: "Удалить операцию", text: "Вы уверены, что хотите удалить операцию?")
            if answer.showAlrt() == true {
                let selectedTableView = notification.object as! NSTableView
                myStream?.values?.remove(at: selectedTableView.selectedRow)
                sentacis = myStream?.values ?? []
                
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
