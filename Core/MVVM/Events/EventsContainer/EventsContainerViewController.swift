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
    @IBOutlet private weak var segmentPageViewControllerContainer: UIView!
    @IBOutlet private weak var refreshButton: UIButton!
    @IBOutlet private weak var segmentView: SegmentView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.EventsContrainer.title
        view.backgroundColor = .bagdet
        tabBarItem = TabBarItemFactory.new(
            title: Strings.EventsContrainer.title,
            image: Images.Sections.eventsDeselected,
            selectedImage: Images.Sections.eventsSelected
        )
        setupSegmentView()
        setupSegmentPageViewController()
        if #available(iOS 11.0, *) { navigationItem.largeTitleDisplayMode = .never }
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
        refreshButton.rx.tap.bind(to: viewModel.refreshTrigger).disposed(by: disposeBag)
        viewModel.refreshTrigger.onNext(())
    }
}
