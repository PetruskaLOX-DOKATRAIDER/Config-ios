//
//  TeamItemCell.swift
//  Core
//
//  Created by Oleg Petrychuk on 16.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import DTModelStorage

public class TeamItemCell: UITableViewCell, ModelTransfer, ReusableViewProtocol {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var stackViewContainerWidth: NSLayoutConstraint!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.font = .filsonBoldWithSize(16)
        nameLabel.textColor = .snowWhite
        backgroundColor = .bagdet
    }
    
    public func onUpdate(with viewModel: TeamItemViewModel, disposeBag: DisposeBag) {
        viewModel.name.drive(nameLabel.rx.text).disposed(by: disposeBag)
        viewModel.logoURL.drive(logoImageView.rx.imageURL).disposed(by: disposeBag)
        updatePlayers(viewModel.players)
    }
    
    private func updatePlayers(_ players: [PlayerPreviewViewModel]) {
        stackView.subviews.forEach{ $0.removeFromSuperview() }
        players.forEach { vm in
            let view = PlayerInTeamView()
            view.viewModel = vm
            stackView.addArrangedSubview(view)
            view.snp.makeConstraints{
                $0.width.equalTo(126)
                $0.height.equalTo(161)
            }
        }
        stackView.layoutIfNeeded()
        stackViewContainerWidth.constant = stackView.bounds.size.width
    }
}
