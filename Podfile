platform :ios, '10.0'
inhibit_all_warnings!
use_frameworks!

abstract_target 'AT' do
    target 'Core' do
        # RxSwift
        pod 'RxSwift', '~> 4.1'
        pod 'RxCocoa', '~> 4.1'
        pod 'RxOptional', '~> 3.5'
        pod 'Action', '~> 3.8'
        pod 'RxKeyboard', '~> 0.9'
        pod 'ReachabilitySwift', '~> 4.3'
        pod 'RxViewController', '~> 0.3'
        pod 'RxMapKit', '~> 1.2'
        
        #CodeGeneration
        pod 'Sourcery', '~> 0.15'
        pod 'SwiftGen', '~> 5.3'
        pod 'SwiftLint', '~> 0.27'
        
        #UIKit
        pod 'AppRouter', '~> 4.1.2'
        pod 'AppRouter/RxSwift', '~> 4.1.2'
        pod 'DTTableViewManager', '~> 6.4.0'
        pod 'DTCollectionViewManager', '~> 6.4'
        pod 'LoadableViews', '~> 3.1'
        pod 'SnapKit', '~> 4.0.0'
        pod 'NVActivityIndicatorView', '~> 4.4'
        pod 'Kingfisher', '~> 4.0'
        pod 'RxKingfisher', '~> 0.2'
        pod 'Motion', '~> 1.4.3'
        
        #MVVM
        pod 'Dip', '~> 7.0'
        pod 'ReusableView', '~> 1.2.1'
        pod 'Result', '~> 4.0.0'
        
        #Networking
        pod 'TRON', '~> 4.2.1'
        pod 'SwiftyJSON', '~> 4.1.0'
        pod 'Starscream', '~> 3.0.6'
        
        #Analytics
        pod 'Flurry-iOS-SDK/FlurrySDK', '~> 9.2.1'
        
        #Logging
        pod 'CocoaLumberjack/Swift', '~> 3.4.2'

        target 'TestsHelper' do
            inherit! :search_paths

            pod 'Nimble', '~> 7.3.1'
            pod 'Quick', '~> 1.3.2'
            
            target 'Tests' do
                inherit! :search_paths

                pod 'RxTest', '~> 4.3.1'
                pod 'RxBlocking', '~> 4.3.1'
            end
        end

        target 'Config' do
            inherit! :search_paths
            #Crashlytics
            pod 'Fabric'
            pod 'Firebase/Core'
        end
        
        target 'CoreDataStorage' do
            inherit! :search_paths

        end
    end
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        if config.name.include? 'Debug'
          config.build_settings['ONLY_ACTIVE_ARCH'] = 'YES'
          config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
          config.build_settings['VALIDATE_PRODUCT'] = 'NO'
          config.build_settings['GCC_OPTIMIZATION_LEVEL'] = 0
          config.build_settings['SWIFT_ACTIVE_COMPILATION_CONDITIONS'] = 'DEBUG'
        end
      end
    end

    # Specify swift 3.2 pods here
    myTargets = []

    installer.pods_project.targets.each do |target|
        if myTargets.include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.2'
            end
        end
    end
end
