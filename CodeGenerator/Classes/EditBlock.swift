//
//  EditBlock.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 25.10.2020.
//

import Foundation

class Analize {
    public init(str: String, type: VarType) {
        self.str = str
        self.type = type
        separator = ["+", "*", "(", ")", "-", "/", " "]
    }
    
    func isCorrect() -> Bool {
        switch type {
            case .integer: return intScanner()
            case .byte: return intScanner()
            case .shortint: return intScanner()
            case .longint: return intScanner()
            case .real: return intScanner()
            case .single: return intScanner()
            case .double: return intScanner()
            case .extended: return intScanner()
            case .boolean: return intScanner()
            case .char: return intScanner()
            case .string: return intScanner()
        }
    }
    
    func intScanner() -> Bool {
        while !str.isEmpty {
            var retStr = ""
            if takeWord(strC: &str, retStr: &retStr) {
                print(retStr)
                print(str)
            }
        }
        
        return true
    }
    
    func takeWord(strC: inout String, retStr:  inout String) -> Bool {
        var isTrue = false
        var myStr = strC
        var varible = ""
        if myStr.first?.isLetter == true {
            isTrue = true
            varible += "\(myStr.removeFirst())"
            while myStr.first?.isLetter == true || myStr.first?.isNumber == true {
                varible += "\(myStr.removeFirst())"
            }
        }
        
        if isTrue {
            print(varible)
            strC = myStr
            retStr = varible
        }
        return isTrue
    }
    
    private var separator: [String]
    private var str: String
    private var type: VarType
}
