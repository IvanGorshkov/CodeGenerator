//
//  ProssesBlock.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 24.10.2020.
//

import Cocoa

class ProssesBlock: BaseBlock {
    convenience init(name: String, frame: NSRect) {
        self.init(nameBlock: name, frame: frame)
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

class ProcBlock: BaseBlock {
    private let path = NSBezierPath()
    convenience init(name: String, frame: NSRect) {
        self.init(nameBlock: name, frame: frame)
        contentTintColor = .black
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.white.cgColor
        self.isBordered = false
        self.layer?.borderWidth = 2
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        path.move(to: CGPoint(x: 8, y:0))
        path.line(to: CGPoint(x: 8, y:self.frame.size.height))
        path.move(to: CGPoint(x: self.frame.size.width - 8, y:0))
        path.line(to: CGPoint(x: self.frame.size.width - 8, y:self.frame.size.height))
        NSColor.black.set()
        path.lineWidth = 2
        path.stroke()
    }
    
}
