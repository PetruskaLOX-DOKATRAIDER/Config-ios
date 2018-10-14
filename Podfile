platform :ios, '10.0'
inhibit_all_warnings!
use_frameworks!

abstract_target 'AT' do
    target 'Core' do
        # RxSwift
        pod 'RxSwift', '~> 4.1'
        pod 'RxCocoa', '~> 4.1'
        pod 'RxOptional'
        pod 'Action'
        pod 'RxKeyboard'
        pod 'ReachabilitySwift'
        pod 'RxViewController'
        pod 'RxMapKit'
        
        #CodeGeneration
        pod 'Sourcery'
        pod 'SwiftGen', '~> 5.3'
        pod 'SwiftLint'
        
        #UIKit
        pod 'AppRouter', '~> 4.1.2'
        pod 'AppRouter/RxSwift', '~> 4.1.2'
        pod 'DTTableViewManager'
        pod 'DTCollectionViewManager'
        pod 'LoadableViews'
        pod 'SnapKit', '~> 4.0.0'
        pod 'NVActivityIndicatorView'
        pod 'Kingfisher', '~> 4.0'
        pod 'RxKingfisher'
        pod 'Motion'
        
        #MVVM
        pod 'Dip', '~> 7.0'
        pod 'ReusableView', '~> 1.2.1'
        pod 'Result', '~> 4.0.0'
        
        #Networking
        pod 'TRON', '~> 4.2.1'
        pod 'SwiftyJSON', '~> 4.1.0'
        #pod 'Starscream', :git => 'https://github.com/daltoniam/Starscream.git', :branch => 'xcode-10'
        pod 'Starscream'
        
        #Analytics
        pod 'Flurry-iOS-SDK/FlurrySDK'
        
        #Logging
        pod 'CocoaLumberjack/Swift'

        target 'TestsHelper' do
            inherit! :search_paths

            pod 'Nimble'
            pod 'Quick'
            
            target 'Tests' do
                inherit! :search_paths

                pod 'RxTest'
                pod 'RxBlocking'
            end
        end

        target 'Config' do
            inherit! :search_paths

            pod 'Fabric'
            pod 'Crashlytics'
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
