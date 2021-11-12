Pod::Spec.new do |spec|

  spec.name     = 'NXNavigationExtension'
  spec.version  = '4.0.0'
  spec.summary  = '🔥 NXNavigationExtension 是为 iOS 应用设计的一个轻量级的导航栏处理框架，同时支持 SwiftUI 和 UIKit。'

  spec.description  = <<-DESC
  '🔥 NXNavigationExtension 是为 iOS 应用设计的一个轻量级的导航栏处理框架，同时支持 SwiftUI 和 UIKit。框架对现有代码入侵非常小，只需要简单的几个方法调用就可以满足大部分的应用场景。可能是最省心的一款 iOS 导航栏处理框架之一。'
                   DESC

  spec.homepage = 'https://github.com/l1Dan/NXNavigationExtension'
  spec.license  = 'MIT'
  spec.source   = { :git => 'https://github.com/l1Dan/NXNavigationExtension.git', :tag => "#{spec.version}" }
  
  spec.author   = { 'Leo Lee' => 'l1dan@hotmail.com' }
  spec.social_media_url = 'https://github.com/l1Dan'

  spec.ios.deployment_target  = '9.0'
  spec.default_subspec = 'Sources'
  spec.swift_version = '5.0'
  spec.module_map = 'NXNavigationExtension/module.modulemap'
  spec.frameworks = 'UIKit'

  spec.subspec 'Sources' do |ss|
    ss.source_files = 'NXNavigationExtension/**/*.{h,m}'
    ss.public_header_files  = 'NXNavigationExtension/{Core,Support SwiftUI}/*.h', 'NXNavigationExtension/NXNavigationExtension.h'
  end

  spec.subspec 'SwiftUI' do |ss|
    ss.ios.deployment_target  = '13.0'
    ss.source_files = 'NXNavigationExtensionSwiftUI/{Core}/*.swift'
    ss.frameworks   = 'SwiftUI'
    ss.dependency 'NXNavigationExtension/Sources'
  end

end
