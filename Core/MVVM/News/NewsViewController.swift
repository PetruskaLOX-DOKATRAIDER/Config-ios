//
//  NewsViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public final class NewsViewController: UIViewController, NonReusableViewProtocol, DTCollectionViewManageable {
    @IBOutlet public var collectionView: UICollectionView?
    @IBOutlet private weak var profileButton: UIButton!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.News.title
        view.backgroundColor = .amethyst
        tabBarItem = TabBarItemFactory.new(
            title: Strings.News.title,
            image: Images.Sections.newsDeselected,
            selectedImage: Images.Sections.newsSelected
        )
        
        setupManagerAndCollectionView()
    }
    
    private func setupManagerAndCollectionView() {
        collectionView?.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        manager.startManaging(withDelegate: self)
        manager.register(NewsItemCell.self)
        manager.sizeForCell(withItem: NewsItemCell.ModelType.self, { [collectionView] _, _ in
            guard let collectionView = collectionView else { return CGSize (width: 0, height: 0) }
            return CGSize(width: collectionView.bounds.size.width - 16, height: collectionView.bounds.size.height * 0.65)
        })
        manager.didSelect(NewsItemCell.self) { (_, viewModel, _) in
            viewModel.selectionTrigger.onNext(())
        }
    }
    
    public func onUpdate(with viewModel: NewsViewModel, disposeBag: DisposeBag) {
        connectVertical(viewModel.newsPaginator).disposed(by: disposeBag)
        viewModel.newsPaginator.isWorking.asObservable().take(1).asDriver(onErrorJustReturn: false).drive(view.rx.activityIndicator).disposed(by: disposeBag)
        viewModel.messageViewModel.drive(view.rx.messageView).disposed(by: disposeBag)
        profileButton.rx.tap.bind(to: viewModel.profileTrigger).disposed(by: disposeBag)
        viewModel.newsPaginator.refreshTrigger.onNext(())
    }
}
