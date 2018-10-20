//
//  ListEventsViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 20.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public class ListEventsViewController: UIViewController, NonReusableViewProtocol, DTTableViewManageable {
    @IBOutlet public weak var tableView: UITableView!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.bagdet
        
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        manager.register(EventItemCell.self)
        manager.didSelect(EventItemCell.self) { (_, viewModel, _) in
            viewModel.selectionTrigger.onNext(())
        }
    }
    
    public func onUpdate(with viewModel: ListEventsViewModel, disposeBag: DisposeBag) {
        viewModel.events.drive(manager.memoryStorage.rx.items()).disposed(by: disposeBag)
    }
}
