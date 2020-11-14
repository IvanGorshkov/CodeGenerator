//
//  EditBlcokForViewController.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 11.11.2020.
//

import Cocoa

class EditBlcokForViewController: NSViewController, CellDelegate {
    @IBOutlet weak var addBlock: NSPopUpButton!
    @IBOutlet weak var varity: NSPopUpButton!
    @IBOutlet weak var forType: NSPopUpButton!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var blockName: NSTextField!
    @IBOutlet weak var from: NSTextField!
    @IBOutlet weak var to: NSTextField!
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
    private var blocksInWileArray = [String]()
    var myWileBlock: WhileModelBlock?
    
    func didPressButton(_ tag: Int, _ table: Int) {
        guard let myWileBlock = myWileBlock else { return }
        blocksInWileArray.remove(at: tag)
        let selectedIndex = myWileBlock.body.index(myWileBlock.body.startIndex, offsetBy: tag)
        myWileBlock.body.remove(at: selectedIndex)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blockName.stringValue = "Блок: \(myWileBlock?.name ?? "")"
        for value in Blocks.allCases {
            if value == .start || value == .end { continue }
            blocksArray.append(value)
            addBlock.addItem(withTitle: value.name())
        }
        for item in myWileBlock?.body ?? [] {
            blocksInWileArray.append(item.name ?? "noname")
        }
        
        let directoryItems = GenModelController.shared.getArrayType()
        for value in directoryItems {
            varity.addItem(withTitle: value.name)
        }
        forType.addItems(withTitles: ["to", "downto"])
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerForDraggedTypes([.string])
        

        let strFor = myWileBlock?.values?[0]
        if strFor != nil {
            let dateAsArray = strFor?.split(separator: " ").map{ String($0) }
            if dateAsArray![3] == "downto" {
                forType.selectItem(at: 1)
            } else {
                forType.selectItem(at: 0)
                
            }
            
            for item in varity.itemArray {
                if item.title == dateAsArray?[0] {
                    varity.select(item)
                    break;
                }
            }
            from.stringValue = dateAsArray![2]
            to.stringValue = dateAsArray![4]
        }

    }
    
    @IBAction func save(_ sender: Any) {
        myWileBlock?.values = ["\(varity.selectedItem?.title ?? "") := \(from.stringValue) \(forType.selectedItem?.title ?? "") \(to.stringValue)"]
    }
    
    @IBAction func add(_ sender: Any) {
        let answer = DeleteAlert(question: "Ошибка данных", text: "Введите условие!")
        if from.stringValue.isEmpty || to.stringValue.isEmpty || ((varity.selectedItem?.title.isEmpty) == nil) {
            answer.showError()
            return
        }
        guard let myWileBlock = myWileBlock else { return }
        let eBlock = blocksArray[addBlock.indexOfSelectedItem]
        let blockfactory = InfoAboutBlock(selected: eBlock, name: "\(eBlock.name()) \(myWileBlock.body.count)", tag: myWileBlock.body.count)
        let createdBlock = blockfactory.produce()
        myWileBlock.body.append(createdBlock)
        blocksInWileArray.append(createdBlock.name ?? "")
        tableView.reloadData()
    }
    
    @IBAction func close(_ sender: Any) {
        if let controller = self.storyboard?.instantiateController(withIdentifier: "ViewController") as? ViewController {
            self.view.window?.contentViewController = controller
        }
    }
}


extension EditBlcokForViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return blocksInWileArray.count
    }
}

extension EditBlcokForViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, pasteboardWriterForRow row: Int) -> NSPasteboardWriting? {
        return blocksInWileArray[row] as NSString
    }
    
    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableView.DropOperation) -> NSDragOperation {
        guard dropOperation == .above, let tableView = info.draggingSource as? NSTableView else { return [] }
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
        let text = blocksInWileArray[row]
        let cellIdentifier = "Cell1"
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? BranchingСell {
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
            case .procedure:
                editProcedureViewController.myProcess = myWileBlock.body[selectedIndex]
                self.view.window?.contentViewController = editProcedureViewController
                break;
            case .forblock:
                editBlcokForViewController.myWileBlock =  myWileBlock.body[selectedIndex] as? WhileModelBlock
                self.view.window?.contentViewController = editBlcokForViewController
            default:
                break;
        }
    }
}
