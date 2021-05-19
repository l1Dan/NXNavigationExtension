Pod::Spec.new do |spec|
  spec.name         = "UNXNavigator"
  spec.version      = "3.1"
  spec.summary      = "🔥 UNXNavigator（UINavigationBar Extensions）是为 iOS 应用设计的一个简单、易用的导航栏处理框架。"

  spec.description  = <<-DESC
  "🔥 UNXNavigator（UINavigationBar Extensions）是为 iOS 应用设计的一个简单、易用的导航栏处理框架。框架对现有代码入侵非常小，只需要简单的几个方法调用就可以满足大部分的应用场景。"
                   DESC

  spec.homepage     = "https://github.com/l1Dan/UNXNavigator"
  spec.license      = "MIT"
  spec.author       = { "Leo Lee" => "l1dan@hotmail.com" }
  spec.source       = { :git => "https://github.com/l1Dan/UNXNavigator.git", :tag => "#{spec.version}" }

  spec.ios.deployment_target = "11.0"
  spec.source_files = "UNXNavigator/*.{h,m}", "Framework/*.{h,m}"
  spec.private_header_files = "UNXNavigator/UNXNavigatorPrivate.h", "UNXNavigator/UNXNavigatorMacro.h"
end
