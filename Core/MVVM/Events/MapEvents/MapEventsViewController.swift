//
//  MapEventsViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 20.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public class MapEventsViewController: UIViewController, NonReusableViewProtocol {
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var eventDescriptionView: EventDescriptionView!
    @IBOutlet private weak var eventDescriptionViewBottomConstraint: NSLayoutConstraint!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        showInfoView(false)
    }
    
    public func onUpdate(with viewModel: MapEventsViewModel, disposeBag: DisposeBag) {
        eventDescriptionView.viewModel = viewModel.eventDescriptionViewModel
        viewModel.events.drive(mapView.rx.annotations).disposed(by: disposeBag)
        mapView.rx.handleViewForAnnotation { _, annotation in
            guard let viewModel = annotation as? EventItemAnnotationViewModel else { return nil }
            return EventItemAnnotationView(viewModel: viewModel)
        }
        mapView.rx.regionWillChange.asDriver().drive(onNext: { [weak self] _ in
            self?.showInfoView(false)
            self?.mapView.deselectAllAnnotation()
        }).disposed(by: disposeBag)
        mapView.rx.didSelectAnnotationView.asDriver().drive(onNext: { [weak self] annotationView in
            guard let strongSelf = self else { return }

            guard let cityAnnotation = annotationView.annotation as? EventItemAnnotationViewModel else { return }
            cityAnnotation.selectionTrigger.onNext(())

            strongSelf.mapView.deselectAllAnnotation()
            strongSelf.mapView.setCurrentRegion(withCoordinate: cityAnnotation.coordinate)
            strongSelf.showInfoView(true)
        }).disposed(by: disposeBag)
    }
    
    private func showInfoView(_ show: Bool) {
        let bottomOffset: CGFloat = 20
        eventDescriptionViewBottomConstraint.constant = show ? bottomOffset : -(bottomOffset + eventDescriptionView.bounds.size.height)
        UIView.animate(withDuration: 0.7) { self.view.layoutIfNeeded() }
    }
}
