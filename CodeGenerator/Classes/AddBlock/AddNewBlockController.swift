//
//  AddNewBlockController.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 23.10.2020.
//

import Cocoa

class AddNewBlockController: NSViewController {
    private var blocksArray = [Blocks]()
    @IBOutlet private weak var blockType: NSPopUpButton!
    @IBOutlet private weak var textField: NSTextField!
    @IBAction private func close(_ sender: Any) {
        if let controller = self.storyboard?.instantiateController(withIdentifier: "ViewController") as? ViewController {
            self.view.window?.contentViewController = controller
        }
    }
    
    @IBAction private func save(_ sender: Any) {
        savingBlock()
        if let controller = self.storyboard?.instantiateController(withIdentifier: "ViewController") as? ViewController {
            self.view.window?.contentViewController = controller
        }
    }
    
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
    
    private func isIncludeStartOrEnd(value: Blocks) -> Bool {
        let gemMCBlocksList = GenModelController.shared.blocksList
        if (gemMCBlocksList.contains(where: { (block) -> Bool in return block.blocks == .start }) && value == .start) ||
            (gemMCBlocksList.contains(where: { (block) -> Bool in return block.blocks == .end }) && value == .end) {
            return true
        }
        return false
    }
    
    private func savingBlock() {
        let saveBlock = SaveBlock(block: blocksArray[blockType.indexOfSelectedItem], name: textField.stringValue.isEmpty ? nil : textField.stringValue)
        saveBlock.save()
    }
}
