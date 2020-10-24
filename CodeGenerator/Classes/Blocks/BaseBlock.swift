//
//  BaseBlock.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 23.10.2020.
//

import Cocoa

class BaseBlock: NSButton {
    var blockName: String?
    var numberOfExit: Int?
    var numberOfEnters: Int?
    init(nameBlock: String, frame: NSRect, numberOfExit: Int?, numberOfEnters: Int?) {
        super.init(frame: frame)
        blockName = nameBlock;
        self.numberOfExit = numberOfExit
        self.numberOfEnters = numberOfEnters
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.white.cgColor
        self.isBordered = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

    }
    
    func setTag(tag: Int) {
        self.tag = tag
    }
    
    func getTag() -> Int {
        return tag
    }
}
