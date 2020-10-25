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
        var str = "Program BlockToGode;\n\n"
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
        

        i = 0;
        while i < data.count {
            let block = data.nodeAt(index: i)?.value.blocks
            switch block {
            case .start:
                str += "Begin\n"
                break;
            case .end:
                str += "End.\n"
                break;
            case .prosess:
                for i in data.nodeAt(index: i)?.value.values ?? [] {
                    str += i + "\n"
                }
                
            case .none:
                break;
            }
            i += 1
        }
        
        return str
    }
    
    private let data: GenModelController
}
