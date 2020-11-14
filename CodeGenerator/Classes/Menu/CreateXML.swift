//
//  CreateXML.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 09.11.2020.
//

import Foundation

class CreateXML {
    func generateXML() -> XMLDocument {
        let data = GenModelController.shared
        let root = XMLElement(name: "root")
        let xml = XMLDocument(rootElement: root)
        let vars = XMLElement(name: "vars")
        root.addChild(vars)
        var i = 1
        for pascalVar in data.getArrayType() {
            let elem = XMLElement(name: "var_\(i)")
            elem.setAttributesWith(["type": pascalVar.type.name(), "name": pascalVar.name])
            vars.addChild(elem)
            i += 1
        }
        var blocks = XMLElement(name: "blocks")
        root.addChild(blocks)
        i = 1
        for item in data.blocksList {
            addBlock(item: item, parent: &blocks, index: i)
            i += 1
        }
        
        return xml
    }
    
    private func addBlock(item: ModelBlock, parent: inout XMLElement, index: Int) {
        var elem = XMLElement(name: "elem_\(index)")
        elem.setAttributesWith(["block": item.blocks.name(), "name" : item.name!])
        var j = 1
        for values in item.values ?? [] {
            let value = XMLElement(name: "value_\(j)")
            value.setAttributesWith(["name" : values])
            j += 1
            elem.addChild(value)
            if item.blocks == .ifblock {
                bodyIf(item: item, parent: &elem)
            }
            if item.blocks == .whileblock {
                bodyWhile(item: item, parent: &elem)
            }
            if item.blocks == .forblock {
                bodyWhile(item: item, parent: &elem)
            }
        }
        parent.addChild(elem)
    }
    
    private func bodyWhile(item: ModelBlock, parent: inout XMLElement) {
        let whileItem = item as! WhileModelBlock
        var body = XMLElement(name: "body")
        var j = 1
        for itemB in whileItem.body {
            addBlock(item: itemB, parent: &body, index: j)
            j += 1
        }
        parent.addChild(body)
    }
    
    private func bodyIf(item: ModelBlock, parent: inout XMLElement){
        let ifItem = item as! IfModelBlock
        var left = XMLElement(name: "left")
        var j = 1
        for itemL in ifItem.left {
            addBlock(item: itemL, parent: &left, index: j)
            j += 1
        }
        parent.addChild(left)
        var right = XMLElement(name: "right")
        j = 1
        for itemR in ifItem.right {
            addBlock(item: itemR, parent: &right, index: j)
            j += 1
        }
        parent.addChild(right)
    }
}
