// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import TestsHelper

// swiftlint:disable file_length
// swiftlint:disable line_length
// swiftlint:disable type_body_length
// swiftlint:disable function_parameter_count

class RouterTestsGenerated: XCTestCase {
    var container: DependencyContainer!
    var router: Router!

    override func setUp() {
        super.setUp()
        container = DependencyContainer().registerAll().stubStorages().stubModels()
        router = Router(router: AppRouter.shared, viewFactory: container, viewModelFactory: container, deviceRouter: DeviceRouterImpl())
    }

    func testSplash() {
        expect(try self.router.splash().provideEmbeddedSourceController()).toNot(beNil())
    }
    func testTutorial() {
        expect(try self.router.tutorial().provideEmbeddedSourceController()).toNot(beNil())
    }
    func testSkins() {
        expect(try self.router.skins().provideEmbeddedSourceController()).toNot(beNil())
    }
    func testFeedback() {
        expect(try self.router.feedback().provideEmbeddedSourceController()).toNot(beNil())
    }
}
