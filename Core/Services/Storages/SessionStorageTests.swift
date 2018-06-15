import XCTest
import TestsHelper
import Core

class SessionStorageTests: XCTestCase {
    var userDefaults: UserDefaults!
    let userDefaultsSuiteName = "TestDefaults"
    
    override func setUp() {
        super.setUp()
        UserDefaults().removePersistentDomain(forName: userDefaultsSuiteName)
        userDefaults = UserDefaults(suiteName: userDefaultsSuiteName)
    }
    
    func testDefaultsItemIsStored() throws {
        let storage = UserDefaultsSessionStorage(sessionKey: "foo")
        storage.session.value = try Session(token: "bar")
        XCTAssertEqual(storage.session.value?.token, "bar")
    }
    
    func testDefaultsDifferentStorageReadsTheSameValue() throws {
        let storage = UserDefaultsSessionStorage(sessionKey: "foo")
        storage.session.value = try Session(token: "foo")
        let storage2 = UserDefaultsSessionStorage(sessionKey: "foo")
        XCTAssert(storage2.session.value?.token == "foo")
    }
    
    func testDefaultsStorageAllowsNillifyToken() throws {
        let storage = UserDefaultsSessionStorage(sessionKey: "foo")
        storage.session.value = try Session(token: "bar")
        XCTAssertEqual(storage.session.value?.token, "bar")
        storage.session.value = nil
        XCTAssertNil(storage.session.value?.token)
    }
    
    func testResetSessionInUserDefaults() {
        let storage = UserDefaultsSessionStorage(sessionKey: "foo", defaults: userDefaults)
        storage.session.value = try? Session(token: "bar")
        storage.session.value = nil
        let currentToken = userDefaults.string(forKey: "token" + "foo")
        XCTAssertNil(currentToken)
    }
}
