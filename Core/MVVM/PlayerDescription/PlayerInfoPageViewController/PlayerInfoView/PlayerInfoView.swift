//
//  PlayerInfoView.swift
//  Core
//
//  Created by Oleg Petrychuk on 27.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import LoadableViews

final class PlayerInfoView: LoadableView {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var pointView: UIView!
    
    init(
        title: HighlightText,
        frame: CGRect = .zero
    ) {
        super.init(frame: frame)
        setup()
        let attributedStr = NSMutableAttributedString(string: title.full)
        title.highlights.forEach {
            attributedStr.setColorForText(textForAttribute: $0, withColor: .ichigos)
        }
        titleLabel.attributedText = attributedStr
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        titleLabel.font = .filsonMediumWithSize(16)
        titleLabel.textColor = UIColor.solled
        pointView.backgroundColor = .ichigos
    }
}
