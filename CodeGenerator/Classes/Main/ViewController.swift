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
    @IBOutlet weak var textView: NSTextView!
    @IBOutlet weak var scroll: NSScrollView!
    var width: CGFloat = 200
    let documentView = View(frame: NSRect(x: 0, y: 0, width: 0, height: 0))
    lazy var editBlockProsessViewController: EditBlockProsessViewController = {
        return self.storyboard!.instantiateController(withIdentifier: "EditBlockProsessViewController") as! EditBlockProsessViewController
    }()
    lazy var editBlockStreamViewController: EditBlockStreamViewController = {
        return self.storyboard!.instantiateController(withIdentifier: "EditBlockStreamViewController") as! EditBlockStreamViewController
    }()
    lazy var editIfBlockController: EditIfBlockController = {
        return self.storyboard!.instantiateController(withIdentifier: "EditIfBlockController") as! EditIfBlockController
    }()
    lazy var editBlockWhileViewController: EditBlockWhileViewController = {
        return self.storyboard!.instantiateController(withIdentifier: "EditBlockWhileViewController") as! EditBlockWhileViewController
    }()
    
    func reloadTable() {
        documentView.subviews.forEach({ $0.removeFromSuperview() })
        drawBlokAlg(offset: 80)
        documentView.subviews.forEach({ $0.removeFromSuperview() })
        drawBlokAlg(offset:  width / 2)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var representedObject: Any? { didSet { } }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.title = "BlockToCode"
    }
    
    @objc func goEditProssesBlock(_ sender: ProssesBlock) {
        let index = GenModelController.shared.blocksList.index(GenModelController.shared.blocksList.startIndex, offsetBy: sender.tag )
        editBlockProsessViewController.myProcess = GenModelController.shared.blocksList[index]
        self.view.window?.contentViewController = editBlockProsessViewController
    }
    
    @objc func goEditStreamBlock(_ sender: StreamBlock) {
        print(sender.tag)
        let index = GenModelController.shared.blocksList.index(GenModelController.shared.blocksList.startIndex, offsetBy: sender.tag )
        editBlockStreamViewController.myStream = GenModelController.shared.blocksList[index]
        self.view.window?.contentViewController = editBlockStreamViewController
    }
    
    @objc func goEditIfBlock(_ sender: StreamBlock) {
        print(sender.tag)
        editIfBlockController.tag = sender.tag
        let index = GenModelController.shared.blocksList.index(GenModelController.shared.blocksList.startIndex, offsetBy: sender.tag )
        editIfBlockController.myIfModel = (GenModelController.shared.blocksList[index] as! IfModelBlock)
        
        self.view.window?.contentViewController = editIfBlockController
    }
    
    @objc func goEditWhileBlock(_ sender: IfBlock) {
        print(sender.tag)
        editBlockWhileViewController.tag = sender.tag
        let index = GenModelController.shared.blocksList.index(GenModelController.shared.blocksList.startIndex, offsetBy: sender.tag )
        editBlockWhileViewController.myWileBlock = GenModelController.shared.blocksList[index] as? WhileModelBlock
        
        
        self.view.window?.contentViewController = editBlockWhileViewController
    }
    
    override func viewWillAppear() {
        drawBlokAlg(offset: 80)
        documentView.subviews.forEach({ $0.removeFromSuperview() })
        drawBlokAlg(offset:  width / 2)
        
    }
    
    func drawBlokAlg(offset: CGFloat) {
        var i = 0;
        var scrollSize = CGSize(width: scroll.frame.size.width, height: 0)
        var subviewFrame = CGRect(origin: .zero, size: scrollSize)
        let blocksList = GenModelController.shared.blocksList
        for block in blocksList {
            if blocksList.contains(where: { (in_block) -> Bool in
                return (block.blocks == in_block.blocks) && block.blocks == .end
            }) {
                let end = EndBlock(name: block.name ?? "no name", frame: NSRect(x: offset, y: scrollSize.height, width: 100, height: 50))
                scrollSize.height = end.frame.origin.y + end.frame.size.height
                documentView.addSubview(end)
            }
            
            if blocksList.contains(where: { (in_block) -> Bool in
                return (block.blocks == in_block.blocks) && block.blocks == .start
            }) {
                let start = StartBlock(name: block.name ?? "no name", frame: NSRect(x: offset, y: scrollSize.height, width: 100, height: 50))
                scrollSize.height = start.frame.origin.y + start.frame.size.height
                documentView.addSubview(start)
                let line = Line(frame: NSRect(x: offset, y: scrollSize.height, width: 100, height: 25))
                scrollSize.height = line.frame.origin.y + line.frame.size.height
                documentView.addSubview(line)
            }
            
            if blocksList.contains(where: { (in_block) -> Bool in
                return (block.blocks == in_block.blocks) && block.blocks == .prosess
            }) {
                drawProcess(jscrollSize: &scrollSize, item: block, offset: Int(offset), tag: i, isFirst: true)
            }
            if blocksList.contains(where: { (in_block) -> Bool in
                return (block.blocks == in_block.blocks) && block.blocks == .instream
            }) {
                drawStream(jscrollSize: &scrollSize, item: block, offset: Int(offset), tag: i, isFirst: true)
            }
            if blocksList.contains(where: { (in_block) -> Bool in
                return (block.blocks == in_block.blocks) && block.blocks == .outstream
            }) {
                drawStream(jscrollSize: &scrollSize, item: block, offset: Int(offset), tag: i, isFirst: true)
            }
            
            if blocksList.contains(where: { (in_block) -> Bool in
                return (block.blocks == in_block.blocks) && block.blocks == .ifblock
            }) {
                drawIf(scrollSize: &scrollSize, tag: i, block: block, offset: Int(offset), isFirst: true)
            }
            
            if blocksList.contains(where: { (in_block) -> Bool in
                return (block.blocks == in_block.blocks) && block.blocks == .whileblock
            }) {
                drawWhile(scrollSize: &scrollSize, tag: i, block: block, offset: Int(offset), isFirst: true)
            }
            
            i += 1
        }
        
        subviewFrame.size = scrollSize
        documentView.frame = subviewFrame
        documentView.wantsLayer = true
        scroll.documentView = documentView
        scroll.contentView.scroll(to: .zero)
    }
    
    func maxXForScroll(scrollSize: inout CGSize, maxX: CGFloat) {
        scrollSize.width = max(maxX, scrollSize.width)
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
        if !generation.algIsCorrect() {
            let errorAlert = DeleteAlert(question: "Ошибка при генерации", text: generation.getError())
            errorAlert.showError()
            return
        }
        textView.string = generation.generat()
    }
    
    func drawProcess(jscrollSize : inout CGSize, item: ModelBlock, offset: Int, tag: Int, isFirst: Bool) {
        let prosess = ProssesBlock(name: item.name ?? "no name", frame: NSRect(x: offset, y: Int(jscrollSize.height), width: 100, height: 50))
        prosess.title = textInBlock(item: item)
        
        if isFirst {
            prosess.tag = tag
            prosess.target = self
            prosess.delegate = self
            prosess.action = #selector(ViewController.goEditProssesBlock(_:))
        }
        
        jscrollSize.height = prosess.frame.origin.y + prosess.frame.size.height
        documentView.addSubview(prosess)
        let line = Line(frame: NSRect(x: offset, y: Int(jscrollSize.height), width: 100, height: 25))
        jscrollSize.height = line.frame.origin.y + line.frame.size.height
        documentView.addSubview(line)
        maxXForScroll(scrollSize: &jscrollSize, maxX: prosess.frame.maxX)
    }
    
    func drawStream(jscrollSize : inout CGSize, item: ModelBlock, offset: Int, tag: Int, isFirst: Bool) {
        let stream = StreamBlock(name: textInBlock(item: item), frame: NSRect(x: offset, y: Int(jscrollSize.height), width: 100, height: 50))
        
        if isFirst {
            stream.tag = tag
            stream.target = self
            stream.action = #selector(ViewController.goEditStreamBlock(_:))
            stream.delegate = self
        }
        
        jscrollSize.height = stream.frame.origin.y + stream.frame.size.height
        documentView.addSubview(stream)
        let line = Line(frame: NSRect(x: offset, y: Int(jscrollSize.height), width: 100, height: 25))
        jscrollSize.height = line.frame.origin.y + line.frame.size.height
        documentView.addSubview(line)
        maxXForScroll(scrollSize: &jscrollSize, maxX: stream.frame.maxX)
    }
    
    func textInBlock(item: ModelBlock) -> String {
        var pTitle = ""
        if item.values != nil && item.values?.count != 0 {
            var i = 1
            for str in item.values ?? [] {
                pTitle += str
                if item.values?.count != i { pTitle += "\n" }
                i += 1
            }
        } else {
            pTitle = item.name ?? ""
        }
        return pTitle
    }
    
    func drawWhile(scrollSize : inout CGSize, tag: Int, block: ModelBlock, offset: Int, isFirst: Bool) {
        var blockName = ""
        if block.values == nil || block.values?.count == 0 {
            blockName = "Условие"
        } else {
            blockName = (block.values?[0])!
        }
        
        let whileblock = IfBlock(name: blockName, frame: NSRect(x: offset, y: Int(scrollSize.height), width: 100, height: 50))
        scrollSize.height = whileblock.frame.origin.y + whileblock.frame.size.height
        if isFirst {
            whileblock.tag = tag
            whileblock.target = self
            whileblock.action = #selector(ViewController.goEditWhileBlock(_:))
            whileblock.delegate = self
        }
        documentView.addSubview(whileblock)
        let topWhileLine = TopWhileLine(frame: NSRect(x: Int(whileblock.frame.minX) - 50, y: Int(scrollSize.height - whileblock.frame.height) - 15, width: 146 + Int(whileblock.frame.width)/2, height: 50))
        documentView.addSubview(topWhileLine, positioned: .below, relativeTo: whileblock)
        
        let line = Line(frame: NSRect(x: offset, y: Int(scrollSize.height), width: 100, height: 25))
        documentView.addSubview(line)
        let outWileLine = OutWileLine(frame: NSRect(x:  Int(whileblock.frame.maxX) - 58, y: Int(scrollSize.height - whileblock.frame.height/2) - 1, width: 116, height: 50))
        scrollSize.height = line.frame.origin.y + line.frame.size.height
        scrollSize.height = outWileLine.frame.origin.y + outWileLine.frame.size.height
        documentView.addSubview(outWileLine, positioned: .below, relativeTo: whileblock)
        
        drawBodyWhile(scrollSize : &scrollSize, block: block, parent: whileblock)
    }
    func drawBodyWhile(scrollSize : inout CGSize, block: ModelBlock, parent: IfBlock) {
        for item in (block as! WhileModelBlock).body {
            let blockE = item.blocks
            switch blockE {
            case .start:
                break;
            case .end:
                break;
            case .prosess:
                drawProcess(jscrollSize: &scrollSize, item: item, offset: Int(parent.frame.minX), tag: 0, isFirst: false)
                break;
            case .instream:
                drawStream(jscrollSize: &scrollSize, item: item, offset: Int(parent.frame.minX), tag: 0, isFirst: false)
                break;
            case .outstream:
                drawStream(jscrollSize: &scrollSize, item: item, offset: Int(parent.frame.minX), tag: 0, isFirst: false)
                break;
            case .ifblock:
                drawIf(scrollSize: &scrollSize, tag: 1, block: item, offset: Int(parent.frame.minX), isFirst: false)
            case .whileblock:
                drawWhile(scrollSize: &scrollSize, tag: 1, block: item, offset: Int(parent.frame.minX), isFirst: false)
            }
        }
        let line = Line(frame: NSRect(x: parent.frame.minX - 49, y: parent.frame.minY, width: 2, height: scrollSize.height - parent.frame.maxY + 25))
        documentView.addSubview(line)
        let lineEnd = Line(frame: NSRect(x: parent.frame.maxX + 47, y: parent.frame.maxY, width: 2, height: scrollSize.height - parent.frame.maxY))
        documentView.addSubview(lineEnd)
        let endIfLine = EndIfLine(frame: NSRect(x: parent.frame.origin.x - parent.frame.size.width/2, y: lineEnd.frame.maxY, width: 200, height: 50), dir: false)
        documentView.addSubview(endIfLine)
        let EndlineTrue = EndWhileLine(frame: NSRect(x: Int(parent.frame.minX) - 50, y: Int(scrollSize.height) - 25, width: 200, height: 75))
        documentView.addSubview(EndlineTrue)
        scrollSize.height = endIfLine.frame.origin.y + endIfLine.frame.size.height
        maxXForScroll(scrollSize: &scrollSize, maxX: endIfLine.frame.maxX)
    }
    
    func drawIf(scrollSize : inout CGSize, tag: Int, block: ModelBlock, offset: Int, isFirst: Bool) {
        var blockName = ""
        if block.values == nil || block.values?.count == 0 {
            blockName = "Условие"
        } else {
            blockName = (block.values?[0])!
        }
        
        let ifblock = IfBlock(name: blockName, frame: NSRect(x: offset, y: Int(scrollSize.height), width: 100, height: 50))
        scrollSize.height = ifblock.frame.origin.y + ifblock.frame.size.height
        if isFirst {
            ifblock.tag = tag
            ifblock.target = self
            ifblock.action = #selector(ViewController.goEditIfBlock(_:))
            ifblock.delegate = self
        }
        documentView.addSubview(ifblock)
        let lineTrue = IfLine(frame: NSRect(x: Int(ifblock.frame.minX) - 58, y: Int(scrollSize.height - ifblock.frame.height/2) - 1, width: 130, height: 50), dir: true)
        documentView.addSubview(lineTrue, positioned: .below, relativeTo: ifblock)
        let lineFalse = IfLine(frame: NSRect(x:  Int(ifblock.frame.maxX) - 58, y: Int(scrollSize.height - ifblock.frame.height/2) - 1, width: 116, height: 50), dir: false)
        
        scrollSize.height = lineFalse.frame.origin.y + lineFalse.frame.size.height
        documentView.addSubview(lineFalse, positioned: .below, relativeTo: ifblock)
        drawBodyIf(scrollSize: &scrollSize, block: block, parent: ifblock)
        let EndlineTrue = EndIfLine(frame: NSRect(x: Int(ifblock.frame.minX) - 50, y: Int(scrollSize.height), width: 200, height: 50), dir: true)
        documentView.addSubview(EndlineTrue)
        let EndlineFalse = EndIfLine(frame: NSRect(x: Int(ifblock.frame.origin.x) - Int(ifblock.frame.size.width)/2, y: Int(scrollSize.height), width: 200, height: 50), dir: false)
        scrollSize.height = EndlineFalse.frame.origin.y + EndlineFalse.frame.size.height
        documentView.addSubview(EndlineFalse)
        maxXForScroll(scrollSize: &scrollSize, maxX: EndlineFalse.frame.maxX + 5)
    }
    
    func drawBodyIf(scrollSize : inout CGSize, block: ModelBlock, parent: IfBlock) {
        var jscrollSize = scrollSize
        
        for item in (block as! IfModelBlock).left {
            let blockE = item.blocks
            switch blockE {
            case .start:
                break;
            case .end:
                break;
            case .prosess:
                drawProcess(jscrollSize: &jscrollSize, item: item, offset: Int(parent.frame.minX) - Int(parent.frame.width) + 2, tag: 0, isFirst: false)
                break;
            case .instream:
                drawStream(jscrollSize: &jscrollSize, item: item, offset: Int(parent.frame.minX) - Int(parent.frame.width) + 2, tag: 0, isFirst: false)
                break;
            case .outstream:
                drawStream(jscrollSize: &jscrollSize, item: item, offset: Int(parent.frame.minX) - Int(parent.frame.width) + 2, tag: 0, isFirst: false)
                break;
            case .ifblock:
                drawIf(scrollSize: &jscrollSize, tag: 1, block: item, offset: Int(parent.frame.minX) - Int(parent.frame.width) + 2, isFirst: false)
            case .whileblock:
                drawWhile(scrollSize: &jscrollSize, tag: 1, block: item, offset: Int(parent.frame.minX) - Int(parent.frame.width) + 2, isFirst: false)
            }
        }
        
        var kscrollSize = scrollSize
        for item in (block as! IfModelBlock).right {
            let blockE = item.blocks
            switch blockE {
            case .start:
                break;
            case .end:
                break;
            case .prosess:
                drawProcess(jscrollSize: &kscrollSize, item: item, offset: Int(parent.frame.maxX) - 2, tag: 0, isFirst: false)
                break;
            case .instream:
                drawStream(jscrollSize: &kscrollSize, item: item, offset: Int(parent.frame.maxX) - 2, tag: 0, isFirst: false)
                break;
            case .outstream:
                drawStream(jscrollSize: &kscrollSize, item: item, offset: Int(parent.frame.maxX) - 2, tag: 0, isFirst: false)
                break;
            case .ifblock:
                drawIf(scrollSize: &kscrollSize, tag: 1, block: item, offset: Int(parent.frame.maxX) - 2, isFirst: false)
            case .whileblock:
                drawWhile(scrollSize: &kscrollSize, tag: 1, block: item, offset: Int(parent.frame.maxX) - 2, isFirst: false)
            }
        }
        
        scrollSize.height = max(kscrollSize.height, jscrollSize.height)
        scrollSize.width = max(kscrollSize.width, jscrollSize.width)
        scrollSize.width += 50
        width = scrollSize.width
        if kscrollSize.height < jscrollSize.height {
            let line = Line(frame: NSRect(x: parent.frame.maxX + 47, y: kscrollSize.height, width: 2, height: jscrollSize.height - kscrollSize.height))
            documentView.addSubview(line)
            
        } else {
            let line = Line(frame: NSRect(x: parent.frame.minX - 49, y: jscrollSize.height, width: 2, height: kscrollSize.height - jscrollSize.height))
            documentView.addSubview(line)
        }
    }
    
}

