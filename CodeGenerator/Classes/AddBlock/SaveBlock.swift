//
//  SaveBlock.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 30.10.2020.
//

import Foundation

class SaveBlock {
    public func save() {
        let gemMC = GenModelController.shared
        let blockfactory = InfoAboutBlock(selected: block, name: block.name() + " \(gemMC.blocksList.count + 1)", tag:  gemMC.blocksList.count)
        let createdBlock = blockfactory.produce()
        switch block {
        case .start:
            gemMC.blocksList.prepend(createdBlock)
            break
            
        case .end:
            gemMC.blocksList.append(createdBlock)
            break
        case .prosess, .instream, .outstream:
            addBodyBlock(createdBlock: createdBlock, currentEnum: block)
            break
        }
        
        var i = 0
        for block in gemMC.blocksList {
            block.tag = i
            i += 1
        }
    }
    
    private func addBodyBlock(createdBlock: ModelBlock, currentEnum: Blocks)  {
        let gemMC = GenModelController.shared
        if  !gemMC.blocksList.contains(where: { (block) -> Bool in
            return block.blocks == .end
        })  {
            gemMC.blocksList.append(createdBlock)
        } else {
            let end = GenModelController.shared.blocksList.removeLast()
            gemMC.blocksList.append(createdBlock)
            gemMC.blocksList.append(end)
        }
    }
    
    public init(block: Blocks) {
        self.block = block
    }
    
    private let block: Blocks
}
