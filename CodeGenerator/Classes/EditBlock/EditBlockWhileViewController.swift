//
//  EditBlockWhileViewController.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 08.11.2020.
//

import Cocoa

class EditBlockWhileViewController: NSViewController, CellDelegate {
    func didPressButton(_ tag: Int, _ table: Int) {
        guard let myWileBlock = myWileBlock else {
            return
        }
        blocksInWileArray.remove(at: tag)
        let selectedIndex = myWileBlock.body.index(myWileBlock.body.startIndex, offsetBy: tag)
        myWileBlock.body.remove(at: selectedIndex)
        tableView.reloadData()
    }
    
    func didPressButton(_ tag: Int) {
        print("I have pressed a button with a tag: \(tag)")
    }
    
    var tag: Int?
    @IBOutlet weak var addBlock: NSPopUpButton!
    @IBOutlet weak var tableView: NSTableView!
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
    var blocksInWileArray = [String]()
    var myWileBlock: WhileModelBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blockName.stringValue = "Блок: \(myWileBlock?.name ?? "")"
        for value in Blocks.allCases {
            if value == .start || value == .end {
                continue
            }
            
            blocksArray.append(value)
            addBlock.addItem(withTitle: value.name())
        }
        for item in myWileBlock?.body ?? [] {
            blocksInWileArray.append(item.name ?? "noname")
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerForDraggedTypes([.string])
        var blockName = ""
        if myWileBlock?.values == nil || myWileBlock?.values?.count == 0 {
            blockName = ""
        } else {
            blockName = ( myWileBlock?.values?[0])!
        }
        
        textField.stringValue = blockName
    }
    
    @IBAction func save(_ sender: Any) {
        myWileBlock?.values = [textField.stringValue]
    }
    
    @IBAction func add(_ sender: Any) {
        let answer = DeleteAlert(question: "Ошибка данных", text: "Введите условие!")
        if textField.stringValue.isEmpty {
            answer.showError()
            return
        }
        let blockfactory = InfoAboutBlock(selected: blocksArray[addBlock.indexOfSelectedItem], name: "Левый \(blocksArray[addBlock.indexOfSelectedItem].name()) \( myWileBlock?.body.count ?? 0)", tag: myWileBlock?.body.count ?? 0)
        let createdBlock = blockfactory.produce()
        myWileBlock?.body.append(createdBlock)
        blocksInWileArray.append(createdBlock.name ?? "")
        tableView.reloadData()
    }
    
    @IBAction func close(_ sender: Any) {
        if let controller = self.storyboard?.instantiateController(withIdentifier: "ViewController") as? ViewController {
            self.view.window?.contentViewController = controller
        }
    }
}


extension EditBlockWhileViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return blocksInWileArray.count
    }
}

extension EditBlockWhileViewController: NSTableViewDelegate {
    fileprivate enum CellIdentifiers {
        static let NameCell = "Cell1"
    }
    
    func tableView(_ tableView: NSTableView, pasteboardWriterForRow row: Int) -> NSPasteboardWriting? {
        return blocksInWileArray[row] as NSString
    }
    
    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableView.DropOperation) -> NSDragOperation {
        
        guard dropOperation == .above,
              let tableView = info.draggingSource as? NSTableView else { return [] }
        
        tableView.draggingDestinationFeedbackStyle = .gap
        return .move
    }
    
    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableView.DropOperation) -> Bool {
        guard let items = info.draggingPasteboard.pasteboardItems,
              let pasteBoardItem = items.first,
              let pasteBoardItemName = pasteBoardItem.string(forType: .string),
              let index = blocksInWileArray.firstIndex(of: pasteBoardItemName) else { return false }
        blocksInWileArray.swapAt(index, (index < row ? row - 1 : row))
        let index_1 = (myWileBlock?.body.index((myWileBlock?.body.startIndex)!, offsetBy: (index < row ? row - 1 : row)))!
        let index_2 = myWileBlock?.body.index((myWileBlock?.body.startIndex)!, offsetBy: index)
        myWileBlock?.body.swapAt(index_1, index_2!)
        tableView.beginUpdates()
        tableView.moveRow(at: index, to: (index < row ? row - 1 : row))
        tableView.endUpdates()
        return true
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var text: String = ""
        text = blocksInWileArray[row]
        var cellIdentifier: String = ""
        cellIdentifier = CellIdentifiers.NameCell
        
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? YourCell {
            cell.textField?.stringValue = text
            cell.cellDelegate = self
            cell.btn.tag = row
            return cell
        }
        
        return nil
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let tableiew = notification.object as! NSTableView
        if tableiew.selectedRow == -1 {
            return
        }
        guard let myWileBlock = myWileBlock else {
            return
        }
        let selectedIndex = myWileBlock.body.index(myWileBlock.body.startIndex, offsetBy: tableiew.selectedRow)
        let block = myWileBlock.body[selectedIndex].blocks
        
        switch block {
        case .prosess:
            ifEditBlockProsessViewController.myProcess = myWileBlock.body[selectedIndex]
            self.view.window?.contentViewController = ifEditBlockProsessViewController
            break;
        case .instream, .outstream:
            editBlockStreamViewController.myStream = myWileBlock.body[selectedIndex]
            self.view.window?.contentViewController = editBlockStreamViewController
            break;
        case .ifblock:
            editIfBlockController.myIfModel = myWileBlock.body[selectedIndex] as? IfModelBlock
            self.view.window?.contentViewController = editIfBlockController
            break;
        case .whileblock:
            editBlockWhileViewController.myWileBlock = myWileBlock.body[selectedIndex] as? WhileModelBlock
            self.view.window?.contentViewController = editBlockWhileViewController
            break;
        default:
            break;
        }
    }
}
