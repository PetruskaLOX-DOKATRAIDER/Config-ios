//
//  FavoritePlayersItemCell.swift
//  Core
//
//  Created by Oleg Petrychuk on 21.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import DTModelStorage

final class FavoritePlayersItemCell: UITableViewCell, ModelTransfer, ReusableViewProtocol {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var countOfPlayersLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = .solled
        titleLabel.font = .filsonMediumWithSize(21)
        titleLabel.text = Strings.Favoriteplayers.title
        
        countOfPlayersLabel.textColor = .solled
        countOfPlayersLabel.font = .filsonMediumWithSize(15)
    }
    
    public static func defaultHeight() -> CGFloat {
        return 57
    }
    
    public func onUpdate(with viewModel: FavoritePlayersItemViewModel, disposeBag: DisposeBag) {
        viewModel.countOfPlayers.drive(countOfPlayersLabel.rx.text).disposed(by: disposeBag)
    }
}

