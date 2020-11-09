//
//  BlocksConfig.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 23.10.2020.
//

import Foundation

enum Blocks:String, CaseIterable {
    case start = "Старт"
    case end = "Конец"
    case prosess = "Процесс"
    case instream = "Ввод"
    case outstream = "Вывод"
    case ifblock = "Условие"
    case whileblock = "Цикл с предусловием"
    
    init?(id : Int) {
        switch id {
        case 1: self = .start
        case 2: self = .end
        case 3: self = .prosess
        case 4: self = .instream
        case 5: self = .outstream
        case 6: self = .ifblock
        case 7: self = .whileblock
        default: return nil
        }
    }
    
    func name() ->String { return self.rawValue }
}

class ModelBlock {
    let blocks: Blocks
    let countEnters: Int
    let countExit: Int
    var tag: Int?
    var countEntersBusy: Int = 0
    var countExitBusy: Int = 0
    var name: String?
    var values: [String]?
    init(blocks: Blocks, countEnters: Int, countExit: Int, name: String, tag: Int) {
        self.blocks = blocks
        self.countEnters = countEnters
        self.countExit = countExit
        self.name = name
        self.tag = tag
    }
}

class IfModelBlock: ModelBlock {
    var left = LinkedList<ModelBlock>()
    var right = LinkedList<ModelBlock>()
}

class WhileModelBlock: ModelBlock {
    var body = LinkedList<ModelBlock>()
}


class InfoAboutBlock: BlockFactory {
    func produce() -> ModelBlock {
        if block == .ifblock {
            return IfModelBlock(blocks: block, countEnters: 0, countExit: 1, name: name, tag: tag)
        }
        if block == .whileblock {
            return WhileModelBlock(blocks: block, countEnters: 0, countExit: 1, name: name, tag: tag)
        }
        return ModelBlock(blocks: block, countEnters: 0, countExit: 1, name: name, tag: tag)
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
