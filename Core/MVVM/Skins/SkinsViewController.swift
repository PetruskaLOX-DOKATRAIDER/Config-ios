//
//  SkinsViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 23.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public final class SkinsViewController: UIViewController, NonReusableViewProtocol, DTTableViewManageable {
    @IBOutlet private weak var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var workingStatusLabel: UILabel!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet public weak var tableView: UITableView!
    @IBOutlet private weak var closeButton: UIButton!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.Skins.title
        view.backgroundColor = Colors.bagdet
        KeyboardAvoiding.avoid(with: tableViewBottomConstraint, inside: view).disposed(by: rx.disposeBag)
        
        workingStatusLabel.font = .filsonRegularWithSize(15)
        workingStatusLabel.textColor = Colors.ichigos
        workingStatusLabel.text = Strings.Skins.workingStatus
        
        manager.register(SkinItemCell.self)
        
        searchBar.barTintColor = Colors.bagdet
        searchBar.placeholder = Strings.Skins.search
    }
    
    public func onUpdate(with viewModel: SkinsViewModel, disposeBag: DisposeBag) {
        viewModel.skins.drive(manager.memoryStorage.rx.items()).disposed(by: disposeBag)
        viewModel.isWorking.drive(view.rx.activityIndicator).disposed(by: disposeBag)
        viewModel.messageViewModel.drive(view.rx.messageView).disposed(by: disposeBag)
        viewModel.isWorking.map{ !$0 }.drive(workingStatusLabel.rx.isHidden).disposed(by: disposeBag)
        closeButton.rx.tap.bind(to: viewModel.closeTrigger).disposed(by: disposeBag)
        searchBar.rx.text.bind(to: viewModel.searchTrigger).disposed(by: disposeBag)
        searchBar.rx.searchButtonClicked.map(to: searchBar.text).bind(to: viewModel.searchTrigger).disposed(by: disposeBag)
        viewModel.refreshTrigger.onNext(())
    }
}
