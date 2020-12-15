//
//  GenerationPascal.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 06.12.2020.
//

import Foundation


class GenerationPascal: Generation {
    init (generated data: GenModelController) {
        self.data = data
        firstError = ""
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

