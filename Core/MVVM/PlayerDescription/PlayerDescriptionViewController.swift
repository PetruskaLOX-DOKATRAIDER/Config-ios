//
//  PlayerDescriptionViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public final class PlayerDescriptionViewController: UIViewController, NonReusableViewProtocol {
    private let personalInfoVC = StoryboardScene.PlayerInfoPage.initialViewController()
    private let settingsVC = StoryboardScene.PlayerInfoPage.initialViewController()
    private let hardwareVC = StoryboardScene.PlayerInfoPage.initialViewController()
    private let segmentPageViewController = SegmentPageViewController()
    @IBOutlet private weak var segmentPageContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var segmentPageViewControllerContainer: UIView!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var headerContainerView: UIView!
    @IBOutlet private weak var segmentView: SegmentView!
    @IBOutlet private weak var fullNameLabel: UILabel!
    @IBOutlet private weak var sendCFGButton: UIButton!
    @IBOutlet private weak var detailsButton: UIButton!
    @IBOutlet private weak var optionsButton: UIButton!
    @IBOutlet private weak var closeButton: UIButton!

    override public func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.PlayerDescription.title
        view.backgroundColor = .amethyst

        fullNameLabel.font = .filsonRegularWithSize(22)
        fullNameLabel.textColor = .snowWhite

        sendCFGButton.setTitle(Strings.PlayerDescription.sendCfg, for: .normal)
        sendCFGButton.backgroundColor = .ichigos
        sendCFGButton.setTitleColor(.snowWhite, for: .normal)
        sendCFGButton.titleLabel?.font = .filsonMediumWithSize(18)
        sendCFGButton.applyShadow(color: UIColor.ichigos.cgColor)
        
        optionsButton.setTitle(Strings.PlayerDescription.options, for: .normal)
        optionsButton.setTitleColor(.ichigos, for: .normal)
        optionsButton.borderWidth = 2
        optionsButton.borderColor = .ichigos
        optionsButton.titleLabel?.font = .filsonMediumWithSize(18)

        detailsButton.setTitle(Strings.PlayerDescription.details, for: .normal)
        detailsButton.backgroundColor = .ichigos
        detailsButton.setTitleColor(.snowWhite, for: .normal)
        detailsButton.titleLabel?.font = .filsonMediumWithSize(18)
        
        segmentPageViewController.setupViewControllers([personalInfoVC, hardwareVC, settingsVC])
        addChild(viewController: segmentPageViewController, onContainer: segmentPageViewControllerContainer)
        
        segmentView.titles = [Strings.PlayerDescription.personalInfo, Strings.PlayerDescription.hardvare, Strings.PlayerDescription.settings]
        segmentView.didSelectSegment = { [weak self] index in
            self?.segmentPageViewController.showViewController(atIndex: index)
        }
    }
    
    public func onUpdate(with viewModel: PlayerDescriptionViewModel, disposeBag: DisposeBag) {
        let playerInfoVM = viewModel.playerInfoViewModel
        let showContent = viewModel.isWorking.filter{ !$0 }.delay(0.5)
        let hideContent = viewModel.isWorking.filter{ $0 }
        viewModel.messageViewModel.drive(view.rx.messageView).disposed(by: disposeBag)
        playerInfoVM.avatarURL.drive(avatarImageView.rx.imageURL).disposed(by: disposeBag)
        playerInfoVM.fullName.drive(fullNameLabel.rx.text).disposed(by: disposeBag)
        playerInfoVM.personalInfo.drive(personalInfoVC.rx.infoTitles).disposed(by: disposeBag)
        playerInfoVM.hardware.drive(hardwareVC.rx.infoTitles).disposed(by: disposeBag)
        playerInfoVM.settings.drive(settingsVC.rx.infoTitles).disposed(by: disposeBag)
        hideContent.drive(view.rx.activityIndicator).disposed(by: disposeBag)
        hideContent.map(to: 0).drive(headerContainerView.rx.alpha).disposed(by: disposeBag)
        hideContent.map(to: 0).drive(segmentPageViewControllerContainer.rx.alpha).disposed(by: disposeBag)
        showContent.drive(view.rx.activityIndicator).disposed(by: disposeBag)
        showContent.map(to: 0.9).drive(headerContainerView.rx.visibleAlphaWithDuration).disposed(by: disposeBag)
        showContent.map(to: 0.6).drive(segmentPageViewControllerContainer.rx.visibleAlphaWithDuration).disposed(by: disposeBag)
        closeButton.rx.tap.bind(to: viewModel.closeTrigger).disposed(by: disposeBag)
        sendCFGButton.rx.tap.bind(to: viewModel.sendCFGTrigger).disposed(by: disposeBag)
        detailsButton.rx.tap.bind(to: viewModel.detailsTrigger).disposed(by: disposeBag)
        optionsButton.rx.tap.bind(to: viewModel.optionsTrigger).disposed(by: disposeBag)
        viewModel.refreshTrigger.onNext(())
    }
}
