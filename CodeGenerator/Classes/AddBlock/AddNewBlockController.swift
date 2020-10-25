//
//  AddNewBlockController.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 23.10.2020.
//

import Cocoa

class AddNewBlockController: NSViewController {
    private(set) var popUpInitiallySelectedItem: NSMenuItem?
    @IBOutlet weak var blockType: NSPopUpButton!
    @IBOutlet weak var blockIn: NSPopUpButton!
    @IBOutlet weak var blockOut: NSPopUpButton!
    var blocksArray = [Blocks]()
    var blocksIn = [Node]()
    var blocksOut = [Node]()
    override func viewWillAppear() {
        super.viewWillAppear()
        for value in Blocks.allCases {
            if AppDelegate.genModel.isInclude(block: .start) && value == .start {
                continue
            }
            
            if AppDelegate.genModel.isInclude(block: .end) && value == .end {
                continue
            }
            
            blocksArray.append(value)
            blockType.addItem(withTitle: value.name())
        }
        
        var i = 0
        while i < AppDelegate.genModel.count {
            let block = AppDelegate.genModel.nodeAt(index: i)?.value
            if block!.countEnters != 0 && block!.countEnters != block!.countEntersBusy {
                blockOut.addItem(withTitle: (AppDelegate.genModel.nodeAt(index: i)?.value.name)!)
                blocksOut.append(AppDelegate.genModel.nodeAt(index: i)!)
            }
            
            if block!.countExit != 0 && block!.countExit != block!.countExitBusy {
                blockIn.addItem(withTitle: (AppDelegate.genModel.nodeAt(index: i)?.value.name)!)
                blocksIn.append(AppDelegate.genModel.nodeAt(index: i)!)
            }
            i += 1
        }
        
        popUpInitiallySelectedItem = blockType.selectedItem
    }
    
    func updateInfo(block :Blocks) {
        blockIn.isEnabled = true
        blockOut.isEnabled = true
        let selectedBlock = InfoAboutBlock.shared.getBlocks(selected: block)
        
        if selectedBlock.countEnters == 0 {
            blockIn.isEnabled = false
        }
        
        if selectedBlock.countExit == 0 {
            blockOut.isEnabled = false
        }
    }
    
    @IBAction func popUpSelectionDidChange(_ sender: NSPopUpButton) {
        updateInfo(block: blocksArray[blockType.indexOfSelectedItem])
    }
    
    @IBAction func close(_ sender: Any) {
        if let controller = self.storyboard?.instantiateController(withIdentifier: "ViewController") as? ViewController {
            self.view.window?.contentViewController = controller
        }
    }
    
    @IBAction func save(_ sender: Any) {
        let block =  blocksArray[blockType.indexOfSelectedItem]
        let createdBlock = InfoAboutBlock.shared.getBlocks(selected: block)
        createdBlock.tag = AppDelegate.genModel.count
        createdBlock.name = block.name() + " \(AppDelegate.genModel.count + 1)"
        switch block {
        case .start:
            AppDelegate.genModel.addBegin(value: createdBlock)
            break
            
        case .end:
            AppDelegate.genModel.append(value: createdBlock)
            break
        case .prosess:
            AppDelegate.genModel.addPreEnd(value: createdBlock)
        }
       
        if let controller = self.storyboard?.instantiateController(withIdentifier: "ViewController") as? ViewController {
            self.view.window?.contentViewController = controller
        }
    }
}
