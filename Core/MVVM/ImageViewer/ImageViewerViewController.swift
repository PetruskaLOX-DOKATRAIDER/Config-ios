//
//  ImageViewerViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 02.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public class ImageViewerViewController: UIViewController, NonReusableViewProtocol {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var buttonsContainerView: UIView!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var browserButton: UIButton!
    @IBOutlet private weak var closeButton: UIButton!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bagdet
        buttonsContainerView.backgroundColor = .amethyst
        buttonsContainerView.applyShadow()
    }
    
    public func onUpdate(with viewModel: ImageViewerViewModel, disposeBag: DisposeBag) {
        viewModel.title.drive(rx.title).disposed(by: disposeBag)
        viewModel.imageURL.drive(imageView.rx.imageURL).disposed(by: disposeBag)
        viewModel.isWorking.drive(view.rx.activityIndicator).disposed(by: disposeBag)
        viewModel.messageViewModel.drive(view.rx.messageView).disposed(by: disposeBag)
        shareButton.rx.tap.bind(to: viewModel.shareTrigger).disposed(by: disposeBag)
        saveButton.rx.tap.bind(to: viewModel.saveTrigger).disposed(by: disposeBag)
        browserButton.rx.tap.bind(to: viewModel.browserTrigger).disposed(by: disposeBag)
        closeButton.rx.tap.bind(to: viewModel.closeTrigger).disposed(by: disposeBag)
    }
}
