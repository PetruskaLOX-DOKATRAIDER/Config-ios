//
//  AlertActionViewModel.swift
//  Config
//
//  Created by Oleg Petrychuk on 02.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public enum AlertActionStyleViewModel {
    case `default`
    case destructive
    case cancel
}

extension AlertActionStyleViewModel: Equatable {
    public static func == (lhs: AlertActionStyleViewModel, rhs: AlertActionStyleViewModel) -> Bool {
        switch (lhs, rhs) {
        case (.`default`, .`default`): return true
        case (.destructive, .destructive): return true
        case (.cancel, .cancel): return true
        default: return false
        }
    }
}

public protocol AlertActionViewModel {
    var title: String { get }
    var style: AlertActionStyleViewModel { get }
    var action: PublishSubject<Void>? { get }
}

public final class AlertActionViewModelImpl: AlertActionViewModel {
    public let title: String
    public let style: AlertActionStyleViewModel
    public let action: PublishSubject<Void>?
    
    public init(
        title: String,
        style: AlertActionStyleViewModel = .`default`,
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
