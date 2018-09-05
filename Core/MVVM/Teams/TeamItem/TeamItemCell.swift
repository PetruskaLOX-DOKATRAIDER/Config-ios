//
//  TeamItemCell.swift
//  Core
//
//  Created by Oleg Petrychuk on 16.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public class TeamItemCell: UITableViewCell, ModelTransfer, ReusableViewProtocol {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var stackViewContainerWidth: NSLayoutConstraint!
    static let defaultWidth: CGFloat = 227
    
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
        stackViewContainerWidth.constant = (PlayerInTeamView.defaultWidth + stackView.spacing) * CGFloat(players.count)
        stackView.removeAllSubviews()
        players.forEach { vm in
            // pass frame - LoadableView issue
            let view = PlayerInTeamView(frame: CGRect(x: 0, y: 0, width: PlayerInTeamView.defaultWidth, height: stackView.bounds.size.height))
            view.viewModel = vm
            stackView.addArrangedSubview(view)
            view.snp.makeConstraints{
                $0.width.equalTo(PlayerInTeamView.defaultWidth)
            }
        }
        contentView.layoutIfNeeded()
    }
}
