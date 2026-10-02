Pod::Spec.new do |spec|

  spec.name     = 'NXNavigationExtension'
  spec.version  = '5.0.1'
  spec.summary  = '🔥 Lightweight, simple, and easy-to-use NavigationBar library.'

  spec.description  = <<-DESC
  '🔥 NXNavigationExtension 是为 UINavigationBar 设计的轻量级的、简单的、可扩展的库，支持 SwiftUI 和 UIKit。框架对现有代码入侵非常小，只需要简单的几个方法调用就可以满足大部分的应用场景。可能是最省心的 iOS 导航栏处理框架之一。'
                   DESC

  spec.homepage = 'https://github.com/l1Dan/NXNavigationExtension'
  spec.license  = 'MIT'
  spec.source   = { :git => 'https://github.com/l1Dan/NXNavigationExtension.git', :tag => "#{spec.version}" }
  
  spec.author   = { 'Leo Lee' => 'l1dan@hotmail.com' }
  spec.social_media_url = 'https://github.com/l1Dan'

  spec.ios.deployment_target  = '15.0'
  spec.default_subspec = 'Sources'
  spec.swift_version = '6.0'
  spec.frameworks = 'UIKit'

  spec.subspec 'Sources' do |ss|
    ss.source_files = 'NXNavigationExtension/{Core,Private,Support SwiftUI}/*.{h,m}', 'NXNavigationExtension/NXNavigationExtension.h'
    ss.public_header_files  = 'NXNavigationExtension/{Core,Support SwiftUI}/*.h', 'NXNavigationExtension/NXNavigationExtension.h'
  end

  spec.subspec 'SwiftUI' do |ss|
    ss.ios.deployment_target  = '15.0'
    ss.source_files = 'NXNavigationExtensionSwiftUI/Core/*.swift'
    ss.frameworks   = 'SwiftUI'
    ss.dependency 'NXNavigationExtension/Sources'
  end

end
