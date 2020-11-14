//
//  VarType.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 25.10.2020.
//

import Foundation

enum VarType: String, CaseIterable {
    case integer = "integer"
    case byte = "byte"
    case shortint = "shortint"
    case longint = "longint"
    case real = "real"
    case single = "single"
    case double = "double"
    case extended = "extended"
    case boolean = "boolean"
    case char = "char"
    case string = "string"
    
    init?(id : Int) {
        switch id {
        case 1: self = .integer
        case 2: self = .byte
        case 3: self = .shortint
        case 4: self = .longint
        case 5: self = .real
        case 6: self = .single
        case 7: self = .double
        case 8: self = .extended
        case 9: self = .boolean
        case 10: self = .char
        case 11: self = .string
        default: return nil
        }
    }
    
    func name() -> String { return self.rawValue }
}

struct ModelType {
    let name: String
    let type: VarType
}
