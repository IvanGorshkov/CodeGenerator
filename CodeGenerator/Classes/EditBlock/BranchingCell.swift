//
//  BranchingCell.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 10.11.2020.
//

import Foundation
import Cocoa

class BranchingСell : NSTableCellView {
    @IBOutlet weak var btn: NSButton!
    var cellDelegate: CellDelegate?
    var table = 0
    @IBAction func buttonPressed(_ sender: NSButton) {
        cellDelegate?.didPressButton(sender.tag, table)
    }
}
