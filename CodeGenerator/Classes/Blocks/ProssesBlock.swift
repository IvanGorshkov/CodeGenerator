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
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
