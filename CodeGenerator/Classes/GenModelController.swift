//
//  GenModel.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 23.10.2020.
//

import Foundation


class GenModelController {
    fileprivate var head: Node?
    private var tail: Node?
    private var _count: Int = 0
    public var isEmpty: Bool {
        return head == nil
    }
    
    public var first: Node? {
        return head
    }
    
    public var last: Node? {
        return tail
    }
    
    public var count: Int {
        get {
            return _count
        }
    }
    
    
    
    public func append(value: ModelBlock) {
        let newNode = Node(value: value)
        if let tailNode = tail {
            newNode.previous = tailNode
            tailNode.next = newNode
            if tailNode.previous?.value.countExitBusy == 1 {
                tailNode.previous?.value.countExitBusy += 1
            }
            
        } else {
            if head == nil {
                head = newNode
                if head!.value.countExitBusy == 1 {
                    head!.value.countExitBusy += 1
                }
            } else {
                head?.next = newNode
                newNode.previous = head
                if head!.value.countExitBusy == 1 {
                    head!.value.countExitBusy += 1
                }
            }
        }
        tail = newNode
        if tail?.previous != nil {
            if (tail?.previous?.value.countExitBusy)! < (tail?.previous?.value.countExit)! {
                tail?.previous?.value.countExitBusy += 1
                tail?.value.countEntersBusy += 1
            }
        }
        _count += 1
    }
    
    public func addBegin(value: ModelBlock) {
        let newNode = Node(value: value)
        
        if head != nil {
            newNode.previous = nil
            newNode.next = head
            head?.previous = newNode
            head = newNode
        } else {
            head = newNode
        }
        _count += 1
    }
    
    
    public func nodeAt(index: Int) -> Node? {
        if index >= 0 {
            var node = head
            var i = index
            while node != nil {
                if i == 0 { return node }
                i -= 1
                node = node!.next
            }
        }
        return nil
    }
    
    public func removeAll() {
        head = nil
        tail = nil
    }
    
    public func remove(node: Node) -> ModelBlock {
        let prev = node.previous
        let next = node.next
        
        if let prev = prev {
            prev.next = next
        } else {
            head = next
        }
        next?.previous = prev
        
        if next == nil {
            tail = prev
        }
        
        node.previous = nil
        node.next = nil
        _count -= 1
        return node.value
    }
    
    public func isInclude(block: Blocks) -> Bool {
        var node = head
        while node != nil {
            if node!.value.blocks == block {
                return true
            }
            node = node!.next
        }
        return false
    }
    public func addPreEnd(value: ModelBlock) {
        let newNode = Node(value: value)
        if head == nil {
            addBegin(value: value)
            return
        }
        
        if tail != nil {
            newNode.previous = tail?.previous
            tail?.previous?.next = newNode
            newNode.next = tail
            tail?.previous = newNode
        } else {
            append(value: value)
            return
        }
        
        _count += 1
    }
    
    public func addType(name: String, type: VarType) {
        var_types.append(ModelType(name: name, type: type))
    }
    
    public func removeType(index: Int) {
        var_types.remove(at: index)
    }
    
    public func getArrayType() -> [ModelType] {
        return var_types
    }
    
    private var var_types = [ModelType]()
}

public class Node {
    
    var value: ModelBlock
    var next: Node?
    weak var previous: Node?
    
    init(value: ModelBlock) {
        self.value = value
    }
}

extension GenModelController: CustomStringConvertible {
    // 2
    public var description: String {
        // 3
        var text = "["
        var node = head
        // 4
        while node != nil {
            text += "\(node!.value.name ?? "")"
            node = node!.next
            if node != nil { text += ", " }
        }
        // 5
        return text + "]"
    }
}
