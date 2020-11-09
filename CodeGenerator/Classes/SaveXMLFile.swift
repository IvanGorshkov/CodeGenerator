//
//  SaveXMLFile.swift
//  CodeGenerator
//
//  Created by Ivan Gorshkov on 23.10.2020.
//

import Foundation
import Cocoa

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
        switch item.blocks {
        case .start, .end, .instream, .outstream, .prosess:
            addBlock(item: item, parent: &blocks, index: i)
            break;
        case .ifblock:
            addBlock(item: item, parent: &blocks, index: i)
        case .whileblock:
            addBlock(item: item, parent: &blocks, index: i)
        }
        i += 1
    }
    
    return xml
}
func addBlock(item: ModelBlock, parent: inout XMLElement, index: Int) {
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
    }
    parent.addChild(elem)
}

func bodyWhile(item: ModelBlock, parent: inout XMLElement) {
    let whileItem = item as! WhileModelBlock
    var body = XMLElement(name: "body")
    var j = 1
    for itemB in whileItem.body {
        addBlock(item: itemB, parent: &body, index: j)
        j += 1
    }
    parent.addChild(body)
}

func bodyIf(item: ModelBlock, parent: inout XMLElement){
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

func saveXMLFile()  {
    let xml =  generateXML()
    
    let openPanel = NSOpenPanel()       // Authorize access in sandboxed mode
    openPanel.message = NSLocalizedString("Select folder where to create file\n(Necessary to manage security on this computer)", comment: "enableFileMenuItems")
    openPanel.prompt = NSLocalizedString("Select", comment: "enableFileMenuItems")
    openPanel.canChooseFiles = false    // Only select or create Directory here ; you can select the real Desktop
    openPanel.canChooseDirectories = true
    openPanel.canCreateDirectories = true
    openPanel.begin() {                              // In the completion, Save the file
        (result2) -> Void in
        if result2 == NSApplication.ModalResponse.OK {
            let savePanel = NSSavePanel()
            savePanel.title = NSLocalizedString("File to create", comment: "enableFileMenuItems")
            savePanel.nameFieldStringValue = ""
            savePanel.prompt = NSLocalizedString("Create", comment: "enableFileMenuItems")
            savePanel.allowedFileTypes = ["xml"]   // if you want to specify file signature
            let fileManager = FileManager.default
            
            savePanel.begin() { (result) -> Void in
                if result == NSApplication.ModalResponse.OK {
                    let fileWithExtensionURL = savePanel.url!  //  May test that file does not exist already
                    let xmlData = xml.xmlData(options: .nodePrettyPrint)
                    if fileManager.fileExists(atPath: fileWithExtensionURL.path) {
                        do {
                            try xmlData.write(to: fileWithExtensionURL)
                        }
                        catch {
                            
                        }
                    } else {
                        do {
                            try xmlData.write(to: fileWithExtensionURL)
                        }
                        catch {
                            
                        }
                    }
                }
            }
        }
    }
}

func exportPasFile(pascal: String)  {
    let openPanel = NSOpenPanel()
    openPanel.message = NSLocalizedString("Выбретите диркеторию для экспорта документа", comment: "enableFileMenuItems")
    openPanel.prompt = NSLocalizedString("Выбрать", comment: "enableFileMenuItems")
    openPanel.canChooseFiles = false
    openPanel.canChooseDirectories = true
    openPanel.canCreateDirectories = true
    openPanel.begin() {
        (result2) -> Void in
        if result2 == NSApplication.ModalResponse.OK {
            let savePanel = NSSavePanel()
            savePanel.title = NSLocalizedString("файл для экспорта", comment: "enableFileMenuItems")
            savePanel.nameFieldStringValue = "CodeGenerator.pas"
            savePanel.prompt = NSLocalizedString("Экспорт", comment: "enableFileMenuItems")
            savePanel.allowedFileTypes = ["pas"]   // if you want to specify file signature
            let fileManager = FileManager.default
            
            savePanel.begin() { (result) -> Void in
                if result == NSApplication.ModalResponse.OK {
                    let fileWithExtensionURL = savePanel.url!  //  May test that file does not exist already
                    if fileManager.fileExists(atPath: fileWithExtensionURL.path) {
                        
                    } else {
                        do {
                            try pascal.write(to: fileWithExtensionURL, atomically: false, encoding: .utf8)
                        }
                        catch {
                            
                        }
                    }
                }
            }
        }
    }
}

class XMLParserAlg {
    init() {
        
    }
    func parseXMLFile(path: String) {
        guard let url = Bundle.main.url(forAuxiliaryExecutable: path) else { return }
        guard let xml = XML(contentsOf: url) else { return }
        for tag in xml[0][0].children {
            switch tag.attributes["type"] {
            case "integer":
                GenModelController.shared.addType(name: tag.attributes["name"]!, type: .integer)
                break;
            case "byte":
                GenModelController.shared.addType(name: tag.attributes["name"]!, type: .byte)
                break;
            case "shortint":
                GenModelController.shared.addType(name: tag.attributes["name"]!, type: .shortint)
                break;
            case "longint":
                GenModelController.shared.addType(name: tag.attributes["name"]!, type: .longint)
                break;
            case "real":
                GenModelController.shared.addType(name: tag.attributes["name"]!, type: .real)
                break;
            case "single":
                GenModelController.shared.addType(name: tag.attributes["name"]!, type: .single)
                break;
            case "double":
                GenModelController.shared.addType(name: tag.attributes["name"]!, type: .double)
                break;
            case "extended":
                GenModelController.shared.addType(name: tag.attributes["name"]!, type: .extended)
                break;
            case "boolean":
                GenModelController.shared.addType(name: tag.attributes["name"]!, type: .boolean)
                break;
            case "char":
                GenModelController.shared.addType(name: tag.attributes["name"]!, type: .char)
                break;
            case "string":
                GenModelController.shared.addType(name: tag.attributes["name"]!, type: .string)
                break;
            default:
                break;
            }
        }
        var i = 0
        for blocks in xml[0]["blocks"]?.children ?? [] {
            switch blocks.attributes["block"] {
            case "Старт":
                GenModelController.shared.blocksList.append(ModelBlock(blocks: .start, countEnters: 1, countExit: 1, name: blocks.attributes["name"]!, tag: i))
                break;
            case "Процесс":
                let process = ModelBlock(blocks: .prosess, countEnters: 1, countExit: 1, name: blocks.attributes["name"]!, tag: i)
                process.values = []
                for value in blocks.children {
                    process.values?.append(value.attributes["name"]!)
                }
                
                GenModelController.shared.blocksList.append(process)
                break;
            case "Ввод":
                let instream = ModelBlock(blocks: .instream, countEnters: 1, countExit: 1, name: blocks.attributes["name"]!, tag: i)
                instream.values = []
                for value in blocks.children {
                    instream.values?.append(value.attributes["name"]!)
                }
                
                GenModelController.shared.blocksList.append(instream)
                break;
            case "Вывод":
                let outstream = ModelBlock(blocks: .outstream, countEnters: 1, countExit: 1, name: blocks.attributes["name"]!, tag: i)
                outstream.values = []
                for value in blocks.children {
                    outstream.values?.append(value.attributes["name"]!)
                }
                
                GenModelController.shared.blocksList.append(outstream)
                break;
            case "Конец":
                GenModelController.shared.blocksList.append(ModelBlock(blocks: .end, countEnters: 1, countExit: 1, name: blocks.attributes["name"]!, tag: i))
                break;
            case "Условие":
                var ifbody = IfModelBlock(blocks: .ifblock, countEnters: 1, countExit: 1, name: blocks.attributes["name"]!, tag: i)
                ifbody.values = []
                ifBody(parent: blocks, index: i, parentIfModel: &ifbody)
                GenModelController.shared.blocksList.append(ifbody)
                break;
            case "Цикл с предусловием":
                var whileBody = WhileModelBlock(blocks: .whileblock, countEnters: 1, countExit: 1, name: blocks.attributes["name"]!, tag: i)
                whileBody.values = []
                WhileBody(parent: blocks, index: i, whileblock: &whileBody)
                GenModelController.shared.blocksList.append(whileBody)
                break;
            default:
                break;
            }
            
            i += 1
        }
    }
    
    func ifBody(parent: XMLNode, index: Int, parentIfModel: inout IfModelBlock) {
        for value in parent.children {
            if value.name == "value_1" {
                parentIfModel.values?.append(value.attributes["name"]!)
            }
            if value.name == "left" {
                var i = 0
                for blocks in value.children {
                    switch blocks.attributes["block"] {
                    case "Процесс":
                        let process = ModelBlock(blocks: .prosess, countEnters: 1, countExit: 1, name: blocks.attributes["name"]!, tag: i)
                        process.values = []
                        for value in blocks.children {
                            process.values?.append(value.attributes["name"]!)
                        }
                        
                        parentIfModel.left.append(process)
                        break;
                    case "Ввод":
                        let instream = ModelBlock(blocks: .instream, countEnters: 1, countExit: 1, name: blocks.attributes["name"]!, tag: i)
                        instream.values = []
                        for value in blocks.children {
                            instream.values?.append(value.attributes["name"]!)
                        }
                        
                        parentIfModel.left.append(instream)
                        break;
                    case "Вывод":
                        let outstream = ModelBlock(blocks: .outstream, countEnters: 1, countExit: 1, name: blocks.attributes["name"]!, tag: i)
                        outstream.values = []
                        for value in blocks.children {
                            outstream.values?.append(value.attributes["name"]!)
                        }
                        
                        parentIfModel.left.append(outstream)
                        break;
                    case "Условие":
                        var ifbody = IfModelBlock(blocks: .ifblock, countEnters: 1, countExit: 1, name: blocks.attributes["name"]!, tag: i)
                        ifbody.values = []
                        ifBody(parent: blocks, index: i, parentIfModel: &ifbody)
                        parentIfModel.left.append(ifbody)
                        break;
                    case "Цикл с предусловием":
                        var whileBody = WhileModelBlock(blocks: .whileblock, countEnters: 1, countExit: 1, name: blocks.attributes["name"]!, tag: i)
                        whileBody.values = []
                        WhileBody(parent: blocks, index: i, whileblock: &whileBody)
                        parentIfModel.left.append(whileBody)
                        break;
                    default:
                        break;
                    }
                    
                    i += 1
                }
            }
            if value.name == "right" {
                var i = 0
                for blocks in value.children {
                    switch blocks.attributes["block"] {
                    case "Процесс":
                        let process = ModelBlock(blocks: .prosess, countEnters: 1, countExit: 1, name: blocks.attributes["name"]!, tag: i)
                        process.values = []
                        for value in blocks.children {
                            process.values?.append(value.attributes["name"]!)
                        }
                        
                        parentIfModel.right.append(process)
                        break;
                    case "Ввод":
                        let instream = ModelBlock(blocks: .instream, countEnters: 1, countExit: 1, name: blocks.attributes["name"]!, tag: i)
                        instream.values = []
                        for value in blocks.children {
                            instream.values?.append(value.attributes["name"]!)
                        }
                        
                        parentIfModel.right.append(instream)
                        break;
                    case "Вывод":
                        let outstream = ModelBlock(blocks: .outstream, countEnters: 1, countExit: 1, name: blocks.attributes["name"]!, tag: i)
                        outstream.values = []
                        for value in blocks.children {
                            outstream.values?.append(value.attributes["name"]!)
                        }
                        
                        parentIfModel.right.append(outstream)
                        break;
                    case "Условие":
                        var ifbody = IfModelBlock(blocks: .ifblock, countEnters: 1, countExit: 1, name: blocks.attributes["name"]!, tag: i)
                        ifbody.values = []
                        ifBody(parent: blocks, index: i, parentIfModel: &ifbody)
                        parentIfModel.right.append(ifbody)
                        break;
                    case "Цикл с предусловием":
                        var whileBody = WhileModelBlock(blocks: .whileblock, countEnters: 1, countExit: 1, name: blocks.attributes["name"]!, tag: i)
                        whileBody.values = []
                        WhileBody(parent: blocks, index: i, whileblock: &whileBody)
                        parentIfModel.right.append(whileBody)
                        break;
                    default:
                        break;
                    }
                    
                    i += 1
                }
            }
        }
    }
    
    func WhileBody(parent: XMLNode, index: Int, whileblock: inout WhileModelBlock) {
        for value in parent.children {
            if value.name == "value_1" {
                whileblock.values?.append(value.attributes["name"]!)
            }
            if value.name == "body" {
                var i = 0
                for blocks in value.children {
                    switch blocks.attributes["block"] {
                    case "Процесс":
                        let process = ModelBlock(blocks: .prosess, countEnters: 1, countExit: 1, name: blocks.attributes["name"]!, tag: i)
                        process.values = []
                        for value in blocks.children {
                            process.values?.append(value.attributes["name"]!)
                        }
                        
                        whileblock.body.append(process)
                        break;
                    case "Ввод":
                        let instream = ModelBlock(blocks: .instream, countEnters: 1, countExit: 1, name: blocks.attributes["name"]!, tag: i)
                        instream.values = []
                        for value in blocks.children {
                            instream.values?.append(value.attributes["name"]!)
                        }
                        
                        whileblock.body.append(instream)
                        break;
                    case "Вывод":
                        let outstream = ModelBlock(blocks: .outstream, countEnters: 1, countExit: 1, name: blocks.attributes["name"]!, tag: i)
                        outstream.values = []
                        for value in blocks.children {
                            outstream.values?.append(value.attributes["name"]!)
                        }
                        
                        whileblock.body.append(outstream)
                        break;
                    case "Условие":
                        var ifbody = IfModelBlock(blocks: .ifblock, countEnters: 1, countExit: 1, name: blocks.attributes["name"]!, tag: i)
                        ifbody.values = []
                        ifBody(parent: blocks, index: i, parentIfModel: &ifbody)
                        whileblock.body.append(ifbody)
                        break;
                        
                    case "Цикл с предусловием":
                        var whileBody = WhileModelBlock(blocks: .whileblock, countEnters: 1, countExit: 1, name: blocks.attributes["name"]!, tag: i)
                        whileBody.values = []
                        WhileBody(parent: blocks, index: i, whileblock: &whileBody)
                        whileblock.body.append(whileBody)
                        break;
                    default:
                        break;
                    }
                    
                    i += 1
                }
            }
        }
    }
}
