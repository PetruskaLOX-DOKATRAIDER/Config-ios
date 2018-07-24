//
//  DateFieldViewModel.swift
//  Core
//
//  Created by Oleg Petrychuk on 24.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol DateFieldViewModel {
    var text: Driver<String> { get }
    var placeholder: Driver<String> { get }
    var datePicker: Driver<UIDatePicker> { get }
    var updateTextTrigger: PublishRelay<Void> { get }
}

public final class DateFieldViewModelImpl: DateFieldViewModel, ReactiveCompatible {
    public let text: Driver<String>
    public let placeholder: Driver<String>
    public let datePicker: Driver<UIDatePicker>
    public let updateTextTrigger = PublishRelay<Void>()
    
    public init(
        dateFormatter: DateFormatter = DateFormatters.default,
        datePicker: UIDatePicker? = nil,
        placeholder: String = ""
    ) {
        func defaultDatePicker() -> UIDatePicker {
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            return datePicker
        }
        
        let datePicker = datePicker ?? defaultDatePicker()
        text = updateTextTrigger.asDriver().map{ dateFormatter.string(from: datePicker.date) }
        self.placeholder = Driver.just(placeholder)
        self.datePicker = .just(datePicker)
    }
}
