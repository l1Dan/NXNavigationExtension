<p align="center" >
  <img src="https://raw.githubusercontent.com/l1Dan/NXNavigationExtension/main/Snapshots/Slogan.png" alt="NXNavigationExtension" title="NXNavigationExtension">
</p>

[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/NXNavigationExtension.svg?style=flat)](https://img.shields.io/cocoapods/v/NXNavigationExtension.svg) ![Language](https://img.shields.io/github/languages/top/l1dan/NXNavigationExtension.svg?style=flat) [![MIT License](https://img.shields.io/github/license/l1dan/NXNavigationExtension.svg?style=flat)](https://opensource.org/licenses/mit-license.php) [![Platform](https://img.shields.io/cocoapods/p/NXNavigationExtension.svg?style=flat)](https://github.com/l1Dan/NXNavigationExtension/blob/main/README.md) [![GitHub last commit](https://img.shields.io/github/last-commit/l1Dan/NXNavigationExtension.svg?style=flat)](https://img.shields.io/github/last-commit/l1Dan/NXNavigationExtension)

🔥 NXNavigationExtension 是为 UINavigationBar 设计的轻量级的、简单的、可扩展的库，支持 SwiftUI 和 UIKit。框架对现有代码入侵非常小，只需要简单的几个方法调用就可以满足大部分的应用场景。可能是最省心的 iOS 导航栏处理框架之一。NXNavigationExtension 框架本身和示例代码都已经适配暗黑模式可供大家参考。

## 🎯 介绍太长不看系列
### 解决导航栏存在的多个痛点
1. 解决导航栏背景修改不方便问题。
2. 解决操作不当导致导航栏错乱问题。
3. 解决导航栏显示、隐藏时页面之间过渡动画有割裂感、不流畅问题。
4. 解决点击返回按钮事件无法拦截、手势滑动返回事件无法拦截问题。
5. 您用过之后觉得还不错的话，麻烦回来给我个 Star 🌟 鼓励下哦，不胜感激！

## 🎉 预览

[1]: https://raw.githubusercontent.com/l1Dan/NXNavigationExtension/main/Snapshots/Preview1.gif
[2]: https://raw.githubusercontent.com/l1Dan/NXNavigationExtension/main/Snapshots/Preview2.gif
[3]: https://raw.githubusercontent.com/l1Dan/NXNavigationExtension/main/Snapshots/Preview3.gif
[4]: https://raw.githubusercontent.com/l1Dan/NXNavigationExtension/main/Snapshots/Preview4.gif

| SwiftUI 路由 | 完全自定义导航栏 | 返回事件拦截 | 修改导航栏外观 |
| :----------: | :--------------: | :----------: | :------------: |
|    ![][1]    |      ![][2]      |    ![][3]    |     ![][4]     |

## 🌈 要求

|   Version   | Minimum iOS / macOS Target | Requirements |
| :---------: | :------------------------: | :----------: |
| 4.2.6 Later |   iOS 12.0 / macOS 10.15   |   Xcode26    |
| 4.2.5 Later |   iOS 12.0 / macOS 10.15   |   Xcode16    |
| 4.1.7 Later |   iOS 12.0 / macOS 10.15   |   Xcode15    |
| 4.1.5 Later |   iOS 11.0 / macOS 10.15   |   Xcode14    |
|    4.1.4    |   iOS 9.0 / macOS 10.15    |   Xcode13    |
|     3.x     |   iOS 9.0 / macOS 10.15    |      /       |
|     2.x     |   iOS 11.0 / macOS 10.15   |      /       |

## 🍭 优点

- 没有对原生导航栏视图层级进行修改，无需担心系统升级的兼容性问题。
- API 设计通俗易懂，容易使用。
- 没有继承关系，所有操作基于分类实现，低耦合。
- 白名单模式：按需注册所使用的导航控制器，这样才不会影响所有的导航控制器外观。
- 适配 iOS、iPadOS、macOS、横竖屏切换、暗黑模式、支持阿拉伯语等从右往左的布局方式。
- 提供 SwiftUI、UIKit、macCatalyst 框架的支持。
- 支持 CocoaPods、Carthage、Project、Swift Package Manager 方式集成。

## 👏 功能

下面这些特别实用的功能，总有一部分适合你的项目

### 基本功能

- ✅` 设置导航栏透明`
- ✅` 实现系统导航栏模糊效果`
- ✅` 自定义返回按钮图片`
- ✅` 自定义返回按钮`
- ✅` 自定义导航栏模糊背景`
- ✅` 修改返回按钮箭头颜色`
- ✅` 修改系统返回按钮文字`
- ✅` 修改导航栏标题颜色`
- ✅` 修改导航栏背景颜色`
- ✅` 修改导航栏背景图片`
- ✅` 设置导航栏底部阴影颜色`
- ✅` 设置导航栏底部阴影图片`

### 高级功能

- ✅` 禁用右滑手势返回`
- ✅` 启用全屏右滑手势返回`
- ✅` 导航栏返回事件拦截`
- ✅` 支持视图控制器转场状态`
- ✅` SwiftUI 路由`
- ✅` 导航栏点击事件穿透到底部`
- ✅` 动态修改导航栏样式`
- ✅` 更新导航栏样式`
- ✅` 渐变导航栏样式`
- ✅` 长按返回按钮显示菜单功能`
- 更多功能请查看示例代码...

## 🌟 开始使用

下载 [NXNavigationExtension](https://github.com/l1Dan/NXNavigationExtension/archive/refs/heads/main.zip) 示例代码。

## 使用 CocoaPods 集成

使用 [CocoaPods](https://cocoapods.org/) 将 NXNavigationExtension 集成到 Xcode 项目中，需要在 `Podfile` 中指定：

```ruby
## For SwiftUI
pod 'NXNavigationExtension/SwiftUI'

## For UIKit
pod 'NXNavigationExtension'
```

## 使用 Carthage 管理

使用 [Carthage](https://github.com/Carthage/Carthage) 管理 NXNavigationExtension framework，请将以下内容添加到您的 `Cartfile` 文件中：

```yaml
# For SwiftUI
github "l1Dan/NXNavigationExtension" # Requires
github "l1Dan/NXNavigationExtensionSwiftUI"

# For UIKit
github "l1Dan/NXNavigationExtension"

```

## 使用 Swift Package Manager 集成

使用 [Swift Package Manager](https://swift.org/package-manager/) 集成 NXNavigationExtension，请将以下内容添加到您的 `Package.swift` 文件的依赖中：

```swift
dependencies: [
    .package(url: "https://github.com/l1Dan/NXNavigationExtension.git", .upToNextMajor(from: "4.2.6"))
]
```

## 📖 使用教程

- 阅读 [**SwiftUI Guide**](https://github.com/l1Dan/NXNavigationExtension/blob/main/Documentation/NXNavigationExtensionSwiftUI.md) 文档。
- 阅读 [**UIKit Guide**](https://github.com/l1Dan/NXNavigationExtension/blob/main/Documentation/NXNavigationExtensionUIKit.md) 文档。

## 🍽 使用

所有对导航栏外观的修改都是基于视图控制器 `UIViewController` 修改的，而不是基于导航控制器 `UINavigationController` 修改，这种设计逻辑更加符合实际应用场景。也就是说视图控制器管理自己的导航栏，而不是使用导航控制器来全局管理。

1. 💉 导入模块 `import NXNavigationExtension`。
2. 💉 使用之前需要先在 `AppDelegate` 中注册需要修改的导航控制器。

✅ 推荐

只需要下面这一行代码就完成导航控制器的注册，现在你可以尽情地修改导航栏的外观了。

```swift
// For YourNavigationController
NXNavigationConfiguration().registerNavigationControllerClasses([YourNavigationController.self])
```

或者

当然也可以同时注册多个导航控制器

```swift
NXNavigationConfiguration().registerNavigationControllerClasses([YourNavigationController.self, YourNavigationController2.self])
```

或者

还可以动态修改导航栏的外观（`NXNavigationExtensionSwiftUI` 框架就是基于这个特性实现的）

```swift
let configuration = NXNavigationConfiguration.default
// 默认首选配置（单利对象意味着对所有注册的导航控制器生效）
configuration.navigationBarAppearance.tintColor = .customTitle
configuration.registerNavigationControllerClasses([YourNavigationController.self, YourNavigationController2.self]) { navigationController, configuration in
    // For UINavigationController，针对不同导航控制器的修改
    if navigationController is YourNavigationController {
        // 动态修改导航控制器的默认首选配置
        configuration.navigationBarAppearance.backgroundColor = .brown
        // 动态修改视图控制器的默认首选配置
        navigationController.nx_prepareConfigureViewControllersCallback { viewController, configuration in
            // For UIViewController 针对不同视图控制器的修改
            if viewController is MyViewController {
                configuration.navigationBarAppearance.backgroundColor = .red
            }
        }
    }
    return configuration
}
```

❌ 不推荐

```swift
// UINavigationController 会影响所有的导航控制器，所以不推荐使用这种方式注册
NXNavigationConfiguration().registerNavigationControllerClasses([UINavigationController.self])
```

**注意**：

- 👉 虽然示例程序代码使用的是 `Swift` 语言实现的，但框架还是可以支持 `Objective-C` 语言的，如果需要 `Objective-C` 示例程序的代码可以查看 [3.x](https://github.com/l1Dan/NXNavigationExtension/tree/3.x) 分支代码。
- 👉 使用这个框架之前需要先注册导航控制器，然后再去修改被注册的导航控制器所管理的视图控制器的导航栏外观。
- 👉 为了有效避免框架污染到其他的导航控制器，请保持“谁使用，谁注册”的原则。
- 🚫 不要直接注册 `UINavigationController`，会影响全局导航栏的外观，建议创建一个 `UINavigationController` 的子类，对这个子类进行外观的设置。
- 🚫 不要使用 `setNavigationBarHidden:`、`setNavigationBarHidden:animated`、`setHidden:` 等方法显示或隐藏系统导航栏。
- 🚫 不要使用系统导航栏修改透明度。
- 🚫 不要使用系统导航栏或导航控制器 `appearance` 相关属性修改。
- 🚫 不要使用 `<UIGestureRecognizerDelegate>` 相关方法禁用手势返回。
- ❗️ 在某些条件下，不推荐使用 UIViewController 的 `edgesForExtendedLayout = UIRectEdge(rawValue: 0)` 属性设置，使用默认方式即可，具体原因请[查看](https://github.com/l1Dan/NXNavigationExtension/issues/17)。
- 一句话总结：原则就是不要直接修改系统导航栏或者导航控制器的外观，可以让我们少走弯路，把这些繁琐的事情都交给这个框架处理吧。

## 🍻 基本功能

#### 修改返回按钮箭头颜色

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/NXNavigationExtensionDemo/UIKit/Advanced/ViewController07_UpdateNavigationBar.swift)

```swift
override var nx_barTintColor: UIColor? {
    return isDarkMode ? .white : .black
}
```

#### 修改系统返回按钮文字

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/NXNavigationExtensionDemo/UIKit/Advanced/ViewController07_UpdateNavigationBar.swift)

```swift
// 需要设置使用系统返回按钮，这样才会有效果
override var nx_useSystemBackButton: Bool {
    return true
}

override var nx_systemBackButtonTitle: String? {
    return backButtonTitle
}
```

#### 修改导航栏标题颜色

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/NXNavigationExtensionDemo/UIKit/Advanced/ViewController07_UpdateNavigationBar.swift)

```swift
override var nx_titleTextAttributes: [NSAttributedString.Key : Any]? {
    return [NSAttributedString.Key.foregroundColor: nx_barTintColor ?? (isDarkMode ? .white : .black)]
}
```

#### 修改导航栏背景颜色

**导航栏背景颜色默认使用系统蓝色 `UIColor.systemBlue`，这样处理能够快速辨别框架是否生效，也可以使用以下方式进行重写：**

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/NXNavigationExtensionDemo/UIKit/Basic/ViewController01_BackgroundColor.swift)

```swift
// 全局统一修改（不会覆盖基于视图控制器的修改）
let configuration = NXNavigationConfiguration.default
configuration.navigationBarAppearance.backgroundColor = .red

// 基于视图控制器修改（可以是基类视图控制器也是可以是特定需要修改的视图控制器）
override var nx_navigationBarBackgroundColor: UIColor? {
    return randomColor
}
```

#### 修改导航栏背景图片

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/NXNavigationExtensionDemo/UIKit/Basic/ViewController02_BackgroundImage.swift)

```swift
override var nx_navigationBarBackgroundImage: UIImage? {
    return UIImage.navigationBarBackground
}
```

#### 设置导航栏透明

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/NXNavigationExtensionDemo/UIKit/Basic/ViewController03_Transparent.swift)

```swift
override var nx_navigationBarBackgroundColor: UIColor? {
    return .clear
}

// 设置导航栏底部阴影颜色
override var nx_shadowColor: UIColor? {
    return .clear
}
```

#### 实现系统导航栏模糊效果

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/NXNavigationExtensionDemo/UIKit/Basic/ViewController04_LikeSystemNavigationBar.swift)

```swift
override var nx_navigationBarBackgroundColor: UIColor? {
    return .clear
}

override var nx_useBlurNavigationBar: Bool {
    return true
}
```

#### 设置导航栏底部阴影颜色

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/NXNavigationExtensionDemo/UIKit/Basic/ViewController05_ShadowColor.swift)

```swift
override var nx_shadowColor: UIColor? {
    return .red
}
```

#### 设置导航栏底部阴影图片

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/NXNavigationExtensionDemo/UIKit/Basic/ViewController06_ShadowImage.swift)

```swift
override var nx_shadowImage: UIImage? {
    return UIImage(named: "NavigationBarShadowImage")
}
```

#### 自定义返回按钮图片

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/NXNavigationExtensionDemo/UIKit/Basic/ViewController07_CustomBackImage.swift)

```swift
override var nx_backImage: UIImage? {
    return UIImage(named: "NavigationBarBack")
}
```

#### 自定义返回按钮

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/NXNavigationExtensionDemo/UIKit/Basic/ViewController08_CustomBackView.swift)

```swift
override var nx_backButtonCustomView: UIView? {
    return backButton
}
```

---

## 🍺 高级功能

#### 禁用右滑手势返回

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/NXNavigationExtensionDemo/UIKit/Advanced/ViewController01_EdgePopGestureDisable.swift)

```swift
func nx_navigationTransition(_ transitionViewController: UIViewController, navigationBackAction action: NXNavigationBackAction) -> Bool {
    if case .interactionGesture = action {
        return false
    }
    return true
}
```

#### 启用全屏右滑手势返回

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/NXNavigationExtensionDemo/UIKit/Advanced/ViewController02_FullScreenPopGestureEnable.swift)

- 局部有效（在所处页面设置）

```swift
override var nx_enableFullScreenInteractivePopGesture: Bool {
    return true
}
```

- 全局有效

```swift
let configuration = NXNavigationConfiguration.default
configuration.viewControllerPreferences.enableFullScreenInteractivePopGesture = true
```

#### 设置导航栏隐藏（并不是真的隐藏，只是看起来隐藏了，整个导航栏区域不能处理用户交互）

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/NXNavigationExtensionDemo/UIKit/Advanced/ViewController05_NavigationBarDisable.swift)

```swift
// 此操作会将导航栏的背景设置为透明、导航栏所在区域的底部能够接收到点击事件、返回按钮也将不存在。
// “隐藏”导航栏时不要添加 UINavigationBar 的 barButtonItem(s)，这样就可以看起来真的像导航栏隐藏了。
// 不隐藏系统导航栏的原因是：可以让整个导航栏的过渡更加平滑自然，当然也不推荐除此之外任何隐藏系统导航栏的方式。
override var nx_translucentNavigationBar: Bool {
    return true
}
```

#### 禁用**系统**导航栏用户交互（NXNavigationBar 可以处理用户交互）

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/NXNavigationExtensionDemo/UIKit/Advanced/ViewController08_ScrollChangeNavigationBar.swift)

```swift
override var systemNavigationBarUserInteractionDisabled: Bool {
    return true
}
```

#### 更新导航栏样式

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/NXNavigationExtensionDemo/UIKit/Advanced/ViewController07_UpdateNavigationBar.swift)

```swift
nx_setNeedsNavigationBarAppearanceUpdate()
```

如果**状态栏**样式没有发生变化，请检查是否需要调用方法 `setNeedsStatusBarAppearanceUpdate()`，或者在 `UINavigationController` 的子类中设置如下代码：

```swift
override var childForStatusBarStyle: UIViewController? {
    return topViewController
}

override var childForStatusBarHidden: UIViewController? {
    return topViewController
}
```

#### 导航栏返回事件拦截

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/NXNavigationExtensionDemo/UIKit/Advanced/ViewController03_BackButtonEventIntercept.swift)

需要遵守协议 `<NXNavigationTransitionDelegate>`，实现代理方法：

1. `NXNavigationBackActionCallingNXPopMethod`: 调用 `nx_pop` 系列方法返回事件拦截。
2. `NXNavigationBackActionClickBackButton`: 点击返回按钮返回事件拦截。
3. `NXNavigationBackActionClickBackButtonMenu`: 长按返回按钮选择菜单返回事件拦截。
4. `NXNavigationBackActionInteractionGesture`: 使用手势交互返回事件拦截。

```swift
func nx_navigationTransition(_ transitionViewController: UIViewController, navigationBackAction action: NXNavigationBackAction) -> Bool {
    switch action {
    case .clickBackButton:
        // Do something
        return false
    case .clickBackButtonMenu:
        // Do something
        return false
    case .interactionGesture:
        // Do something
        return false
    case .callingNXPopMethod:
        // Do something
        return false
    default:
        // Continue back
        return true
    }
}
```

自定义返回按钮事件需要拦截可以调用 `nx_popViewControllerAnimated:`、`nx_popToViewController:animated:` 或 `nx_popToRootViewControllerAnimated:` 等方法来触发上面的代理回调。

#### 支持视图控制器转场状态

需要遵守协议 `<NXNavigationTransitionDelegate>`，实现代理方法：

```swift
func nx_navigationTransition(_ transitionViewController: UIViewController, navigationTransitionState state: NXNavigationTransitionState) {
    switch state {
    case .unspecified: print("Unspecified")
    case .willPush: print("WillPush")
    case .didPush: print("DidPush")
    case .pushCancelled: print("PushCancelled")
    case .pushCompleted: print("PushCompleted")
    case .willPop: print("WillPop")
    case .didPop: print("DidPop")
    case .popCancelled: print("PopCancelled")
    case .popCompleted: print("PopCompleted")
    case .willSet: print("WillSet")
    case .didSet: print("DidSet")
    case .setCancelled: print("SetCancelled")
    case .setCompleted: print("SetCompleted")
    default: print("None")
    }
}
```

#### 长按返回按钮显示菜单功能

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/NXNavigationExtensionDemo/UIKit/Advanced/ViewController03_BackButtonEventIntercept.swift)

```swift
override var nx_useSystemBackButton: Bool {
    return true
}
```

![BackButtonMenu](https://raw.githubusercontent.com/l1Dan/NXNavigationExtension/main/Snapshots/BackButtonMenu.png)


## ⭐️ 参考链接

- [QMUI_iOS](https://github.com/Tencent/QMUI_iOS)
- [FDFullscreenPopGesture](https://github.com/forkingdog/FDFullscreenPopGesture)

## 📄 协议

NXNavigationExtension 框架是在 MIT 许可下发布的。详情请参见 [LICENSE](https://github.com/l1Dan/NXNavigationExtension/blob/main/LICENSE)。
