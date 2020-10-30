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

class ViewController: NSViewController, ReloadDataDelegate {
    
    func reloadTable() {
        documentView.subviews.forEach({ $0.removeFromSuperview() })
        viewWillAppear()
    }
    
    @IBOutlet weak var textView: NSTextView!
    @IBOutlet weak var scroll: NSScrollView!
    
    let documentView = View(frame: NSRect(x: 0, y: 0, width: 0, height: 0))
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var representedObject: Any? {
        didSet { }
    }
    
    lazy var editBlockProsessViewController: EditBlockProsessViewController = {
        return self.storyboard!.instantiateController(withIdentifier: "EditBlockProsessViewController") as! EditBlockProsessViewController
    }()
    lazy var editBlockStreamViewController: EditBlockStreamViewController = {
        return self.storyboard!.instantiateController(withIdentifier: "EditBlockStreamViewController") as! EditBlockStreamViewController
    }()
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.title = "BlockToCode"
    }

    @objc func goEditProssesBlock(_ sender: ProssesBlock) {
        print(sender.tag)
        editBlockProsessViewController.tag = sender.tag
        let index = GenModelController.shared.blocksList.index(GenModelController.shared.blocksList.startIndex, offsetBy: sender.tag )
        
        editBlockProsessViewController.sentacis = GenModelController.shared.blocksList[index].values ?? []
        self.view.window?.contentViewController = editBlockProsessViewController
    }

    @objc func goEditStreamBlock(_ sender: StreamBlock) {
        print(sender.tag)
        editBlockStreamViewController.tag = sender.tag
        let index = GenModelController.shared.blocksList.index(GenModelController.shared.blocksList.startIndex, offsetBy: sender.tag )
        
        editBlockStreamViewController.sentacis = GenModelController.shared.blocksList[index].values ?? []
        self.view.window?.contentViewController = editBlockStreamViewController
    }
    
    override func viewWillAppear() {
        var i = 0;
        var scrollSize = CGSize(width: scroll.frame.size.width, height: 0)
        var subviewFrame = CGRect(origin: .zero, size: scrollSize)
        for block in GenModelController.shared.blocksList {
            if GenModelController.shared.blocksList.contains(where: { (in_block) -> Bool in
                return (block.blocks == in_block.blocks) && block.blocks == .end
            }) {
                let end = EndBlock(name: block.name ?? "no name", frame: NSRect(x: 80, y: 10 + (70*i), width: 100, height: 50))
                scrollSize.height = end.frame.origin.y + end.frame.size.height
                documentView.addSubview(end)
            }
            
            if GenModelController.shared.blocksList.contains(where: { (in_block) -> Bool in
                return (block.blocks == in_block.blocks) && block.blocks == .start
            }) {
                let start = StartBlock(name: block.name ?? "no name", frame: NSRect(x: 80, y: 10 + (70*i), width: 100, height: 50))
                scrollSize.height = start.frame.origin.y + start.frame.size.height
                documentView.addSubview(start)
                let line = Line(frame: NSRect(x: 80, y: 60 + (70*i), width: 100, height: 50))
                documentView.addSubview(line)
            }
            
            if GenModelController.shared.blocksList.contains(where: { (in_block) -> Bool in
                return (block.blocks == in_block.blocks) && block.blocks == .prosess
            }) {
                let prosess = ProssesBlock(name: block.name ?? "no name", frame: NSRect(x: 80, y: 10 + (70*i), width: 100, height: 50))
                scrollSize.height = prosess.frame.origin.y + prosess.frame.size.height
                prosess.tag = i
                prosess.target = self
                prosess.delegate = self
                prosess.action = #selector(ViewController.goEditProssesBlock(_:))
                documentView.addSubview(prosess)
                let line = Line(frame: NSRect(x: 80, y: 60 + (70*i), width: 100, height: 50))
                documentView.addSubview(line)
            }
            if GenModelController.shared.blocksList.contains(where: { (in_block) -> Bool in
                return (block.blocks == in_block.blocks) && block.blocks == .instream
            }) {
                let instream = StreamBlock(name: block.name ?? "no name", frame: NSRect(x: 80, y: 10 + (70*i), width: 100, height: 50))
                scrollSize.height = instream.frame.origin.y + instream.frame.size.height
                instream.tag = i
                instream.target = self
                instream.delegate = self
                instream.action = #selector(ViewController.goEditStreamBlock(_:))
                documentView.addSubview(instream)
                let line = Line(frame: NSRect(x: 80, y: 60 + (70*i), width: 100, height: 50))
                documentView.addSubview(line)
            }
            if GenModelController.shared.blocksList.contains(where: { (in_block) -> Bool in
                return (block.blocks == in_block.blocks) && block.blocks == .outstream
            }) {
                let outstream = StreamBlock(name: block.name ?? "no name", frame: NSRect(x: 80, y: 10 + (70*i), width: 100, height: 50))
                scrollSize.height = outstream.frame.origin.y + outstream.frame.size.height
                outstream.tag = i
                outstream.target = self
                outstream.action = #selector(ViewController.goEditStreamBlock(_:))
                outstream.delegate = self
                documentView.addSubview(outstream)
                let line = Line(frame: NSRect(x: 80, y: 60 + (70*i), width: 100, height: 50))
                documentView.addSubview(line)
            }
            
            i += 1
        }
       
        subviewFrame.size = scrollSize

        documentView.frame = subviewFrame
        documentView.wantsLayer = true
        
        scroll.documentView = documentView
        scroll.contentView.scroll(to: .zero)
    }

    @IBAction func addNewBlock(_ sender: Any) {
        if let controller = self.storyboard?.instantiateController(withIdentifier: "AddNewBlockController") as? AddNewBlockController {
            self.view.window?.contentViewController = controller
        }
    }
    
    @IBAction func addNewVars(_ sender: Any) {
        if let controller = self.storyboard?.instantiateController(withIdentifier: "NewVarsController") as? NewVarsController {
            controller.directoryItems = GenModelController.shared.getArrayType()
            self.view.window?.contentViewController = controller
        }
    }
    
    @IBAction func generate(_ sender: Any) {
        let generation = Generation(generated: GenModelController.shared)
        textView.string = generation.generat()
    }
    
}

