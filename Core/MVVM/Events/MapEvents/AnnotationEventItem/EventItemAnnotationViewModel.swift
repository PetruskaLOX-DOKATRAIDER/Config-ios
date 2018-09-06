//
//  EventItemAnnotationViewModel.swift
//  Core
//
//  Created by Oleg Petrychuk on 23.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol EventItemAnnotationViewModel: MKAnnotation {
    var logoImage: Driver<UIImage?> { get }
    var reusableIdentifier: String { get }
    var selectionTrigger: PublishSubject<Void> { get }
    var disposeBag: DisposeBag { get }
}

public class EventItemAnnotationViewModelImpl: NSObject, EventItemAnnotationViewModel {
    public let logoImage: Driver<UIImage?>
    public let reusableIdentifier: String = EventItemAnnotationViewModelImpl.className
    public let selectionTrigger = PublishSubject<Void>()
    public let disposeBag = DisposeBag()
    
    public let title: String?
    public let subtitle: String?
    public var coordinate: CLLocationCoordinate2D
    
    public init(
        event: Event,
        imageLoaderService: ImageLoaderService
    ) {
        let url = event.logoURL ?? URL(fileURLWithPath: "")
        logoImage = imageLoaderService.loadImage(withURL: url).map{ $0.value }.asDriver(onErrorJustReturn: nil)
        title = "title" // should't be empty/nil
        subtitle = nil
        coordinate = CLLocationCoordinate2D(coordinates: event.coordinates)
    }
}
