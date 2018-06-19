//
//  UICollectionView+extension.swift
//  Core
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

extension UICollectionView {
    var centerPage: Int {
        let page = contentOffset.x / bounds.width
        let progressInPage = contentOffset.x - (page * bounds.width)
        return Int(CGFloat(page) + progressInPage)
    }
}
