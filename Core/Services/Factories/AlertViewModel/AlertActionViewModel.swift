//
//  AlertActionViewModel.swift
//  Config
//
//  Created by Oleg Petrychuk on 02.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public enum AlertActionStyleViewModel {
    case defaultActionStyle
    case destructiveActionStyle
    case cancelActionStyle
}

extension AlertActionStyleViewModel: Equatable {
    public static func == (lhs: AlertActionStyleViewModel, rhs: AlertActionStyleViewModel) -> Bool {
        switch (lhs, rhs) {
        case (.defaultActionStyle, .defaultActionStyle): return true
        case (.destructiveActionStyle, .destructiveActionStyle): return true
        case (.cancelActionStyle, .cancelActionStyle): return true
        default: return false
        }
    }
}

public protocol AlertActionViewModel {
    var title: String { get }
    var style: AlertActionStyleViewModel { get }
    var action: PublishSubject<Void>? { get }
}

public class AlertActionViewModelImpl: AlertActionViewModel {
    public let title: String
    public let style: AlertActionStyleViewModel
    public let action: PublishSubject<Void>?
    
    init(
        title: String,
        style: AlertActionStyleViewModel = .defaultActionStyle,
        action: PublishSubject<Void>? = nil
    ) {
        self.title = title
        self.style = style
        self.action = action
    }
}

extension AlertActionViewModelImpl: Equatable {
    public static func == (lhs: AlertActionViewModelImpl, rhs: AlertActionViewModelImpl) -> Bool {
            return lhs.title == rhs.title && lhs.style == rhs.style
    }
}
