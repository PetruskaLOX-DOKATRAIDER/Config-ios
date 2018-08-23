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
        pod 'SwiftGen'
        pod 'SwiftLint'

        #UIKit
        pod 'AppRouter'
        pod 'AppRouter/RxSwift'
        pod 'DTTableViewManager'
        pod 'DTCollectionViewManager'
        pod 'LoadableViews'
        pod 'SnapKit', '~> 4.0.0'
        pod 'NVActivityIndicatorView'
        pod 'Kingfisher', '~> 4.0'
        pod 'RxKingfisher'
        pod 'Motion'
        
        #MVVM
        pod 'Dip', '~> 6.0'
        pod 'ReusableView'
        pod 'Result'

        #Networking
        pod 'TRON'
        pod 'SwiftyJSON'
        pod 'Starscream', '~> 3.0.2'

        #Logging
        pod 'CocoaLumberjack/Swift'

        target 'TestsHelper' do
            inherit! :search_paths

            target 'Tests' do
                inherit! :search_paths

                pod 'RxTest'
                pod 'Nimble'
                pod 'RxBlocking'
                pod 'Quick'
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
          config.build_settings['OTHER_SWIFT_FLAGS'] = ['$(inherited)', '-Onone']
          config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
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
