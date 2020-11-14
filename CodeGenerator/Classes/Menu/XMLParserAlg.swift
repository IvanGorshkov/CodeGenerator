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
        var i = 0
        for blocks in xml[0]["blocks"]?.children ?? [] {
            switch blocks.attributes["block"] {
            case "Старт":
                data.blocksList.append(ModelBlock(blocks: .start, name: blocks.attributes["name"]!, tag: i))
                break;
            case "Процесс":
                let process = ModelBlock(blocks: .prosess, name: blocks.attributes["name"]!, tag: i)
                process.values = []
                for value in blocks.children {
                    process.values?.append(value.attributes["name"]!)
                }
                
                data.blocksList.append(process)
                break;
            case "Ввод":
                let instream = ModelBlock(blocks: .instream, name: blocks.attributes["name"]!, tag: i)
                instream.values = []
                for value in blocks.children {
                    instream.values?.append(value.attributes["name"]!)
                }
                
                data.blocksList.append(instream)
                break;
            case "Вывод":
                let outstream = ModelBlock(blocks: .outstream, name: blocks.attributes["name"]!, tag: i)
                outstream.values = []
                for value in blocks.children {
                    outstream.values?.append(value.attributes["name"]!)
                }
                
                data.blocksList.append(outstream)
                break;
            case "Внешняя процедура":
                let proc = ModelBlock(blocks: .procedure, name: blocks.attributes["name"]!, tag: i)
                proc.values = []
                for value in blocks.children {
                    proc.values?.append(value.attributes["name"]!)
                }
                
                data.blocksList.append(proc)
                break;
            case "Конец":
                data.blocksList.append(ModelBlock(blocks: .end, name: blocks.attributes["name"]!, tag: i))
                break;
            case "Условие":
                var ifbody = IfModelBlock(blocks: .ifblock, name: blocks.attributes["name"]!, tag: i)
                ifbody.values = []
                ifBody(parent: blocks, index: i, parentIfModel: &ifbody)
                data.blocksList.append(ifbody)
                break;
            case "Цикл с предусловием":
                var whileBody = WhileModelBlock(blocks: .whileblock, name: blocks.attributes["name"]!, tag: i)
                whileBody.values = []
                WhileBody(parent: blocks, index: i, whileblock: &whileBody)
                data.blocksList.append(whileBody)
                break;
            case "Счетный цикл":
                var forBody = WhileModelBlock(blocks: .forblock, name: blocks.attributes["name"]!, tag: i)
                forBody.values = []
                WhileBody(parent: blocks, index: i, whileblock: &forBody)
                data.blocksList.append(forBody)
                break;
            default:
                break;
            }
            
            i += 1
        }
    }
    private func ifBranch(value: XMLNode, parantList: inout LinkedList<ModelBlock>) {
        var i = 0
        for blocks in value.children {
            switch blocks.attributes["block"] {
            case "Процесс":
                let process = ModelBlock(blocks: .prosess, name: blocks.attributes["name"]!, tag: i)
                process.values = []
                for value in blocks.children {
                    process.values?.append(value.attributes["name"]!)
                }
                
                parantList.append(process)
                break;
            case "Ввод":
                let instream = ModelBlock(blocks: .instream, name: blocks.attributes["name"]!, tag: i)
                instream.values = []
                for value in blocks.children {
                    instream.values?.append(value.attributes["name"]!)
                }
                
                parantList.append(instream)
                break;
            case "Вывод":
                let outstream = ModelBlock(blocks: .outstream, name: blocks.attributes["name"]!, tag: i)
                outstream.values = []
                for value in blocks.children {
                    outstream.values?.append(value.attributes["name"]!)
                }
                
                parantList.append(outstream)
                break;
            case "Внешняя процедура":
                let proc = ModelBlock(blocks: .procedure, name: blocks.attributes["name"]!, tag: i)
                proc.values = []
                for value in blocks.children {
                    proc.values?.append(value.attributes["name"]!)
                }
                
                parantList.append(proc)
                break;
            case "Условие":
                var ifbody = IfModelBlock(blocks: .ifblock, name: blocks.attributes["name"]!, tag: i)
                ifbody.values = []
                ifBody(parent: blocks, index: i, parentIfModel: &ifbody)
                parantList.append(ifbody)
                break;
            case "Цикл с предусловием":
                var whileBody = WhileModelBlock(blocks: .whileblock, name: blocks.attributes["name"]!, tag: i)
                whileBody.values = []
                WhileBody(parent: blocks, index: i, whileblock: &whileBody)
                parantList.append(whileBody)
                break;
            case "Счетный цикл":
                var forBody = WhileModelBlock(blocks: .forblock, name: blocks.attributes["name"]!, tag: i)
                forBody.values = []
                WhileBody(parent: blocks, index: i, whileblock: &forBody)
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
                ifBranch(value: value, parantList: &parentIfModel.left)
            }
            if value.name == "right" {
                ifBranch(value: value, parantList: &parentIfModel.right)
            }
        }
    }
    
    private func WhileBody(parent: XMLNode, index: Int, whileblock: inout WhileModelBlock) {
        for value in parent.children {
            if value.name == "value_1" {
                whileblock.values?.append(value.attributes["name"]!)
            }
            if value.name == "body" {
                ifBranch(value: value, parantList: &whileblock.body)
            }
        }
    }
}
