//
//  Line.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 29.10.2020.
//

import Cocoa

class Line: NSView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let aPath = NSBezierPath()
        aPath.move(to: CGPoint(x:self.frame.size.width/2, y:0))
        aPath.line(to: CGPoint(x: self.frame.size.width/2, y: self.frame.size.height))
        aPath.close()
        NSColor.white.set()
        aPath.lineWidth = 2
        aPath.stroke()
    }
}

