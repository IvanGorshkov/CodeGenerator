//
//  CellDelegate.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 04.11.2020.
//

import Foundation

protocol CellDelegate : class {
    func didPressButton(_ tag: Int, _ table: Int)
}
