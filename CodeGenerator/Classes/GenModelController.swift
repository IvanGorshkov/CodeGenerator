//
//  GenModel.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 23.10.2020.
//

import Foundation


class GenModelController {
    static let shared = GenModelController()
    public var blocksList = LinkedList<ModelBlock>()
    public func addType(name: String, type: VarType) {
        varTypes.append(ModelType(name: name, type: type))
    }
    
    public func removeType(index: Int) {
        varTypes.remove(at: index)
    }
    
    public func removeTypeAll() {
        varTypes.removeAll()
    }
    
    
    public func getArrayType() -> [ModelType] {
        return varTypes
    }
    
    private var varTypes = [ModelType]()
}

public struct LinkedList<Element> {

    private var headNode: Node<Element>?
    private var tailNode: Node<Element>?
    public private(set) var count: Int = 0

    public init() { }

}

//MARK: - LinkedList Node
 fileprivate class Node<Element> {
    public var value: Element
    public var next: Node?
    public weak var previous: Node?

    public init(value: Element) {
        self.value = value
    }
}

//MARK: - Initializers
public extension LinkedList {

    private init(_ nodeChain: NodeChain<Element>?) {
        guard let chain = nodeChain else {
            return
        }
        headNode = chain.head
        tailNode = chain.tail
        count = chain.count
    }

    init<S>(_ sequence: S) where S: Sequence, S.Element == Element {
        if let linkedList = sequence as? LinkedList<Element> {
            self = linkedList
        } else {
            self = LinkedList(NodeChain(of: sequence))
        }
    }

}

private struct NodeChain<Element> {
    let head: Node<Element>!
    let tail: Node<Element>!
    private(set) var count: Int

    // Creates a chain of nodes from a sequence. Returns `nil` if the sequence is empty.
    init?<S>(of sequence: S) where S: Sequence, S.Element == Element {
        var iterator = sequence.makeIterator()

        guard let firstValue = iterator.next() else {
            return nil
        }

        var currentNode = Node(value: firstValue)
        head = currentNode
        count = 1

        while let nextElement = iterator.next() {
            let nextNode = Node(value: nextElement)
            currentNode.next = nextNode
            nextNode.previous = currentNode
            currentNode = nextNode
            count += 1
        }
        tail = currentNode
    }

}


//MARK: - Copy Nodes
extension LinkedList {

    private mutating func copyNodes(settingNodeAt index: Index, to value: Element) {

        var currentIndex = startIndex
        var currentNode = Node(value: currentIndex == index ? value : currentIndex.node!.value)
        let newHeadNode = currentNode
        currentIndex = self.index(after: currentIndex)

        while currentIndex < endIndex {
            let nextNode = Node(value: currentIndex == index ? value : currentIndex.node!.value)
            currentNode.next = nextNode
            nextNode.previous = currentNode
            currentNode = nextNode
            currentIndex = self.index(after: currentIndex)
        }
        headNode = newHeadNode
        tailNode = currentNode
    }

    @discardableResult
    private mutating func copyNodes(removing range: Range<Index>) -> Range<Index> {

        var currentIndex = startIndex

        while range.contains(currentIndex) {
            currentIndex = index(after: currentIndex)
        }

        guard let headValue = currentIndex.node?.value else {
            self = LinkedList()
            return endIndex..<endIndex
        }

        var currentNode = Node(value: headValue)
        let newHeadNode = currentNode
        var newCount = 1

        var removedRange: Range<Index> = Index(node: currentNode, offset: 0)..<Index(node: currentNode, offset: 0)
        currentIndex = index(after: currentIndex)

        while currentIndex < endIndex {
            guard !range.contains(currentIndex) else {
                currentIndex = index(after: currentIndex)
                continue
            }

            let nextNode = Node(value: currentIndex.node!.value)
            if currentIndex == range.upperBound {
                removedRange = Index(node: nextNode, offset: newCount)..<Index(node: nextNode, offset: newCount)
            }
            currentNode.next = nextNode
            nextNode.previous = currentNode
            currentNode = nextNode
            newCount += 1
            currentIndex = index(after: currentIndex)

        }
        if currentIndex == range.upperBound {
            removedRange = Index(node: nil, offset: newCount)..<Index(node: nil, offset: newCount)
        }
        headNode = newHeadNode
        tailNode = currentNode
        count = newCount
        return removedRange
    }

}

//MARK: - Computed Properties
public extension LinkedList {
    var head: Element? {
        return headNode?.value
    }

    var tail: Element? {
        return tailNode?.value
    }
}

public struct Iterator<Element>: IteratorProtocol {

    private var currentNode: Node<Element>?

    fileprivate init(node: Node<Element>?) {
        currentNode = node
    }

    public mutating func next() -> Element? {
        guard let node = currentNode else {
            return nil
        }
        currentNode = node.next
        return node.value
    }
}

//MARK: - Sequence Conformance
extension LinkedList: Sequence {

    public typealias Element = Element

    public __consuming func makeIterator() -> Iterator<Element> {
        return Iterator(node: headNode)
    }
}

//MARK: - Collection Conformance
extension LinkedList: Collection {

    public var startIndex: Index {
        return Index(node: headNode, offset: 0)
    }

    public var endIndex: Index {
        return Index(node: nil, offset: count)
    }

    public var first: Element? {
        return head
    }

    public var isEmpty: Bool {
        return count == 0
    }

    public func index(after i: Index) -> Index {
        precondition(i.offset != endIndex.offset, "LinkedList index is out of bounds")
        return Index(node: i.node?.next, offset: i.offset + 1)
    }
}


//MARK: - MutableCollection Conformance
extension LinkedList: MutableCollection {

    public subscript(position: Index) -> Element {
        get {
            precondition(position.offset != endIndex.offset, "Index out of range")
            guard let node = position.node else {
                preconditionFailure("LinkedList index is invalid")
            }
            return node.value
        }
        set {
            precondition(position.offset != endIndex.offset, "Index out of range")

            // Copy-on-write semantics for nodes
            if !isKnownUniquelyReferenced(&headNode) {
                copyNodes(settingNodeAt: position, to: newValue)
            } else {
                position.node?.value = newValue
            }
        }
    }
}



//MARK: LinkedList Specific Operations
public extension LinkedList {

    mutating func prepend(_ newElement: Element) {
        replaceSubrange(startIndex..<startIndex, with: CollectionOfOne(newElement))
    }

    mutating func prepend<S>(contentsOf newElements: __owned S) where S: Sequence, S.Element == Element {
        replaceSubrange(startIndex..<startIndex, with: newElements)
    }

    @discardableResult
    mutating func popFirst() -> Element? {
        if isEmpty {
            return nil
        }
        return removeFirst()
    }

    @discardableResult
    mutating func popLast() -> Element? {
        guard isEmpty else {
            return nil
        }
        return removeLast()
    }
}



//MARK: - BidirectionalCollection Conformance
extension LinkedList: BidirectionalCollection {
    public var last: Element? {
        return tail
    }
    
    public struct Index: Comparable {
        fileprivate weak var node: Node<Element>?
        fileprivate var offset: Int

        fileprivate init(node: Node<Element>?, offset: Int) {
            self.node = node
            self.offset = offset
        }

        public static func ==(lhs: Index, rhs: Index) -> Bool {
            return lhs.offset == rhs.offset
        }

        public static func <(lhs: Index, rhs: Index) -> Bool {
            return lhs.offset < rhs.offset
        }
    }
    
    public func index(before i: Index) -> Index {
        precondition(i.offset != startIndex.offset, "LinkedList index is out of bounds")
        if i.offset == count {
            return Index(node: tailNode, offset: i.offset - 1)
        }
        return Index(node: i.node?.previous, offset: i.offset - 1)
    }

}

//MARK: - RangeReplaceableCollection Conformance
extension LinkedList: RangeReplaceableCollection {

    public mutating func append<S>(contentsOf newElements: __owned S) where S: Sequence, Element == S.Element {
        replaceSubrange(endIndex..<endIndex, with: newElements)
    }

    public mutating func replaceSubrange<S, R>(_ subrange: R, with newElements: __owned S) where S: Sequence, R: RangeExpression, Element == S.Element, Index == R.Bound {

        var range = subrange.relative(to: indices)

        precondition(range.lowerBound >= startIndex && range.upperBound <= endIndex, "Subrange bounds are out of range")

        // If range covers all elements and the new elements are a LinkedList then set references to it
        if range.lowerBound == startIndex, range.upperBound == endIndex, let linkedList = newElements as? LinkedList {
            self = linkedList
            return
        }

        var newElementsCount = 0

        // There are no new elements, so range indicates deletion
        guard let nodeChain = NodeChain(of: newElements) else {

            // If there is nothing in the removal range
            // This also covers the case that the linked list is empty because this is the only possible range
            guard range.lowerBound != range.upperBound else {
                return
            }

            // Deletion range spans all elements
            if range.lowerBound == startIndex && range.upperBound == endIndex {
                headNode = nil
                tailNode = nil
                count = 0
                return
            }

            // Copy-on-write semantics for nodes and remove elements in range
            guard isKnownUniquelyReferenced(&headNode) else {
                copyNodes(removing: range)
                return
            }

            // Update count after mutation to preserve startIndex and endIndex validity
            defer {
                count = count - (range.upperBound.offset - range.lowerBound.offset)
            }

            // Move head up if deletion starts at start index
            if range.lowerBound == startIndex {
                // Can force unwrap node since the upperBound is not the end index
                headNode = range.upperBound.node!
                headNode!.previous = nil

                // Move tail back if deletion ends at end index
            } else if range.upperBound == endIndex {
                // Can force unwrap since lowerBound index must have an associated element
                tailNode = range.lowerBound.node!.previous
                tailNode!.next = nil

                // Deletion range is in the middle of the linked list
            } else {
                // Can force unwrap all bound nodes since they both must have elements
                range.upperBound.node!.previous = range.lowerBound.node!.previous
                range.lowerBound.node!.previous!.next = range.upperBound.node!
            }

            return
        }

        // Obtain the count of the new elements from the node chain composed from them
        newElementsCount = nodeChain.count

        // Replace entire content of list with new elements
        if range.lowerBound == startIndex && range.upperBound == endIndex {
            headNode = nodeChain.head
            tailNode = nodeChain.tail
            count = nodeChain.count
            return
        }

        // Copy-on-write semantics for nodes before mutation
        if !isKnownUniquelyReferenced(&headNode) {
            range = copyNodes(removing: range)
        }

        // Update count after mutation to preserve startIndex and endIndex validity
        defer {
            count += nodeChain.count - (range.upperBound.offset - range.lowerBound.offset)
        }

        // Prepending new elements
        guard range.upperBound != startIndex else {
            headNode?.previous = nodeChain.tail
            nodeChain.tail.next = headNode
            headNode = nodeChain.head
            return
        }

        // Appending new elements
        guard range.lowerBound != endIndex else {
            tailNode?.next = nodeChain.head
            nodeChain.head.previous = tailNode
            tailNode = nodeChain.tail
            return
        }

        if range.lowerBound == startIndex {
            headNode = nodeChain.head
        }
        if range.upperBound == endIndex {
            tailNode = nodeChain.tail
        }

        range.lowerBound.node!.previous!.next = nodeChain.head
        range.upperBound.node!.previous = nodeChain.tail
    }

}

//MARK: - ExpressibleByArrayLiteral Conformance
extension LinkedList: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = Element

    public init(arrayLiteral elements: ArrayLiteralElement...) {
        self.init(elements)
    }
}
