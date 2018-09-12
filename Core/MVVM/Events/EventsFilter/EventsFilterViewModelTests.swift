//
//  EventsFilterViewModelTests.swift
//  Config
//
//  Created by Oleg Petrychuk on 24.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class EventsFilterViewModelTests: BaseTestCase {
    override func spec() {
        describe("EventsFilterViewModel") {
            let eventsFiltersStorage = EventsFiltersStorageMock(startDate: BehaviorRelay(value: nil), finishDate: BehaviorRelay(value: nil), maxCountOfTeams: BehaviorRelay(value: nil), minPrizePool: BehaviorRelay(value: nil))
            var sut: EventsFilterViewModel!
            
            beforeEach {
                createSut()
            }
            
            func createSut() {
                sut = EventsFilterViewModelImpl(eventsFiltersStorage: eventsFiltersStorage)
            }
            
            func selectFilterItem(atIndex index: Int) {
                let items = try? sut.items.toBlocking().first()
                items??[safe: index]?.selectionTrigger.onNext(())
            }
            
            func filterTitle(atIndex index: Int) -> String? {
                let items = try? sut.items.toBlocking().first()
                return (try? items??[safe: index]?.title.toBlocking().first()) ?? nil
            }

            describe("start date filter") {
                describe("when ask title") {
                    context("and storage don't have value") {
                        it("should return not selected", closure: {
                            eventsFiltersStorage.startDate.accept(nil)
                            createSut()
                            expect(filterTitle(atIndex: 0)).to(equal(Strings.EventFilters.dateStartNotSelected))
                        })
                    }
                    context("and storage have some value") {
                        it("should return this date", closure: {
                            let date = Date(timeIntervalSince1970: 1536764917) // 12.09.2018
                            eventsFiltersStorage.startDate.accept(date)
                            createSut()
                            expect(filterTitle(atIndex: 0)).to(equal("12.09.2018"))
                        })
                    }
                }
                describe("when selected") {
                    it("should show valid date picker", closure: {
                        let observer = self.scheduler.createObserver(DatePickerViewModel.self)
                        sut.shouldRouteDatePicker.drive(observer).disposed(by: self.disposeBag)
                        selectFilterItem(atIndex: 0)
                        
                        let datePickerVM = try? sut.shouldRouteDatePicker.toBlocking().first()
                        try? expect(datePickerVM??.title.toBlocking().first()).to(equal(""))
                        try? expect(datePickerVM??.minimumDate.filterNil().toBlocking().first()).to(beNil())
                        try? expect((datePickerVM??.maximumDate.filterNil().toBlocking().first())).to(beCloseTo(Date(), within: 1))
                    })
                }
                describe("when date picker triggered") {
                    it("should update title", closure: {
                        let observer = self.scheduler.createObserver(DatePickerViewModel.self)
                        sut.shouldRouteDatePicker.drive(observer).disposed(by: self.disposeBag)
                        selectFilterItem(atIndex: 0)
                        let datePickerVM = try? sut.shouldRouteDatePicker.toBlocking().first()
                        let date = Date(timeIntervalSince1970: 1536764917) // 12.09.2018
                        datePickerVM??.dateTrigger.onNext(date)
                        
                        expect(filterTitle(atIndex: 0)).to(equal("12.09.2018"))
                    })
                }
            }
            
            describe("finish date filter") {
                describe("when ask title") {
                    context("and storage don't have value") {
                        it("should return not selected", closure: {
                            eventsFiltersStorage.finishDate.accept(nil)
                            createSut()
                            expect(filterTitle(atIndex: 1)).to(equal(Strings.EventFilters.dateFinishNotSelected))
                        })
                    }
                    context("and storage have some value") {
                        it("should return this date", closure: {
                            let date = Date(timeIntervalSince1970: 1536764917) // 12.09.2018
                            eventsFiltersStorage.finishDate.accept(date)
                            createSut()
                            expect(filterTitle(atIndex: 1)).to(equal("12.09.2018"))
                        })
                    }
                }
                describe("when selected") {
                    it("should show valid date picker", closure: {
                        let observer = self.scheduler.createObserver(DatePickerViewModel.self)
                        sut.shouldRouteDatePicker.drive(observer).disposed(by: self.disposeBag)
                        selectFilterItem(atIndex: 1)
                        
                        let datePickerVM = try? sut.shouldRouteDatePicker.toBlocking().first()
                        try? expect(datePickerVM??.title.toBlocking().first()).to(equal(""))
                        try? expect(datePickerVM??.minimumDate.filterNil().toBlocking().first()).to(beNil())
                        try? expect((datePickerVM??.maximumDate.filterNil().toBlocking().first())).to(beCloseTo(Date(), within: 1))
                    })
                }
                describe("when date picker triggered") {
                    it("should update title", closure: {
                        let observer = self.scheduler.createObserver(DatePickerViewModel.self)
                        sut.shouldRouteDatePicker.drive(observer).disposed(by: self.disposeBag)
                        selectFilterItem(atIndex: 1)
                        let datePickerVM = try? sut.shouldRouteDatePicker.toBlocking().first()
                        let date = Date(timeIntervalSince1970: 1536764917) // 12.09.2018
                        datePickerVM??.dateTrigger.onNext(date)
                        
                        expect(filterTitle(atIndex: 1)).to(equal("12.09.2018"))
                    })
                }
            }
            
            describe("max count of teams filter") {
                describe("when ask title") {
                    context("and storage don't have value") {
                        it("should return not selected", closure: {
                            eventsFiltersStorage.maxCountOfTeams.accept(nil)
                            createSut()
                            expect(filterTitle(atIndex: 2)).to(equal(Strings.EventFilters.maxTeamsNotSelected))
                        })
                    }
                    context("and storage have some value") {
                        it("should return this date", closure: {
                            let maxCountOfTeams = Int.random()
                            eventsFiltersStorage.maxCountOfTeams.accept(maxCountOfTeams)
                            createSut()
                            expect(filterTitle(atIndex: 2)).to(equal("\(String(maxCountOfTeams)) \(Strings.EventFilters.teams)"))
                        })
                    }
                }
                describe("when selected") {
                    it("should show valid date picker", closure: {
                        let observer = self.scheduler.createObserver(PickerViewModel.self)
                        sut.shouldRoutePicker.drive(observer).disposed(by: self.disposeBag)
                        selectFilterItem(atIndex: 2)
                        let pickerVM = try? sut.shouldRoutePicker.toBlocking().first()
                        try? expect(pickerVM??.title.toBlocking().first()).to(equal(""))
                        try? expect(pickerVM??.itemTitles.toBlocking().first()).to(contain(["2 teams", "3 teams", "59 teams", "60 teams"]))
                        try? expect(pickerVM??.itemTitles.toBlocking().first()).toNot(contain(["0 teams", "1 teams", "61 teams"]))
                    })
                }
                describe("when picked triggered") {
                    it("should update title", closure: {
                        createSut()
                        let observer = self.scheduler.createObserver(PickerViewModel.self)
                        sut.shouldRoutePicker.drive(observer).disposed(by: self.disposeBag)
                        selectFilterItem(atIndex: 2)
                        let pickerVM = try? sut.shouldRoutePicker.toBlocking().first()
                        pickerVM??.itemAtIndexTrigger.onNext(5)
                        expect(filterTitle(atIndex: 2)).to(contain(Strings.EventFilters.teams))
                    })
                }
            }

            describe("max min prize pool filter") {
                describe("when ask title") {
                    context("and storage don't have value") {
                        it("should return not selected", closure: {
                            eventsFiltersStorage.minPrizePool.accept(nil)
                            createSut()
                            expect(filterTitle(atIndex: 3)).to(equal(Strings.EventFilters.minPrizePoolNotSelected))
                        })
                    }
                    context("and storage have some value") {
                        it("should return this date", closure: {
                            let minPrizePool = Double.random()
                            eventsFiltersStorage.minPrizePool.accept(minPrizePool)
                            createSut()
                            expect(filterTitle(atIndex: 3)).to(equal("\(String(minPrizePool)) $"))
                        })
                    }
                }
                describe("when selected") {
                    it("should show valid date picker", closure: {
                        let observer = self.scheduler.createObserver(PickerViewModel.self)
                        sut.shouldRoutePicker.drive(observer).disposed(by: self.disposeBag)
                        selectFilterItem(atIndex: 3)
                        let pickerVM = try? sut.shouldRoutePicker.toBlocking().first()
                        try? expect(pickerVM??.title.toBlocking().first()).to(equal(""))
                        let expectItemTitles = ["100.00 $", "200.00 $", "300.00 $", "400.00 $", "500.00 $", "600.00 $", "700.00 $", "800.00 $", "900.00 $", "1000.00 $" ]
                        try? expect(pickerVM??.itemTitles.toBlocking().first()).to(equal(expectItemTitles))
                    })
                }
                describe("when picked triggered") {
                    it("should update title", closure: {
                        let observer = self.scheduler.createObserver(PickerViewModel.self)
                        sut.shouldRoutePicker.drive(observer).disposed(by: self.disposeBag)
                        selectFilterItem(atIndex: 3)
                        let pickerVM = try? sut.shouldRoutePicker.toBlocking().first()
                        pickerVM??.itemAtIndexTrigger.onNext(5)
                        expect(filterTitle(atIndex: 3)).to(contain("$"))
                    })
                }
            }
            
            
            describe("when close trigger") {
                it("should close", closure: {
                    let observer = self.scheduler.createObserver(Void.self)
                    sut.shouldClose.drive(observer).disposed(by: self.disposeBag)
                    sut.closeTrigger.onNext(())
                    expect(observer.events.count).to(equal(1))
                })
            }
            
            describe("when apply trigger") {
                it("should save in storage", closure: {
                    eventsFiltersStorage.finishDate.accept(nil)
                    eventsFiltersStorage.maxCountOfTeams.accept(nil)
                    eventsFiltersStorage.minPrizePool.accept(nil)
                    eventsFiltersStorage.startDate.accept(nil)
                    createSut()

                    
                    let pickerObserver = self.scheduler.createObserver(PickerViewModel.self)
                    sut.shouldRoutePicker.drive(pickerObserver).disposed(by: self.disposeBag)
                    selectFilterItem(atIndex: 2)
                    try? sut.shouldRoutePicker.toBlocking().first()?.itemAtIndexTrigger.onNext(5)
                    selectFilterItem(atIndex: 3)
                    try? sut.shouldRoutePicker.toBlocking().first()?.itemAtIndexTrigger.onNext(5)
                    
                    
                    let datePickerObserver = self.scheduler.createObserver(DatePickerViewModel.self)
                    sut.shouldRouteDatePicker.drive(datePickerObserver).disposed(by: self.disposeBag)
                    selectFilterItem(atIndex: 0)
                    try? sut.shouldRouteDatePicker.toBlocking().first()?.dateTrigger.onNext(Date.random())
                    selectFilterItem(atIndex: 1)
                    try? sut.shouldRouteDatePicker.toBlocking().first()?.dateTrigger.onNext(Date.random())
                    
                    sut.applyTrigger.onNext(())
                    
                    expect(eventsFiltersStorage.finishDate.value).toNot(beNil())
                    expect(eventsFiltersStorage.maxCountOfTeams.value).toNot(beNil())
                    expect(eventsFiltersStorage.minPrizePool.value).toNot(beNil())
                    expect(eventsFiltersStorage.startDate.value).toNot(beNil())
                })

                it("should close", closure: {
                    let observer = self.scheduler.createObserver(Void.self)
                    sut.shouldClose.drive(observer).disposed(by: self.disposeBag)
                    sut.applyTrigger.onNext(())
                    expect(observer.events.count).to(equal(1))
                })
            }
            
            describe("when reset trigger") {
                it("should clean storage", closure: {
                    eventsFiltersStorage.finishDate.accept(Date.random())
                    eventsFiltersStorage.maxCountOfTeams.accept(Int.random())
                    eventsFiltersStorage.minPrizePool.accept(Double.random())
                    eventsFiltersStorage.startDate.accept(Date.random())
                    createSut()
                    sut.resetTrigger.onNext(())
                    expect(eventsFiltersStorage.finishDate.value).to(beNil())
                    expect(eventsFiltersStorage.maxCountOfTeams.value).to(beNil())
                    expect(eventsFiltersStorage.minPrizePool.value).to(beNil())
                    expect(eventsFiltersStorage.startDate.value).to(beNil())
                })
                
                it("should close", closure: {
                    let observer = self.scheduler.createObserver(Void.self)
                    sut.shouldClose.drive(observer).disposed(by: self.disposeBag)
                    sut.resetTrigger.onNext(())
                    expect(observer.events.count).to(equal(1))
                })
            }
        }
    }
}
