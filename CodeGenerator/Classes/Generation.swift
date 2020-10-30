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
            case .prosess:
                for line in block.values ?? [] {
                    str += "\t" + line + "\n"
                }
            case .instream:
                for line in block.values ?? [] {
                    str += "\t" + line + "\n"
                }
            case .outstream:
                for line in block.values ?? [] {
                    str += "\t" + line + "\n"
                }
            }
        }
        
        return str
    }
    
    private let data: GenModelController
}
