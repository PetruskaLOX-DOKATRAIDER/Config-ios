// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation
import UIKit

// swiftlint:disable file_length
// swiftlint:disable line_length
// swiftlint:disable type_body_length

protocol StoryboardSceneType {
  static var storyboardName: String { get }
}

extension StoryboardSceneType {
  static func storyboard() -> UIStoryboard {
    return UIStoryboard(name: self.storyboardName, bundle: Bundle(for: BundleToken.self))
  }

  static func initialViewController() -> UIViewController {
    guard let vc = storyboard().instantiateInitialViewController() else {
      fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
    }
    return vc
  }
}

extension StoryboardSceneType where Self: RawRepresentable, Self.RawValue == String {
  func viewController() -> UIViewController {
    return Self.storyboard().instantiateViewController(withIdentifier: self.rawValue)
  }
  static func viewController(identifier: Self) -> UIViewController {
    return identifier.viewController()
  }
}

protocol StoryboardSegueType: RawRepresentable { }

extension UIViewController {
  func perform<S: StoryboardSegueType>(segue: S, sender: Any? = nil) where S.RawValue == String {
    performSegue(withIdentifier: segue.rawValue, sender: sender)
  }
}

enum StoryboardScene {
  enum EventsContainer: StoryboardSceneType {
    static let storyboardName = "EventsContainerViewController"

    static func initialViewController() -> EventsContainerViewController {
      guard let vc = storyboard().instantiateInitialViewController() as? EventsContainerViewController else {
        fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
      }
      return vc
    }
  }
  enum EventsFilter: StoryboardSceneType {
    static let storyboardName = "EventsFilterViewController"

    static func initialViewController() -> EventsFilterViewController {
      guard let vc = storyboard().instantiateInitialViewController() as? EventsFilterViewController else {
        fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
      }
      return vc
    }
  }
  enum ListEvents: StoryboardSceneType {
    static let storyboardName = "ListEventsViewController"

    static func initialViewController() -> ListEventsViewController {
      guard let vc = storyboard().instantiateInitialViewController() as? ListEventsViewController else {
        fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
      }
      return vc
    }
  }
  enum MapEvents: StoryboardSceneType {
    static let storyboardName = "MapEventsViewController"

    static func initialViewController() -> MapEventsViewController {
      guard let vc = storyboard().instantiateInitialViewController() as? MapEventsViewController else {
        fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
      }
      return vc
    }
  }
  enum News: StoryboardSceneType {
    static let storyboardName = "NewsViewController"

    static func initialViewController() -> NewsViewController {
      guard let vc = storyboard().instantiateInitialViewController() as? NewsViewController else {
        fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
      }
      return vc
    }
  }
  enum PlayerDescription: StoryboardSceneType {
    static let storyboardName = "PlayerDescriptionViewController"

    static func initialViewController() -> PlayerDescriptionViewController {
      guard let vc = storyboard().instantiateInitialViewController() as? PlayerDescriptionViewController else {
        fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
      }
      return vc
    }
  }
  enum Players: StoryboardSceneType {
    static let storyboardName = "PlayersViewController"

    static func initialViewController() -> PlayersViewController {
      guard let vc = storyboard().instantiateInitialViewController() as? PlayersViewController else {
        fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
      }
      return vc
    }
  }
  enum Profile: StoryboardSceneType {
    static let storyboardName = "ProfileViewController"

    static func initialViewController() -> ProfileViewController {
      guard let vc = storyboard().instantiateInitialViewController() as? ProfileViewController else {
        fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
      }
      return vc
    }
  }
  enum Teams: StoryboardSceneType {
    static let storyboardName = "TeamsViewController"

    static func initialViewController() -> TeamsViewController {
      guard let vc = storyboard().instantiateInitialViewController() as? TeamsViewController else {
        fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
      }
      return vc
    }
  }
  enum Tutorial: StoryboardSceneType {
    static let storyboardName = "TutorialViewController"

    static func initialViewController() -> TutorialViewController {
      guard let vc = storyboard().instantiateInitialViewController() as? TutorialViewController else {
        fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
      }
      return vc
    }
  }
}

enum StoryboardSegue {
}

private final class BundleToken {}
