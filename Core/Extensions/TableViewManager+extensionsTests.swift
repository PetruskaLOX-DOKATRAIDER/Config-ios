//
//  TableViewManager+extensionsTests.swift
//  Tests
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import Core
import XCTest
import Nimble
import DTTableViewManager
import DTModelStorage

class DTManageableExtensionTests: XCTestCase {
    var vc: FakeViewController!
    
    override func setUp() {
        super.setUp()
        vc = FakeViewController()
    }
    
    func testRefreshControlPaginationWithItems() {
        vc.viewModel = FakeItemsViewModel(paginator: Paginator(factory: { _ in .just(Page<String>.empty) }))
        vc.tableView.rx.refreshControl.rx.isRefreshing.onNext(true)
        vc.viewModel?.items.refreshTrigger.accept(())
        expect(self.vc.tableView.rx.refreshControl.isRefreshing).to(beFalse())
    }
    
    func testRefreshControlPaginationWithError() {
        vc.viewModel = FakeItemsViewModel(paginator: Paginator(factory: { _ in .error("error") }))
        vc.tableView.rx.refreshControl.rx.isRefreshing.onNext(true)
        vc.viewModel?.items.refreshTrigger.accept(())
        expect(self.vc.tableView?.rx.refreshControl.isRefreshing).to(beFalse())
    }
}


class FakeViewController: UIViewController, NonReusableViewProtocol, DTTableViewManageable {
    public var tableView: UITableView!
    
    public func onUpdate(with viewModel: FakeItemsViewModelType, disposeBag: DisposeBag) {
        tableView = UITableView()
        connect(viewModel.items).disposed(by: disposeBag)
    }
}

protocol FakeItemsViewModelType { var items: Paginator<String> { get } }

class FakeItemsViewModel: FakeItemsViewModelType {
    let items: Paginator<String>
    init(paginator: Paginator<String>) { items = paginator }
}
