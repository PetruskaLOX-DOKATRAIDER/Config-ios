//
//  PlayersViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import DTCollectionViewManager
import DTModelStorage

class PlayersViewController: UIViewController, NonReusableViewProtocol, DTCollectionViewManageable {    
    @IBOutlet public weak var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.Players.title
        view.backgroundColor = .bagdet
        manager.startManaging(withDelegate: self)
        manager.register(PlayerPreviewCell.self)
    }
    
    func onUpdate(with viewModel: PlayersViewModel, disposeBag: DisposeBag) {
        //connect(viewModel.players).disposed(by: disposeBag)
        //viewModel.events.refreshTrigger.onNext(())
        //rx.onViewWillAppear().toVoid().bind(to: viewModel.events.refreshTrigger).disposed(by: disposeBag)
    }
}

// MARK: Factory

public class PlayersViewControllerFactory {
    public static func withTabBarItem(
        viewModel: PlayersViewModel = PlayersViewModelFactory.default()
    ) -> UIViewController {
        let viewController = StoryboardScene.Players.initialViewController()
        viewController.tabBarItem = TabBarItemFactory.new(
            title: Strings.Players.title,
            image: Images.Sections.playersDeselected,
            selectedImage: Images.Sections.playersSelected
        )
        viewController.viewModel = viewModel
        return viewController
    }
}
