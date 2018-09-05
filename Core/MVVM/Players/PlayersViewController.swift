//
//  PlayersViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public final class PlayersViewController: UIViewController, DTCollectionViewManageable, NonReusableViewProtocol {
    @IBOutlet public weak var collectionView: UICollectionView?
    @IBOutlet private weak var profileButton: UIButton!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.Players.title
        view.backgroundColor = .bagdet
        tabBarItem = TabBarItemFactory.new(
            title: Strings.Players.title,
            image: Images.Sections.playersDeselected,
            selectedImage: Images.Sections.playersSelected
        )
        setupManagerAndCollectionView()
    }
    
    private func setupManagerAndCollectionView() {
        let numberOfColumns = 2
        collectionView?.collectionViewLayout = PinterestLayout(numberOfColumns: numberOfColumns, collectionViewManager: manager)
        collectionView?.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        manager.startManaging(withDelegate: self)
        manager.register(PlayerPreviewCell.self)
        manager.sizeForCell(withItem: PlayerPreviewCell.ModelType.self, { [collectionView] vm, _ in
            let cellWidth = collectionView?.bounds.size.width ?? 0 / CGFloat(numberOfColumns)
            let cellHeight = CGFloat(vm.imageHeight(withContainerWidth: Double(cellWidth))) + PlayerPreviewCell.nicknameContainerHeight
            return CGSize(width: cellWidth, height: cellHeight)
        })
        manager.didSelect(PlayerPreviewCell.self) { (_, viewModel, _) in
            viewModel.selectionTrigger.onNext(())
        }
    }
    
    public func onUpdate(with viewModel: PlayersViewModel, disposeBag: DisposeBag) {
        connectVertical(viewModel.playersPaginator).disposed(by: disposeBag)
        viewModel.playersPaginator.isWorking.asObservable().take(1).asDriver(onErrorJustReturn: false).drive(view.rx.activityIndicator).disposed(by: disposeBag)
        viewModel.messageViewModel.drive(view.rx.messageView).disposed(by: disposeBag)
        profileButton.rx.tap.bind(to: viewModel.profileTrigger).disposed(by: disposeBag)
        viewModel.playersPaginator.refreshTrigger.onNext(())
    }
}
