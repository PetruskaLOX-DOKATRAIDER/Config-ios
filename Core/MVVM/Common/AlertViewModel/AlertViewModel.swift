//
//  AlertViewModel.swift
//  Config
//
//  Created by Oleg Petrychuk on 02.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public enum AlertViewModelStyle {
    case alert
    case actionSheet
}

public protocol AlertViewModel {
    var title: String? { get }
    var message: String? { get }
    var style: AlertViewModelStyle { get }
    var actions: [AlertActionViewModel] { get }
}

public final class AlertViewModelImpl: AlertViewModel {
    public let title: String?
    public let message: String?
    public let style: AlertViewModelStyle
    public let actions: [AlertActionViewModel]
    
    public init(
        title: String? = nil,
        message: String? = nil,
        style: AlertViewModelStyle = .alert,
        actions: [AlertActionViewModel] = [AlertActionViewModel]()
    ) {
        self.title = title
        self.message = message
        self.style = style
        self.actions = actions
    }
}

extension AlertViewModelImpl: Equatable {
    public static func == (lhs: AlertViewModelImpl, rhs: AlertViewModelImpl) -> Bool {
        return lhs.title == rhs.title
            && lhs.message == rhs.message
            && lhs.style == rhs.style
            && lhs.actions.count == rhs.actions.count
    }
}
