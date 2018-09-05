//
//  EventsFilterViewModel.swift
//  Config
//
//  Created by Oleg Petrychuk on 24.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol EventsFilterViewModel {
    var items: Driver<[EventFilterItemViewModel]> { get }
    var cancelTrigger: PublishSubject<Void> { get }
    var applyTrigger: PublishSubject<Void> { get }
    var resetTrigger: PublishSubject<Void> { get }
    var shouldRouteDatePicker: Driver<DatePickerViewModel> { get }
    var shouldRoutePicker: Driver<PickerViewModel> { get }
    var shouldClose: Driver<Void> { get }
}

final class EventsFilterViewModelImpl: EventsFilterViewModel, ReactiveCompatible {
    let items: Driver<[EventFilterItemViewModel]>
    let cancelTrigger = PublishSubject<Void>()
    let applyTrigger = PublishSubject<Void>()
    let resetTrigger = PublishSubject<Void>()
    let shouldRouteDatePicker: Driver<DatePickerViewModel>
    let shouldRoutePicker: Driver<PickerViewModel>
    let shouldClose: Driver<Void>
    
    init(eventsFiltersStorage: EventsFiltersStorage) {
        func convertDate(_ date: Date?, notSelectedMessage: String) -> String {
            guard let date = date else { return notSelectedMessage }
            return DateFormatters.default.string(from: date)
        }
        var initialMaxCountOfTeamsTitle: String {
            guard let value = eventsFiltersStorage.maxCountOfTeams.value else { return Strings.EventFilters.maxTeamsNotSelected }
            return "\(String(value)) \(Strings.EventFilters.teams)"
        }
        var initialMinPrizePoolTitle: String {
            guard let value = eventsFiltersStorage.minPrizePool.value else { return Strings.EventFilters.minPrizePoolNotSelected }
            return "\(String(value)) \(Strings.EventFilters.dollarChar)"
        }
        var maxCountOfTeamsItems: [PickerItem<Int>] {
            return Array(2...60).map{ PickerItem(
                title: "\(String($0)) \(Strings.EventFilters.teams)",
                object: $0)
            }
        }
        var minPrizePoolItems: [PickerItem<Double>] {
            let data = Array(100...1000).filter{ $0 % 100 == 0 }.map{ Double($0) }
            return data.map{ PickerItem(
                title: String(format: "%.2f \(Strings.EventFilters.dollarChar)", $0),
                object: $0)
            }
        }
        
        let startDatePickerVM = DatePickerViewModelImpl()
        let startDateTitle = startDatePickerVM.datePicked.map{ DateFormatters.default.string(from: $0) }.startWith( convertDate(eventsFiltersStorage.startDate.value, notSelectedMessage: Strings.EventFilters.dateStartNotSelected) )
        let startDateVM = EventFilterItemViewModelImpl(title: startDateTitle, icon: Images.EventFilters.date)
       
        let finishDatePickerVM = DatePickerViewModelImpl()
        let finishDateTitle = finishDatePickerVM.datePicked.map{ DateFormatters.default.string(from: $0) }.startWith( convertDate(eventsFiltersStorage.finishDate.value, notSelectedMessage: Strings.EventFilters.dateFinishNotSelected) )
        let finishDateVM = EventFilterItemViewModelImpl(title: finishDateTitle, icon: Images.EventFilters.date)

        let maxCountOfTeamsPickerVM = PickerViewModelImpl(items: maxCountOfTeamsItems)
        let maxCountOfTeamsTitle = maxCountOfTeamsPickerVM.itemPicked.map{ $0.title }.startWith(initialMaxCountOfTeamsTitle)
        let maxCountOfTeamsVM = EventFilterItemViewModelImpl(title: maxCountOfTeamsTitle, icon: Images.EventFilters.teams)
        
        let minPrizePoolPickerVM = PickerViewModelImpl(items: minPrizePoolItems)
        let minPrizePoolTitle = minPrizePoolPickerVM.itemPicked.map{ $0.title }.startWith(initialMinPrizePoolTitle)
        let minPrizePoolVM = EventFilterItemViewModelImpl(title: minPrizePoolTitle, icon: Images.EventFilters.prizePool)
        
        items = .just([
            startDateVM,
            finishDateVM,
            maxCountOfTeamsVM,
            minPrizePoolVM
        ])
        
        shouldClose = .merge(
            cancelTrigger.asDriver(onErrorJustReturn: ()),
            applyTrigger.asDriver(onErrorJustReturn: ()),
            resetTrigger.asDriver(onErrorJustReturn: ())
        )
        let datePicker = PublishSubject<DatePickerViewModel?>()
        shouldRouteDatePicker = datePicker.asDriver(onErrorJustReturn: nil).filterNil()
        let picker = PublishSubject<PickerViewModel?>()
        shouldRoutePicker = picker.asDriver(onErrorJustReturn: nil).filterNil()
        startDateVM.selectionTrigger.asDriver(onErrorJustReturn: ()).map(to: startDatePickerVM).drive(datePicker).disposed(by: rx.disposeBag)
        finishDateVM.selectionTrigger.asDriver(onErrorJustReturn: ()).map(to: finishDatePickerVM).drive(datePicker).disposed(by: rx.disposeBag)
        maxCountOfTeamsVM.selectionTrigger.asDriver(onErrorJustReturn: ()).map(to: maxCountOfTeamsPickerVM).drive(picker).disposed(by: rx.disposeBag)
        minPrizePoolVM.selectionTrigger.asDriver(onErrorJustReturn: ()).map(to: minPrizePoolPickerVM).drive(picker).disposed(by: rx.disposeBag)
        
        applyTrigger.withLatestFrom(startDatePickerVM.datePicked).asDriver(onErrorJustReturn: Date()).drive(eventsFiltersStorage.startDate).disposed(by: rx.disposeBag)
        applyTrigger.withLatestFrom(finishDatePickerVM.datePicked).asDriver(onErrorJustReturn: Date()).drive(eventsFiltersStorage.finishDate).disposed(by: rx.disposeBag)
        applyTrigger.withLatestFrom(maxCountOfTeamsPickerVM.itemPicked).map{ $0.object }.asDriver(onErrorJustReturn: 0).drive(eventsFiltersStorage.maxCountOfTeams).disposed(by: rx.disposeBag)
        applyTrigger.withLatestFrom(minPrizePoolPickerVM.itemPicked).map{ $0.object }.asDriver(onErrorJustReturn: 0).drive(eventsFiltersStorage.minPrizePool).disposed(by: rx.disposeBag)
        
        let reset = resetTrigger.asDriver(onErrorJustReturn: ())
        reset.map(to: nil).drive(eventsFiltersStorage.startDate).disposed(by: rx.disposeBag)
        reset.map(to: nil).drive(eventsFiltersStorage.finishDate).disposed(by: rx.disposeBag)
        reset.map(to: nil).drive(eventsFiltersStorage.maxCountOfTeams).disposed(by: rx.disposeBag)
        reset.map(to: nil).drive(eventsFiltersStorage.minPrizePool).disposed(by: rx.disposeBag)
    }
}
