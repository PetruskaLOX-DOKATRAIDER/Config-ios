//
//  NewsStorage.swift
//  Core
//
//  Created by Oleg Petrychuk on 31.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol NewsStorage {
    func updateNewsPreview(withNewNews newNews: [NewsPreview]) -> Driver<Void>
    func fetchNewsPreview() -> Driver<[NewsPreview]>
    func updateNewsDescription(withNewNews newNews: NewsDescription) -> Driver<Void>
    func fetchNewsDescription(byID id: Int) -> Driver<NewsDescription?>
}
