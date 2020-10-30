//
//  StreamBlock.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 29.10.2020.
//

import Cocoa

enum outS: String, CaseIterable {
    case write = "Write"
    case writeln = "WriteLn"
    
    init?(id : Int) {
        switch id {
        case 1: self = .write
        case 2: self = .writeln
        default: return nil
        }
    }
    
    func name() ->String { return self.rawValue }
}
 

enum inS: String, CaseIterable  {
    case read = "Read"
    case readln = "ReadLn"
    init?(id : Int) {
        switch id {
        case 1: self = .read
        case 2: self = .readln
        default: return nil
        }
    }
    
    func name() ->String { return self.rawValue }
}

class StreamBlock: BaseBlock {
    convenience init(name: String, frame: NSRect) {
        self.init(nameBlock: name, frame: frame, numberOfExit: 1, numberOfEnters: 1)
        if name.starts(with: "Ввод") {
            self.name = "Ввод"
        } else {
            self.name = "Вывод"
        }
    }
    
    var offset: CGFloat = 20 { didSet { needsDisplay = true } }
    var fillColor: NSColor = .white { didSet { needsDisplay = true } }
    let path = NSBezierPath()
    let textLayer = CenterTextLayer()
    var name: String?
    
    override func draw(_ rect: CGRect) {
        path.move(to: CGPoint(x: bounds.minX + offset, y: bounds.minY))
        path.line(to: CGPoint(x: bounds.maxX, y: bounds.minY))
        path.line(to: CGPoint(x: bounds.maxX - offset, y: bounds.maxY))
        path.line(to: CGPoint(x: bounds.minX, y: bounds.maxY))
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
