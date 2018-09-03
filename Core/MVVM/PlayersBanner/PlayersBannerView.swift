//
//  PlayersBannerView.swift
//  Core
//
//  Created by Oleg Petrychuk on 16.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import LoadableViews
import DTCollectionViewManager
import DTModelStorage

public class PlayersBannerView: LoadableView, ReusableViewProtocol, DTCollectionViewManageable {
    @IBOutlet public weak var collectionView: UICollectionView?
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var errorLabel: UILabel!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .ichigos
        errorLabel.font = .filsonMediumWithSize(16)
        errorLabel.textColor = .ichigos
        pageControl.currentPageIndicatorTintColor = .ichigos
        collectionView?.decelerationRate = UIScrollViewDecelerationRateFast
        setupManager()
    }

    
    private func setupManager() {
        manager.startManaging(withDelegate: self)
        manager.register(PlayerBannerItemCell.self)
        manager.sizeForCell(withItem: PlayerBannerItemCell.ModelType.self){ [collectionView] (_, _) in
            return collectionView?.frame.size ?? .zero
        }
        manager.didSelect(PlayerBannerItemCell.self) { (_, viewModel, _) in
            viewModel.selectionTrigger.onNext(())
        }
    }
    
    public func onUpdate(with viewModel: PlayersBannerViewModel, disposeBag: DisposeBag) {
        connectVertical(viewModel.playersPaginator, needsPullToRefresh: false).disposed(by: disposeBag)
        viewModel.playersPaginator.isWorking.drive(rx.activityIndicator).disposed(by: disposeBag)
        viewModel.playersPaginator.elements.asDriver().map{ $0.isEmpty }.drive(pageControl.rx.isHidden).disposed(by: disposeBag)
        viewModel.errorMessage.drive(errorLabel.rx.text).disposed(by: disposeBag)
        viewModel.currentPage.drive(pageControl.rx.currentPage).disposed(by: disposeBag)
        Driver.merge(
            collectionView?.rx.didEndDecelerating.asDriver() ?? .empty(),
            collectionView?.rx.didEndScrollingAnimation.asDriver() ?? .empty()
        ).drive(onNext: {
            viewModel.pageTrigger.onNext(self.collectionView?.centerPage ?? 0)
        }).disposed(by: rx.disposeBag)
        viewModel.playersPaginator.refreshTrigger.onNext(())
    }
}
