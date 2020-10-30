//
//  BaseBlock.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 23.10.2020.
//

import Cocoa

class BaseBlock: NSButton {
    var blockName: String?
    var numberOfExit: Int?
    var numberOfEnters: Int?
    var delegate: ReloadDataDelegate!
    init(nameBlock: String, frame: NSRect, numberOfExit: Int?, numberOfEnters: Int?) {
        super.init(frame: frame)
        blockName = nameBlock;
        self.numberOfExit = numberOfExit
        self.numberOfEnters = numberOfEnters
        font = NSFont.systemFont(ofSize: 13, weight: NSFont.Weight.medium)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    func setTag(tag: Int) {
        self.tag = tag
    }
    
    func getTag() -> Int {
        return tag
    }
    
    @objc
    func swap(sender: NSMenuItem)  {
        print(self.getTag())
        print("\(sender.title)  \(sender.tag)")
        let indexFrom = GenModelController.shared.blocksList.index(GenModelController.shared.blocksList.startIndex, offsetBy: self.getTag() )
        let indexTo = GenModelController.shared.blocksList.index(GenModelController.shared.blocksList.startIndex, offsetBy: sender.tag )
        GenModelController.shared.blocksList[indexTo].tag = self.getTag()
        GenModelController.shared.blocksList[indexFrom].tag = sender.tag
        GenModelController.shared.blocksList.swapAt(indexFrom, indexTo)
        delegate.reloadTable()
    }
    @objc
    func deleteblock(sender: NSMenuItem)  {
        let index = GenModelController.shared.blocksList.index(GenModelController.shared.blocksList.startIndex, offsetBy: getTag())
        GenModelController.shared.blocksList.remove(at: index)
        delegate.reloadTable()
    }
    override func rightMouseDown(with theEvent: NSEvent) {
        if self.getTag() == -1 {
            return
        }
        let menu = NSMenu()
        let deleteItem = NSMenuItem(
            title: "Удалить \(self.blockName ?? "")",
            action:  #selector(deleteblock(sender: )),
            keyEquivalent: ""
        )
        deleteItem.target = self
        menu.addItem(deleteItem)
        
        let aboutItem = NSMenuItem(
            title: "Поменять \(self.blockName ?? "") местами c",
            action:  nil,
            keyEquivalent: ""
        )
        menu.addItem(aboutItem)
        for block in GenModelController.shared.blocksList {
            if block.blocks == .start || block.blocks == .end || block.tag == self.getTag() {
                continue
            }
            let quitItem = NSMenuItem()
            quitItem.tag = block.tag ?? 0
            quitItem.title = block.name ?? ""
            quitItem.action = #selector(swap(sender: ))
            quitItem.target = self
            menu.addItem(quitItem)
        }
        aboutItem.target = self
        menu.popUp(positioning: aboutItem, at: NSPoint(x: 50, y: 0), in: self)
    }
}
