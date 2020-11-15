//
//  Generation.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 24.10.2020.
//

import Foundation

class Generation {
    init (generated data: GenModelController) {
        self.data = data
        firstError = ""
    }
    
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
        case .prosess, .instream, .outstream:
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
    
    func generat() -> String {
        var str = "Program BlockToCode;\n\n"
        var i = 0
        for value in VarType.allCases {
            while i < data.getArrayType().count {
                if value ==  data.getArrayType()[i].type {
                    str += "var "
                    str += data.getArrayType()[i].name + ": " + data.getArrayType()[i].type.name() + ";\n"
                }
                i += 1
            }
            i = 0
        }
        
        for block in data.blocksList {
            let blockE = block.blocks
            switch blockE {
            case .start:
                str += "Begin\n"
                break;
            case .end:
                str += "End.\n"
                break;
            case .prosess, .instream, .outstream, .procedure:
                t += 1
                for line in block.values ?? [] {
                    printT(str: &str)
                    str +=  line + "\n"
                }
                t -= 1
            case .ifblock:
                t += 1
                printIf(str: &str, block: block)
                t -= 1
            case .whileblock:
                t += 1
                printWhile(str: &str, block: block as! WhileModelBlock, type: "while")
                t -= 1
            case .forblock:
                t += 1
                printWhile(str: &str, block: block as! WhileModelBlock, type: "for")
                t -= 1
            }
        }
        
        return str
    }
    
    private func printT(str: inout String) {
        for _ in 0..<t {
            str += "\t"
        }
    }
    
    private func printWhile(str: inout String, block: WhileModelBlock, type: String) {
        printT(str: &str)
        str += "\(type) \(block.values?[0] ?? "") do begin\n"
        for item in block.body {
            printBranch(str: &str, item: item)
        }
        printT(str: &str)
        str += "end;\n"
    }
    
    private func printIf(str: inout String, block: ModelBlock) {
        printT(str: &str)
        str += "if \(block.values?[0] ?? "") then begin\n"
        let ifblock = (block as! IfModelBlock)
        
        for item in ifblock.left {
            printBranch(str: &str, item: item)
        }
        printT(str: &str)
        str += "end"
        var i = 0
        for item in ifblock.right {
            if i == 0 {
                str += "\n"
                printT(str: &str)
                str += "else begin\n"
            }
            i += 1
            
            printBranch(str: &str, item: item)
        }
        if i == 0 {
            str += ";\n"
        } else {
            
            printT(str: &str)
            str += "end;\n"
        }
    }
    private func printBranch(str: inout String, item: ModelBlock) {
        t += 1
        if item.blocks == .ifblock {
            printIf(str: &str, block: item)
            t -= 1
            return
        }
        
        if item.blocks == .whileblock {
            printWhile(str: &str, block: item as! WhileModelBlock, type: "while")
            t -= 1
            return
        }
        
        if item.blocks == .forblock {
            printWhile(str: &str, block: item as! WhileModelBlock, type: "for")
            t -= 1
            return
        }
        
        for line in item.values ?? [] {
            printT(str: &str)
            str += line + "\n"
        }
        t -= 1
    }
    
    private var t = 0
    private let data: GenModelController
    private var firstError: String
    func getError() -> String {
        return firstError
    }
}

