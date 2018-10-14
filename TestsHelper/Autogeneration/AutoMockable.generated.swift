// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Core

// swiftlint:disable file_length
// swiftlint:disable line_length
// swiftlint:disable type_body_length



public class AnalyticsServiceMock: AnalyticsService {


    public init() {
    }

    // MARK: - trackFeedback

    public var trackFeedbackWithMessageCalled = false
    public var trackFeedbackWithMessageReceived: String?

    public func trackFeedback(withMessage message: String) {
        trackFeedbackWithMessageCalled = true
        trackFeedbackWithMessageReceived = message
    }
}
public class AppEnvironmentMock: AppEnvironment {
    public var apiURL: URL
    public var appVersion: String
    public var isDebug: Bool
    public var appStoreURL: URL
    public var donateURL: URL
    public var skinsApiURL: URL
    public var skinsCoverImageApiURL: URL
    public var flurryID: String


    public init(apiURL: URL, appVersion: String, isDebug: Bool, appStoreURL: URL, donateURL: URL, skinsApiURL: URL, skinsCoverImageApiURL: URL, flurryID: String) {
        self.apiURL = apiURL
        self.appVersion = appVersion
        self.isDebug = isDebug
        self.appStoreURL = appStoreURL
        self.donateURL = donateURL
        self.skinsApiURL = skinsApiURL
        self.skinsCoverImageApiURL = skinsCoverImageApiURL
        self.flurryID = flurryID
    }

}
public class AppViewModelMock: AppViewModel {
    public var didBecomeActiveTrigger: PublishSubject<Void>
    public var shouldRouteTutorial: Driver<Void>
    public var shouldRouteApp: Driver<Void>


    public init(didBecomeActiveTrigger: PublishSubject<Void>, shouldRouteTutorial: Driver<Void>, shouldRouteApp: Driver<Void>) {
        self.didBecomeActiveTrigger = didBecomeActiveTrigger
        self.shouldRouteTutorial = shouldRouteTutorial
        self.shouldRouteApp = shouldRouteApp
    }

}
public class BannerAPIServiceMock: BannerAPIService {


    public init() {
    }

    // MARK: - getPlayers

    public var getPlayersPageCalled = false
    public var getPlayersPageReceived: Int?
    public var getPlayersPageReturnValue: Response<Page<PlayerBanner>, RequestError>!

    public func getPlayers(page: Int) -> Response<Page<PlayerBanner>, RequestError> {
        getPlayersPageCalled = true
        getPlayersPageReceived = page
        return getPlayersPageReturnValue
    }
}
public class BannerServiceMock: BannerService {


    public init() {
    }

    // MARK: - getForPlayers

    public var getForPlayersPageCalled = false
    public var getForPlayersPageReceived: Int?
    public var getForPlayersPageReturnValue: DriverResult<Page<PlayerBanner>, BannerServiceError>!

    public func getForPlayers(page: Int) -> DriverResult<Page<PlayerBanner>, BannerServiceError> {
        getForPlayersPageCalled = true
        getForPlayersPageReceived = page
        return getForPlayersPageReturnValue
    }
}
public class CameraServiceMock: CameraService {
    public var cameraAuthorizationStatus: CameraAuthorizationStatus


    public init(cameraAuthorizationStatus: CameraAuthorizationStatus) {
        self.cameraAuthorizationStatus = cameraAuthorizationStatus
    }

}
public class DeviceRouterMock: DeviceRouter {


    public init() {
    }

    // MARK: - openSettings

    public var openSettingsCalled = false

    public func openSettings() {
        openSettingsCalled = true
    }
    // MARK: - open

    public var openUrlCalled = false
    public var openUrlReceived: URL?

    public func open(url: URL) {
        openUrlCalled = true
        openUrlReceived = url
    }
}
public class EmailServiceMock: EmailService {


    public init() {
    }

    // MARK: - send

    public var sendWithInfoCalled = false
    public var sendWithInfoReceived: EmailInfo?
    public var sendWithInfoReturnValue: DriverResult<Void, EmailServiceError>!

    public func send(withInfo info: EmailInfo) -> DriverResult<Void, EmailServiceError> {
        sendWithInfoCalled = true
        sendWithInfoReceived = info
        return sendWithInfoReturnValue
    }
}
public class EventsAPIServiceMock: EventsAPIService {


    public init() {
    }

    // MARK: - get

    public var getPageCalled = false
    public var getPageReceived: Int?
    public var getPageReturnValue: Response<Page<Core.Event>, RequestError>!

    public func get(page: Int) -> Response<Page<Core.Event>, RequestError> {
        getPageCalled = true
        getPageReceived = page
        return getPageReturnValue
    }
}
public class EventsFiltersStorageMock: EventsFiltersStorage {
    public var startDate: BehaviorRelay<Date?>
    public var finishDate: BehaviorRelay<Date?>
    public var maxCountOfTeams: BehaviorRelay<Int?>
    public var minPrizePool: BehaviorRelay<Double?>


    public init(startDate: BehaviorRelay<Date?>, finishDate: BehaviorRelay<Date?>, maxCountOfTeams: BehaviorRelay<Int?>, minPrizePool: BehaviorRelay<Double?>) {
        self.startDate = startDate
        self.finishDate = finishDate
        self.maxCountOfTeams = maxCountOfTeams
        self.minPrizePool = minPrizePool
    }

}
public class EventsServiceMock: EventsService {


    public init() {
    }

    // MARK: - get

    public var getPageCalled = false
    public var getPageReceived: Int?
    public var getPageReturnValue: DriverResult<Page<Core.Event>, EventsServiceError>!

    public func get(page: Int) -> DriverResult<Page<Core.Event>, EventsServiceError> {
        getPageCalled = true
        getPageReceived = page
        return getPageReturnValue
    }
}
public class EventsStorageMock: EventsStorage {


    public init() {
    }

    // MARK: - update

    public var updateWithNewCalled = false
    public var updateWithNewReceived: [Core.Event]?
    public var updateWithNewReturnValue: Driver<Void>!

    public func update(withNew events: [Core.Event]) -> Driver<Void> {
        updateWithNewCalled = true
        updateWithNewReceived = events
        return updateWithNewReturnValue
    }
    // MARK: - get

    public var getCalled = false
    public var getReturnValue: Driver<[Core.Event]>!

    public func get() -> Driver<[Core.Event]> {
        getCalled = true
        return getReturnValue
    }
}
public class ImageLoaderServiceMock: ImageLoaderService {


    public init() {
    }

    // MARK: - loadImage

    public var loadImageWithURLCalled = false
    public var loadImageWithURLReceived: URL?
    public var loadImageWithURLReturnValue: Observable<Result<Image, ImageLoaderServiceError>>!

    public func loadImage(withURL url: URL) -> Observable<Result<Image, ImageLoaderServiceError>> {
        loadImageWithURLCalled = true
        loadImageWithURLReceived = url
        return loadImageWithURLReturnValue
    }
    // MARK: - clearCache

    public var clearCacheCalled = false

    public func clearCache() {
        clearCacheCalled = true
    }
}
public class NewsAPIServiceMock: NewsAPIService {


    public init() {
    }

    // MARK: - get

    public var getPageCalled = false
    public var getPageReceived: Int?
    public var getPageReturnValue: Response<Page<NewsPreview>, RequestError>!

    public func get(page: Int) -> Response<Page<NewsPreview>, RequestError> {
        getPageCalled = true
        getPageReceived = page
        return getPageReturnValue
    }
    // MARK: - get

    public var getNewsCalled = false
    public var getNewsReceived: Int?
    public var getNewsReturnValue: Response<NewsDescription, RequestError>!

    public func get(news id: Int) -> Response<NewsDescription, RequestError> {
        getNewsCalled = true
        getNewsReceived = id
        return getNewsReturnValue
    }
}
public class NewsServiceMock: NewsService {


    public init() {
    }

    // MARK: - getPreview

    public var getPreviewPageCalled = false
    public var getPreviewPageReceived: Int?
    public var getPreviewPageReturnValue: DriverResult<Page<NewsPreview>, NewsServiceError>!

    public func getPreview(page: Int) -> DriverResult<Page<NewsPreview>, NewsServiceError> {
        getPreviewPageCalled = true
        getPreviewPageReceived = page
        return getPreviewPageReturnValue
    }
    // MARK: - getDescription

    public var getDescriptionNewsCalled = false
    public var getDescriptionNewsReceived: Int?
    public var getDescriptionNewsReturnValue: DriverResult<NewsDescription, NewsServiceError>!

    public func getDescription(news id: Int) -> DriverResult<NewsDescription, NewsServiceError> {
        getDescriptionNewsCalled = true
        getDescriptionNewsReceived = id
        return getDescriptionNewsReturnValue
    }
}
public class NewsStorageMock: NewsStorage {


    public init() {
    }

    // MARK: - updatePreview

    public var updatePreviewWithNewCalled = false
    public var updatePreviewWithNewReceived: [NewsPreview]?
    public var updatePreviewWithNewReturnValue: Driver<Void>!

    public func updatePreview(withNew news: [NewsPreview]) -> Driver<Void> {
        updatePreviewWithNewCalled = true
        updatePreviewWithNewReceived = news
        return updatePreviewWithNewReturnValue
    }
    // MARK: - getPreview

    public var getPreviewCalled = false
    public var getPreviewReturnValue: Driver<[NewsPreview]>!

    public func getPreview() -> Driver<[NewsPreview]> {
        getPreviewCalled = true
        return getPreviewReturnValue
    }
    // MARK: - updateDescription

    public var updateDescriptionWithNewCalled = false
    public var updateDescriptionWithNewReceived: NewsDescription?
    public var updateDescriptionWithNewReturnValue: Driver<Void>!

    public func updateDescription(withNew news: NewsDescription) -> Driver<Void> {
        updateDescriptionWithNewCalled = true
        updateDescriptionWithNewReceived = news
        return updateDescriptionWithNewReturnValue
    }
    // MARK: - getDescription

    public var getDescriptionNewsCalled = false
    public var getDescriptionNewsReceived: Int?
    public var getDescriptionNewsReturnValue: Driver<NewsDescription?>!

    public func getDescription(news id: Int) -> Driver<NewsDescription?> {
        getDescriptionNewsCalled = true
        getDescriptionNewsReceived = id
        return getDescriptionNewsReturnValue
    }
}
public class PasteboardServiceMock: PasteboardService {


    public init() {
    }

    // MARK: - save

    public var saveStringCalled = false
    public var saveStringReceived: String?

    public func save(string: String) {
        saveStringCalled = true
        saveStringReceived = string
    }
    // MARK: - saved

    public var savedCalled = false
    public var savedReturnValue: String?

    public func saved() -> String? {
        savedCalled = true
        return savedReturnValue
    }
}
public class PhotosAlbumServiceMock: PhotosAlbumService {


    public init() {
    }

    // MARK: - save

    public var saveImageCalled = false
    public var saveImageReceived: UIImage?
    public var saveImageReturnValue: Observable<Result<Void, PhotosAlbumServiceError>>!

    public func save(image: UIImage) -> Observable<Result<Void, PhotosAlbumServiceError>> {
        saveImageCalled = true
        saveImageReceived = image
        return saveImageReturnValue
    }
}
public class PlayersAPIServiceMock: PlayersAPIService {


    public init() {
    }

    // MARK: - getPreview

    public var getPreviewPageCalled = false
    public var getPreviewPageReceived: Int?
    public var getPreviewPageReturnValue: Response<Page<PlayerPreview>, RequestError>!

    public func getPreview(page: Int) -> Response<Page<PlayerPreview>, RequestError> {
        getPreviewPageCalled = true
        getPreviewPageReceived = page
        return getPreviewPageReturnValue
    }
    // MARK: - getDescription

    public var getDescriptionPlayerCalled = false
    public var getDescriptionPlayerReceived: Int?
    public var getDescriptionPlayerReturnValue: Response<PlayerDescription, RequestError>!

    public func getDescription(player id: Int) -> Response<PlayerDescription, RequestError> {
        getDescriptionPlayerCalled = true
        getDescriptionPlayerReceived = id
        return getDescriptionPlayerReturnValue
    }
}
public class PlayersBannerViewModelMock: PlayersBannerViewModel {
    public var playersPaginator: Paginator<PlayerBannerItemViewModel>
    public var currentPage: Driver<Int>
    public var pageTrigger: PublishSubject<Int>
    public var errorMessage: Driver<String>
    public var shouldRouteDescription: Driver<Int>


    public init(playersPaginator: Paginator<PlayerBannerItemViewModel>, currentPage: Driver<Int>, pageTrigger: PublishSubject<Int>, errorMessage: Driver<String>, shouldRouteDescription: Driver<Int>) {
        self.playersPaginator = playersPaginator
        self.currentPage = currentPage
        self.pageTrigger = pageTrigger
        self.errorMessage = errorMessage
        self.shouldRouteDescription = shouldRouteDescription
    }

}
public class PlayersServiceMock: PlayersService {


    public init() {
    }

    // MARK: - getPreview

    public var getPreviewPageCalled = false
    public var getPreviewPageReceived: Int?
    public var getPreviewPageReturnValue: DriverResult<Page<PlayerPreview>, PlayersServiceError>!

    public func getPreview(page: Int) -> DriverResult<Page<PlayerPreview>, PlayersServiceError> {
        getPreviewPageCalled = true
        getPreviewPageReceived = page
        return getPreviewPageReturnValue
    }
    // MARK: - getDescription

    public var getDescriptionPlayerCalled = false
    public var getDescriptionPlayerReceived: Int?
    public var getDescriptionPlayerReturnValue: DriverResult<PlayerDescription, PlayersServiceError>!

    public func getDescription(player id: Int) -> DriverResult<PlayerDescription, PlayersServiceError> {
        getDescriptionPlayerCalled = true
        getDescriptionPlayerReceived = id
        return getDescriptionPlayerReturnValue
    }
    // MARK: - getFavoritePreview

    public var getFavoritePreviewCalled = false
    public var getFavoritePreviewReturnValue: DriverResult<[PlayerPreview], PlayersServiceError>!

    public func getFavoritePreview() -> DriverResult<[PlayerPreview], PlayersServiceError> {
        getFavoritePreviewCalled = true
        return getFavoritePreviewReturnValue
    }
    // MARK: - add

    public var addFavouriteCalled = false
    public var addFavouriteReceived: Int?
    public var addFavouriteReturnValue: DriverResult<Void, PlayersServiceError>!

    public func add(favourite id: Int) -> DriverResult<Void, PlayersServiceError> {
        addFavouriteCalled = true
        addFavouriteReceived = id
        return addFavouriteReturnValue
    }
    // MARK: - remove

    public var removeFavouriteCalled = false
    public var removeFavouriteReceived: Int?
    public var removeFavouriteReturnValue: DriverResult<Void, PlayersServiceError>!

    public func remove(favourite id: Int) -> DriverResult<Void, PlayersServiceError> {
        removeFavouriteCalled = true
        removeFavouriteReceived = id
        return removeFavouriteReturnValue
    }
    // MARK: - isFavourite

    public var isFavouritePlayerCalled = false
    public var isFavouritePlayerReceived: Int?
    public var isFavouritePlayerReturnValue: DriverResult<Bool, PlayersServiceError>!

    public func isFavourite(player id: Int) -> DriverResult<Bool, PlayersServiceError> {
        isFavouritePlayerCalled = true
        isFavouritePlayerReceived = id
        return isFavouritePlayerReturnValue
    }
}
public class PlayersStorageMock: PlayersStorage {


    public init() {
    }

    // MARK: - updatePreview

    public var updatePreviewWithNewCalled = false
    public var updatePreviewWithNewReceived: [PlayerPreview]?
    public var updatePreviewWithNewReturnValue: Driver<Void>!

    public func updatePreview(withNew players: [PlayerPreview]) -> Driver<Void> {
        updatePreviewWithNewCalled = true
        updatePreviewWithNewReceived = players
        return updatePreviewWithNewReturnValue
    }
    // MARK: - getPreview

    public var getPreviewCalled = false
    public var getPreviewReturnValue: Driver<[PlayerPreview]>!

    public func getPreview() -> Driver<[PlayerPreview]> {
        getPreviewCalled = true
        return getPreviewReturnValue
    }
    // MARK: - updateDescription

    public var updateDescriptionWithNewCalled = false
    public var updateDescriptionWithNewReceived: PlayerDescription?
    public var updateDescriptionWithNewReturnValue: Driver<Void>!

    public func updateDescription(withNew player: PlayerDescription) -> Driver<Void> {
        updateDescriptionWithNewCalled = true
        updateDescriptionWithNewReceived = player
        return updateDescriptionWithNewReturnValue
    }
    // MARK: - getDescription

    public var getDescriptionPlayerCalled = false
    public var getDescriptionPlayerReceived: Int?
    public var getDescriptionPlayerReturnValue: Driver<PlayerDescription?>!

    public func getDescription(player id: Int) -> Driver<PlayerDescription?> {
        getDescriptionPlayerCalled = true
        getDescriptionPlayerReceived = id
        return getDescriptionPlayerReturnValue
    }
    // MARK: - getFavoritePreview

    public var getFavoritePreviewCalled = false
    public var getFavoritePreviewReturnValue: Driver<[PlayerPreview]>!

    public func getFavoritePreview() -> Driver<[PlayerPreview]> {
        getFavoritePreviewCalled = true
        return getFavoritePreviewReturnValue
    }
    // MARK: - add

    public var addFavouriteCalled = false
    public var addFavouriteReceived: Int?
    public var addFavouriteReturnValue: Driver<Void>!

    public func add(favourite id: Int) -> Driver<Void> {
        addFavouriteCalled = true
        addFavouriteReceived = id
        return addFavouriteReturnValue
    }
    // MARK: - remove

    public var removeFavouriteCalled = false
    public var removeFavouriteReceived: Int?
    public var removeFavouriteReturnValue: Driver<Void>!

    public func remove(favourite id: Int) -> Driver<Void> {
        removeFavouriteCalled = true
        removeFavouriteReceived = id
        return removeFavouriteReturnValue
    }
    // MARK: - isFavourite

    public var isFavouritePlayerCalled = false
    public var isFavouritePlayerReceived: Int?
    public var isFavouritePlayerReturnValue: Driver<Bool>!

    public func isFavourite(player id: Int) -> Driver<Bool> {
        isFavouritePlayerCalled = true
        isFavouritePlayerReceived = id
        return isFavouritePlayerReturnValue
    }
}
public class ReachabilityServiceMock: ReachabilityService {
    public var connection: Connection


    public init(connection: Connection) {
        self.connection = connection
    }

}
public class SkinsAPIServiceMock: SkinsAPIService {


    public init() {
    }

    // MARK: - subscribeForNewSkins

    public var subscribeForNewSkinsCalled = false
    public var subscribeForNewSkinsReturnValue: DriverResult<Skin, SkinsAPIServiceError>!

    public func subscribeForNewSkins() -> DriverResult<Skin, SkinsAPIServiceError> {
        subscribeForNewSkinsCalled = true
        return subscribeForNewSkinsReturnValue
    }
}
public class SkinsServiceMock: SkinsService {


    public init() {
    }

    // MARK: - subscribeForNewSkins

    public var subscribeForNewSkinsCalled = false
    public var subscribeForNewSkinsReturnValue: DriverResult<Skin, SkinsServiceError>!

    public func subscribeForNewSkins() -> DriverResult<Skin, SkinsServiceError> {
        subscribeForNewSkinsCalled = true
        return subscribeForNewSkinsReturnValue
    }
}
public class TeamsAPIServiceMock: TeamsAPIService {


    public init() {
    }

    // MARK: - get

    public var getPageCalled = false
    public var getPageReceived: Int?
    public var getPageReturnValue: Response<Page<Team>, RequestError>!

    public func get(page: Int) -> Response<Page<Team>, RequestError> {
        getPageCalled = true
        getPageReceived = page
        return getPageReturnValue
    }
}
public class TeamsServiceMock: TeamsService {


    public init() {
    }

    // MARK: - get

    public var getPageCalled = false
    public var getPageReceived: Int?
    public var getPageReturnValue: DriverResult<Page<Team>, TeamsServiceError>!

    public func get(page: Int) -> DriverResult<Page<Team>, TeamsServiceError> {
        getPageCalled = true
        getPageReceived = page
        return getPageReturnValue
    }
}
public class TeamsStorageMock: TeamsStorage {


    public init() {
    }

    // MARK: - update

    public var updateWithNewCalled = false
    public var updateWithNewReceived: [Team]?
    public var updateWithNewReturnValue: Driver<Void>!

    public func update(withNew teams: [Team]) -> Driver<Void> {
        updateWithNewCalled = true
        updateWithNewReceived = teams
        return updateWithNewReturnValue
    }
    // MARK: - get

    public var getCalled = false
    public var getReturnValue: Driver<[Team]>!

    public func get() -> Driver<[Team]> {
        getCalled = true
        return getReturnValue
    }
}
public class UserStorageMock: UserStorage {
    public var isOnboardingPassed: BehaviorRelay<Bool>
    public var email: BehaviorRelay<String?>


    public init(isOnboardingPassed: BehaviorRelay<Bool>, email: BehaviorRelay<String?>) {
        self.isOnboardingPassed = isOnboardingPassed
        self.email = email
    }

}
