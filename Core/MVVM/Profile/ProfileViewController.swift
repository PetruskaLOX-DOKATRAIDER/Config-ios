//
//  ProfileViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import DTTableViewManager
import DTModelStorage

public final class ProfileViewController: UIViewController, NonReusableViewProtocol, DTTableViewManageable {
    @IBOutlet public weak var tableView: UITableView!
    @IBOutlet private weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.Profile.title
        view.backgroundColor = .bagdet
        tabBarItem = TabBarItemFactory.new(
            title: Strings.Profile.title,
            image: Images.Sections.profileDeselected,
            selectedImage: Images.Sections.profileSelected
        )
        setupManager()
        KeyboardAvoiding.avoid(with: tableViewBottomConstraint, inside: view).disposed(by: rx.disposeBag)
    }
    
    private func setupManager() {
        manager.startManaging(withDelegate: self)
        manager.configureEvents(for: SectionTopicView.self) { header, model in
            manager.registerHeader(header)
            manager.heightForHeader(withItem: model, { _, _ -> CGFloat in
                return SectionTopicView.defaultHeight()
            })
        }
        manager.registerFooter(SectionSubtopicView.self)
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
    }
}
