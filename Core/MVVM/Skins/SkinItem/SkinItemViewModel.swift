//
//  SkinItemViewModel.swift
//  Core
//
//  Created by Oleg Petrychuk on 23.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol SkinItemViewModel {
    var title: Driver<String> { get }
    var description: Driver<HighlightText> { get }
    var coverImageURL: Driver<URL?> { get }
}

public final class SkinItemViewModelImpl: SkinItemViewModel, ReactiveCompatible {
    public let title: Driver<String>
    public let description: Driver<HighlightText>
    public let coverImageURL: Driver<URL?>
    
    public init(skin: Skin) {
        title = .just(skin.name)
        let price = (skin.prise == 0) ? Strings.Skinitem.free : "\(String(skin.prise))$"
        let full = "\(skin.gunName) \(Strings.Skinitem.priceSubstr) \(price)"
        description = .just(HighlightText(full: full, highlights: [price]))
        coverImageURL = .just(skin.coverImageURL)
    }
}
