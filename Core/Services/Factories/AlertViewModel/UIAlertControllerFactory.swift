//
//  UIAlertControllerFactory.swift
//  Config
//
//  Created by Oleg Petrychuk on 02.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//


public class UIAlertControllerFactory {
    public static func alertController(fromViewModelAlert viewModel: AlertViewModel) -> UIAlertController {
        let alertController = UIAlertController(title: viewModel.title, message: viewModel.message, preferredStyle: alertControllerStyle(fromStyle: viewModel.style))
        alertControllerActions(fromViewModels: viewModel.actions).forEach { alertController.addAction($0) }
        return alertController
    }

    static private func alertControllerActions(fromViewModels viewModels: [AlertActionViewModel]) -> [UIAlertAction] {
        return viewModels.map { viewModel in
            UIAlertAction(
                title: viewModel.title,
                style: UIAlertControllerFactory.alertActionStyle(fromStyle: viewModel.style),
                handler: { _ in
                    viewModel.action?.onNext(())
                }
            )
        }
    }
    
    static private func alertControllerStyle(fromStyle style: AlertViewModelStyle) -> UIAlertControllerStyle {
        switch style {
        case .alert: return .alert
        case .actionSheet: return .actionSheet
        }
    }
    
    static private func alertActionStyle(fromStyle style: AlertActionStyleViewModel) -> UIAlertActionStyle {
        switch style {
        case .defaultActionStyle: return .default
        case .destructiveActionStyle: return .destructive
        case .cancelActionStyle: return .cancel
        }
    }
}
