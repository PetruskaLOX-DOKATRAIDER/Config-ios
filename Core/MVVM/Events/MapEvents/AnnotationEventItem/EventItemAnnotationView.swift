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
                let imageContainerView = self?.imageContainerView(withIcon: image)
                self?.image = imageContainerView?.asImage()
            })
        }).disposed(by: viewModel.disposeBag)        
        canShowCallout = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func imageContainerView(withIcon icon: UIImage?) -> UIImageView {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.image = icon
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.ichigos.cgColor
        imageView.layer.cornerRadius = imageView.bounds.size.height / 2
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .bagdet
        return imageView
    }
}
