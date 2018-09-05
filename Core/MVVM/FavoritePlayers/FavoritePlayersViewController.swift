//
//  FavoritePlayersViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 02.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public final class FavoritePlayersViewController: UIViewController, NonReusableViewProtocol, DTCollectionViewManageable {
    @IBOutlet public weak var collectionView: UICollectionView?
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var noContentContainerView: UIView!
    @IBOutlet private weak var noContentTitleLabel: UILabel!
    @IBOutlet private weak var noContentSubtitleLabel: UILabel!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.Favoriteplayers.title
        view.backgroundColor = .bagdet
        setupManagerAndCollectionView()
        
        noContentTitleLabel.textColor = .solled
        noContentTitleLabel.font = .filsonMediumWithSize(18)
        noContentTitleLabel.text = Strings.Favoriteplayers.NoContent.title
        noContentSubtitleLabel.textColor = .quaded
        noContentSubtitleLabel.font = .filsonRegularWithSize(15)
        noContentSubtitleLabel.text = Strings.Favoriteplayers.NoContent.subtitle
        noContentContainerView.layoutIfNeeded()
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
    
    public func onUpdate(with viewModel: FavoritePlayersViewModel, disposeBag: DisposeBag) {
        viewModel.players.drive(manager.memoryStorage.rx.items()).disposed(by: disposeBag)
        closeButton.rx.tap.bind(to: viewModel.closeTrigger).disposed(by: disposeBag)
        viewModel.isContentExist.drive(noContentContainerView.rx.isHidden).disposed(by: disposeBag)
        rx.viewWillAppear.toVoid().bind(to: viewModel.refreshTrigger).disposed(by: disposeBag)
    }
}
