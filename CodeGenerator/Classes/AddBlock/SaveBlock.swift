//
//  SaveBlock.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 30.10.2020.
//

import Foundation

class SaveBlock {
    public func save() {
        let blockfactory = ModelBlcokFactory(selected: block, name: (name == nil ? block.name() + " \(gemMC.blocksList.count + 1)" : name)!, tag:  gemMC.blocksList.count)
        let createdBlock = blockfactory.produce()
        switch block {
        case .start:
            gemMC.blocksList.prepend(createdBlock)
            break
        case .end:
            gemMC.blocksList.append(createdBlock)
            break
        case .prosess, .instream, .outstream, .ifblock, .whileblock, .procedure, .forblock:
            addBodyBlock(createdBlock: createdBlock, currentEnum: block)
        }
        
        var i = 0
        for block in gemMC.blocksList {
            block.tag = i
            i += 1
        }
    }
    
    private func addBodyBlock(createdBlock: ModelBlock, currentEnum: Blocks)  {
        if  !gemMC.blocksList.contains(where: { (block) -> Bool in
            return block.blocks == .end
        })  {
            gemMC.blocksList.append(createdBlock)
        } else {
            let end = gemMC.blocksList.removeLast()
            gemMC.blocksList.append(createdBlock)
            gemMC.blocksList.append(end)
        }
    }
    
    public init(block: Blocks, name: String?) {
        self.block = block
        self.name = name
        gemMC = GenModelController.shared
    }
    
    private let block: Blocks
    private let name: String?
    private let gemMC: GenModelController
}
