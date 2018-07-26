//
//  DatePickerViewModel.swift
//  Config
//
//  Created by Oleg Petrychuk on 25.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol DatePickerViewModel {
    var title: Driver<String> { get }
    var minimumDate: Driver<Date?> { get }
    var maximumDate: Driver<Date?> { get }
    var cancelTrigger: PublishSubject<Void> { get }
    var dateTrigger: PublishSubject<Date> { get }
    var datePicked: Driver<Date> { get }
    var shouldClose: Driver<Void> { get }
}

public final class DatePickerViewModelImpl: DatePickerViewModel {
    public let title: Driver<String>
    public let minimumDate: Driver<Date?>
    public let maximumDate: Driver<Date?>
    public let cancelTrigger = PublishSubject<Void>()
    public let dateTrigger = PublishSubject<Date>()
    public let datePicked: Driver<Date>
    public let shouldClose: Driver<Void>

    public init(
        title: String = "",
        minimumDate: Date? = nil,
        maximumDate: Date = Date()
    ) {
        self.title = .just(title)
        self.minimumDate = .just(minimumDate)
        self.maximumDate = .just(maximumDate)
        datePicked = dateTrigger.asDriver(onErrorJustReturn: Date())
        shouldClose = .merge(datePicked.toVoid(), cancelTrigger.asDriver(onErrorJustReturn: ()))
    }
}
