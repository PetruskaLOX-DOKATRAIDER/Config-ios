//
//  PlayerInTeamView.swift
//  Core
//
//  Created by Oleg Petrychuk on 16.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

final class PlayerInTeamView: LoadableView, ReusableViewProtocol {
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var selectionButton: UIButton!
    @IBOutlet private weak var nicknameLabel: UILabel!
    static let defaultWidth: CGFloat = 126
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        nicknameLabel.font = .filsonMediumWithSize(16)
        nicknameLabel.textColor = .snowWhite
        nicknameLabel.backgroundColor = .ichigos
    }
    
    func onUpdate(with viewModel: PlayerPreviewViewModel, disposeBag: DisposeBag) {
        viewModel.nickname.drive(nicknameLabel.rx.text).disposed(by: disposeBag)
        viewModel.avatarURL.drive(avatarImageView.rx.imageURL).disposed(by: disposeBag)
        selectionButton.rx.tap.bind(to: viewModel.selectionTrigger).disposed(by: disposeBag)
    }
}
