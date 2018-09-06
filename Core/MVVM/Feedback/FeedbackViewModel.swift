//
//  FeedbackViewModel.swift
//  Config
//
//  Created by Oleg Petrychuk on 27.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol FeedbackViewModel {
    var messageTextFieldViewModel: TextFieldViewModel { get }
    var closeTrigger: PublishSubject<Void> { get }
    var sendTrigger: PublishSubject<Void> { get }
    var shouldClose: Driver<Void> { get }
}

public final class FeedbackViewModelImpl: FeedbackViewModel, ReactiveCompatible {
    public let messageTextFieldViewModel: TextFieldViewModel
    public let closeTrigger = PublishSubject<Void>()
    public let sendTrigger = PublishSubject<Void>()
    public let shouldClose: Driver<Void>

    public init(analyticsService: AnalyticsService) {
        messageTextFieldViewModel = TextFieldViewModelImpl(placeholder: Strings.Feedback.messagePlaceholder)
        let message = sendTrigger.asDriver(onErrorJustReturn: ()).withLatestFrom( messageTextFieldViewModel.text.asDriver() ).filterEmpty()
        shouldClose = .merge(
            message.map(to: ()),
            closeTrigger.asDriver(onErrorJustReturn: ())
        )
        message.map{ analyticsService.trackFeedback(withMessage: $0) }.drive().disposed(by: rx.disposeBag)
    }
}
