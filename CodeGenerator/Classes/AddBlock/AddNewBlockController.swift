//
//  AddNewBlockController.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 23.10.2020.
//

import Cocoa

class AddNewBlockController: NSViewController {
    @IBOutlet weak var blockType: NSPopUpButton!
    var blocksArray = [Blocks]()
    override func viewWillAppear() {
        super.viewWillAppear()
        for value in Blocks.allCases {
            if isIncludeStartOrEnd(value: value) {
                continue
            }
            blocksArray.append(value)
            blockType.addItem(withTitle: value.name())
        }
    }
    
    func isIncludeStartOrEnd(value: Blocks) -> Bool {
        let gemMCBlocksList = GenModelController.shared.blocksList
        if (gemMCBlocksList.contains(where: { (block) -> Bool in return block.blocks == .start }) && value == .start) ||
            (gemMCBlocksList.contains(where: { (block) -> Bool in return block.blocks == .end }) && value == .end) {
            return true
        }
        return false
    }
    
    @IBAction func close(_ sender: Any) {
        if let controller = self.storyboard?.instantiateController(withIdentifier: "ViewController") as? ViewController {
            self.view.window?.contentViewController = controller
        }
    }
    
    @IBAction func save(_ sender: Any) {
        savingBlock()
        if let controller = self.storyboard?.instantiateController(withIdentifier: "ViewController") as? ViewController {
            self.view.window?.contentViewController = controller
        }
    }
    
    func savingBlock() {
        let saveBlock = SaveBlock(block: blocksArray[blockType.indexOfSelectedItem])
        saveBlock.save()
    }
}
