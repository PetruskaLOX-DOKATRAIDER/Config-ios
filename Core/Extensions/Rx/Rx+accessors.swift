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

// MARK: UIDatePicker

public extension Reactive where Base: UIDatePicker {
    public var minimumDate: Binder<Date?> {
        return Binder(base) { datePicker, date in
            datePicker.minimumDate = date
        }
    }
    
    public var maximumDate: Binder<Date?> {
        return Binder(base) { datePicker, date in
            datePicker.maximumDate = date
        }
    }
}


// MARK: MKMapView

public extension Reactive where Base: MKMapView {
    public var annotations: Binder<[EventItemAnnotationViewModel]> {
        return Binder(base) { mapView, annotations in
            mapView.removeAnnotations(annotations)
            mapView.addAnnotations(annotations)
        }
    }
}

// PlayerInfoPageViewController

public extension Reactive where Base: PlayerInfoPageViewController {
    public var infoTitles: Binder<[HighlightText]> {
        return Binder(base) { vc, titles in
            vc.updateInfoTitles(titles)
        }
    }
}
