//
//  EditIfBlockController.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 03.11.2020.
//

import Cocoa

class EditIfBlockController: NSViewController, CellDelegate {
    @IBOutlet weak var addIfBlcok: NSPopUpButton!
    @IBOutlet weak var addElseBlcok: NSPopUpButton!
    @IBOutlet weak var tableViewIf: NSTableView!
    @IBOutlet weak var tableViewElse: NSTableView!
    @IBOutlet weak var blockName: NSTextField!
    @IBOutlet weak var textField: NSTextField!
    private lazy var ifEditBlockProsessViewController: EditBlockProsessViewController = {
        return self.storyboard!.instantiateController(withIdentifier: "EditBlockProsessViewController") as! EditBlockProsessViewController
    }()
    private lazy var editBlockStreamViewController: EditBlockStreamViewController = {
        return self.storyboard!.instantiateController(withIdentifier: "EditBlockStreamViewController") as! EditBlockStreamViewController
    }()
    private lazy var editIfBlockController: EditIfBlockController = {
        return self.storyboard!.instantiateController(withIdentifier: "EditIfBlockController") as! EditIfBlockController
    }()
    private lazy var editBlockWhileViewController: EditBlockWhileViewController = {
        return self.storyboard!.instantiateController(withIdentifier: "EditBlockWhileViewController") as! EditBlockWhileViewController
    }()
    private lazy var editProcedureViewController: EditProcedureViewController = {
        return self.storyboard!.instantiateController(withIdentifier: "EditProcedureViewController") as! EditProcedureViewController
    }()
    private lazy var editBlcokForViewController: EditBlcokForViewController = {
        return self.storyboard!.instantiateController(withIdentifier: "EditBlcokForViewController") as! EditBlcokForViewController
    }()
    
    
    private var blocksArray = [Blocks]()
    private var ifArray = [String]()
    private var elseArray = [String]()
    var myIfModel: IfModelBlock?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blockName.stringValue = "Блок: \(myIfModel?.name ?? "")"
        for value in Blocks.allCases {
            if value == .start || value == .end { continue }
            blocksArray.append(value)
            addIfBlcok.addItem(withTitle: value.name())
            addElseBlcok.addItem(withTitle: value.name())
        }
        guard let myIfModel = myIfModel else { return }
        addToArrat(array: &ifArray, list: myIfModel.left)
        addToArrat(array: &elseArray, list: myIfModel.right)
        setTablesViews()
        
        var blockName = ""
        if myIfModel.values == nil || myIfModel.values?.count == 0 {
            blockName = ""
        } else {
            blockName = (myIfModel.values?[0])!
        }
        
        textField.stringValue = blockName
    }
    
    private func addToArrat(array: inout [String], list: LinkedList<ModelBlock>) {
        for item in list {
            array.append(item.name ?? "noname")
        }
    }
    
    private func setTablesViews() {
        tableViewIf.delegate = self
        tableViewIf.dataSource = self
        tableViewElse.delegate = self
        tableViewElse.dataSource = self
        tableViewIf.registerForDraggedTypes([.string])
        tableViewElse.registerForDraggedTypes([.string])
    }
    
    @IBAction func save(_ sender: Any) {
        myIfModel?.values = [textField.stringValue]
    }
    
    private func addBlock(index: Int, array: inout [String], list: inout LinkedList<ModelBlock>, side: String) {
        let blockfactory = InfoAboutBlock(selected: blocksArray[index], name: "\(side) \(blocksArray[index].name()) \(list.count)", tag: list.count)
        let createdBlock = blockfactory.produce()
        list.append(createdBlock)
        array.append(createdBlock.name ?? "")
    }
    
    @IBAction func add(_ sender: Any) {
        let answer = DeleteAlert(question: "Ошибка данных", text: "Введите условие!")
        if textField.stringValue.isEmpty {
            answer.showError()
            return
        }
        guard let myIfModel = myIfModel else { return }
        if (sender as! NSButton).tag == 1 {
            addBlock(index: addIfBlcok.indexOfSelectedItem, array: &ifArray, list: &myIfModel.left, side: "Лев.")
            tableViewIf.reloadData()
        } else {
            addBlock(index: addElseBlcok.indexOfSelectedItem, array: &elseArray, list: &myIfModel.right, side: "Пр.")
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
    func tableView(_ tableView: NSTableView, pasteboardWriterForRow row: Int) -> NSPasteboardWriting? {
        if tableView.tag == 1 {
            return ifArray[row] as NSString
        } else {
            return elseArray[row] as NSString
        }
    }
    
    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableView.DropOperation) -> NSDragOperation {
        guard dropOperation == .above, let tableView = info.draggingSource as? NSTableView else { return [] }
        tableView.draggingDestinationFeedbackStyle = .gap
        return .move
    }
    
    private func swapBlocks(info: NSDraggingInfo, row: Int, array: inout [String], list: inout LinkedList<ModelBlock>, tableView: NSTableView) -> Bool {
        guard let items = info.draggingPasteboard.pasteboardItems,
              let pasteBoardItem = items.first,
              let pasteBoardItemName = pasteBoardItem.string(forType: .string),
              let index = array.firstIndex(of: pasteBoardItemName) else { return false }
        array.swapAt(index, (index < row ? row - 1 : row))
        let index_1 = list.index(list.startIndex, offsetBy: (index < row ? row - 1 : row))
        let index_2 = list.index(list.startIndex, offsetBy: index)
        list.swapAt(index_1, index_2)
        tableView.beginUpdates()
        tableView.moveRow(at: index, to: (index < row ? row - 1 : row))
        tableView.endUpdates()
        return true
    }
    
    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableView.DropOperation) -> Bool {
        guard let myIfModel = myIfModel else { return false }
        if tableView.tag == 1 {
            if !swapBlocks(info: info, row: row, array: &ifArray, list: &myIfModel.left, tableView: tableView) {
                return false
            }
        } else {
            if !swapBlocks(info: info, row: row, array: &elseArray, list: &myIfModel.right, tableView: tableView) {
                return false
            }
        }
        return true
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var text = ""
        var table = 0
        if tableView.tag == 1 {
            text = ifArray[row]
            table = 1
        } else {
            text = elseArray[row]
            table = 2
        }
        let cellIdentifier = "Cell1"
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? BranchingСell {
            cell.textField?.stringValue = text
            cell.cellDelegate = self
            cell.btn.tag = row
            cell.table = table
            return cell
        }
        
        return nil
    }
    
    private func jumptoEditVC(list: LinkedList<ModelBlock>, selectedRow: Int) {
        let selectedIndex = list.index(list.startIndex, offsetBy: selectedRow)
        let block = list[selectedIndex].blocks
        
        switch block {
        case .prosess:
            ifEditBlockProsessViewController.myProcess = list[selectedIndex]
            self.view.window?.contentViewController = ifEditBlockProsessViewController
            break;
        case .instream, .outstream:
            editBlockStreamViewController.myStream = list[selectedIndex]
            self.view.window?.contentViewController = editBlockStreamViewController
            break;
        case .ifblock:
            editIfBlockController.myIfModel = list[selectedIndex] as? IfModelBlock
            self.view.window?.contentViewController = editIfBlockController
            break;
        case .whileblock:
            editBlockWhileViewController.myWileBlock = list[selectedIndex] as? WhileModelBlock
            self.view.window?.contentViewController = editBlockWhileViewController
        case .procedure:
            editProcedureViewController.myProcess = list[selectedIndex]
            self.view.window?.contentViewController = editProcedureViewController
        case .forblock:
            editBlcokForViewController.myWileBlock = list[selectedIndex] as? WhileModelBlock
            self.view.window?.contentViewController = editBlcokForViewController
        default:
            break;
        }
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let tableiew = notification.object as! NSTableView
        if tableiew.selectedRow == -1 {  return }
        guard let myIfModel = myIfModel else { return  }
        
        if tableiew.tag == 1 {
            jumptoEditVC(list: myIfModel.left, selectedRow: tableiew.selectedRow)
        } else {
            jumptoEditVC(list: myIfModel.right, selectedRow: tableiew.selectedRow)
        }
    }
}
