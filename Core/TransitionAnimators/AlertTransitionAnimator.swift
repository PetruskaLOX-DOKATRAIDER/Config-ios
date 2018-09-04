//
//  AlertTransitionAnimator.swift
//  Core
//
//  Created by Oleg Petrychuk on 27.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

let viewBlackAlphaComponent: CGFloat = 0.7

final class AlertTransitionAnimator: NSObject, UIViewControllerTransitioningDelegate {
    private let animationDuration: Double
    
    public init(animationDuration: Double = 0.8) {
        self.animationDuration = animationDuration
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AlertTransitionPresentationAnimator(animationDuration: animationDuration)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AlertTransitionDismissAnimator(animationDuration: animationDuration)
    }
}

private final class AlertTransitionDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private let animationDuration: Double
    
    init(animationDuration: Double) {
        self.animationDuration = animationDuration
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
        fromVC.view.backgroundColor = .clear
        let containerView = transitionContext.containerView
        containerView.addSubview(fromVC.view)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(viewBlackAlphaComponent)
        containerView.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make -> Void in
            make.left.right.top.bottom.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        let snapshotView = fromVC.view.resizableSnapshotView(from: fromVC.view.frame, afterScreenUpdates: true, withCapInsets: .zero)
        snapshotView >>- (backgroundView.addSubview)
        
        fromVC.view.subviews.forEach { $0.isHidden = true }
        
        let firstAnimationDuration = 0.2
        UIView.animate(withDuration: firstAnimationDuration, animations: {
            snapshotView?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: { finished in
            UIView.animate(withDuration: self.animationDuration - firstAnimationDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: [], animations: {
                print(finished)
            }, completion: { finished in
                snapshotView?.removeFromSuperview()
                backgroundView.removeFromSuperview()
                transitionContext.completeTransition(finished)
                fromVC.view.subviews.forEach { $0.isHidden = false }
            })
        })
    }
}

private final class AlertTransitionPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private let animationDuration: Double
    
    init(animationDuration: Double) {
        self.animationDuration = animationDuration
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to) else { return }
        toVC.view.backgroundColor = .clear
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        
        let snapshotView = toVC.view.resizableSnapshotView(from: toVC.view.frame, afterScreenUpdates: true, withCapInsets: .zero)
        snapshotView?.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        snapshotView?.alpha = 0
        snapshotView >>- (containerView.addSubview)
        
        toVC.view.subviews.forEach { $0.isHidden = true }
        
        UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: [], animations: {
            snapshotView?.alpha = 1
            snapshotView?.transform = .identity
            toVC.view.backgroundColor = UIColor.black.withAlphaComponent(viewBlackAlphaComponent)
        }, completion: { finished in
            snapshotView?.removeFromSuperview()
            transitionContext.completeTransition(finished)
            toVC.view.subviews.forEach { $0.isHidden = false }
        })
    }
}
