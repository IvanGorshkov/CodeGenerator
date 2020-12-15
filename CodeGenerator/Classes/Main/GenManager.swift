//
//  GenManager.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 06.12.2020.
//

import Foundation

class GenManager {
    init() {
    }
    
    func generate(analyzer: Analyser, generation: Generation, text: inout String) -> Bool {
        if !analyzer.algIsCorrect() {
            text = analyzer.getError()
            return false;
        }
        text = generation.generat()
        return true
    }
}
