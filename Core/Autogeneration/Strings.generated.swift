// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// swiftlint:disable explicit_type_interface identifier_name line_length nesting type_body_length type_name
public enum Strings {

  public enum Datepicker {
    /// Close
    public static let cancel = Strings.tr("Localizable", "DatePicker.cancel")
    /// Done
    public static let done = Strings.tr("Localizable", "DatePicker.done")
  }

  public enum Errors {
    /// Error
    public static let error = Strings.tr("Localizable", "Errors.error")
    /// Oops, something went wrong
    public static let generalMessage = Strings.tr("Localizable", "Errors.general_message")
  }

  public enum EventDescription {
    /// More Details
    public static let details = Strings.tr("Localizable", "Event_Description.details")
  }

  public enum EventFilters {
    /// Apply
    public static let apply = Strings.tr("Localizable", "Event_Filters.apply")
    /// Cancel
    public static let cancel = Strings.tr("Localizable", "Event_Filters.cancel")
    /// Event finish date not selected
    public static let dateFinishNotSelected = Strings.tr("Localizable", "Event_Filters.date_finish_not_selected")
    /// Event start date not selected
    public static let dateStartNotSelected = Strings.tr("Localizable", "Event_Filters.date_start_not_selected")
    /// Event date range
    public static let dateTitle = Strings.tr("Localizable", "Event_Filters.date_title")
    /// You can setup your events filters here\nAll changes will be saved after you click save
    public static let description = Strings.tr("Localizable", "Event_Filters.description")
    /// More options
    public static let detailsTitle = Strings.tr("Localizable", "Event_Filters.details_title")
    /// $
    public static let dollarChar = Strings.tr("Localizable", "Event_Filters.dollar_char")
    /// Location
    public static let locationTitle = Strings.tr("Localizable", "Event_Filters.location_title")
    /// Max count of teams
    public static let maxCountOfTeams = Strings.tr("Localizable", "Event_Filters.max_count_of_teams")
    /// Max count of teams in event not selected
    public static let maxTeamsNotSelected = Strings.tr("Localizable", "Event_Filters.max_teams_not_selected")
    /// Min prize pool
    public static let minPrizePool = Strings.tr("Localizable", "Event_Filters.min_prize_pool")
    /// Min event prize pool not selected
    public static let minPrizePoolNotSelected = Strings.tr("Localizable", "Event_Filters.min_prize_pool_not_selected")
    /// Reset
    public static let reset = Strings.tr("Localizable", "Event_Filters.reset")
    /// teams
    public static let teams = Strings.tr("Localizable", "Event_Filters.teams")
    /// Filters
    public static let title = Strings.tr("Localizable", "Event_Filters.title")

    public enum Date {
      /// Finish
      public static let finish = Strings.tr("Localizable", "Event_Filters.date.finish")
      /// Start
      public static let start = Strings.tr("Localizable", "Event_Filters.date.start")
    }
  }

  public enum EventsContrainer {
    /// List
    public static let list = Strings.tr("Localizable", "Events_Contrainer.list")
    /// Map
    public static let map = Strings.tr("Localizable", "Events_Contrainer.map")
    /// Events
    public static let title = Strings.tr("Localizable", "Events_Contrainer.title")
  }

  public enum Favoriteplayers {
    /// You have %d players in Favorites
    public static func playersCount(_ p1: Int) -> String {
      return Strings.tr("Localizable", "FavoritePlayers.players_count", p1)
    }
    /// Favorite players
    public static let title = Strings.tr("Localizable", "FavoritePlayers.title")

    public enum NoContent {
      /// You can add any player to Favorites from player description screen
      public static let subtitle = Strings.tr("Localizable", "FavoritePlayers.no_content.subtitle")
      /// You don't have favorite players yet
      public static let title = Strings.tr("Localizable", "FavoritePlayers.no_content.title")
    }
  }

  public enum Feedback {
    /// Your message
    public static let messagePlaceholder = Strings.tr("Localizable", "Feedback.message_placeholder")
    /// Send
    public static let send = Strings.tr("Localizable", "Feedback.send")
    /// Feedback
    public static let title = Strings.tr("Localizable", "Feedback.title")
  }

  public enum Imageviewer {
    /// Failed to load the image
    public static let failureLoadImage = Strings.tr("Localizable", "ImageViewer.failure_load_image")
    /// Failed to save the image
    public static let failureSaveImage = Strings.tr("Localizable", "ImageViewer.failure_save_image")
    /// 
    public static let title = Strings.tr("Localizable", "ImageViewer.title")

    public enum CameraDenied {
      /// Cancel
      public static let cancel = Strings.tr("Localizable", "ImageViewer.camera_denied.cancel")
      /// Please, give us permissions for saving images into your device
      public static let message = Strings.tr("Localizable", "ImageViewer.camera_denied.message")
      /// Give permissions
      public static let permissions = Strings.tr("Localizable", "ImageViewer.camera_denied.permissions")
      /// Error
      public static let title = Strings.tr("Localizable", "ImageViewer.camera_denied.title")
    }

    public enum SuccessSaveImage {
      /// The image has been saved
      public static let description = Strings.tr("Localizable", "ImageViewer.success_save_image.description")
      /// Info
      public static let title = Strings.tr("Localizable", "ImageViewer.success_save_image.title")
    }
  }

  public enum Keybardtoolbar {
    /// Cancel
    public static let cancel = Strings.tr("Localizable", "KeybardToolbar.cancel")
  }

  public enum ListEvents {
    /// 00$
    public static let currency = Strings.tr("Localizable", "List_Events.currency")
    /// From %@ to %@ at the tournament will fight %d teams for a prize fund of %@
    public static func description(_ p1: String, _ p2: String, _ p3: Int, _ p4: String) -> String {
      return Strings.tr("Localizable", "List_Events.description", p1, p2, p3, p4)
    }
  }

  public enum News {
    /// News
    public static let title = Strings.tr("Localizable", "News.title")
  }

  public enum Newsdescription {
    /// by
    public static let by = Strings.tr("Localizable", "NewsDescription.by")
    /// More Details
    public static let details = Strings.tr("Localizable", "NewsDescription.details")
    /// Posted
    public static let posted = Strings.tr("Localizable", "NewsDescription.posted")
    /// Share
    public static let share = Strings.tr("Localizable", "NewsDescription.share")
  }

  public enum Picker {
    /// Close
    public static let cancel = Strings.tr("Localizable", "Picker.cancel")
    /// Done
    public static let done = Strings.tr("Localizable", "Picker.done")
  }

  public enum PlayerBanner {
    /// Updated long time ago
    public static let updatedLongTime = Strings.tr("Localizable", "Player_Banner.updated_long_time")
    /// Updated at
    public static let updatedPrefix = Strings.tr("Localizable", "Player_Banner.updated_prefix")
    /// Updated today!
    public static let updatedToday = Strings.tr("Localizable", "Player_Banner.updated_today")
    /// Updated yesterday!
    public static let updatedYesterday = Strings.tr("Localizable", "Player_Banner.updated_yesterday")
  }

  public enum PlayerDescription {
    /// Add to Favorites
    public static let addFavorite = Strings.tr("Localizable", "Player_Description.add_favorite")
    /// Add to favorites
    public static let addToFavorites = Strings.tr("Localizable", "Player_Description.add_to_favorites")
    /// Player has been added to Favorites
    public static let addedFavoriteMessage = Strings.tr("Localizable", "Player_Description.added_favorite_message")
    /// Cancel
    public static let cancel = Strings.tr("Localizable", "Player_Description.cancel")
    /// CFG URL has been copied
    public static let copiedMessage = Strings.tr("Localizable", "Player_Description.copied_message")
    /// Copy CFG url
    public static let copyCfg = Strings.tr("Localizable", "Player_Description.copy_cfg")
    /// More info
    public static let details = Strings.tr("Localizable", "Player_Description.details")
    /// Plays with %@ DPI
    public static func effectiveDPI(_ p1: String) -> String {
      return Strings.tr("Localizable", "Player_Description.effective_DPI", p1)
    }
    /// Favorite players
    public static let favoriteMessage = Strings.tr("Localizable", "Player_Description.favorite_message")
    /// Was born in %@
    public static func fromCountry(_ p1: String) -> String {
      return Strings.tr("Localizable", "Player_Description.from_country", p1)
    }
    /// Plays on %@ resolution
    public static func gameResolution(_ p1: String) -> String {
      return Strings.tr("Localizable", "Player_Description.game_resolution", p1)
    }
    /// Hardvare
    public static let hardvare = Strings.tr("Localizable", "Player_Description.hardvare")
    /// Uses %@ headSet
    public static func headSet(_ p1: String) -> String {
      return Strings.tr("Localizable", "Player_Description.headSet", p1)
    }
    /// Uses %@ keyboard
    public static func keyboard(_ p1: String) -> String {
      return Strings.tr("Localizable", "Player_Description.keyboard", p1)
    }
    /// Play on %@ monitor
    public static func monitor(_ p1: String) -> String {
      return Strings.tr("Localizable", "Player_Description.monitor", p1)
    }
    /// Uses %@ mouse
    public static func mouse(_ p1: String) -> String {
      return Strings.tr("Localizable", "Player_Description.mouse", p1)
    }
    /// Uses %@ mousepad
    public static func mousepad(_ p1: String) -> String {
      return Strings.tr("Localizable", "Player_Description.mousepad", p1)
    }
    /// Name in the game: %@
    public static func nickname(_ p1: String) -> String {
      return Strings.tr("Localizable", "Player_Description.nickname", p1)
    }
    /// Can't send email\nMake sure that you have email account in your device
    public static let noEmailAcc = Strings.tr("Localizable", "Player_Description.no_email_acc")
    /// Options
    public static let options = Strings.tr("Localizable", "Player_Description.options")
    /// Personal info
    public static let personalInfo = Strings.tr("Localizable", "Player_Description.personal_info")
    /// Plays with %@ polling rate
    public static func pollingRate(_ p1: String) -> String {
      return Strings.tr("Localizable", "Player_Description.polling_rate", p1)
    }
    /// Real name: %@
    public static func realName(_ p1: String) -> String {
      return Strings.tr("Localizable", "Player_Description.real_name", p1)
    }
    /// Remove from Favorites
    public static let removeFavorite = Strings.tr("Localizable", "Player_Description.remove_favorite")
    /// Remove from favorites
    public static let removeFromFavorites = Strings.tr("Localizable", "Player_Description.remove_from_favorites")
    /// Player has been removed from Favorites
    public static let removedFavoriteMessage = Strings.tr("Localizable", "Player_Description.removed_favorite_message")
    /// CFG
    public static let sendCfg = Strings.tr("Localizable", "Player_Description.send_cfg")
    /// Plays with %@ windows sens
    public static func sens(_ p1: String) -> String {
      return Strings.tr("Localizable", "Player_Description.sens", p1)
    }
    /// Settings
    public static let settings = Strings.tr("Localizable", "Player_Description.settings")
    /// Share link
    public static let share = Strings.tr("Localizable", "Player_Description.share")
    /// Share CFG url
    public static let shareCfg = Strings.tr("Localizable", "Player_Description.share_cfg")
    /// Memeber of %@
    public static func team(_ p1: String) -> String {
      return Strings.tr("Localizable", "Player_Description.team", p1)
    }
    /// Description
    public static let title = Strings.tr("Localizable", "Player_Description.title")
  }

  public enum Players {
    /// Players
    public static let title = Strings.tr("Localizable", "Players.title")
  }

  public enum Profile {
    /// Application
    public static let appSection = Strings.tr("Localizable", "Profile.app_section")
    /// Donate
    public static let donate = Strings.tr("Localizable", "Profile.donate")
    /// Send feedback
    public static let feedback = Strings.tr("Localizable", "Profile.feedback")
    /// Personal
    public static let personalSection = Strings.tr("Localizable", "Profile.personal_section")
    /// Rate app in appstore
    public static let rateApp = Strings.tr("Localizable", "Profile.rate_app")
    /// Share with friends
    public static let share = Strings.tr("Localizable", "Profile.share")
    /// Skins price online
    public static let skins = Strings.tr("Localizable", "Profile.skins")
    /// Storage
    public static let storageSection = Strings.tr("Localizable", "Profile.storage_section")
    /// Profile
    public static let title = Strings.tr("Localizable", "Profile.title")
    /// Watch tutorial
    public static let tutorial = Strings.tr("Localizable", "Profile.tutorial")
  }

  public enum Profileemail {
    /// Application will insert this email for sending CFG
    public static let description = Strings.tr("Localizable", "ProfileEmail.description")
    /// example@gmail.com
    public static let placeholder = Strings.tr("Localizable", "ProfileEmail.placeholder")
    /// SAVE
    public static let save = Strings.tr("Localizable", "ProfileEmail.save")
    /// Save my email for CFG
    public static let title = Strings.tr("Localizable", "ProfileEmail.title")
  }

  public enum Skinitem {
    /// free
    public static let free = Strings.tr("Localizable", "SkinItem.free")
    /// for
    public static let priceSubstr = Strings.tr("Localizable", "SkinItem.price_substr")
  }

  public enum Skins {
    /// Something went wrong, disconnected
    public static let disconect = Strings.tr("Localizable", "Skins.disconect")
    /// Search
    public static let search = Strings.tr("Localizable", "Skins.search")
    /// Skins online
    public static let title = Strings.tr("Localizable", "Skins.title")
    /// The Application connecting to the server,\n please wait
    public static let workingStatus = Strings.tr("Localizable", "Skins.working_status")
  }

  public enum Storage {
    /// Clear local cache
    public static let clear = Strings.tr("Localizable", "Storage.clear")
    /// Local cache has been cleared
    public static let cleared = Strings.tr("Localizable", "Storage.cleared")
    /// Memory storage
    public static let title = Strings.tr("Localizable", "Storage.title")
    /// With empty cache you can't work in OFFLINE MODE
    public static let warning = Strings.tr("Localizable", "Storage.warning")
  }

  public enum Teams {
    /// Teams
    public static let title = Strings.tr("Localizable", "Teams.title")
  }

  public enum Tutorial {
    /// Next
    public static let next = Strings.tr("Localizable", "Tutorial.next")
    /// Skip
    public static let skip = Strings.tr("Localizable", "Tutorial.skip")
    /// Start
    public static let start = Strings.tr("Localizable", "Tutorial.start")
    /// Tutorial
    public static let title = Strings.tr("Localizable", "Tutorial.title")

    public enum Item1 {
      /// 
      public static let description = Strings.tr("Localizable", "Tutorial.item1.description")
      /// Players
      public static let title = Strings.tr("Localizable", "Tutorial.item1.title")
    }

    public enum Item2 {
      /// 
      public static let description = Strings.tr("Localizable", "Tutorial.item2.description")
      /// Teams
      public static let title = Strings.tr("Localizable", "Tutorial.item2.title")
    }

    public enum Item3 {
      /// 
      public static let description = Strings.tr("Localizable", "Tutorial.item3.description")
      /// Events
      public static let title = Strings.tr("Localizable", "Tutorial.item3.title")
    }

    public enum Item4 {
      /// 
      public static let description = Strings.tr("Localizable", "Tutorial.item4.description")
      /// News
      public static let title = Strings.tr("Localizable", "Tutorial.item4.title")
    }

    public enum Item5 {
      /// 
      public static let description = Strings.tr("Localizable", "Tutorial.item5.description")
      /// Player's CFG
      public static let title = Strings.tr("Localizable", "Tutorial.item5.title")
    }
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length nesting type_body_length type_name

extension Strings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
