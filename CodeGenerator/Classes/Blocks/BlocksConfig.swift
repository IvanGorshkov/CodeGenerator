//
//  BlocksConfig.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 23.10.2020.
//

import Foundation

enum Blocks: String, CaseIterable {
    case start = "Старт"
    case end = "Конец"
    case prosess = "Процесс"
    case instream = "Ввод"
    case outstream = "Вывод"
    case ifblock = "Условие"
    case whileblock = "Цикл с предусловием"
    case procedure = "Внешняя процедура"
    case forblock = "Счетный цикл"
    
    init?(id : Int) {
        switch id {
        case 1: self = .start
        case 2: self = .end
        case 3: self = .prosess
        case 4: self = .instream
        case 5: self = .outstream
        case 6: self = .ifblock
        case 7: self = .whileblock
        case 8: self = .procedure
        case 9: self = .forblock
        default: return nil
        }
    }
    
    func name() ->String { return self.rawValue }
}

class ModelBlock {
    let blocks: Blocks
    var tag: Int?
    var name: String?
    var values: [String]?
    init(blocks: Blocks, name: String, tag: Int) {
        self.blocks = blocks
        self.name = name
        self.tag = tag
        values = []
    }
}

class IfModelBlock: ModelBlock {
    var left = LinkedList<ModelBlock>()
    var right = LinkedList<ModelBlock>()
}

class WhileModelBlock: ModelBlock {
    var body = LinkedList<ModelBlock>()
}

class ModelBlcokFactory: BlockFactory {
    func produce() -> ModelBlock {
        if block == .ifblock {
            return IfModelBlock(blocks: block, name: name, tag: tag)
        }

        if block == .whileblock {
            return WhileModelBlock(blocks: block, name: name, tag: tag)
        }
        
        if block == .forblock {
            return WhileModelBlock(blocks: block, name: name, tag: tag)
        }
        
        return ModelBlock(blocks: block, name: name, tag: tag)
    }
    
    func produceWithValue(blocks: XMLNode) -> ModelBlock {
        let block = produce()
        for value in blocks.children {
            block.values?.append(value.attributes["name"]!)
        }
        
        return block
    }
    
    
    init(selected block: Blocks, name: String, tag: Int) {
        self.block = block
        self.name = name
        self.tag = tag
    }
    
    private let block: Blocks
    private let name: String
    private let tag: Int
}
