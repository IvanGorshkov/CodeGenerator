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
    
    init?(id : Int) {
        switch id {
        case 1: self = .start
        case 2: self = .end
        case 3: self = .prosess
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
    init(blocks: Blocks, countEnters: Int, countExit: Int) {
        self.blocks = blocks
        self.countEnters = countEnters
        self.countExit = countExit
    }
}

class IfBlock: ModelBlock {
    
}


class InfoAboutBlock {
    let blockStart: ModelBlock
    let blockEnd: ModelBlock
    let blockProsess: ModelBlock
    static let shared = InfoAboutBlock()
    init() {
        blockStart = ModelBlock(blocks: .start, countEnters: 0, countExit: 1)
        blockEnd = ModelBlock(blocks: .end, countEnters: 1, countExit: 0)
        blockProsess = ModelBlock(blocks: .prosess, countEnters: 1, countExit: 1)
    }
    
    func getBlocks(selected block: Blocks) -> ModelBlock {
        switch block {
        case .start:
            return blockStart
        case .end:
            return blockEnd
        case .prosess:
            return blockProsess
        }
    }
}
