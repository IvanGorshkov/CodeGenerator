//
//  EditIfBlockController.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 03.11.2020.
//

import Cocoa

class EditIfBlockController: NSViewController, CellDelegate {
    func didPressButton(_ tag: Int, _ table: Int) {
        guard let myIfModel = myIfModel else {
            return
        }
        if table == 1 {
            ifArray.remove(at: tag)
            let selectedIndex = myIfModel.left.index(myIfModel.left.startIndex, offsetBy: tag)
            myIfModel.left.remove(at: selectedIndex)
            tableViewIf.reloadData()
        } else {
            elseArray.remove(at: tag)
            let selectedIndex = myIfModel.right.index(myIfModel.right.startIndex, offsetBy: tag)
            myIfModel.right.remove(at: selectedIndex)
            tableViewElse.reloadData()
        }
        
    }
    
    func didPressButton(_ tag: Int) {
        print("I have pressed a button with a tag: \(tag)")
    }
    
    var tag: Int?
    @IBOutlet weak var addIfBlcok: NSPopUpButton!
    @IBOutlet weak var addElseBlcok: NSPopUpButton!
    @IBOutlet weak var tableViewIf: NSTableView!
    @IBOutlet weak var tableViewElse: NSTableView!
    @IBOutlet weak var blockName: NSTextField!
    @IBOutlet weak var textField: NSTextField!
    lazy var ifEditBlockProsessViewController: EditBlockProsessViewController = {
        return self.storyboard!.instantiateController(withIdentifier: "EditBlockProsessViewController") as! EditBlockProsessViewController
    }()
    lazy var editBlockStreamViewController: EditBlockStreamViewController = {
        return self.storyboard!.instantiateController(withIdentifier: "EditBlockStreamViewController") as! EditBlockStreamViewController
    }()
    lazy var editIfBlockController: EditIfBlockController = {
        return self.storyboard!.instantiateController(withIdentifier: "EditIfBlockController") as! EditIfBlockController
    }()
    lazy var editBlockWhileViewController: EditBlockWhileViewController = {
        return self.storyboard!.instantiateController(withIdentifier: "EditBlockWhileViewController") as! EditBlockWhileViewController
    }()
    
    var blocksArray = [Blocks]()
    var ifArray = [String]()
    var elseArray = [String]()
    var myIfModel: IfModelBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blockName.stringValue = "Блок: \(myIfModel?.name ?? "")"
        for value in Blocks.allCases {
            if value == .start || value == .end {
                continue
            }
            
            blocksArray.append(value)
            addIfBlcok.addItem(withTitle: value.name())
            addElseBlcok.addItem(withTitle: value.name())
        }
        for item in myIfModel?.left ?? [] {
            ifArray.append(item.name ?? "noname")
        }
        
        for item in myIfModel?.right ?? [] {
            elseArray.append(item.name ?? "noname")
        }
        
        tableViewIf.delegate = self
        tableViewIf.dataSource = self
        tableViewElse.delegate = self
        tableViewElse.dataSource = self
        tableViewIf.registerForDraggedTypes([.string])
        tableViewElse.registerForDraggedTypes([.string])
        textField.stringValue = myIfModel?.values?[0] ?? ""
    }
    
    @IBAction func save(_ sender: Any) {
        myIfModel?.values = [textField.stringValue]
    }
    
    @IBAction func add(_ sender: Any) {
        let answer = DeleteAlert(question: "Ошибка данных", text: "Введите условие!")
            if textField.stringValue.isEmpty {
                answer.showError()
                return
            }
        if (sender as! NSButton).tag == 1 {
            let blockfactory = InfoAboutBlock(selected: blocksArray[addIfBlcok.indexOfSelectedItem], name: "Левый \(blocksArray[addIfBlcok.indexOfSelectedItem].name()) \( myIfModel?.left.count ?? 0)", tag:  myIfModel?.left.count ?? 0 )
            let createdBlock = blockfactory.produce()
            
            myIfModel?.left.append(createdBlock)
            ifArray.append(createdBlock.name ?? "")
            tableViewIf.reloadData()
        } else {
            let blockfactory = InfoAboutBlock(selected: blocksArray[addElseBlcok.indexOfSelectedItem], name: "Правый \(blocksArray[addElseBlcok.indexOfSelectedItem].name()) \( myIfModel?.right.count ?? 0)", tag:  myIfModel?.right.count ?? 0 )
            let createdBlock = blockfactory.produce()
            myIfModel?.right.append(createdBlock)
            
            elseArray.append(createdBlock.name ?? "")
            tableViewElse.reloadData()
        }
        
    }
    
    @IBAction func close(_ sender: Any) {
        if let controller = self.storyboard?.instantiateController(withIdentifier: "ViewController") as? ViewController {
            self.view.window?.contentViewController = controller
        }
    }
}


extension EditIfBlockController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView.tag == 1 {
            return ifArray.count
        } else {
            return elseArray.count
        }
    }
}

extension EditIfBlockController: NSTableViewDelegate {
    fileprivate enum CellIdentifiers {
        static let NameCell = "Cell1"
    }
    func tableView(_ tableView: NSTableView, pasteboardWriterForRow row: Int) -> NSPasteboardWriting? {
        if tableView.tag == 1 {
            return ifArray[row] as NSString
        } else {
            return elseArray[row] as NSString
        }
    }
    
    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableView.DropOperation) -> NSDragOperation {

      guard dropOperation == .above,
            let tableView = info.draggingSource as? NSTableView else { return [] }

      tableView.draggingDestinationFeedbackStyle = .gap
      return .move
    }
    
    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableView.DropOperation) -> Bool {
        if tableView.tag == 1 {
          guard let items = info.draggingPasteboard.pasteboardItems,
                let pasteBoardItem = items.first,
                let pasteBoardItemName = pasteBoardItem.string(forType: .string),
                let index = ifArray.firstIndex(of: pasteBoardItemName) else { return false }
            ifArray.swapAt(index, (index < row ? row - 1 : row))
            let index_1 = (myIfModel?.left.index((myIfModel?.left.startIndex)!, offsetBy: (index < row ? row - 1 : row)))!
            let index_2 = myIfModel?.left.index((myIfModel?.left.startIndex)!, offsetBy: index)
            myIfModel?.left.swapAt(index_1, index_2!)
            tableView.beginUpdates()
            tableView.moveRow(at: index, to: (index < row ? row - 1 : row))
            tableView.endUpdates()
        } else {
            guard let items = info.draggingPasteboard.pasteboardItems,
                  let pasteBoardItem = items.first,
                  let pasteBoardItemName = pasteBoardItem.string(forType: .string),
                  let index = elseArray.firstIndex(of: pasteBoardItemName) else { return false }
            elseArray.swapAt(index, (index < row ? row - 1 : row))
              let index_1 = (myIfModel?.right.index((myIfModel?.right.startIndex)!, offsetBy: (index < row ? row - 1 : row)))!
              let index_2 = myIfModel?.right.index((myIfModel?.right.startIndex)!, offsetBy: index)
              myIfModel?.right.swapAt(index_1, index_2!)
            tableView.beginUpdates()
            tableView.moveRow(at: index, to: (index < row ? row - 1 : row))
            tableView.endUpdates()
        }

      return true
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var text: String = ""
        var table = 0
        if tableView.tag == 1 {
            text = ifArray[row]
            table = 1
        } else {
            text = elseArray[row]
            table = 2
        }
        var cellIdentifier: String = ""
        cellIdentifier = CellIdentifiers.NameCell
        
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? YourCell {
            cell.textField?.stringValue = text
            cell.cellDelegate = self
            cell.btn.tag = row
            cell.table = table
            return cell
        }
        
        return nil
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let tableiew = notification.object as! NSTableView
        if tableiew.selectedRow == -1 {
            return
        }
        guard let myIfModel = myIfModel else {
            return
        }
        if tableiew.tag == 1 {
            let selectedIndex = myIfModel.left.index(myIfModel.left.startIndex, offsetBy: tableiew.selectedRow)
            let block = myIfModel.left[selectedIndex].blocks
            
            switch block {
            case .prosess:
                ifEditBlockProsessViewController.myProcess = myIfModel.left[selectedIndex]
                self.view.window?.contentViewController = ifEditBlockProsessViewController
                break;
            case .instream, .outstream:
                editBlockStreamViewController.myStream = myIfModel.left[selectedIndex]
                self.view.window?.contentViewController = editBlockStreamViewController
                break;
            case .ifblock:
                editIfBlockController.myIfModel = myIfModel.left[selectedIndex] as? IfModelBlock
                self.view.window?.contentViewController = editIfBlockController
                break;
            case .whileblock:
                editBlockWhileViewController.myWileBlock = myIfModel.left[selectedIndex] as? WhileModelBlock
                self.view.window?.contentViewController = editBlockWhileViewController
            default:
                break;
            }
        } else {
            let selectedIndex = myIfModel.right.index(myIfModel.right.startIndex, offsetBy: tableiew.selectedRow)
            let block = myIfModel.right[selectedIndex].blocks
            switch block {
            case .prosess:
                ifEditBlockProsessViewController.myProcess = myIfModel.right[selectedIndex]
                self.view.window?.contentViewController = ifEditBlockProsessViewController
                break;
            case .instream, .outstream:
                editBlockStreamViewController.myStream = myIfModel.right[selectedIndex]
                self.view.window?.contentViewController = editBlockStreamViewController
                break;
            case .ifblock:
                editIfBlockController.myIfModel = myIfModel.right[selectedIndex] as? IfModelBlock
                self.view.window?.contentViewController = editIfBlockController
                break;
            case . whileblock:
                editBlockWhileViewController.myWileBlock = myIfModel.right[selectedIndex] as? WhileModelBlock
                self.view.window?.contentViewController = editBlockWhileViewController
            default:
                break;
            }
        }
    }
}
