#
# Be sure to run `pod lib lint TFBaseLib_iOS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TFBaseLib_iOS'
  s.version          = '1.1.1'
  s.summary          = 'Base lib for Treasure framework'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Base lib for Treasure framework
                       DESC

  s.homepage         = 'https://github.com/loverbabyz/TFBaseLib_iOS'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'SunXiaofei' => 'daniel.xiaofei@gmail.com' }
  s.source           = { :git => 'https://github.com/loverbabyz/TFBaseLib_iOS.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.requires_arc = true

  # s.source_files = 'TFBaseLib_iOS/Classes/**/*'
  
  s.source_files = 'TFBaseLib_iOS/Classes/TFBaseLib_iOS.h'
  s.public_header_files = 'TFBaseLib_iOS/Classes/TFBaseLib_iOS.h'

  # s.resource = 'TFBaseLib_iOS/Assets/*.bundle'
  
  # s.resource_bundles = {
  #   'TFBaseLib_iOS' => ['TFBaseLib_iOS/Assets/*.png']
  # }
  
  # s.framework  = "frameworkname"
  # s.ios.library   = "libraryname"
  # s.vendored_libraries = "TFBaseLib/Classes/**/*.{a}"
  # s.resources = "TFBaseLib/Resources/**/*.{bundle}"
  
  s.ios.libraries = "stdc++", "sqlite3"
#  s.ios.vendored_frameworks = "TFBaseLib_iOS/Classes/3rd-framework/**/*.{framework}"

  s.frameworks = "Foundation", "UIKit", "CoreGraphics", "CoreData", "CoreText", "CoreTelephony", "CoreLocation", "Security", "ImageIO", "QuartzCore", "SystemConfiguration", "Photos", "CoreBluetooth", "AVFoundation", "Contacts", "LocalAuthentication", "CoreServices", "AssetsLibrary", "AddressBook"
  
  s.subspec 'Core-3rd' do |ss|
  ss.platform = :ios
  ss.source_files = 'TFBaseLib_iOS/Classes/Core-3rd/*.{h,m}'
  ss.public_header_files = 'TFBaseLib_iOS/Classes/Core-3rd/*.h'

    ss.subspec 'SafeKit' do |sss|
    sss.platform = :ios
    sss.source_files = 'TFBaseLib_iOS/Classes/Core-3rd/SafeKit/*.{h,m}'
    sss.public_header_files = 'TFBaseLib_iOS/Classes/Core-3rd/SafeKit/*.h'
    end

    ss.subspec 'SafeKitMRC' do |sss|
    sss.platform = :ios
    sss.requires_arc = false
    sss.compiler_flags = '-ObjC'
    sss.source_files = 'TFBaseLib_iOS/Classes/Core-3rd/SafeKitMRC/*.{h,m}'
    sss.public_header_files = 'TFBaseLib_iOS/Classes/Core-3rd/SafeKitMRC/*.h'
    end
    
    ss.subspec 'DeepLinkKit' do |sss|
    sss.platform = :ios
    sss.source_files = 'TFBaseLib_iOS/Classes/Core-3rd/DeepLinkKit/**/*.{h,m}'
    sss.public_header_files = 'TFBaseLib_iOS/Classes/Core-3rd/DeepLinkKit/**/*.h'
    end

  end

  s.subspec 'Core-Category' do |ss|
  ss.platform = :ios
  ss.source_files = 'TFBaseLib_iOS/Classes/Core-Category/**/*.{h,m}'
  ss.public_header_files = 'TFBaseLib_iOS/Classes/Core-Category/**/*.h'
  end

  s.subspec 'Core-DataHelper' do |ss|
  ss.platform = :ios
  ss.source_files = 'TFBaseLib_iOS/Classes/Core-DataHelper/*.{h,m}'
  ss.public_header_files = 'TFBaseLib_iOS/Classes/Core-DataHelper/*.h'

    ss.subspec 'TFUserDefaults' do |sss|
    sss.platform = :ios
    sss.source_files = 'TFBaseLib_iOS/Classes/Core-DataHelper/TFUserDefaults/*.{h,m}'
    sss.public_header_files = 'TFBaseLib_iOS/Classes/Core-DataHelper/TFUserDefaults/*.h'
    end

    ss.subspec 'TFKeyChain' do |sss|
    sss.platform = :ios
    sss.source_files = 'TFBaseLib_iOS/Classes/Core-DataHelper/TFKeyChain/*.{h,m}'
    sss.public_header_files = 'TFBaseLib_iOS/Classes/Core-DataHelper/TFKeyChain/*.h'
    end

    ss.subspec 'TFGCDQueue' do |sss|
    sss.platform = :ios
    sss.source_files = 'TFBaseLib_iOS/Classes/Core-DataHelper/TFGCDQueue/*.{h,m}'
    sss.public_header_files = 'TFBaseLib_iOS/Classes/Core-DataHelper/TFGCDQueue/*.h'
    end

    ss.dependency 'AutoCoding', '2.2.3'

  end

  s.subspec 'Core-Macro' do |ss|
  ss.platform = :ios
  ss.source_files = 'TFBaseLib_iOS/Classes/Core-Macro/*.{h,m}'
  ss.public_header_files = 'TFBaseLib_iOS/Classes/Core-Macro/*.h'
  end

  s.subspec 'Core-Manager' do |ss|
    ss.platform = :ios
    ss.source_files = 'TFBaseLib_iOS/Classes/Core-Manager/*.{h,m}'
    ss.public_header_files = 'TFBaseLib_iOS/Classes/Core-Manager/*.h'

    ss.dependency 'AFNetworking', '4.0.1'
    ss.dependency 'CocoaLumberjack', '3.6.1'
  end

  s.subspec 'Core-Util' do |ss|
  ss.platform = :ios
  ss.source_files = 'TFBaseLib_iOS/Classes/Core-Util/*.{h,m}'
  ss.public_header_files = 'TFBaseLib_iOS/Classes/Core-Util/*.h'
  end

  s.dependency  'FMDB', '2.7.5'
  s.dependency  'Aspects','1.4.1'
  s.dependency  'SAMKeychain', '1.5.3'
  s.dependency  'ObjcAssociatedObjectHelpers','2.0.1'
  s.dependency  'MJExtension', '3.2.1'
  
end
