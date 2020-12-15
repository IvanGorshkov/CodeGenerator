//
//  AnalyserPascal.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 06.12.2020.
//

import Foundation

class AnalyserPascal: Analyser {
    internal var firstError: String
    
    private func haveHeadOrTail(item: Blocks) -> Bool {
        if (data.blocksList.contains(where: { (block) -> Bool in return block.blocks == item })) {
            
            return true
        }
        firstError = "Отсутствует \(item)"
        return false
    }
    
    private func checkBlock(item: ModelBlock) -> Bool {
        if (item.values == nil || item.values?.count == 0) && item.blocks != .end && item.blocks != .start {
            firstError = "Незаполненные данные \(item.name ?? "")"
            return false
        }
        return true
    }
    
    func algIsCorrect() -> Bool {
        if !haveHeadOrTail(item: .end) { return false }
        if !haveHeadOrTail(item: .start) { return false }
        
        for item in data.blocksList {
            if !checkBlock(item: item) { return false }
            if item.blocks == .ifblock {
                if !checkBlockIf(item: item) { return false }
            }
            
            if item.blocks == .whileblock || item.blocks == .forblock  {
                if !checkBlockWhile(item: item) { return false }
            }
        }
        
        return true
    }
    
    private func checkBlockWhile(item: ModelBlock) -> Bool{
        if !checkBlock(item: item) { return false }
        for item in (item as! WhileModelBlock).body {
            if !checkBranch(item: item) { return false }
        }
        return true
    }
    
    private func checkBranch(item: ModelBlock) -> Bool {
        let blockE = item.blocks
        switch blockE {
        case .prosess, .instream, .outstream, .procedure:
            if !checkBlock(item: item) { return false }
            break;
        case .ifblock:
            if !checkBlockIf(item: item) { return false }
        case .whileblock, .forblock:
            if !checkBlockWhile(item: item) { return false }
        default:
            break
        }
        return true
    }
    
    private func checkBlockIf(item: ModelBlock) -> Bool {
        if !checkBlock(item: item) { return false }
        for item in (item as! IfModelBlock).left {
            if !checkBranch(item: item) { return false }
        }
        
        for item in (item as! IfModelBlock).right {
            if !checkBranch(item: item) { return false }
        }
        
        return true
    }
    init (data: GenModelController) {
        self.data = data
        firstError = ""
    }
    private let data: GenModelController
   // private var firstError: String
    func getError() -> String {
        return firstError
    }
}
