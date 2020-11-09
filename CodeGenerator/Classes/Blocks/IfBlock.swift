//
//  IfBlock.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 03.11.2020.
//

import Cocoa

class IfBlock: BaseBlock {
    convenience init(name: String, frame: NSRect) {
        self.init(nameBlock: name, frame: frame, numberOfExit: 1, numberOfEnters: 1)
        self.name = name
    }
    
    var offset: CGFloat = 20 { didSet { needsDisplay = true } }
    var fillColor: NSColor = .white { didSet { needsDisplay = true } }
    let path = NSBezierPath()
    let textLayer = CenterTextLayer()
    var name: String?
    
    override func draw(_ rect: CGRect) {
        path.move(to: CGPoint(x: bounds.midX, y: bounds.minY + 0))
        path.line(to: CGPoint(x: bounds.maxX - 0, y: bounds.midY))
        path.line(to: CGPoint(x: bounds.midX, y: bounds.maxY - 0))
        path.line(to: CGPoint(x: bounds.minX + 0, y: bounds.midY))
        path.close()
        fillColor.setFill()
        path.fill()
        NSColor.black.setStroke()
        path.lineWidth = 2
        path.stroke()
        
        createTextLayer()
    }

    func createTextLayer() {
        textLayer.frame = bounds
        textLayer.string = name
        textLayer.alignmentMode = .center
        textLayer.foregroundColor = NSColor.black.cgColor
        self.layer?.addSublayer(textLayer)
        textLayer.fontSize = 15
        textLayer.contentsScale=2;
        textLayer.font = NSFont.systemFont(ofSize: 18, weight: NSFont.Weight.medium)
        
    }
}
