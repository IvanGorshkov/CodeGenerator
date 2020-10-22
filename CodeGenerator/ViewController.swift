//
//  ViewController.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 23.09.2020.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let start = StartBlock(name: "Старт", frame: NSRect(x: 150, y: 200, width: 80, height: 55))
        view.addSubview(start)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

