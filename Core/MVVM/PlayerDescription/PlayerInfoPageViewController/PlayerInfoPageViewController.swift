//
//  PlayerInfoPageViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 27.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public class PlayerInfoPageViewController: UIViewController {
   @IBOutlet var stackView: UIStackView!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public func updateInfoTitles(_ titles: [HighlightText]) {
        stackView.removeAllSubviews()
        titles.map{ PlayerInfoView(title: $0) }.forEach{ infoView in
            stackView.addArrangedSubview(infoView)
            infoView.snp.makeConstraints{
                $0.height.equalTo(48)
            }
        }
        view.layoutIfNeeded()
    }
}
