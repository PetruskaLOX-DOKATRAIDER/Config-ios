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
        return Binder(base) { vc, _ in
            vc.close()
        }
    }
    
    public var motiondClose: Binder<MotionTransitionAnimationType> {
        return Binder(base) { vc, transition in
            vc.addMotionTransition(transition)
            vc.close()
        }
    }
}

// MARK: UIView

extension Reactive where Base: UIView {
    var activityIndicator: Binder<Bool> {
        return Binder(base) { view, show in
            show ? view.showActivityIndicatorView() : view.hideActivityIndicatorView()
        }
    }
    
    var messageView: Binder<MessageViewModel> {
        return Binder(base) { view, vm in
            view.showMessageView(withViewModel: vm)
        }
    }
    
    var visibleAlphaWithDuration: Binder<TimeInterval> {
        return Binder(base) { view, duration in
            UIView.animate(withDuration: duration, animations: {
                view.alpha = 1
            })
        }
    }
    
    var invisibleAlphaWithDuration: Binder<TimeInterval> {
        return Binder(base) { view, duration in
            UIView.animate(withDuration: duration, animations: {
                view.alpha = 0
            })
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

// MARK: Router

public extension Reactive where Base: Router {
    public var presentSafariVC: Binder<URL> {
        return Binder(base) { router, url in
            let safariVC = SFSafariViewController(url: url)
            router.appRouter.topViewController?.navigationController?.present(safariVC, animated: true, completion: nil)
        }
    }
    
    public var presentActivityVC: Binder<ShareItem> {
        return Binder(base) { router, share in
            let activityVC = UIActivityViewController(activityItems: share.items(), applicationActivities: [])
            router.appRouter.topViewController?.navigationController?.present(activityVC, animated: true, completion: nil)
        }
    }
    
    public var presentAlertVM: Binder<AlertViewModel> {
        return Binder(base) { router, alert in
            let alertVC = UIAlertControllerFactory.alertController(fromViewModelAlert: alert)
            router.appRouter.topViewController?.navigationController?.present(alertVC, animated: true, completion: nil)
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
    
    public var currentRegion: Binder<CLLocationCoordinate2D> {
        return Binder(base) { mapView, coordinate in
            mapView.setCurrentRegion(withCoordinate: coordinate)
        }
    }
}

// MARK: PlayerInfoPageViewController

public extension Reactive where Base: PlayerInfoPageViewController {
    public var infoTitles: Binder<[HighlightText]> {
        return Binder(base) { vc, titles in
            vc.updateInfoTitles(titles)
        }
    }
}

// MARK: MemoryStorage

extension Reactive where Base: MemoryStorage {
    var sectionViewModels: Binder<[SectionViewModelType]> {
        return Binder(base) { memoryStorage, sections in
            memoryStorage.removeAllItems()
            for (index, section) in sections.enumerated() {
                section.items.drive(onNext: { [weak memoryStorage] in
                    memoryStorage?.setItems($0, forSection: index) }
                ).disposed(by: self.base.rx.disposeBag)
                section.topic.drive(onNext: { [weak memoryStorage] in
                    memoryStorage?.setSectionHeaderModel($0, forSection: index) }
                ).disposed(by: self.base.rx.disposeBag)
                section.topic.drive(onNext: { [weak memoryStorage] in
                    memoryStorage?.setSectionFooterModel($0, forSection: index) }
                ).disposed(by: self.base.rx.disposeBag)
            }
        }
    }
}

// MARK: UITableViewCell

public extension Reactive where Base: UITableViewCell {
    public var accessoryType: Binder<UITableViewCellAccessoryType> {
        return Binder(base) { cell, selectionStyle in
            cell.accessoryType = selectionStyle
        }
    }
}
