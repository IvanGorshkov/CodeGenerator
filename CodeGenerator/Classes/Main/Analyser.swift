//
//  Analyser.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 06.12.2020.
//

import Foundation

protocol Analyser {
    func algIsCorrect() -> Bool
    func getError() -> String
    var firstError: String { get set }
}
