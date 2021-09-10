Pod::Spec.new do |spec|

  spec.name     = 'NXNavigationExtension'
  spec.version  = '3.4.5'
  spec.summary  = '🔥 NXNavigationExtension 是为 iOS 应用设计的一个简单、易用的导航栏处理框架。'

  spec.description  = <<-DESC
  '🔥 NXNavigationExtension 是为 iOS 应用设计的一个简单、易用的导航栏处理框架。框架对现有代码入侵非常小，只需要简单的几个方法调用就可以满足大部分的应用场景。'
                   DESC

  spec.homepage = 'https://github.com/l1Dan/NXNavigationExtension'
  spec.license  = 'MIT'
  spec.author   = { 'Leo Lee' => 'l1dan@hotmail.com' }
  spec.source   = { :git => 'https://github.com/l1Dan/NXNavigationExtension.git', :tag => "#{spec.version}" }

  spec.ios.deployment_target  = '9.0'
  spec.frameworks   = 'UIKit'
  spec.source_files = 'NXNavigationExtension/**/*.{h,m}'
  spec.module_map   = 'NXNavigationExtension/module.modulemap'
  spec.public_header_files  = 'NXNavigationExtension/Core/*.h', 'NXNavigationExtension/NXNavigationExtension.h'

end
