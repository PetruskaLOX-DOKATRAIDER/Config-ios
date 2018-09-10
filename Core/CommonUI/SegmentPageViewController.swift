//
//  SegmentPageViewController.swift
//  Core
//
//  Created by Oleg Petrychuk on 20.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

final class SegmentPageViewController: UIPageViewController {
    private var _viewControllers = [UIViewController]()
    @IBInspectable var isPageScrollEnabled: Bool = false {
        didSet { setScrollEnabled(isPageScrollEnabled) }
    }
  
    init(
        transitionStyle style: UIPageViewControllerTransitionStyle = .scroll,
        navigationOrientation: UIPageViewControllerNavigationOrientation = .horizontal,
        options: [String : AnyObject]? = nil
    ) {
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupViewControllers(_ viewControllers: [UIViewController]) {
        viewControllers.forEach{ $0.loadViewIfNeeded() }
        _viewControllers = viewControllers
        if let firstViewController = viewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: false, completion: nil)
        }
    }
    
    func showViewController(_ viewController: UIViewController) {
        guard let newVCIndex = _viewControllers.index(of: viewController) else { return }
        showViewController(atIndex: newVCIndex)
    }
    
    func showViewController(atIndex index: Int) {
        guard let curentVC = viewControllers?.first else { return }
        guard let curentVCIndex = _viewControllers.index(of: curentVC) else { return }
        guard let newVC = _viewControllers[safe: index] else { return }
        guard let newVCIndex = _viewControllers.index(of: newVC) else { return }
        let direction: UIPageViewControllerNavigationDirection = curentVCIndex < newVCIndex ? .forward : .reverse
        setViewControllers([newVC], direction: direction, animated: true, completion: nil)
    }
}

extension SegmentPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = _viewControllers.index(of: viewController) else { return nil }
        let previousIndex = vcIndex - 1
        guard previousIndex >= 0 else { return nil }
        guard _viewControllers.count > previousIndex else { return nil }
        return _viewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = _viewControllers.index(of: viewController) else { return nil }
        let nextIndex = vcIndex + 1
        guard _viewControllers.count != nextIndex else { return nil }
        guard _viewControllers.count > nextIndex else { return nil }
        return _viewControllers[nextIndex]
    }
}
