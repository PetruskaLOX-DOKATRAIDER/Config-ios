//
//  NewsViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public final class NewsViewController: UIViewController, NonReusableViewProtocol {
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.News.title
        view.backgroundColor = .bagdet
        tabBarItem = TabBarItemFactory.new(
            title: Strings.News.title,
            image: Images.Sections.newsDeselected,
            selectedImage: Images.Sections.newsSelected
        )
    }
    
    public func onUpdate(with viewModel: NewsViewModel, disposeBag: DisposeBag) {

    }
}
