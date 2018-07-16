//
//  PlayerInTeamView.swift
//  Core
//
//  Created by Oleg Petrychuk on 16.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import LoadableViews

public class PlayerInTeamView: LoadableView, ReusableViewProtocol {
    @IBOutlet private weak var nicknameLabel: UILabel!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var selectionButton: UIButton!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        nicknameLabel.font = .filsonMediumWithSize(16)
        nicknameLabel.textColor = .snowWhite
        nicknameLabel.backgroundColor = .ichigos
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func onUpdate(with viewModel: PlayerPreviewViewModel, disposeBag: DisposeBag) {
        viewModel.nickname.drive(nicknameLabel.rx.text).disposed(by: disposeBag)
        viewModel.avatarURL.drive(avatarImageView.rx.imageURL).disposed(by: disposeBag)
        selectionButton.rx.tap.bind(to: viewModel.selectionTrigger).disposed(by: disposeBag)
    }
}
