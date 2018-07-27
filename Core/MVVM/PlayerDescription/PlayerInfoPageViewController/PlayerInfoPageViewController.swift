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
        print("sackView1: \(stackView)")
    }
    
    public func updateInfo(withTitles titles: [String]) {
        print("sackView2: \(stackView)")
        stackView.removeAllSubviews()
        titles.map{ PlayerInfoView(title: $0) }.forEach{ infoView in
            stackView.addArrangedSubview(infoView)
            infoView.snp.makeConstraints{
                $0.height.equalTo(55)
            }
        }
        view.layoutIfNeeded()
    }
}
