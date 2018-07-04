//
//  TableViewManager+extensions.swift
//  Core
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import DTTableViewManager
import DTModelStorage

extension ModelTransfer where Self: ReusableViewProtocol {
    public func update(with model: ViewModelProtocol) {
        viewModel = model
    }
}

public extension DTTableViewManageable {
    func connect<T, U>(_ paginator: BasePaginator<T, U>, needsBottomIndicator: Bool = true, needsPullToRefresh: Bool = true, section: Int = 0) -> Disposable {
        var bag = DisposeBag()
        paginator.elements.asDriver().drive(manager.memoryStorage.rx.items(forSection: section)).disposed(by: bag)
        tableView.rx.reachedBottom(threshold: 2).bind(to: paginator.loadNextPageTrigger).disposed(by: bag)
        
        if needsBottomIndicator {
            paginator.isWorking.drive(tableView.rx.bottomLoadingVisible).disposed(by: bag)
        }
        if needsPullToRefresh {
            Driver.merge(
                paginator.error.map(to: false),
                paginator.elements.asDriver().map(to: false)
            ).drive(tableView.rx.refreshControl.rx.isRefreshing).disposed(by: bag)
            tableView.rx.refreshControl.rx.controlEvent(.valueChanged).bind(to: paginator.refreshTrigger).disposed(by: bag)
        }
        
        return Disposables.create{ bag = .init() }
    }
}

extension Reactive where Base: UIScrollView {
    func reachedBottom(threshold: CGFloat = 1) -> Observable<Void> {
        return contentOffset.flatMap { [weak base] contentOffset -> Observable<Void> in
            guard let scrollView = base else {
                return Observable.empty()
            }
            
            let visibleHeight = (scrollView.frame.height * threshold) - scrollView.contentInset.top - scrollView.contentInset.bottom
            let y = contentOffset.y + scrollView.contentInset.top
            let threshold = max(0.0, scrollView.contentSize.height - visibleHeight)
            
            return y >= threshold ? Observable.just(()) : Observable.empty()
        }
    }
}

extension Reactive where Base: UITableView {
    var bottomLoadingVisible: Binder<Bool> {
        return Binder(base) { base, value in
            guard base.tableFooterView is UIActivityIndicatorView || base.tableFooterView == nil else { return }
            if base.tableFooterView == nil {
                let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
                indicator.hidesWhenStopped = true
                indicator.color = .gray
                base.tableFooterView = indicator
            }
            guard let loader = base.tableFooterView as? UIActivityIndicatorView else { return }
            if value {
                loader.startAnimating()
            } else {
                loader.stopAnimating()
            }
        }
    }
}

public extension Reactive where Base: UIScrollView {
    var refreshControl: UIRefreshControl {
        if let current = base.refreshControl { return current }
        let new = UIRefreshControl()
        new.tintColor = .ichigos
        base.refreshControl = new
        return new
    }
}

public extension Reactive where Base: MemoryStorage {
    public func items<T>(forSection section: Int = 0) -> Binder<[T]> {
        return Binder(base) { base, value in
            base.setItems(value, forSection: section)
        }
    }
}
