//
//  ProssesBlock.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 24.10.2020.
//

import Cocoa

class ProssesBlock: BaseBlock {
    convenience init(name: String, frame: NSRect) {
        self.init(nameBlock: name, frame: frame, numberOfExit: 1, numberOfEnters: 1)
        title =  "Процесс"
        contentTintColor = .black
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.white.cgColor
        self.isBordered = false
        self.layer?.borderWidth = 2
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
}
