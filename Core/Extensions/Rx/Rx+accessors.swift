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
    public var showActivityIndicator: Binder<Bool> {
        return Binder(base) { vc, show in
            show ? vc.showActivityIndicatorView() : vc.hideActivityIndicatorView()
        }
    }
    
    public var showMessageView: Binder<MessageViewModel> {
        return Binder(base) { vc, vm in
            vc.showMessageView(withViewModel: vm)
        }
    }
}
