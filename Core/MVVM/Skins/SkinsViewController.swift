//
//  SkinsViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 23.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import DTTableViewManager

public class SkinsViewController: UIViewController, NonReusableViewProtocol, DTTableViewManageable {
    @IBOutlet public weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var workingStatusLabel: UILabel!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.Skins.title
        view.backgroundColor = .bagdet
        
        workingStatusLabel.font = .filsonRegularWithSize(15)
        workingStatusLabel.textColor = .ichigos
        workingStatusLabel.text = Strings.Skins.workingStatus
        
        manager.startManaging(withDelegate: self)
        manager.register(SkinItemCell.self)
    }
    
    public func onUpdate(with viewModel: SkinsViewModel, disposeBag: DisposeBag) {
        closeButton.rx.tap.bind(to: viewModel.closeTrigger).disposed(by: disposeBag)
        viewModel.skins.drive(manager.memoryStorage.rx.items()).disposed(by: disposeBag)
        viewModel.isWorking.drive(view.rx.activityIndicator).disposed(by: disposeBag)
        viewModel.messageViewModel.drive(view.rx.messageView).disposed(by: disposeBag)
        viewModel.isWorking.map{ !$0 }.drive(workingStatusLabel.rx.isHidden).disposed(by: disposeBag)
        viewModel.refreshTrigger.onNext(())
    }
}
