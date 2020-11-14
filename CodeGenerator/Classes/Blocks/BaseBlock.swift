//
//  BaseBlock.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 23.10.2020.
//

import Cocoa

class BaseBlock: NSButton {
    private var blockName: String?
    var delegate: ReloadDataDelegate!
    private var data: GenModelController
    init(nameBlock: String, frame: NSRect) {
        data = GenModelController.shared
        super.init(frame: frame)
        blockName = nameBlock;
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
    
    @objc func swap(sender: NSMenuItem)  {
        let indexFrom = data.blocksList.index(data.blocksList.startIndex, offsetBy: self.getTag())
        let indexTo = data.blocksList.index(data.blocksList.startIndex, offsetBy: sender.tag)
        data.blocksList[indexTo].tag = self.getTag()
        data.blocksList[indexFrom].tag = sender.tag
        data.blocksList.swapAt(indexFrom, indexTo)
        delegate.reloadTable()
    }
    
    @objc func deleteblock(sender: NSMenuItem)  {
        let index = data.blocksList.index(data.blocksList.startIndex, offsetBy: getTag())
        data.blocksList.remove(at: index)
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
            keyEquivalent: "Q"
        )
        deleteItem.target = self
        menu.addItem(deleteItem)
        
        let aboutItem = NSMenuItem(
            title: "Поменять \(self.blockName ?? "") местами c",
            action:  nil,
            keyEquivalent: ""
        )
        aboutItem.target = self
        menu.addItem(aboutItem)
        for block in data.blocksList {
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
        menu.popUp(positioning: aboutItem, at: NSPoint(x: 50, y: 0), in: self)
    }
}
