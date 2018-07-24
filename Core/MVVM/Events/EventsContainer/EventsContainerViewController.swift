//
//  EventsContainerViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 20.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

enum ChildViewControllerType: Int {
    case map
    case list
}

public class EventsContainerViewController: UIViewController, NonReusableViewProtocol {
    private let listEventsViewController = StoryboardScene.ListEvents.initialViewController()
    private let mapEventsViewController = StoryboardScene.MapEvents.initialViewController()
    private let segmentPageViewController = SegmentPageViewController()
    @IBOutlet private weak var indicatorContainerView: UIView!
    @IBOutlet private weak var indicatorContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var segmentPageViewControllerContainer: UIView!
    @IBOutlet private weak var refreshButton: UIButton!
    @IBOutlet private weak var filterButton: UIButton!
    @IBOutlet private weak var segmentView: SegmentView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.EventsContrainer.title
        view.backgroundColor = .bagdet
        indicatorContainerView.backgroundColor = .bagdet
        tabBarItem = TabBarItemFactory.new(
            title: Strings.EventsContrainer.title,
            image: Images.Sections.eventsDeselected,
            selectedImage: Images.Sections.eventsSelected
        )
        setupSegmentView()
        setupSegmentPageViewController()
    }
    
    private func setupSegmentPageViewController() {
        segmentPageViewController.isPageScrollEnabled = false
        segmentPageViewController.setupViewControllers([listEventsViewController, mapEventsViewController])
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
    
    public func onUpdate(with viewModel: EventsContainerViewModel, disposeBag: DisposeBag) {
        listEventsViewController.viewModel = viewModel.listEventsViewModel
        mapEventsViewController.viewModel = viewModel.mapEventsViewModel
        refreshButton.rx.tap.bind(to: viewModel.eventsPaginator.refreshTrigger).disposed(by: disposeBag)
        filterButton.rx.tap.bind(to: viewModel.filtersTrigger).disposed(by: disposeBag)
        rx.viewDidAppear.toVoid().take(1).bind(to: viewModel.eventsPaginator.refreshTrigger).disposed(by: disposeBag)

        let showIndicatorTrigger = viewModel.eventsPaginator.isWorking.filter{ $0 }
        let hideIndicatorTrigger = viewModel.eventsPaginator.isWorking.filter{ !$0 }.delay(0.7)
        showIndicatorTrigger.drive(indicatorContainerView.rx.activityIndicator).disposed(by: disposeBag)
        showIndicatorTrigger.toVoid().drive(onNext: { [weak self] in
            self?.indicatorContainerViewHeightConstraint.constant = 60
            UIView.animate(withDuration: 0.5, animations: { self?.view.layoutIfNeeded() })
        }).disposed(by: disposeBag)
        hideIndicatorTrigger.drive(indicatorContainerView.rx.activityIndicator).disposed(by: disposeBag)
        hideIndicatorTrigger.toVoid().drive(onNext: { [weak self] in
            self?.indicatorContainerViewHeightConstraint.constant = 0
            UIView.animate(withDuration: 0.5, animations: { self?.view.layoutIfNeeded() })
        }).disposed(by: disposeBag)
    }
}
