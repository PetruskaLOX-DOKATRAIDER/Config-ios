//
//  MapEventsViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 20.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public class MapEventsViewController: UIViewController, NonReusableViewProtocol {
    @IBOutlet private weak var eventDescriptionViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var eventDescriptionView: EventDescriptionView!
    @IBOutlet private weak var mapView: MKMapView!
    
    public func onUpdate(with viewModel: MapEventsViewModel, disposeBag: DisposeBag) {
        eventDescriptionView.viewModel = viewModel.eventDescriptionViewModel
        viewModel.events.drive(mapView.rx.annotations).disposed(by: disposeBag)
        viewModel.isDescriptionAvailable.drive(onNext: { [weak self] in self?.showInfoView($0) }).disposed(by: disposeBag)
        mapView.rx.regionWillChange.map(to: ()).bind(to: viewModel.unFocusTrigger).disposed(by: disposeBag)
        mapView.rx.didDeselectAnnotationView
            .map{ $0.annotation?.coordinate }
            .asDriver(onErrorJustReturn: nil).filterNil()
            .drive(mapView.rx.currentRegion).disposed(by: disposeBag)
        mapView.rx.handleViewForAnnotation { _, annotation in
            guard let viewModel = annotation as? EventItemAnnotationViewModel else { return nil }
            return EventItemAnnotationView(viewModel: viewModel)
        }
        mapView.rx.didSelectAnnotationView.asDriver().drive(onNext: { annotationView in
            guard let cityAnnotation = annotationView.annotation as? EventItemAnnotationViewModel else { return }
            cityAnnotation.selectionTrigger.onNext(())
        }).disposed(by: disposeBag)
    }
    
    private func showInfoView(_ show: Bool) {
        mapView.deselectAllAnnotation()
        let bottomOffset: CGFloat = 20
        eventDescriptionViewBottomConstraint.constant = show ? bottomOffset : -(bottomOffset + eventDescriptionView.bounds.size.height)
        UIView.animate(withDuration: 0.7) { self.view.layoutIfNeeded() }
    }
}
