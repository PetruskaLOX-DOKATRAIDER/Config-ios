//
//  EventItemAnnotationView.swift
//  Core
//
//  Created by Oleg Petrychuk on 23.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

class EventItemAnnotationView: MKAnnotationView {
    init(
        imageDownloader: ImageDownloader = ImageDownloaderImpl(),
        viewModel: EventItemAnnotationViewModel
    ) {
        super.init(annotation: viewModel, reuseIdentifier: viewModel.reusableIdentifier)
        viewModel.logoURL.drive(onNext: { [weak self] url in
            imageDownloader.download(url: url, completionHandler: { image, _ in
                self?.image = image
            })
        }).disposed(by: viewModel.disposeBag)        
        canShowCallout = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
