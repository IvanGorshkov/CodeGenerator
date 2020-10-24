//
//  ViewController.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 23.09.2020.
//

import Cocoa
class View: NSView {
  override var isFlipped: Bool { return true }
}

class ViewController: NSViewController {
    @IBOutlet weak var textView: NSTextView!
    @IBOutlet weak var scroll: NSScrollView!
    
    let documentView = View(frame: NSRect(x: 0, y: 0, width: 0, height: 0))
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var representedObject: Any? {
        didSet { }
    }
    
    lazy var sheetViewController: AddNewBlockController = {
        return self.storyboard!.instantiateController(withIdentifier: "AddNewBlockController") as! AddNewBlockController
    }()
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.title = "BlockToGode"
    }
    override func viewWillAppear() {
        var i = 0;
        
        var scrollSize = CGSize(width: scroll.frame.size.width, height: 0)
        var subviewFrame = CGRect(origin: .zero, size: scrollSize)
        while i < AppDelegate.genModel.count {
            if AppDelegate.genModel.nodeAt(index: i)?.value.blocks == .end {
                let end = EndBlock(name: (AppDelegate.genModel.nodeAt(index: i)?.value.blocks.name())!, frame: NSRect(x: 80, y: 10 + (70*i), width: 80, height: 55))
                scrollSize.height = end.frame.origin.y + end.frame.size.height
                documentView.addSubview(end)
            }
            
            if AppDelegate.genModel.nodeAt(index: i)?.value.blocks == .start {
                let start = StartBlock(name: (AppDelegate.genModel.nodeAt(index: i)?.value.blocks.name())!, frame: NSRect(x: 80, y: 10 + (70*i), width: 80, height: 55))
                scrollSize.height = start.frame.origin.y + start.frame.size.height
                documentView.addSubview(start)
            }
            
            if AppDelegate.genModel.nodeAt(index: i)?.value.blocks == .prosess {
                let prosess = ProssesBlock(name: (AppDelegate.genModel.nodeAt(index: i)?.value.blocks.name())!, frame: NSRect(x: 80, y: 10 + (70*i), width: 80, height: 55))
                scrollSize.height = prosess.frame.origin.y + prosess.frame.size.height
                documentView.addSubview(prosess)
            }
           
            i += 1
        }
        
        
        subviewFrame.size = scrollSize

        documentView.frame = subviewFrame
        documentView.wantsLayer = true
        
        scroll.backgroundColor = NSColor.green.withAlphaComponent(0.2)
        scroll.documentView = documentView
        scroll.contentView.scroll(to: .zero)
        
        print( AppDelegate.genModel.description)
    }

    @IBAction func addNewBlock(_ sender: Any) {
        if let controller = self.storyboard?.instantiateController(withIdentifier: "AddNewBlockController") as? AddNewBlockController {
            self.view.window?.contentViewController = controller
        }
    }
    
    @IBAction func generate(_ sender: Any) {
        let generation = Generation(generated: AppDelegate.genModel)
        textView.string = generation.generat()
    }
}

