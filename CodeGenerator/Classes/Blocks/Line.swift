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

class IfLine: NSView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let aPath = NSBezierPath()
        aPath.move(to: CGPoint(x:self.frame.size.width/2, y:self.frame.size.height - 2))
        if dir == true {
            aPath.line(to: CGPoint(x: 10, y:self.frame.size.height - 2))
            aPath.line(to: CGPoint(x: 10, y:0))
            aPath.line(to: CGPoint(x: 15, y:5))
            aPath.line(to: CGPoint(x: 10, y:0))
            aPath.line(to: CGPoint(x: 5, y:5))
        } else {
            aPath.line(to: CGPoint(x: self.frame.size.width - 10, y:self.frame.size.height - 2))
            aPath.line(to: CGPoint(x: self.frame.size.width - 10, y:0))
            aPath.line(to: CGPoint(x: self.frame.size.width - 15, y:5))
            aPath.line(to: CGPoint(x: self.frame.size.width - 10, y:0))
            aPath.line(to: CGPoint(x: self.frame.size.width - 5, y:5))
        }
        
        NSColor.white.set()
        aPath.lineWidth = 2
        aPath.stroke()
    }
    init(frame frameRect: NSRect, dir: Bool) {
        self.dir = dir
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var dir: Bool
}

class EndIfLine: NSView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let aPath = NSBezierPath()
        if dir == true {
            aPath.move(to: CGPoint(x: 2, y:self.frame.size.height))
            aPath.line(to: CGPoint(x: 2, y:self.frame.size.height/2))
            aPath.line(to: CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2))
            aPath.line(to: CGPoint(x: self.frame.size.width/2, y: 0))
            
        } else {
            aPath.move(to: CGPoint(x: self.frame.size.width - 2, y:self.frame.size.height))
            aPath.line(to: CGPoint(x: self.frame.size.width - 2, y:self.frame.size.height/2))
            aPath.line(to: CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2))
            aPath.line(to: CGPoint(x: self.frame.size.width/2, y: 0))
        }
        
        NSColor.white.set()
        aPath.lineWidth = 2
        aPath.stroke()
    }
    init(frame frameRect: NSRect, dir: Bool) {
        self.dir = dir
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var dir: Bool
}

class EndWhileLine: NSView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let aPath = NSBezierPath()
        aPath.move(to: CGPoint(x: 2, y:self.frame.size.height))
        aPath.line(to: CGPoint(x: 2, y:self.frame.size.height/2))
        aPath.line(to: CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2))
        aPath.line(to: CGPoint(x: self.frame.size.width/2, y: self.frame.size.height))
        NSColor.white.set()
        aPath.lineWidth = 2
        aPath.stroke()
    }
}


class TopWhileLine: NSView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let aPath = NSBezierPath()
        aPath.move(to: CGPoint(x:self.frame.size.width/2, y:self.frame.size.height - 10))
        aPath.line(to: CGPoint(x: self.frame.size.width/2 - 5, y:self.frame.size.height - 15))
        aPath.line(to: CGPoint(x:self.frame.size.width/2, y:self.frame.size.height - 10))
        aPath.line(to: CGPoint(x: self.frame.size.width/2 - 5, y:self.frame.size.height - 5))
        aPath.line(to: CGPoint(x:self.frame.size.width/2, y:self.frame.size.height - 10))
        aPath.line(to: CGPoint(x: 2, y:self.frame.size.height - 10))
        aPath.line(to: CGPoint(x: 2, y:0))
        
        NSColor.white.set()
        aPath.lineWidth = 2
        aPath.stroke()
    }
}


class OutWileLine: NSView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let aPath = NSBezierPath()
        aPath.move(to: CGPoint(x:self.frame.size.width/2, y:self.frame.size.height - 2))
        aPath.line(to: CGPoint(x: self.frame.size.width - 10, y:self.frame.size.height - 2))
        aPath.line(to: CGPoint(x: self.frame.size.width - 10, y:0))
        
        NSColor.white.set()
        aPath.lineWidth = 2
        aPath.stroke()
    }
}
