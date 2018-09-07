//
//  SkinsViewModel.swift
//  Config
//
//  Created by Oleg Petrychuk on 23.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol SkinsViewModel {
    var skins: Driver<[SkinItemViewModel]> { get }
    var messageViewModel: Driver<MessageViewModel> { get }
    var isWorking: Driver<Bool> { get }
    var refreshTrigger: PublishSubject<Void> { get }
    var searchTrigger: PublishSubject<String?> { get }
    var closeTrigger: PublishSubject<Void> { get }
    var shouldClose: Driver<Void> { get }
}

public final class SkinsViewModelImpl: SkinsViewModel {
    public let skins: Driver<[SkinItemViewModel]>
    public let messageViewModel: Driver<MessageViewModel>
    public let isWorking: Driver<Bool>
    public let refreshTrigger = PublishSubject<Void>()
    public let searchTrigger = PublishSubject<String?>()
    public let closeTrigger = PublishSubject<Void>()
    public let shouldClose: Driver<Void>

    public init(skinsService: SkinsService) {
        let refresh = refreshTrigger.asDriver(onErrorJustReturn: ())
        let response = refresh.flatMapLatest{ skinsService.subscribeForNewSkins() }
        let newSkinVM = response.success()
        let newSkins = newSkinVM
            .map{ [$0] }
            .scan([], accumulator: { $0 + $1 })
            .map{ $0.reversed() }
            .startWith([])
        
        let search = searchTrigger.asDriver(onErrorJustReturn: nil).distinctUntilChanged().throttle(0.3)
        skins = Driver.combineLatest(newSkins, search) { skins, searchText -> [Skin] in
            guard let search = searchText, search.isNotEmpty else { return skins }
            return skins.filter{ $0.name.containsIgnoringCase(find: search) }
        }.map{ $0.map{ SkinItemViewModelImpl(skin: $0) }}
        
        messageViewModel = response.failure().map(to: MessageViewModelImpl.error(description: Strings.Skins.disconect))
        isWorking = Driver.merge(refresh.map(to: true), response.map(to: false)).startWith(false)
        shouldClose = closeTrigger.asDriver(onErrorJustReturn: ())
    }
}
