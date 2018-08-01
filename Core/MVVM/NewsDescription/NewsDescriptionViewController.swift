//
//  NewsDescriptionViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 01.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public class NewsDescriptionViewController: UIViewController, NonReusableViewProtocol {
    @IBOutlet private weak var closeButton: UIButton!
    
    
    public func onUpdate(with viewModel: NewsDescriptionViewModel, disposeBag: DisposeBag) {
        closeButton.rx.tap.bind(to: viewModel.closeTrigger).disposed(by: disposeBag)
    }
}
