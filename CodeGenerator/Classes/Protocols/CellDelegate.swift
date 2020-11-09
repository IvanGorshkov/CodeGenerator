//
//  CellDelegate.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 04.11.2020.
//

import Foundation
import Cocoa

protocol CellDelegate : class {
    func didPressButton(_ tag: Int, _ table: Int)
}

class YourCell : NSTableCellView {
    var cellDelegate: CellDelegate?
    @IBOutlet weak var btn: NSButton!
    var table = 0
    @IBAction func buttonPressed(_ sender: NSButton) {
        cellDelegate?.didPressButton(sender.tag, table)
    }
}
