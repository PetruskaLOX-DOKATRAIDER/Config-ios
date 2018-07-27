//
//  PlayerDescriptionViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

enum PlayerInfoContainerType: Int {
    case personal
    case hardware
    case settingsVC
}

public class PlayerDescriptionViewController: UIViewController, NonReusableViewProtocol {
    @IBOutlet private weak var headerContainerView: UIView!
    @IBOutlet private weak var segmentPageViewControllerContainer: UIView!
    @IBOutlet private weak var addRemoveFavoritesButton: UIButton!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nicknameLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var sendCFGButton: UIButton!
    @IBOutlet private weak var detailButton: UIButton!
    @IBOutlet private weak var segmentView: SegmentView!
    private let segmentPageViewController = SegmentPageViewController()
    private let personalInfoVC = StoryboardScene.PlayerInfoPage.initialViewController()
    private let hardwareVC = StoryboardScene.PlayerInfoPage.initialViewController()
    private let settingsVC = StoryboardScene.PlayerInfoPage.initialViewController()
    @IBOutlet weak var segmentPageContainerHeightConstraint: NSLayoutConstraint!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentPageViewController()
        title = Strings.PlayerDescription.title
    }
    
    private func setupSegmentPageViewController() {
        segmentPageViewController.isPageScrollEnabled = false
        segmentPageViewController.setupViewControllers([personalInfoVC, hardwareVC, settingsVC])
        addChildViewController(segmentPageViewController)
        segmentPageViewControllerContainer.addSubview(segmentPageViewController.view)
        segmentPageViewController.view.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        segmentPageViewController.didMove(toParentViewController: self)
    }
    
    private func setupSegmentView() {
        segmentView.addSegmentWithTitle(title: Strings.EventsContrainer.list)
        segmentView.addSegmentWithTitle(title: Strings.EventsContrainer.map)
        segmentView.setSegment(atIndex: 0)
        
        segmentView.didSelectAtIndex = { [weak self] index in
            guard let childType = ChildViewControllerType(rawValue: index) else { return }
            switch childType {
            case .list: self?.segmentPageViewController.showViewController(atIndex: childType.rawValue, withDirection: .forward)
            case .map: self?.segmentPageViewController.showViewController(atIndex: childType.rawValue, withDirection: .reverse)
            }
        }
    }
    
    public func onUpdate(with viewModel: PlayerDescriptionViewModel, disposeBag: DisposeBag) {
        closeButton.rx.tap.bind(to: viewModel.closeTrigger).disposed(by: disposeBag)
        //addRemoveFavoritesButton.rx.tap.bind(to: viewModel.closeTrigger).disposed(by: disposeBag)
        
//        delay(3) {
//            self.segmentPageViewController.showViewController(atIndex: 1, withDirection: .forward)
//            self.segmentPageContainerHeightConstraint.constant = self.hardwareVC.stackView.bounds.size.height
//            self.view.layoutIfNeeded()
//        }
    }
}
