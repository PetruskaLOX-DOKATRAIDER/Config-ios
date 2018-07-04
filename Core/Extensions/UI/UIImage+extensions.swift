//
//  UIImage+extensions.swift
//  Core
//
//  Created by Oleg Petrychuk on 04.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import Kingfisher

extension UIImageView {
    func setImage(withURL url: URL?) {
        kf.setImage(with: url)
    }
}
