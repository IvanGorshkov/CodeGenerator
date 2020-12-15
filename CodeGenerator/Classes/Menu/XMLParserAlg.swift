//
//  XMLParserAlg.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 09.11.2020.
//

import Foundation

class XMLParserAlg {
    private let path: String
    private let data = GenModelController.shared
    init(path: String) {
        self.path = path
    }
    
    public func parseXMLFile() {
        guard let url = Bundle.main.url(forAuxiliaryExecutable: path) else { return }
        guard let xml = XML(contentsOf: url) else { return }
        for tag in xml[0][0].children {
            switch tag.attributes["type"] {
            case "integer":
                data.addType(name: tag.attributes["name"]!, type: .integer)
                break;
            case "byte":
                data.addType(name: tag.attributes["name"]!, type: .byte)
                break;
            case "shortint":
                data.addType(name: tag.attributes["name"]!, type: .shortint)
                break;
            case "longint":
                data.addType(name: tag.attributes["name"]!, type: .longint)
                break;
            case "real":
                data.addType(name: tag.attributes["name"]!, type: .real)
                break;
            case "single":
                data.addType(name: tag.attributes["name"]!, type: .single)
                break;
            case "double":
                data.addType(name: tag.attributes["name"]!, type: .double)
                break;
            case "extended":
                data.addType(name: tag.attributes["name"]!, type: .extended)
                break;
            case "boolean":
                data.addType(name: tag.attributes["name"]!, type: .boolean)
                break;
            case "char":
                data.addType(name: tag.attributes["name"]!, type: .char)
                break;
            case "string":
                data.addType(name: tag.attributes["name"]!, type: .string)
                break;
            default:
                break;
            }
        }
        
        parseBlcoks(value: xml[0]["blocks"]!, parantList: &data.blocksList)
        
    }
    private func parseBlcoks(value: XMLNode, parantList: inout LinkedList<ModelBlock>) {
        var i = 0
        for blocks in value.children {
            let name =  blocks.attributes["name"]
            switch blocks.attributes["block"] {
            case "Старт":
                let factory = ModelBlcokFactory(selected: .start, name: name ?? "", tag: i)
                parantList.append(factory.produce())
            case "Конец":
                let factory = ModelBlcokFactory(selected: .end, name: name ?? "", tag: i)
                parantList.append(factory.produce())
            case "Процесс":
                let factory = ModelBlcokFactory(selected: .prosess, name: name ?? "", tag: i)
                parantList.append(factory.produceWithValue(blocks: blocks))
                break;
            case "Ввод":
                let factory = ModelBlcokFactory(selected: .instream, name: name ?? "", tag: i)
                parantList.append(factory.produceWithValue(blocks: blocks))
                break;
            case "Вывод":
                let factory = ModelBlcokFactory(selected: .outstream, name: name ?? "", tag: i)
                parantList.append(factory.produceWithValue(blocks: blocks))
                break;
            case "Внешняя процедура":
                let factory = ModelBlcokFactory(selected: .procedure, name: name ?? "", tag: i)
                parantList.append(factory.produceWithValue(blocks: blocks))
                break;
            case "Условие":
                let factory = ModelBlcokFactory(selected: .ifblock, name: name ?? "", tag: i)
                var ifbody = factory.produce() as! IfModelBlock
                ifBody(parent: blocks, index: i, parentIfModel: &ifbody)
                parantList.append(ifbody)
                break;
            case "Цикл с предусловием":
                let factory = ModelBlcokFactory(selected: .whileblock, name: name ?? "", tag: i)
                var whileBody = factory.produce() as! WhileModelBlock
                CycleBody(parent: blocks, index: i, whileblock: &whileBody)
                parantList.append(whileBody)
                break;
            case "Счетный цикл":
                let factory = ModelBlcokFactory(selected: .forblock, name: name ?? "", tag: i)
                var forBody = factory.produce() as! WhileModelBlock
                CycleBody(parent: blocks, index: i, whileblock: &forBody)
                parantList.append(forBody)
                break;
            default:
                break;
            }
            i += 1
        }
    }
    
    private  func ifBody(parent: XMLNode, index: Int, parentIfModel: inout IfModelBlock) {
        for value in parent.children {
            if value.name == "value_1" {
                parentIfModel.values?.append(value.attributes["name"]!)
            }
            if value.name == "left" {
                parseBlcoks(value: value, parantList: &parentIfModel.left)
            }
            if value.name == "right" {
                parseBlcoks(value: value, parantList: &parentIfModel.right)
            }
        }
    }
    
    private func CycleBody(parent: XMLNode, index: Int, whileblock: inout WhileModelBlock) {
        for value in parent.children {
            if value.name == "value_1" {
                whileblock.values?.append(value.attributes["name"]!)
            }
            if value.name == "body" {
                parseBlcoks(value: value, parantList: &whileblock.body)
            }
        }
    }
}
