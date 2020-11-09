//
//  StartBlock.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 23.10.2020.
//

import Cocoa

class StartBlock: BaseBlock {
    convenience init(name: String, frame: NSRect) {
        self.init(nameBlock: name, frame: frame, numberOfExit: 1, numberOfEnters: 0)
        title =  "Старт"
        contentTintColor = .black
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.white.cgColor
        self.isBordered = false
        self.layer?.cornerRadius = self.frame.height / 2.0
        self.layer?.borderWidth = 2
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
}
