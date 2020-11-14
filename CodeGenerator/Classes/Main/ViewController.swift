//
//  ViewController.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 23.09.2020.
//

import Cocoa

class ViewController: NSViewController, ReloadDataDelegate {
    @IBOutlet private weak var textView: NSTextView!
    @IBOutlet private weak var scroll: NSScrollView!
    private var width: CGFloat = 200
    private let documentView = View(frame: NSRect(x: 0, y: 0, width: 0, height: 0))
    private var index: LinkedList<ModelBlock>.Index!
    private var gemMC: GenModelController!
    private lazy var editBlockProsessViewController: EditBlockProsessViewController = {
        return self.storyboard!.instantiateController(withIdentifier: "EditBlockProsessViewController") as! EditBlockProsessViewController
    }()
    private lazy var editBlockStreamViewController: EditBlockStreamViewController = {
        return self.storyboard!.instantiateController(withIdentifier: "EditBlockStreamViewController") as! EditBlockStreamViewController
    }()
    private lazy var editIfBlockController: EditIfBlockController = {
        return self.storyboard!.instantiateController(withIdentifier: "EditIfBlockController") as! EditIfBlockController
    }()
    private lazy var editBlockWhileViewController: EditBlockWhileViewController = {
        return self.storyboard!.instantiateController(withIdentifier: "EditBlockWhileViewController") as! EditBlockWhileViewController
    }()
    private lazy var editProcedureViewController: EditProcedureViewController = {
        return self.storyboard!.instantiateController(withIdentifier: "EditProcedureViewController") as! EditProcedureViewController
    }()
    private lazy var editBlcokForViewController: EditBlcokForViewController = {
        return self.storyboard!.instantiateController(withIdentifier: "EditBlcokForViewController") as! EditBlcokForViewController
    }()
    
    func reloadTable() {
        documentView.subviews.forEach({ $0.removeFromSuperview() })
        drawBlokAlg(offset: 80)
        documentView.subviews.forEach({ $0.removeFromSuperview() })
        drawBlokAlg(offset: width / 2)
    }
    
    @IBAction func addNewBlock(_ sender: Any) {
        if let controller = self.storyboard?.instantiateController(withIdentifier: "AddNewBlockController") as? AddNewBlockController {
            self.view.window?.contentViewController = controller
        }
    }
    
    @IBAction func addNewVars(_ sender: Any) {
        if let controller = self.storyboard?.instantiateController(withIdentifier: "NewVarsController") as? NewVarsController {
            self.view.window?.contentViewController = controller
        }
    }
    
    @IBAction func generate(_ sender: Any) {
        let generation = Generation(generated: gemMC)
        if !generation.algIsCorrect() {
            let errorAlert = DeleteAlert(question: "Ошибка при генерации", text: generation.getError())
            errorAlert.showError()
            return
        }
        textView.string = generation.generat()
    }
    
    override func viewDidLoad() {
        gemMC = GenModelController.shared
        super.viewDidLoad()
    }
    
    override var representedObject: Any? { didSet { } }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.title = "BlockToCode"
    }
    
    @objc private func goEditProssesBlock(_ sender: ProssesBlock) {
        index = gemMC.blocksList.index(gemMC.blocksList.startIndex, offsetBy: sender.tag )
        editBlockProsessViewController.myProcess = gemMC.blocksList[index]
        self.view.window?.contentViewController = editBlockProsessViewController
    }
    
    @objc private func goEditStreamBlock(_ sender: StreamBlock) {
        index = gemMC.blocksList.index(gemMC.blocksList.startIndex, offsetBy: sender.tag )
        editBlockStreamViewController.myStream = gemMC.blocksList[index]
        self.view.window?.contentViewController = editBlockStreamViewController
    }
    
    @objc private func goEditIfBlock(_ sender: IfBlock) {
        index = gemMC.blocksList.index(gemMC.blocksList.startIndex, offsetBy: sender.tag )
        editIfBlockController.myIfModel = gemMC.blocksList[index] as? IfModelBlock
        self.view.window?.contentViewController = editIfBlockController
    }
    
    @objc private func goEditWhileBlock(_ sender: IfBlock) {
        index = gemMC.blocksList.index(gemMC.blocksList.startIndex, offsetBy: sender.tag )
        editBlockWhileViewController.myWileBlock = gemMC.blocksList[index] as? WhileModelBlock
        self.view.window?.contentViewController = editBlockWhileViewController
    }
    
    @objc private func goEditForBlock(_ sender: IfBlock) {
        index = gemMC.blocksList.index(gemMC.blocksList.startIndex, offsetBy: sender.tag )
        editBlcokForViewController.myWileBlock = gemMC.blocksList[index] as? WhileModelBlock
        self.view.window?.contentViewController = editBlcokForViewController
    }
    
    @objc private func goEditProcedure(_ sender: ProssesBlock) {
        index = gemMC.blocksList.index(gemMC.blocksList.startIndex, offsetBy: sender.tag )
        editProcedureViewController.myProcess = gemMC.blocksList[index]
        self.view.window?.contentViewController = editProcedureViewController
    }
    
    override func viewWillAppear() {
        drawBlokAlg(offset: 80)
        documentView.subviews.forEach({ $0.removeFromSuperview() })
        drawBlokAlg(offset:  width / 2)
    }
    
    private func drawLine(offset: CGFloat, scrollSize: inout CGSize) {
        let line = Line(frame: NSRect(x: offset, y: scrollSize.height, width: 100, height: 25))
        scrollSize.height = line.frame.origin.y + line.frame.size.height
        documentView.addSubview(line)
    }
    
    private func drawBlokAlg(offset: CGFloat) {
        var i = 0;
        var scrollSize = CGSize(width: scroll.frame.size.width, height: 0)
        let blocksList = gemMC.blocksList
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
                drawLine(offset: offset, scrollSize: &scrollSize)
            }
            
            if blocksList.contains(where: { (in_block) -> Bool in
                return (block.blocks == in_block.blocks) && block.blocks == .prosess
            }) {
                drawProcess(jscrollSize: &scrollSize, item: block, offset: Int(offset)) { (process) in
                    process.tag = i
                    process.target = self
                    process.delegate = self
                    process.action = #selector(ViewController.goEditProssesBlock(_:))
                }
            }
            
            if blocksList.contains(where: { (in_block) -> Bool in
                return (block.blocks == in_block.blocks) && block.blocks == .procedure
            }) {
                drawProc(jscrollSize: &scrollSize, item: block, offset: Int(offset)) { (process) in
                    process.tag = i
                    process.target = self
                    process.delegate = self
                    process.action = #selector(ViewController.goEditProcedure(_:))
                }
            }
            
            if blocksList.contains(where: { (in_block) -> Bool in
                return (block.blocks == in_block.blocks) && (block.blocks == .outstream || block.blocks == .instream)
            }) {
                drawStream(jscrollSize: &scrollSize, item: block, offset: Int(offset)) { (stream) in
                    stream.tag = i
                    stream.target = self
                    stream.action = #selector(ViewController.goEditStreamBlock(_:))
                    stream.delegate = self
                }
            }
            
            if blocksList.contains(where: { (in_block) -> Bool in
                return (block.blocks == in_block.blocks) && block.blocks == .ifblock
            }) {
                drawIf(scrollSize: &scrollSize, block: block, offset: Int(offset)) { (ifblock) in
                    ifblock.tag = i
                    ifblock.target = self
                    ifblock.action = #selector(ViewController.goEditIfBlock(_:))
                    ifblock.delegate = self
                }
            }
            
            if blocksList.contains(where: { (in_block) -> Bool in
                return (block.blocks == in_block.blocks) && block.blocks == .whileblock
            }) {
                drawWhile(scrollSize: &scrollSize, block: block, offset: Int(offset)) { (blockWhile) in
                    blockWhile.tag = i
                    blockWhile.target = self
                    blockWhile.action = #selector(ViewController.goEditWhileBlock(_:))
                    blockWhile.delegate = self
                }
            }
            
            if blocksList.contains(where: { (in_block) -> Bool in
                return (block.blocks == in_block.blocks) && block.blocks == .forblock
            }) {
                drawFor(scrollSize: &scrollSize, block: block, offset: Int(offset)) { (blockWhile) in
                    blockWhile.tag = i
                    blockWhile.target = self
                    blockWhile.action = #selector(ViewController.goEditForBlock(_:))
                    blockWhile.delegate = self
                }
            }
            
            i += 1
        }
        
        let subviewFrame = CGRect(origin: .zero, size: scrollSize)
        documentView.frame = subviewFrame
        documentView.wantsLayer = true
        scroll.documentView = documentView
        scroll.contentView.scroll(to: .zero)
    }
    
    private func maxXForScroll(scrollSize: inout CGSize, maxX: CGFloat) {
        scrollSize.width = max(maxX, scrollSize.width)
    }
    
    private func drawProcess(jscrollSize : inout CGSize, item: ModelBlock, offset: Int, completion: @escaping (BaseBlock)->()) {
        let prosess = ProssesBlock(name: textInBlock(item: item), frame: NSRect(x: offset, y: Int(jscrollSize.height), width: 100, height: 50))
        prosess.title = textInBlock(item: item)
        completion(prosess)
        addToDocumentView(jscrollSize: &jscrollSize, offset: offset, item: prosess)
    }
    
    private func drawProc(jscrollSize : inout CGSize, item: ModelBlock, offset: Int, completion: @escaping (BaseBlock)->()) {
        let proc = ProcBlock(name: textInBlock(item: item), frame: NSRect(x: offset, y: Int(jscrollSize.height), width: 100, height: 50))
        proc.title = textInBlock(item: item)
        completion(proc)
        addToDocumentView(jscrollSize: &jscrollSize, offset: offset, item: proc)
    }
    
    private func drawStream(jscrollSize : inout CGSize, item: ModelBlock, offset: Int, completion: @escaping (BaseBlock)->()) {
        let stream = StreamBlock(name: textInBlock(item: item), frame: NSRect(x: offset, y: Int(jscrollSize.height), width: 100, height: 50))
        completion(stream)
        addToDocumentView(jscrollSize: &jscrollSize, offset: offset, item: stream)
    }
    
    private func addToDocumentView(jscrollSize : inout CGSize, offset: Int, item: BaseBlock) {
        jscrollSize.height = item.frame.origin.y + item.frame.size.height
        documentView.addSubview(item)
        drawLine(offset: CGFloat(offset), scrollSize: &jscrollSize)
        maxXForScroll(scrollSize: &jscrollSize, maxX: item.frame.maxX)
    }
    
    private func textInBlock(item: ModelBlock) -> String {
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
    
    private func getNameCondition(block: ModelBlock) -> String {
        var blockName = ""
        if block.values == nil || block.values?.count == 0 {
            blockName = "Условие"
        } else {
            blockName = (block.values?[0])!
        }
        return blockName
    }
    
    private func drawFor(scrollSize : inout CGSize, block: ModelBlock, offset: Int, completion: @escaping (BaseBlock)->()) {
        let forblock = ForBlock(name: getNameCondition(block: block), frame: NSRect(x: offset, y: Int(scrollSize.height), width: 100, height: 50))
        scrollSize.height = forblock.frame.origin.y + forblock.frame.size.height
        completion(forblock)
        documentView.addSubview(forblock)
        let topWhileLine = TopWhileLine(frame: NSRect(x: Int(forblock.frame.minX) - 50, y: Int(forblock.frame.midY) - 10, width: Int(forblock.frame.width), height: 50))
        documentView.addSubview(topWhileLine, positioned: .below, relativeTo: forblock)
        cycleEndPart(whileblock: forblock, block: block, offset: offset, scrollSize: &scrollSize)
    }
    
    private func drawWhile(scrollSize : inout CGSize, block: ModelBlock, offset: Int, completion: @escaping (BaseBlock)->()) {
        let whileblock = IfBlock(name: getNameCondition(block: block), frame: NSRect(x: offset, y: Int(scrollSize.height), width: 100, height: 50))
        scrollSize.height = whileblock.frame.origin.y + whileblock.frame.size.height
        completion(whileblock)
        documentView.addSubview(whileblock)
        let topWhileLine = TopWhileLine(frame: NSRect(x: Int(whileblock.frame.minX) - 50, y: Int(scrollSize.height - whileblock.frame.height) - 15, width: 146 + Int(whileblock.frame.width)/2, height: 50))
        documentView.addSubview(topWhileLine, positioned: .below, relativeTo: whileblock)
        drawLables(title: "нет", rect: CGRect(x: Int(whileblock.frame.maxX) - 5, y: Int(whileblock.frame.midY) - 20, width: 25, height: 25))
        drawLables(title: "да", rect: CGRect(x: Int(whileblock.frame.midX) - 30, y: Int(whileblock.frame.maxY), width: 25, height: 25))
        cycleEndPart(whileblock: whileblock, block: block, offset: offset, scrollSize: &scrollSize)
    }
    
    private func cycleEndPart(whileblock:BaseBlock, block: ModelBlock, offset: Int, scrollSize: inout CGSize) {
        let outWileLine = OutWileLine(frame: NSRect(x:  Int(whileblock.frame.maxX) - 58, y: Int(scrollSize.height - whileblock.frame.height/2) - 1, width: 116, height: 50))
        drawLine(offset: CGFloat(offset), scrollSize: &scrollSize)
        scrollSize.height = outWileLine.frame.origin.y + outWileLine.frame.size.height
        documentView.addSubview(outWileLine, positioned: .below, relativeTo: whileblock)
        drawBodyWhile(scrollSize : &scrollSize, block: block, parent: whileblock)
    }
    
    private func drawBodyWhile(scrollSize : inout CGSize, block: ModelBlock, parent: BaseBlock) {
        for item in (block as! WhileModelBlock).body {
            branch(scrollSize: &scrollSize, item: item, xOffset: Int(parent.frame.minX))
        }
        
        let line = Line(frame: NSRect(x: parent.frame.minX - 49, y: parent.frame.minY + 30, width: 2, height: scrollSize.height - parent.frame.maxY))
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
    
    
    private func drawLables(title: String, rect: CGRect) {
        let label = NSTextField(string: title)
        label.backgroundColor = .clear
        label.isEditable = false
        label.isBordered = false
        label.isSelectable = false
        label.frame = rect
        documentView.addSubview(label)
    }
    
    private func drawIf(scrollSize : inout CGSize, block: ModelBlock, offset: Int, completion: @escaping (BaseBlock)->()) {
        let ifblock = IfBlock(name: getNameCondition(block: block), frame: NSRect(x: offset, y: Int(scrollSize.height), width: 100, height: 50))
        scrollSize.height = ifblock.frame.origin.y + ifblock.frame.size.height
        completion(ifblock)
        documentView.addSubview(ifblock)
        drawLables(title: "да", rect: CGRect(x: Int(ifblock.frame.minX) - 10, y: Int(ifblock.frame.midY) - 20, width: 25, height: 25))
        drawLables(title: "нет", rect: CGRect(x: Int(ifblock.frame.maxX) - 5, y: Int(ifblock.frame.midY) - 20, width: 25, height: 25))
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
    
    private func drawBodyIf(scrollSize : inout CGSize, block: ModelBlock, parent: IfBlock) {
        var jscrollSize = scrollSize
        
        for item in (block as! IfModelBlock).left {
            branch(scrollSize: &jscrollSize, item: item, xOffset: Int(parent.frame.minX) - Int(parent.frame.width) + 2)
        }
        
        var kscrollSize = scrollSize
        for item in (block as! IfModelBlock).right {
            branch(scrollSize: &kscrollSize, item: item, xOffset: Int(parent.frame.maxX) - 2)
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
    
    private func branch(scrollSize: inout CGSize, item: ModelBlock, xOffset: Int) {
        let blockE = item.blocks
        switch blockE {
        case .prosess:
            drawProcess(jscrollSize: &scrollSize, item: item, offset: xOffset) { (block) in }
            break
        case .procedure:
            drawProc(jscrollSize: &scrollSize, item: item, offset: xOffset) { (block) in }
        case .instream, .outstream:
            drawStream(jscrollSize: &scrollSize, item: item, offset: xOffset) { (block) in }
            break
        case .ifblock:
            drawIf(scrollSize: &scrollSize, block: item, offset: xOffset) { (block) in }
            break;
        case .whileblock:
            drawWhile(scrollSize: &scrollSize, block: item, offset: xOffset) { (block) in }
            break
        case .forblock:
            drawFor(scrollSize: &scrollSize, block: item, offset: xOffset) { (block) in }
        default:
            break
        }
    }
}
