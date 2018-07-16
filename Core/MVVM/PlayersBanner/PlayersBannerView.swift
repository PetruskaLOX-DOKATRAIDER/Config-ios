//
//  PlayersBannerView.swift
//  Core
//
//  Created by Oleg Petrychuk on 16.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import LoadableViews

public class PlayersBannerView: LoadableView, ReusableViewProtocol {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .ichigos
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func onUpdate(with viewModel: PlayersBannerViewModel, disposeBag: DisposeBag) {
        
    }
}
