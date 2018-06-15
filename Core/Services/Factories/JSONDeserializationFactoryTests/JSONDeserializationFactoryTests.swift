import XCTest
import Core
import Nimble
import SwiftyJSON
import TRON

class JSONDeserializationFactoryTests: XCTestCase {
    func testFailure() {
        let builder: JSONDeserializationFactory<TestModel, String> = JSONDeserializationFactory()
        if case .failure = builder.serializeResponse(nil, nil, nil, nil) {
            XCTAssert(true)
        } else {
            XCTFail()
        }
    }
    
    func testNormal() {
        let builder: JSONDeserializationFactory<TestModel, String> = JSONDeserializationFactory()
        if let filePath = Bundle.test.path(forResource: "JSONDeserializationTestModel", ofType: "json") {
            guard let data = NSData(contentsOfFile: filePath) else { return XCTFail() }
            let result = builder.serializeResponse(nil, nil, Data(referencing: data), nil)
            if case .success(let model) = result {
                XCTAssert(model.id == "1")
            } else { XCTFail() }
        } else { XCTFail() }
    }
    
    func testNormalSubkey() {
        let builder: JSONDeserializationFactory<TestModel, String> = JSONDeserializationFactory(subkey: "subkey")
        if let filePath = Bundle.test.path(forResource: "JSONDeserializationTestModel", ofType: "json") {
            guard let data = NSData(contentsOfFile: filePath) else { return XCTFail() }
            let result = builder.serializeResponse(nil, nil, Data(referencing: data), nil)
            if case .success(let model) = result {
                XCTAssert(model.id == "2")
            } else { XCTFail() }
        } else { XCTFail() }
    }
    
    func testVoid() {
        let builder: VoidSerializationFactory<String> = VoidSerializationFactory()
        let result = builder.serializeResponse(nil, nil, nil, nil)
        if case .success = result {
            XCTAssert(true)
        } else { XCTFail() }
    }
    
    func testErrorDeserializer() {
        let builder: VoidSerializationFactory<TestModel> = VoidSerializationFactory()
        guard let filePath = Bundle.test.path(forResource: "JSONDeserializationTestModel", ofType: "json") else { XCTFail(); return }
        guard let data = NSData(contentsOfFile: filePath) else { return XCTFail() }
        let result = builder.serializeError(nil, nil, nil, Data(referencing: data), "")
        expect(result.errorModel?.id).to(equal("1"))
    }

    func testAnonymousFailure() {
        let builder: AnonymousDeserializationFactory<[String], String> = .init(factory:{ (json: JSON) in
            json["collection"].arrayValue.map{ (child: JSON) in child["product_id"].stringValue }
        })
        let result = builder.serializeResponse(nil, nil, nil, nil)
        switch result {
        case .failure: XCTAssert(true)
        default: XCTFail()
        }
    }
    
    func testAnonymous() {
        let builder: AnonymousDeserializationFactory<[String], String> = .init(factory:{ (json: JSON) in
            json["collection"].arrayValue.map{ (child: JSON) in child["product_id"].stringValue }
        })
        if let filePath = Bundle.test.path(forResource: "AnonymousDeserializationTestModel", ofType: "json") {
            guard let data = NSData(contentsOfFile: filePath) else { return XCTFail() }
            let result = builder.serializeResponse(nil, nil, Data(referencing: data), nil)
            if case .success(let model) = result {
                XCTAssert(model.count == 1)
                XCTAssert(model[0] == "com.app.points10")
            } else { XCTFail() }
        } else { XCTFail() }
    }
}

private class TestModel: JSONDecodable {
    let id: String
    
    required init(json: JSON) {
        self.id = json["id"].stringValue
    }
}
