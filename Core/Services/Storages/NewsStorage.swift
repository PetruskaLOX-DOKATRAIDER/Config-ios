//
//  NewsStorage.swift
//  Core
//
//  Created by Oleg Petrychuk on 31.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol NewsStorage: AutoMockable {
    func updateNewsPreview(withNewNews newNews: [NewsPreview], completion: (() -> Void)?)
    func fetchNewsPreview(completion: (([NewsPreview]) -> Void)?)
    func updateNewsDescription(withNewNews newNews: NewsDescription, completion: (() -> Void)?)
    func fetchNewsDescription(byID id: Int, completion: ((NewsDescription?) -> Void)?)
}
