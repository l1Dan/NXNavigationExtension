Pod::Spec.new do |spec|
  spec.name         = "UINavigationExtension"
  spec.version      = "2.0"
  spec.summary      = "iOS 导航栏处理扩展"

  spec.description  = <<-DESC
  "UINavigationExtension 是一个 iOS 导航栏处理扩展"
                   DESC

  spec.homepage     = "https://github.com/l1Dan/UINavigationExtension"
  spec.license      = "MIT"
  spec.author       = { "Leo Lee" => "l1dan@hotmail.com" }
  spec.source       = { :git => "https://github.com/l1Dan/UINavigationExtension.git", :tag => "#{spec.version}" }

  spec.ios.deployment_target = "10.0"
  spec.source_files = "UINavigationExtension/Source/*.{h,m}"

end
