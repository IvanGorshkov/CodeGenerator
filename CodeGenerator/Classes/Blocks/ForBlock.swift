//
//  ForBlock.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 11.11.2020.
//

import Cocoa

class ForBlock: BaseBlock {
    convenience init(name: String, frame: NSRect) {
        self.init(nameBlock: name, frame: frame)
        self.name = name
    }
    
    private var offset: CGFloat = 20 { didSet { needsDisplay = true } }
    private var fillColor: NSColor = .white { didSet { needsDisplay = true } }
    private let path = NSBezierPath()
    private let textLayer = CenterTextLayer()
    private var name: String?
    
    override func draw(_ rect: CGRect) {
        path.move(to: CGPoint(x: bounds.minX, y: bounds.midY))
        path.line(to: CGPoint(x: bounds.minX + 20, y: bounds.maxY))
        path.line(to: CGPoint(x: bounds.maxX - 20, y: bounds.maxY))
        path.line(to: CGPoint(x: bounds.maxX, y: bounds.midY))
        path.line(to: CGPoint(x: bounds.maxX - 20, y: bounds.minY))
        path.line(to: CGPoint(x: bounds.minX + 20, y: bounds.minY))
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
        textLayer.fontSize = 15
        textLayer.contentsScale=2;
        textLayer.font = NSFont.systemFont(ofSize: 18, weight: NSFont.Weight.medium)
        self.layer?.addSublayer(textLayer)
        
    }
}
