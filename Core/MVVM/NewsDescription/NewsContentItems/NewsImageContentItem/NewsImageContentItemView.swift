//
//  NewsImageContentItemView.swift
//  Core
//
//  Created by Oleg Petrychuk on 01.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

final class NewsImageContentItemView: LoadableView, NonReusableViewProtocol {
    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var selectionButton: UIButton!
    
    override func setupNib() {
        super.setupNib()
        
        coverImageView.backgroundColor = Colors.wonded
        selectionButton.applyShadow()
    }
    
    func onUpdate(with viewModel: NewsImageContentItemViewModel, disposeBag: DisposeBag) {
        viewModel.coverImageURL.drive(coverImageView.rx.imageURL).disposed(by: disposeBag)
        selectionButton.rx.tap.bind(to: viewModel.selectionTrigger).disposed(by: disposeBag)
    }
}
