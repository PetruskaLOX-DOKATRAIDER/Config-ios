//
//  TutorialViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 18.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import DTCollectionViewManager
import DTModelStorage

public final class TutorialViewController: UIViewController, NonReusableViewProtocol, DTCollectionViewManageable {
    @IBOutlet private weak var skipButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet public weak var collectionView: UICollectionView?
    @IBOutlet private weak var closeButton: UIButton!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bagdet
        title = Strings.Tutorial.title
        setupManagerAndCollectionView()

        skipButton.setTitleColor(.ichigos, for: .normal)
        skipButton.titleLabel?.font = .filsonRegularWithSize(16)
        skipButton.setTitle(Strings.Tutorial.skip, for: .normal)
        
        nextButton.backgroundColor = .ichigos
        nextButton.titleLabel?.font = .filsonMediumWithSize(18)
        nextButton.applyShadow()
        nextButton.setTitleColor(.snowWhite, for: .normal)
        
        pageControl.currentPageIndicatorTintColor = .ichigos
    }
    
    private func setupManagerAndCollectionView() {
        collectionView?.decelerationRate = UIScrollViewDecelerationRateFast
        manager.startManaging(withDelegate: self)
        manager.register(TutoriaItemCell.self)
        manager.sizeForCell(withItem: TutorialItemViewModel.self){ [collectionView] (_, _) in
            return collectionView?.frame.size ?? .zero
        }
    }
    
    public func onUpdate(with viewModel: TutorialViewModel, disposeBag: DisposeBag) {
        viewModel.items.drive(manager.memoryStorage.rx.items()).disposed(by: disposeBag)
        viewModel.items.map{ $0.count }.drive(pageControl.rx.numberOfPages).disposed(by: disposeBag)
        viewModel.navigationTitle.drive(nextButton.rx.title()).disposed(by: disposeBag)
        viewModel.currentPage.drive(pageControl.rx.currentPage).disposed(by: disposeBag)
        viewModel.isMoveBackAvailable.drive(closeButton.rx.isHidden).disposed(by: disposeBag)
        viewModel.isMoveBackAvailable.map{ !$0 }.drive(skipButton.rx.isHidden).disposed(by: disposeBag)
        nextButton.rx.tap.bind(to: viewModel.nextTrigger).disposed(by: disposeBag)
        closeButton.rx.tap.bind(to: viewModel.closeTrigger).disposed(by: disposeBag)
        skipButton.rx.tap.bind(to: viewModel.skipTrigger).disposed(by: disposeBag)
        Driver.merge(
            collectionView?.rx.didEndDecelerating.asDriver() ?? .empty(),
            collectionView?.rx.didEndScrollingAnimation.asDriver() ?? .empty()
        ).drive(onNext: { [weak self] in
                viewModel.pageTrigger.onNext(self?.collectionView?.centerPage ?? 0)
        }).disposed(by: rx.disposeBag)
        viewModel.currentPage.distinctUntilChanged().drive(onNext: { [weak self] page in
            self?.collectionView?.scrollToItem(at: IndexPath(row: page, section: 0), at: .left, animated: true)
        }).disposed(by: disposeBag)
    }
}
