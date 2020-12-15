//
//  CodeGeneratorTests.swift
//  CodeGeneratorTests
//
//  Created by Ivan Gorshkov on 23.09.2020.
//

import XCTest
@testable import CodeGenerator

class CodeGeneratorTests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    func testCreatModelEnd() {
        let fabric = ModelBlcokFactory(selected: .end, name: "конец", tag: 0)
        let block = fabric.produce()
        XCTAssertEqual(block.blocks, Blocks.end)
    }
    
    func testCreatModelStart() {
        let fabric = ModelBlcokFactory(selected: .start, name: "старт", tag: 0)
        let block = fabric.produce()
        XCTAssertEqual(block.blocks, Blocks.start)
    }
    
    func testCreatModelProcess() {
        let fabric = ModelBlcokFactory(selected: .prosess, name: "процесс", tag: 0)
        let block = fabric.produce()
        XCTAssertEqual(block.blocks, Blocks.prosess)
    }
    
    func testCreatModelStreamIn() {
        let fabric = ModelBlcokFactory(selected: .instream, name: "Ввод", tag: 0)
        let block = fabric.produce()
        XCTAssertEqual(block.blocks, Blocks.instream)
    }
    
    func testCreatModelStreamOut() {
        let fabric = ModelBlcokFactory(selected: .outstream, name: "Вывод", tag: 0)
        let block = fabric.produce()
        XCTAssertEqual(block.blocks, Blocks.outstream)
    }
    
    func testCreatModelProc() {
        let fabric = ModelBlcokFactory(selected: .procedure, name: "процедура", tag: 0)
        let block = fabric.produce()
        XCTAssertEqual(block.blocks, Blocks.procedure)
    }
    
    func testCreatModelIf() {
        let fabric = ModelBlcokFactory(selected: .ifblock, name: "условие", tag: 0)
        let block = fabric.produce()
        XCTAssertEqual(block.blocks, Blocks.ifblock)
    }
    
    func testCreatModelWhile() {
        let fabric = ModelBlcokFactory(selected: .whileblock, name: "цикл while", tag: 0)
        let block = fabric.produce()
        XCTAssertEqual(block.blocks, Blocks.whileblock)
    }
    
    func testCreatModelFor() {
        let fabric = ModelBlcokFactory(selected: .forblock, name: "цикл for", tag: 0)
        let block = fabric.produce()
        XCTAssertEqual(block.blocks, Blocks.forblock)
    }
    
    func testaddElem()  {
        let savingEnd = SaveBlock(block: .end, name: "Конец")
        savingEnd.save()
        let savingProc = SaveBlock(block: .prosess, name: "Процесс")
        savingProc.save()
        let savingStart = SaveBlock(block: .start, name: "Старт")
        savingStart.save()
        let arr = [Blocks.start, .prosess, .end]
        var i = 0
        GenModelController.shared.blocksList.forEach { (model) in
            XCTAssertEqual(model.blocks, arr[i])
            i += 1
        }
        GenModelController.shared.removeTypeAll()
        GenModelController.shared.blocksList.removeAll()
    }
    
    func testUseDocumentForScroll()  {
        let view = View()
        XCTAssertTrue(view.isFlipped)
    }
    
    func testGenerationEmptyFile()  {
        let gModel = GenModelController.shared
        let emptyFile = AnalyserPascal(data: gModel)
        let genManager = GenManager()
        var str = ""
        XCTAssertFalse(genManager.generate(analyzer: emptyFile, generation: GenerationPascal(generated: gModel), text: &str))
        XCTAssertFalse(emptyFile.algIsCorrect())
        XCTAssertEqual(emptyFile.getError(), "Отсутствует end")
        GenModelController.shared.removeTypeAll()
        GenModelController.shared.blocksList.removeAll()
    }
    
    func testGenerationWithEnd()  {
        let savingEnd = SaveBlock(block: .end, name: "Конец")
        savingEnd.save()
        let gModel = GenModelController.shared
        let emptyFile = AnalyserPascal(data: gModel)
        XCTAssertFalse(emptyFile.algIsCorrect())
        XCTAssertEqual(emptyFile.getError(), "Отсутствует start")
        GenModelController.shared.removeTypeAll()
        GenModelController.shared.blocksList.removeAll()
    }
    
    func testGenerationWithStart()  {
        let savingEnd = SaveBlock(block: .start, name: "Старт")
        savingEnd.save()
        let gModel = GenModelController.shared
        let emptyFile = AnalyserPascal(data: gModel)
        XCTAssertFalse(emptyFile.algIsCorrect())
        XCTAssertEqual(emptyFile.getError(), "Отсутствует end")
        GenModelController.shared.removeTypeAll()
        GenModelController.shared.blocksList.removeAll()
    }
    
    func testVars() {
        let varModel = ModelType(name: "x", type: .integer)
        XCTAssertEqual("integer", varModel.type.name())
        XCTAssertEqual("x", varModel.name)
    }
    
    func testisAllVarsInclude() {
        let varsArr = ["integer", "byte", "shortint", "longint", "real", "single", "double", "extended", "boolean", "char", "string"]
        var varsEnum = [VarType]()
        for id in Range(1...11) {
            varsEnum.append(VarType(id: id)!)
        }
        var i = 0
        for item in varsEnum {
            XCTAssertEqual(item.name(), varsArr[i])
            i += 1
        }
    }
    
    func testAddGenModel() {
        let gModel = GenModelController.shared
        gModel.addType(name: "x", type: .byte)
        XCTAssertFalse(gModel.getArrayType().isEmpty)
        
        GenModelController.shared.removeTypeAll()
        GenModelController.shared.blocksList.removeAll()
    }
    
    func testRemoveAddGenModel() {
        let gModel = GenModelController.shared
        gModel.addType(name: "x", type: .byte)
        gModel.removeType(index: 0)
        XCTAssertTrue(gModel.getArrayType().isEmpty)
        
        GenModelController.shared.removeTypeAll()
        GenModelController.shared.blocksList.removeAll()
    }
    
    func testStartBlockAndSetTag() {
        let startBlock = StartBlock(name: "мой блок", frame: .infinite)
        XCTAssertEqual(startBlock.title, "Старт")
        XCTAssertNotEqual(startBlock.Nameblock, "Старт")
        startBlock.setTag(tag: 1)
        XCTAssertEqual(startBlock.getTag(), 1)
    }
    
    func testEndBlock() {
        let endBlock = EndBlock(name: "мой блок 2", frame: .infinite)
        XCTAssertEqual(endBlock.title, "Конец")
        XCTAssertNotEqual(endBlock.Nameblock, "Конец")
    }
    
    func testProssesBlock() {
        let prossesBlock = ProssesBlock(name: "мой блок 3", frame: .infinite)
        XCTAssertEqual(prossesBlock.title, "Процесс")
        XCTAssertNotEqual(prossesBlock.Nameblock, "Процесс")
    }
    
    func testStreamBlock() {
        let streamBlock = StreamBlock(nameBlock: "Ввод", frame: .infinite)
        XCTAssertEqual(streamBlock.Nameblock, "Ввод")
    }
    
    func testIfBlock() {
        let ifBlock = IfBlock(nameBlock: "Условие", frame: .infinite)
        XCTAssertEqual(ifBlock.Nameblock, "Условие")
    }
    
    func testForBlock() {
        let forBlock = ForBlock(nameBlock: "Условие", frame: .infinite)
        XCTAssertEqual(forBlock.Nameblock, "Условие")
    }
    func testProcBlock() {
        let procBlock = ProcBlock(name: "блок 4", frame: .infinite)
        XCTAssertEqual(procBlock.title, "Процедура")
    }
    
    func testcreateXML() {
        let savingEnd = SaveBlock(block: .end, name: "Конец")
        savingEnd.save()
        let savingProc = SaveBlock(block: .prosess, name: "Процесс")
        savingProc.save()
        let savingStart = SaveBlock(block: .start, name: "Старт")
        savingStart.save()
        let createXML = CreateXML()
        XCTAssertEqual(1, createXML.generateXML().childCount)
        
        GenModelController.shared.removeTypeAll()
        GenModelController.shared.blocksList.removeAll()
    }
    
    func testCheckGnerationFromFile() {
        let filepath = Bundle.main.path(forResource: "test_file", ofType: "btc")!
        let parseXMLFile = XMLParserAlg(path: filepath)
        parseXMLFile.parseXMLFile()
        let gModel = GenModelController.shared
        let file = AnalyserPascal(data: gModel)
        XCTAssertTrue(file.algIsCorrect())
        GenModelController.shared.removeTypeAll()
        GenModelController.shared.blocksList.removeAll()
    }
    
    func testCheckCorrectPascalFile() {
        let filepath = Bundle.main.path(forResource: "test_file", ofType: "btc")!
        let parseXMLFile = XMLParserAlg(path: filepath)
        parseXMLFile.parseXMLFile()
        let file = GenerationPascal(generated: GenModelController.shared)
        let fileAnalyzer = AnalyserPascal(data: GenModelController.shared)
        if let filepath = Bundle.main.path(forResource: "test_file", ofType: "pas") {
            do {
                let contents = try String(contentsOfFile: filepath)
                let genManager = GenManager()
                var str = ""
                XCTAssertTrue(genManager.generate(analyzer: fileAnalyzer, generation: file, text: &str))
                XCTAssertEqual(str, contents)
            } catch {
                print("не смог загрузить файл")
            }
        } else {
            print("не нашел файл")
        }
        
        GenModelController.shared.removeTypeAll()
        GenModelController.shared.blocksList.removeAll()
    }
    
    func testCreateXMLFile() {
        let filepath = Bundle.main.path(forResource: "test_file", ofType: "btc")!
        let parseXMLFile = XMLParserAlg(path: filepath)
        parseXMLFile.parseXMLFile()
        let xmlFile = CreateXML().generateXML()
        XCTAssertNotNil(xmlFile)
        GenModelController.shared.removeTypeAll()
        GenModelController.shared.blocksList.removeAll()
    }
}
