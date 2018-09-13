//
//  EventsFilterViewModel.swift
//  Config
//
//  Created by Oleg Petrychuk on 24.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol EventsFilterViewModel {
    var items: Driver<[EventFilterItemViewModel]> { get }
    var closeTrigger: PublishSubject<Void> { get }
    var applyTrigger: PublishSubject<Void> { get }
    var resetTrigger: PublishSubject<Void> { get }
    var shouldRouteDatePicker: Driver<DatePickerViewModel> { get }
    var shouldRoutePicker: Driver<PickerViewModel> { get }
    var shouldClose: Driver<Void> { get }
}

public final class EventsFilterViewModelImpl: EventsFilterViewModel, ReactiveCompatible {
    public let items: Driver<[EventFilterItemViewModel]>
    public let closeTrigger = PublishSubject<Void>()
    public let applyTrigger = PublishSubject<Void>()
    public let resetTrigger = PublishSubject<Void>()
    public let shouldRouteDatePicker: Driver<DatePickerViewModel>
    public let shouldRoutePicker: Driver<PickerViewModel>
    public let shouldClose: Driver<Void>
    
    public init(eventsFiltersStorage: EventsFiltersStorage) {
        func startAndFinishDate(_ date: Date?, notSelectedMessage: String) -> String {
            guard let date = date else { return notSelectedMessage }
            return DateFormatters.`default`.string(from: date)
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
        let startDateTitle = startDatePickerVM.datePicked
            .map{ DateFormatters.`default`.string(from: $0) }
            .startWith( startAndFinishDate(eventsFiltersStorage.startDate.value, notSelectedMessage: Strings.EventFilters.dateStartNotSelected) )
        let startDateVM = EventFilterItemViewModelImpl(title: startDateTitle, icon: Images.EventFilters.date)
       
        let finishDatePickerVM = DatePickerViewModelImpl()
        let finishDateTitle = finishDatePickerVM.datePicked
            .map{ DateFormatters.`default`.string(from: $0) }
            .startWith( startAndFinishDate(eventsFiltersStorage.finishDate.value, notSelectedMessage: Strings.EventFilters.dateFinishNotSelected) )
        let finishDateVM = EventFilterItemViewModelImpl(title: finishDateTitle, icon: Images.EventFilters.date)

        let maxCountOfTeamsPickerVM = PickerViewModelImpl(items: maxCountOfTeamsItems)
        let maxCountOfTeamsTitle = maxCountOfTeamsPickerVM.itemPicked
            .map{ $0.title }
            .startWith(initialMaxCountOfTeamsTitle)
        let maxCountOfTeamsVM = EventFilterItemViewModelImpl(title: maxCountOfTeamsTitle, icon: Images.EventFilters.teams)
        
        let minPrizePoolPickerVM = PickerViewModelImpl(items: minPrizePoolItems)
        let minPrizePoolTitle = minPrizePoolPickerVM.itemPicked
            .map{ $0.title }
            .startWith(initialMinPrizePoolTitle)
        let minPrizePoolVM = EventFilterItemViewModelImpl(title: minPrizePoolTitle, icon: Images.EventFilters.prizePool)
        
        items = .just([
            startDateVM,
            finishDateVM,
            maxCountOfTeamsVM,
            minPrizePoolVM
        ])
        
        shouldClose = .merge(
            closeTrigger.asDriver(onErrorJustReturn: ()),
            applyTrigger.asDriver(onErrorJustReturn: ()),
            resetTrigger.asDriver(onErrorJustReturn: ())
        )
        
        shouldRouteDatePicker = .merge(
            startDateVM.selectionTrigger.asDriver(onErrorJustReturn: ()).map(to: startDatePickerVM),
            finishDateVM.selectionTrigger.asDriver(onErrorJustReturn: ()).map(to: finishDatePickerVM)
        )
        
        shouldRoutePicker = .merge(
            maxCountOfTeamsVM.selectionTrigger.asDriver(onErrorJustReturn: ()).map(to: maxCountOfTeamsPickerVM),
            minPrizePoolVM.selectionTrigger.asDriver(onErrorJustReturn: ()).map(to: minPrizePoolPickerVM)
        )
        
        let saveStartDate = applyTrigger.withLatestFrom( startDatePickerVM.datePicked ).asDriver(onErrorJustReturn: Date())
        saveStartDate.drive(eventsFiltersStorage.startDate).disposed(by: rx.disposeBag)
        
        let saveFinishDate = applyTrigger.withLatestFrom( finishDatePickerVM.datePicked ).asDriver(onErrorJustReturn: Date())
        saveFinishDate.drive(eventsFiltersStorage.finishDate).disposed(by: rx.disposeBag)
        
        let saveCounOfTeams = applyTrigger.withLatestFrom( maxCountOfTeamsPickerVM.itemPicked ).map{ $0.object }.asDriver(onErrorJustReturn: 0)
        saveCounOfTeams.drive(eventsFiltersStorage.maxCountOfTeams).disposed(by: rx.disposeBag)
        
        let savePrizePool = applyTrigger.withLatestFrom( minPrizePoolPickerVM.itemPicked ).map{ $0.object }.asDriver(onErrorJustReturn: 0)
        savePrizePool.drive(eventsFiltersStorage.minPrizePool).disposed(by: rx.disposeBag)
        
        let reset = resetTrigger.asDriver(onErrorJustReturn: ())
        reset.map(to: nil).drive(eventsFiltersStorage.startDate).disposed(by: rx.disposeBag)
        reset.map(to: nil).drive(eventsFiltersStorage.finishDate).disposed(by: rx.disposeBag)
        reset.map(to: nil).drive(eventsFiltersStorage.maxCountOfTeams).disposed(by: rx.disposeBag)
        reset.map(to: nil).drive(eventsFiltersStorage.minPrizePool).disposed(by: rx.disposeBag)
    }
}
