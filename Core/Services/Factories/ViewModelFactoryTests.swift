import Core
import Dip
import Nimble
import XCTest

class ViewModelFactoryTests: XCTestCase {
    let container = DependencyContainer()
    
    override func tearDown() {
        super.tearDown()
        container.reset()
    }
    
    func testBuildViewModelSuccess() {
        container.register(.unique) { FakeViewModelWithoutArg() as FakeViewModelType }
        container.register(.unique) { FakeViewModelWithArg1(arg1: $0) as FakeViewModelType }
        container.register(.unique) { FakeViewModelWithArg1Arg2(arg1: $0, arg2: $1) as FakeViewModelType }
        
        try expect(self.container.buildViewModel() as FakeViewModelType).toNot(beNil())
        try expect(self.container.buildViewModel(arg: 1) as FakeViewModelType).toNot(beNil())
        try expect(self.container.buildViewModel(arg: 1, arg2: 2) as FakeViewModelType).toNot(beNil())
    }
    
    func testBuildViewModelFailure() {
        expect { try self.container.buildViewModel() as FakeViewModelType }.to(throwError())
    }
}

private protocol FakeViewModelType {}

private class FakeViewModelWithoutArg: FakeViewModelType {}
private class FakeViewModelWithArg1: FakeViewModelType { init(arg1: Int) {} }
private class FakeViewModelWithArg1Arg2: FakeViewModelType { init(arg1: Int, arg2: Int) {} }
