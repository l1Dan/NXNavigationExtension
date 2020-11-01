Pod::Spec.new do |spec|
  spec.name         = "UINavigationExtension"
  spec.version      = "2.3.4"
  spec.summary      = "UINavigationExtension 是为 iOS 应用设计的一个简单、易用的导航栏处理框架。"

  spec.description  = <<-DESC
  "UINavigationExtension 是为 iOS 应用设计的一个简单、易用的导航栏处理框架。框架代码入侵非常小，只需要简单的几个 API 调用就可以满足大部分的应用场景。"
                   DESC

  spec.homepage     = "https://github.com/l1Dan/UINavigationExtension"
  spec.license      = "MIT"
  spec.author       = { "Leo Lee" => "l1dan@hotmail.com" }
  spec.source       = { :git => "https://github.com/l1Dan/UINavigationExtension.git", :tag => "#{spec.version}" }

  spec.ios.deployment_target = "11.0"
  spec.source_files = "UINavigationExtension/Source/*.{h,m}"
  spec.private_header_files = 'UINavigationExtension/Source/UINavigationExtensionPrivate.h'

end
