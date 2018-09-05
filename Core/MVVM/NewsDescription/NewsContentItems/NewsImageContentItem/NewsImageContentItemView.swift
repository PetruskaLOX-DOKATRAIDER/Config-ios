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
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        coverImageView.backgroundColor = .wonded
        selectionButton.applyShadow()
    }
    
    func onUpdate(with viewModel: NewsImageContentItemViewModel, disposeBag: DisposeBag) {
        viewModel.coverImageURL.drive(coverImageView.rx.imageURL).disposed(by: disposeBag)
        selectionButton.rx.tap.bind(to: viewModel.selectionTrigger).disposed(by: disposeBag)
    }
}
