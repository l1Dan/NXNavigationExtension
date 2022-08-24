<p align="center" >
  <img src="https://raw.githubusercontent.com/l1Dan/NXNavigationExtension/main/Snapshots/Slogan.png" alt="NXNavigationExtension" title="NXNavigationExtension">
</p>

[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/NXNavigationExtension.svg?style=flat)](https://img.shields.io/cocoapods/v/NXNavigationExtension.svg) ![Language](https://img.shields.io/github/languages/top/l1dan/NXNavigationExtension.svg?style=flat) [![MIT License](https://img.shields.io/github/license/l1dan/NXNavigationExtension.svg?style=flat)](https://opensource.org/licenses/mit-license.php) [![Platform](https://img.shields.io/cocoapods/p/NXNavigationExtension.svg?style=flat)](https://github.com/l1Dan/NXNavigationExtension/blob/main/README.md) [![GitHub last commit](https://img.shields.io/github/last-commit/l1Dan/NXNavigationExtension.svg?style=flat)](https://img.shields.io/github/last-commit/l1Dan/NXNavigationExtension)

🔥 NXNavigationExtension 是为 UINavigationBar 设计的轻量级的、简单的、可扩展的库，支持 SwiftUI 和 UIKit。框架对现有代码入侵非常小，只需要简单的几个方法调用就可以满足大部分的应用场景。可能是最省心的 iOS 导航栏处理框架之一。NXNavigationExtension 框架本身和示例代码都已经适配暗黑模式可供大家参考。

## 🎉 预览

[1]: https://raw.githubusercontent.com/l1Dan/NXNavigationExtension/main/Snapshots/Preview1.gif
[2]: https://raw.githubusercontent.com/l1Dan/NXNavigationExtension/main/Snapshots/Preview2.gif
[3]: https://raw.githubusercontent.com/l1Dan/NXNavigationExtension/main/Snapshots/Preview3.gif
[4]: https://raw.githubusercontent.com/l1Dan/NXNavigationExtension/main/Snapshots/Preview4.gif

| SwiftUI 路由 | 完全自定义导航栏 | 返回事件拦截 | 修改导航栏外观 |
| :----------: | :--------------: | :----------: | :------------: |
|    ![][1]    |      ![][2]      |    ![][3]    |     ![][4]     |

## 🌈 要求

| Version | Minimum iOS / macOS Target |         Frameworks          |         Note         |
| :-----: | :------------------------: | :-------------------------: | :------------------: |
|   4.x   |   iOS 9.0 / macOS 10.15    | SwiftUI、UIKit、macCatalyst | Xcode13、SwiftUI 2.0 |
|   3.x   |   iOS 9.0 / macOS 10.15    |     UIKit、macCatalyst      |          /           |
|   2.x   |   iOS 11.0 / macOS 10.15   |     UIKit、macCatalyst      |          /           |

## 🍭 优点

- API 设计通俗易懂，容易上手。
- 没有继承关系，所有操作基于分类实现，低耦合。
- 白名单模式：按需注册所使用的导航控制器，这样才不会影响所有的导航控制器外观。
- 没有对原生导航栏视图层级进行修改，无需担心系统升级的兼容性问题。
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

- ✅` 禁用滑动返回手势`
- ✅` 启用全屏滑动返回手势`
- ✅` 导航栏返回事件拦截`
- ✅` 支持视图控制器转场周期事件`
- ✅` 任一视图控制器跳转`
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

### 使用 Carthage 管理

使用 [Carthage](https://github.com/Carthage/Carthage) 管理 NXNavigationExtension framework，请将以下内容添加到您的 `Cartfile` 文件中：

```yaml
# For SwiftUI
github "l1Dan/NXNavigationExtension" # Requires
github "l1Dan/NXNavigationExtensionSwiftUI"

# For UIKit
github "l1Dan/NXNavigationExtension"

```

### 使用 Swift Package Manager 集成

使用 [Swift Package Manager](https://swift.org/package-manager/) 集成 NXNavigationExtension，请将以下内容添加到您的 `Package.swift` 文件的依赖中：

```swift
dependencies: [
    .package(url: "https://github.com/l1Dan/NXNavigationExtension.git", .upToNextMajor(from: "4.1.2"))
]
```

## 📖 使用教程

- 阅读 [**SwiftUI Guide**](https://github.com/l1Dan/NXNavigationExtension/blob/main/Documentation/NXNavigationExtensionSwiftUI.md) 文档。
- 阅读 [**UIKit Guide**](https://github.com/l1Dan/NXNavigationExtension/blob/main/Documentation/NXNavigationExtensionUIKit.md) 文档。

## ❤️ 感谢 [JetBrains](https://jb.gg/OpenSourceSupport) 对开源项目的支持

<p align="left" >
  <img src="https://resources.jetbrains.com/storage/products/company/brand/logos/jb_beam.svg" alt="jb_beam" title="jb_beam" width="200px">
</p>

## 🔍 FAQ 常见问题

Q：iOS14 及之后的版本为什么注册了 `UIImagePickerController`、`PHPickerViewController` 类之后还是无法修改导航栏的外观？

A：因为 `UIImagePickerController` 和 `PHPickerViewController` 里面的 UINavigationBar 是隐藏的，NXNavigationBar 会跟随系统导航栏隐藏与显示，所以无法修改（**iOS14 之前系统的 `UIImagePickerController` 是可以修改的**）。另外 PHPickerViewController 其实是一个 UIViewController 的子类，你既可以用 `push` 的方式显示控制器也可以用 `present` 的方式显示控制器，他们有个共同特点：使用的都是一个 “假” 的导航栏。

---

Q：为什么 iOS13 之前使用 `self.navigationItem.searchController` 设置的 `UISearchBar` 无法跟随导航栏的变化而变化，iOS13 之后的却可以呢？

A：因为在 iOS13 之前导航栏中不包含 `UISearchBar`，iOS13 之后导航栏才包含 `UISearchBar` 的。具体使用请参考[示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/Shared/UIKit/Feature/FeatureTableViewController.swift)。

---

Q：如何解决 `UIScrollView` 和 `UIPageViewController` 全屏手势冲突?

A：使用 [UIScrollView](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/Shared/UIKit/Feature/FullPopGesture_ScrollView.swift) 和 [UIPageViewController](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/Shared/UIKit/Feature/FullPopGesture_PageViewController.swift) 全屏手势冲突解决方案。

---

Q：为什么 `NXNavigationExtension` 框架不包含控制器的转场动画功能？

A：原则就是尽可能的保持框架的简单轻量，将更多的精力花在框架本身的稳定性上，尽可能地使用系统原有功能。转场动画功能并不适用于所有业务场景，另外也不属于这个框架的功能。如果有转场动画的需求需要开发者自己实现，也可以参考[VCTransitionsLibrary](https://github.com/ColinEberhardt/VCTransitionsLibrary)，或者参考[示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/Shared/UIKit/Feature/Drawer/DrawerViewController.swift)。

---

Q：为什么导航栏的系统返回按钮箭头和自定义返回按钮箭头的位置不一致？

A：因为导航栏的系统返回按钮是用 `self.navigationItem.backBarButtonItem` 属性来设置的。而自定义返回按钮是用 `self.navigationItem.leftBarButtonItem` 属性来设置的，他们的位置本来就不一样。当然你可以使用系统返回按钮，通过 `(nx_)useSystemBackButton` 属性设置是否使用系统返回按钮，再配合 `(nx_)systemBackButtonTitle` 属性设置系统返回按钮的标题。还可以通过 `(nx_)backImageInsets` 或者 `(nx_)landscapeBackImageInsets` 属性来控制自定义返回按钮图片的偏移量。

- 返回按钮箭头在切图里尽量靠左而不要居中，右边可以保留透明背景。
- 使用 `nx_backButtonCustomView` 属性自定义返回按钮时就需要开发者自己来修正箭头的偏移量了。

## 🙋 已知问题

1. 在 UIViewController 中设置 `edgesForExtendedLayout = UIRectEdge(rawValue: 0)` 属性，并且使用 [IQKeyboardManager](https://github.com/hackiftekhar/IQKeyboardManager) 框架的同时键盘没有收起，此时返回上级页面 NXNavigationBar 会出现错位的现象。这是 IQKeyboardManager 框架本身处理这种情况就有问题（设置 `edgesForExtendedLayout = UIRectEdge(rawValue: 0)` 属性，键盘没收起时返回上级页面导致界面下移的问题），NXNavigationExtension 框架内部无法处理这种情况（其实已经最大程度适配 IQKeyboardManager 框架）。解决方法：

- 不使用 IQKeyboardManager 框架（或者在使用的 UIViewController 中暂时禁用 IQKeyboardManager 框架）。
- 不使用 `edgesForExtendedLayout = UIRectEdge(rawValue: 0)` 属性。
- 在 UIViewController 中不使用 UITextField/UITextView 等需要弹出键盘的控件。

---

2. 在 UIViewController 中设置 `edgesForExtendedLayout = UIRectEdge(rawValue: 0)` 属性，并且使用 NXNavigationBar 本身或者 `contentView` 中添加需要用户交互的控件时，里面添加的控件将无法接受到用户事件的响应（控件展示没有问题），但是添加没有用户交互事件的控件是不受限制的，比如在 [ViewController04_CustomNavigationBar](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/Shared/UIKit/Advanced/ViewController04_CustomNavigationBar.swift) 中设置 `edgesForExtendedLayout = UIRectEdge(rawValue: 0)` 属性时，NXNavigationBar 上面的按钮将无法点击。解决方法：

- 不要在 NXNavigationBar 本身或者 `contentView` 中添加需要用户交互的控件。
- 不使用 `edgesForExtendedLayout = UIRectEdge(rawValue: 0)` 属性。

---

## ⭐️ 参考链接

- [QMUI_iOS](https://github.com/Tencent/QMUI_iOS)
- [FDFullscreenPopGesture](https://github.com/forkingdog/FDFullscreenPopGesture)

## 📄 协议

NXNavigationExtension 框架是在 MIT 许可下发布的。详情请参见 [LICENSE](https://github.com/l1Dan/NXNavigationExtension/blob/main/LICENSE)。
