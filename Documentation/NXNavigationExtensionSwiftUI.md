## 🍽 使用

`NXNavigationExtensionSwiftUI` 由 [NXNavigationExtension](https://github.com/l1Dan/NXNavigationExtension/blob/main/Documentation/NXNavigationExtensionUIKit.md) 框架提供强力支持，两者功能基本保持一致。目前仅对 iOS 14 及以上系统的 SwiftUI 进行支持，参考如下：

| NavigationView  | iOS 14 | iOS 15 | iOS 16 | iOS 17 |
| :-------------: | :----: | :----: | :----: | :----: |
|   .automatic    |   ❌    |   ❌    |   ❌    |   ❌    |
|    .columns     |   ❌    |   ❌    |   ❌    |   ❌    |
|     .stack      |   ✅    |   ✅    |   ✅    |   ✅    |
| NavigationStack |   ❌    |   ❌    |   ✅    |   ✅    |

1. 💉 导入模块。

   - 使用 `CocoaPods` 集成：`import NXNavigationExtension`
   - 使用 `Carthage` 管理：`import NXNavigationExtensionSwiftUI`

2. 💉 使用之前需要先在 `AppDelegate` 中注册需要修改的导航控制器。

✅ 推荐

在 `UIKit` 版本中其实只需要 `NXNavigationConfiguration().registerNavigationControllerClasses([YourNavigationController.self])` 这一行代码就完成导航控制器的注册了。但是在 `SwiftUI` 版本中还需要一个额外的步骤：指定 `NXNavigationVirtualWrapperView` 的查找规则，他是 SwiftUI 与 UIKit 之间的桥梁。查找规则开发者可以自定义，也可以使用框架提供的默认查找规则。

```swift
// AppDelegate.swift
var classes: [AnyClass] = []
    if #available(iOS 15.0, *) {
        classes = [
            NSClassFromString("SwiftUI.SplitViewNavigationController"),
            NSClassFromString("SwiftUI.UIKitNavigationController"),
        ].compactMap { $0 }
    } else {
        classes = [
            NSClassFromString("SwiftUI.SplitViewNavigationController"), // iOS14
        ].compactMap { $0 }
    }

    let defaultConfiguration = NXNavigationConfiguration.default
    defaultConfiguration.registerNavigationControllerClasses(classes) { navigationController, configuration in
        // Configure
        navigationController.nx_applyFilterNavigationVirtualWrapperViewRuleCallback(NXNavigationVirtualView.configureWithDefaultRule(for:))
        return configuration
}
```

```swift
// Example: ContentView.swift
import SwiftUI
import NXNavigationExtension

struct DestinationView: View {
    @State private var context: NXNavigationRouter.Context = NXNavigationRouter.Context(routeName: "/destinationView")

    var body: some View {
        Button {
            // NXNavigationRouter.of(context).pop()
            NXNavigationRouter.of(context /* /destinationView */).popUntil("/contentView")
        } label: {
            Text("Pop")
                .padding()
        }
        .useNXNavigationView(context: $context, onPrepareConfiguration: { configuration in
            // `DestinationView` NavigationView backgroundColor
            configuration.navigationBarAppearance.backgroundColor = .red
        })
    }

}

struct ContentView: View {
    @State private var context: NXNavigationRouter.Context = NXNavigationRouter.Context(routeName: "/contentView")

    var body: some View {
        NavigationView {
            NavigationLink { // 1. 使用 NavigationView 包装
                DestinationView()
            } label: {
                Text("Push")
                    .padding()
                    .useNXNavigationView(context: $context /* /contentView */, onPrepareConfiguration: { configuration in
                        // 3. 修改导航栏背景颜色 ... `Text` NavigationView backgroundColor
                        configuration.navigationBarAppearance.backgroundColor = .brown
                    })
            }
        }
        .navigationViewStyle(.stack) // 2. 使用 StackNavigationViewStyle 风格
    }
}
```

## 🍻 基本功能

#### 修改返回按钮箭头颜色

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/NXNavigationExtensionSwiftUIDemo/SwiftUI/Advanced/View07_UpdateNavigationBar.swift)

```swift
Text("Destination")
    .useNXNavigationView(onPrepareConfiguration: { configuration in
        configuration.navigationBarAppearance.tintColor = .red
    })
```

#### 修改系统返回按钮文字

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/NXNavigationExtensionSwiftUIDemo/SwiftUI/Advanced/View07_UpdateNavigationBar.swift)

```swift
Text("Destination")
    .useNXNavigationView(onPrepareConfiguration: { configuration in
        configuration.navigationBarAppearance.useSystemBackButton = true
        configuration.navigationBarAppearance.systemBackButtonTitle = title
    })
```

#### 修改导航栏标题颜色

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/NXNavigationExtensionSwiftUIDemo/SwiftUI/Advanced/View07_UpdateNavigationBar.swift)

```swift
Text("Destination")
    .useNXNavigationView(onPrepareConfiguration: { configuration in
        configuration.navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    })
```

#### 修改导航栏背景颜色

**导航栏背景颜色默认使用系统蓝色 `UIColor.systemBlue`，这样处理能够快速辨别框架是否生效，也可以使用以下方式进行重写：**

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/NXNavigationExtensionSwiftUIDemo/SwiftUI/Basic/View01_BackgroundColor.swift)

```swift
// 全局统一修改
let configuration = NXNavigationConfiguration.default
configuration.navigationBarAppearance.backgroundColor = .red

// 基于视图控制器修改
Text("Destination")
    .useNXNavigationView(onPrepareConfiguration: { configuration in
        configuration.navigationBarAppearance.backgroundColor = .red
    })
```

#### 修改导航栏背景图片

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/NXNavigationExtensionSwiftUIDemo/SwiftUI/Basic/View02_BackgrounddImage.swift)

```swift
Text("Destination")
    .useNXNavigationView(onPrepareConfiguration: { configuration in
        configuration.navigationBarAppearance.backgroundImage = UIImage(named: "NavigationBarBackground88")
    })
```

#### 设置导航栏透明

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/NXNavigationExtensionSwiftUIDemo/SwiftUI/Basic/View03_Transparent.swift)

```swift
Text("Destination")
    .useNXNavigationView(onPrepareConfiguration: { configuration in
        configuration.navigationBarAppearance.backgroundColor = .clear
        configuration.navigationBarAppearance.shadowColor = .clear
    })
```

#### 实现系统导航栏模糊效果

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/NXNavigationExtensionSwiftUIDemo/SwiftUI/Basic/View04_LikeSystemNavigationBar.swift)

```swift
Text("Destination")
    .useNXNavigationView(onPrepareConfiguration: { configuration in
        configuration.navigationBarAppearance.backgroundColor = .clear
        configuration.viewControllerPreferences.useBlurNavigationBar = true
    })
```

#### 设置导航栏底部阴影颜色

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/NXNavigationExtensionSwiftUIDemo/SwiftUI/Basic/View05_ShadowColor.swift)

```swift
Text("Destination")
    .useNXNavigationView(onPrepareConfiguration: { configuration in
        configuration.navigationBarAppearance.backgroundColor = .systemBackground
        configuration.navigationBarAppearance.shadowColor = .systemRed
    })
```

#### 设置导航栏底部阴影图片

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/NXNavigationExtensionSwiftUIDemo/SwiftUI/Basic/View06_ShadowImage.swift)

```swift
Text("Destination")
    .useNXNavigationView(onPrepareConfiguration: { configuration in
        configuration.navigationBarAppearance.backgroundColor = .systemBackground
        configuration.navigationBarAppearance.shadowImage = UIImage(named: "NavigationBarShadowImage")
    })
```

#### 自定义返回按钮图片

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/NXNavigationExtensionSwiftUIDemo/SwiftUI/Basic/View07_CustomBackImage.swift)

```swift
Text("Destination")
    .useNXNavigationView(onPrepareConfiguration: { configuration in
        configuration.navigationBarAppearance.backImage = UIImage(systemName: "arrow.left")
    })
```

#### 自定义返回按钮

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/NXNavigationExtensionSwiftUIDemo/SwiftUI/Basic/View08_CustomBackView.swift)

```swift
Text("Destination")
    .useNXNavigationView(onPrepareConfiguration: { configuration in
        configuration.navigationBarAppearance.backButtonCustomView = backButton
    })
```

---

## 🍺 高级功能

#### 禁用右滑手势返回

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/NXNavigationExtensionSwiftUIDemo/SwiftUI/Advanced/View01_EdgePopGestureDisable.swift)

```swift
Text("Destination")
    .useNXNavigationView(onBackActionHandler: { action in
        if case .interactionGesture = action {
            return false
        }
        return true
    })
```

#### 启用全屏右滑手势返回

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/NXNavigationExtensionSwiftUIDemo/SwiftUI/Basic/View02_FullScreenPopGestureEnable.swift)

- 全局有效

```swift
let configuration = NXNavigationConfiguration.default
configuration.viewControllerPreferences.enableFullScreenInteractivePopGesture = true
```

- 局部有效（在所处页面设置）

```swift
Text("Destination")
    .useNXNavigationView(onPrepareConfiguration: { configuration in
        configuration.viewControllerPreferences.enableFullScreenInteractivePopGesture = true
    })
```

#### 导航栏返回事件拦截

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/NXNavigationExtensionSwiftUIDemo/SwiftUI/Basic/View03_BackButtonEventIntercept.swift)

1. `.callingNXPopMethod`: 调用 `nx_pop` 系列方法返回事件拦截。
2. `.clickBackButton`: 点击返回按钮返回事件拦截。
3. `.clickBackButtonMenu`: 长按返回按钮选择菜单返回事件拦截。
4. `.interactionGesture`: 使用手势交互返回事件拦截。

```swift
Text("Destination")
    .useNXNavigationView(onBackActionHandler: { action in
        if selectedItemType == .clickBackButton && action == .clickBackButton ||
            selectedItemType == .clickBackButtonMenu && action == .clickBackButtonMenu ||
            selectedItemType == .interactionGesture && action == .interactionGesture ||
            selectedItemType == .callingNXPopMethod && action == .callingNXPopMethod ||
            selectedItemType == .all {
            isPresented = true
            return false
        }
        return true
    })
```

#### SwiftUI 路由

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/NXNavigationExtensionSwiftUIDemo/SwiftUI/Basic/View08_NavigationRouter.swift)

```swift
struct DestinationView: View {
    @State private var context: NXNavigationRouter.Context

    init() {
        context = NXNavigationRouter.Context(routeName: "/currentRouteName")
    }

    var body: some View {
        VStack {
            Button {
                NXNavigationRouter.of(context).pop()
            } label: {
                Text("Pop")
            }
            .useNXNavigationView(context: $context)
        }
    }
}
```

1. 需要注意的是 `NXNavigationRouter.of(context)` 和 `NXNavigationRouter.of(context).nx` 用于调用系统 `pop` 和框架 `nx_pop` 系列方法
2. 使用 `NXNavigationRouter.of(context).nx` 方法退出页面时会触发 `onBackActionHandler` 的回调。

#### 导航栏点击事件穿透到底部

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/NXNavigationExtensionSwiftUIDemo/SwiftUI/Advanced/View05_NavigationBarDisable.swift)

```swift
Text("Destination")
    .useNXNavigationView(onPrepareConfiguration: { configuration in
        configuration.viewControllerPreferences.translucentNavigationBar = true
    })
```

#### 更新导航栏样式

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/NXNavigationExtensionSwiftUIDemo/SwiftUI/Advanced/View07_UpdateNavigationBar.swift)

```swift
Button {
    NXNavigationRouter.of(context).setNeedsNavigationBarAppearanceUpdate()
} label: {
    Text("Update")
}
```

#### 长按返回按钮显示菜单功能

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/NXNavigationExtensionSwiftUIDemo/SwiftUI/Advanced/View08_NavigationRouter.swift)

```swift
Text("Destination")
    .useNXNavigationView(onPrepareConfiguration: { configuration in
        configuration.navigationBarAppearance.useSystemBackButton = true
    })
```

![BackButtonMenu](https://raw.githubusercontent.com/l1Dan/NXNavigationExtension/main/Snapshots/NavigationRouter.png)
