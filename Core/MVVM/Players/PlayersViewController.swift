//
//  PlayersViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import DTCollectionViewManager
import DTModelStorage

public final class PlayersViewController: UIViewController, NonReusableViewProtocol, DTCollectionViewManageable {
    @IBOutlet public weak var collectionView: UICollectionView?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.Players.title
        view.backgroundColor = .bagdet
        tabBarItem = TabBarItemFactory.new(
            title: Strings.Players.title,
            image: Images.Sections.playersDeselected,
            selectedImage: Images.Sections.playersSelected
        )
        setupRefreshControl()
        setupManager()
    }
    
    private func setupManager() {
        manager.startManaging(withDelegate: self)
        manager.register(PlayerPreviewCell.self)
    }
    
    private func setupRefreshControl() {
        let control = UIRefreshControl()
        control.tintColor = .ichigos
        collectionView?.refreshControl = control
    }
    
    public func onUpdate(with viewModel: PlayersViewModel, disposeBag: DisposeBag) {

    }
}
