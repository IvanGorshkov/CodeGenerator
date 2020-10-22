//
//  GenModel.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 23.10.2020.
//

import Foundation


class GenModel<T> {
    private var _countElements: Int = 0
    var countElements: Int { get { return _countElements } set { _countElements = newValue}}
    var head: LinkedListNode<T>
    init(head: LinkedListNode<T>) {
        self.head = head
    }
    
    
}

indirect enum LinkedListNode<T> {
    case value(element: T, prev: LinkedListNode<T>, next: LinkedListNode<T>)
    case end
}
