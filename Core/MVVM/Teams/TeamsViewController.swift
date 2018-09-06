//
//  TeamsViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public final class TeamsViewController: UIViewController, DTTableViewManageable, NonReusableViewProtocol {
    @IBOutlet public weak var tableView: UITableView!
    @IBOutlet private weak var profileButton: UIButton!
    private let playersBannerView = PlayersBannerView()
   
    override public func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.Teams.title
        view.backgroundColor = .bagdet
        tabBarItem = TabBarItemFactory.new(
            title: Strings.Teams.title,
            image: Images.Sections.teamsDeselected,
            selectedImage: Images.Sections.teamsSelected
        )
        setupTableViewAndManager()
    }
    
    private func setupTableViewAndManager() {
        manager.startManaging(withDelegate: self)
        manager.register(TeamItemCell.self)
        
        tableView.tableHeaderView = playersBannerView
        playersBannerView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(Int(view.bounds.size.height * 0.25))
        }
    }
    
    public func onUpdate(with viewModel: TeamsViewModel, disposeBag: DisposeBag) {
        playersBannerView.viewModel = viewModel.playersBannerViewModel
        connect(viewModel.teamsPaginator).disposed(by: disposeBag)
        viewModel.teamsPaginator.isWorking.drive(view.rx.activityIndicator).disposed(by: rx.disposeBag)
        viewModel.messageViewModel.drive(view.rx.messageView).disposed(by: rx.disposeBag)
        profileButton.rx.tap.bind(to: viewModel.profileTrigger).disposed(by: disposeBag)
        viewModel.teamsPaginator.refreshTrigger.onNext(())
    }
}
