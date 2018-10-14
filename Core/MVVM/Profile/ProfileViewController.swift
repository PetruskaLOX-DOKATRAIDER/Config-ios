//
//  ProfileViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public final class ProfileViewController: UIViewController, NonReusableViewProtocol, DTTableViewManageable {
    @IBOutlet private weak var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet public weak var tableView: UITableView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.Profile.title
        view.backgroundColor = Colors.bagdet
        tabBarItem = TabBarItemFactory.new(
            title: Strings.Profile.title,
            image: Images.Sections.profileDeselected,
            selectedImage: Images.Sections.profileSelected
        )
        KeyboardAvoiding.avoid(with: tableViewBottomConstraint, inside: tableView).disposed(by: rx.disposeBag)
        setupManager()
    }
    
    private func setupManager() {
        manager.startManaging(withDelegate: self)
        manager.register(FavoritePlayersItemCell.self)
        manager.register(StorageSetupCell.self)
        manager.register(ProfileEmailItemCell.self)
        manager.register(SectionItemCell.self)
        manager.didSelect(FavoritePlayersItemCell.self){ [weak self] _, viewModel, indexPath in
            self?.tableView.deselectRow(at: indexPath, animated: true)
            viewModel.selectionTrigger.onNext(())
        }
        manager.didSelect(SectionItemCell.self){ [weak self] _, viewModel, indexPath in
            self?.tableView.deselectRow(at: indexPath, animated: true)
            viewModel.selectionTrigger.onNext(())
        }
    }
    
    public func onUpdate(with viewModel: ProfileViewModel, disposeBag: DisposeBag) {
        viewModel.sections.drive(manager.memoryStorage.rx.sectionViewModels).disposed(by: disposeBag)
        viewModel.messageViewModel.drive(view.rx.messageView).disposed(by: disposeBag)
    }
}
