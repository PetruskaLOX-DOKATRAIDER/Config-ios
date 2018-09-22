//
//  NewsStorage.swift
//  Core
//
//  Created by Oleg Petrychuk on 31.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol NewsStorage: AutoMockable {
    func updatePreview(withNew news: [NewsPreview]) -> Driver<Void>
    func getPreview() -> Driver<[NewsPreview]>
    func updateDescription(withNew news: NewsDescription) -> Driver<Void>
    func getDescription(news id: Int) -> Driver<NewsDescription?>
}
