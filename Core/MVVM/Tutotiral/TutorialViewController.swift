//
//  TutorialViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 18.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

// MARK: Implementation

final class TutorialViewController: UIViewController, NonReusableViewProtocol {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Hello"
    }
    
    func onUpdate(with viewModel: TutorialViewModel, disposeBag: DisposeBag) {
        

    }
}

// MARK: Factory

public class TutorialViewControllerFactory {
    public static func `default`(viewModel: TutorialViewModel = TutorialViewModelFactory.default()) -> UIViewController {
        let vc = StoryboardScene.Tutorial.initialViewController()
        vc.viewModel = viewModel
        return vc
    }
}
