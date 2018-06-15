import XCTest
import Dip
import Core

class ViewFactoryTests: XCTestCase {
    let container = DependencyContainer()
    
    override func tearDown() {
        super.tearDown()
        container.reset()
    }
    
    func testBuildView() {
        do {
            let vc = try container.buildView() as ViewFactoryTestableViewController
            XCTAssertNotNil(vc)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    func testBuildViewWithArg() {
        do {
            let vc = try container.buildView(arg: "234") as ViewFactoryTestableViewController
            XCTAssertNotNil(vc)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
