//
//  CollectionViewManager+extensions.swift
//  Core
//
//  Created by Oleg Petrychuk on 23.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import DTCollectionViewManager

public extension DTCollectionViewManageable {
    func connectVertical<T, U>(_ paginator: BasePaginator<T, U>, needsPullToRefresh: Bool = true, workingSection: Int = 0) -> Disposable {
        let bag = DisposeBag()
        
        paginator.elements.asDriver().map{ $0 }.drive(self.manager.memoryStorage.rx.items(forSection: workingSection)).disposed(by: bag)
        collectionView?.rx.reachedBottom(threshold: 2).bind(to: paginator.loadNextPageTrigger).disposed(by: bag)
        
        if needsPullToRefresh {
            collectionView.map{ paginator.elements.asDriver().map{ _ in false }.drive($0.rx.refreshControl.rx.isRefreshing) }?.disposed(by: bag)
            collectionView?.rx.refreshControl.rx.controlEvent(.valueChanged).bind(to: paginator.refreshTrigger).disposed(by: bag)
        }
        
        return Disposables.create{ _ = bag }
    }
}
