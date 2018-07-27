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
        title: String,
        frame: CGRect = .zero
    ) {
        super.init(frame: frame)
        setup()
        titleLabel.text = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    

    
    private func setup() {
        
    }
}
