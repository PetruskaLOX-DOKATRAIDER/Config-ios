//
//  NewsViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import DTCollectionViewManager
import DTModelStorage

public final class NewsViewController: UIViewController, NonReusableViewProtocol, DTCollectionViewManageable {
    @IBOutlet public weak var collectionView: UICollectionView?
    @IBOutlet private weak var profileButton: UIButton!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.News.title
        view.backgroundColor = .bagdet
        tabBarItem = TabBarItemFactory.new(
            title: Strings.News.title,
            image: Images.Sections.newsDeselected,
            selectedImage: Images.Sections.newsSelected
        )
    }
    
    private func setupManagerAndCollectionView() {
        collectionView?.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        manager.startManaging(withDelegate: self)
        manager.register(NewsItemCell.self)
        manager.didSelect(NewsItemCell.self) { (_, viewModel, _) in
            viewModel.selectionTrigger.onNext(())
        }
    }
    public func onUpdate(with viewModel: NewsViewModel, disposeBag: DisposeBag) {

    }
}
