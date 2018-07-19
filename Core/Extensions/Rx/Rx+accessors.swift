//
//  Rx+accessors.swift
//  Core
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

// MARK: ReusableViewProtocol

public extension Reactive where Base: ReusableViewProtocol {
    public var viewModel: Binder<Base.ViewModelProtocol> {
        return Binder(base) { view, model in
            view.viewModel = model
        }
    }
}


// MARK: UIViewController

public extension Reactive where Base: UIViewController {
    public var close: Binder<Bool> {
        return Binder(base) { view, _ in
            view.close()
        }
    }
}

// MARK: UIView

public extension Reactive where Base: UIView {
    public var activityIndicator: Binder<Bool> {
        return Binder(base) { vc, show in
            show ? vc.showActivityIndicatorView() : vc.hideActivityIndicatorView()
        }
    }
    
    public var messageView: Binder<MessageViewModel> {
        return Binder(base) { vc, vm in
            vc.showMessageView(withViewModel: vm)
        }
    }
}

// MARK: UIImageView

public extension Reactive where Base: UIImageView {
    public var imageURL: Binder<URL?> {
        return Binder(base) { imageView, url in
            imageView.setImage(withURL: url)
        }
    }
}
