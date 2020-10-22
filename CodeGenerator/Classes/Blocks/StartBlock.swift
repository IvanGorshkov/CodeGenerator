//
//  StartBlock.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 23.10.2020.
//

import Cocoa

class StartBlock: BaseBlock {
    convenience init(name: String, frame: NSRect) {
        self.init(nameBlock: name, frame: frame)
        title =  "Старт"
        numberOfExit = 1
        numberOfEnters = 0
        self.layer?.cornerRadius = self.frame.height / 2.0
        contentTintColor = .black
        
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
