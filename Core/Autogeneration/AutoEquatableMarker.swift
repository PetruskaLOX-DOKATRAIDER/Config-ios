public protocol AutoEquatable {}

// extend you models with AutoInit marker here (or in any other place if you want)

extension NewsServiceError: AutoEquatable {}

// Waiting for swift 4.2 update

extension NewsServiceError: Equatable {
    public static func == (lhs: NewsServiceError, rhs: NewsServiceError) -> Bool {
        switch (lhs, rhs) {
        case (.serverError, .serverError): return true
        case (.unknown, .unknown): return true
        default: return false
        }
    }
}

extension TeamsServiceError: Equatable {
    public static func == (lhs: TeamsServiceError, rhs: TeamsServiceError) -> Bool {
        switch (lhs, rhs) {
        case (.serverError, .serverError): return true
        case (.unknown, .unknown): return true
        default: return false
        }
    }
}

extension PlayersServiceError: Equatable {
    public static func == (lhs: PlayersServiceError, rhs: PlayersServiceError) -> Bool {
        switch (lhs, rhs) {
        case (.playerIsNotFavorite, .playerIsNotFavorite): return true
        case (.playerIsFavorite, .playerIsFavorite): return true
        case (.serverError, .serverError): return true
        case (.unknown, .unknown): return true
        default: return false
        }
    }
}

extension EventsServiceError: Equatable {
    public static func == (lhs: EventsServiceError, rhs: EventsServiceError) -> Bool {
        switch (lhs, rhs) {
        case (.serverError, .serverError): return true
        case (.unknown, .unknown): return true
        default: return false
        }
    }
}

extension SkinsServiceError: Equatable {
    public static func == (lhs: SkinsServiceError, rhs: SkinsServiceError) -> Bool {
        switch (lhs, rhs) {
        case (.serverError, .serverError): return true
        case (.unknown, .unknown): return true
        default: return false
        }
    }
}

extension BannerServiceError: Equatable {
    public static func == (lhs: BannerServiceError, rhs: BannerServiceError) -> Bool {
        switch (lhs, rhs) {
        case (.serverError, .serverError): return true
        case (.unknown, .unknown): return true
        default: return false
        }
    }
}
