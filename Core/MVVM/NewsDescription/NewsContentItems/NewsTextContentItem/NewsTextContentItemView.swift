//
//  NewsTextContentItemView.swift
//  Core
//
//  Created by Oleg Petrychuk on 01.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

final class NewsTextContentItemView: LoadableView, NonReusableViewProtocol {
    @IBOutlet private weak var textLabel: UILabel!
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        textLabel.font = .filsonRegularWithSize(16)
        textLabel.textColor = .solled
    }
    
    func onUpdate(with viewModel: NewsTextContentItemViewModel, disposeBag: DisposeBag) {
        viewModel.text.drive(textLabel.rx.text).disposed(by: disposeBag)
    }
}
