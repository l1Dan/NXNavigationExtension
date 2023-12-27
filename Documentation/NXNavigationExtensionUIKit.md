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

### 修改返回按钮箭头颜色

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/Shared/UIKit/Advanced/ViewController07_UpdateNavigationBar.swift)

```swift
override var nx_barTintColor: UIColor? {
    return isDarkMode ? .white : .black
}
```

## 修改系统返回按钮文字

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/Shared/UIKit/Advanced/ViewController07_UpdateNavigationBar.swift)

```swift
// 需要设置使用系统返回按钮，这样才会有效果
override var nx_useSystemBackButton: Bool {
    return true
}

override var nx_systemBackButtonTitle: String? {
    return backButtonTitle
}
```

## 修改导航栏标题颜色

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/Shared/UIKit/Advanced/ViewController07_UpdateNavigationBar.swift)

```swift
override var nx_titleTextAttributes: [NSAttributedString.Key : Any]? {
    return [NSAttributedString.Key.foregroundColor: nx_barTintColor ?? (isDarkMode ? .white : .black)]
}
```

#### 修改导航栏背景颜色

**导航栏背景颜色默认使用系统蓝色 `UIColor.systemBlue`，这样处理能够快速辨别框架是否生效，也可以使用以下方式进行重写：**

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/Shared/UIKit/Basic/ViewController01_BackgroundColor.swift)

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

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/Shared/UIKit/Basic/ViewController02_BackgroundImage.swift)

```swift
override var nx_navigationBarBackgroundImage: UIImage? {
    return UIImage.navigationBarBackground
}
```

#### 设置导航栏透明

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/Shared/UIKit/Basic/ViewController03_Transparent.swift)

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

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/Shared/UIKit/Basic/ViewController04_LikeSystemNavigationBar.swift)

```swift
override var nx_navigationBarBackgroundColor: UIColor? {
    return .clear
}

override var nx_useBlurNavigationBar: Bool {
    return true
}
```

### 设置导航栏底部阴影颜色

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/Shared/UIKit/Basic/ViewController05_ShadowColor.swift)

```swift
override var nx_shadowColor: UIColor? {
    return .red
}
```

### 设置导航栏底部阴影图片

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/Shared/UIKit/Basic/ViewController06_ShadowImage.swift)

```swift
override var nx_shadowImage: UIImage? {
    return UIImage(named: "NavigationBarShadowImage")
}
```

### 自定义返回按钮图片

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/Shared/UIKit/Basic/ViewController07_CustomBackImage.swift)

```swift
override var nx_backImage: UIImage? {
    return UIImage(named: "NavigationBarBack")
}
```

### 自定义返回按钮

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/Shared/UIKit/Basic/ViewController08_CustomBackView.swift)

```swift
override var nx_backButtonCustomView: UIView? {
    return backButton
}
```

---

## 🍺 高级功能

#### 禁用滑动返回手势

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/Shared/UIKit/Advanced/ViewController01_EdgePopGestureDisable.swift)

```swift
override var nx_disableInteractivePopGesture: Bool {
    return true
}
```

#### 启用全屏滑动返回手势

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/Shared/UIKit/Advanced/ViewController02_FullScreenPopGestureEnable.swift)

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

### 设置导航栏隐藏（并不是真的隐藏，只是看起来隐藏了，整个导航栏区域不能处理用户交互）

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/Shared/UIKit/Advanced/ViewController05_NavigationBarDisable.swift)

```swift
// 此操作会将导航栏的背景设置为透明、导航栏所在区域的底部能够接收到点击事件、返回按钮也将不存在。
// “隐藏”导航栏时不要添加 UINavigationBar 的 barButtonItem(s)，这样就可以看起来真的像导航栏隐藏了。
// 不隐藏系统导航栏的原因是：可以让整个导航栏的过渡更加平滑自然，当然也不推荐除此之外任何隐藏系统导航栏的方式。
override var nx_translucentNavigationBar: Bool {
    return true
}
```

### 禁用**系统**导航栏用户交互（NXNavigationBar 可以处理用户交互）

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/Shared/UIKit/Advanced/ViewController09_ScrollChangeNavigationBar.swift)

```swift
override var systemNavigationBarUserInteractionDisabled: Bool {
    return true
}
```

### 更新导航栏样式

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/Shared/UIKit/Advanced/ViewController07_UpdateNavigationBar.swift)

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

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/Shared/UIKit/Advanced/ViewController03_BackButtonEventIntercept.swift)

需要遵守协议 `<NXNavigationTransitionDelegate>`，实现代理方法：

1. `NXNavigationBackActionCallingNXPopMethod`: 调用 `nx_pop` 系列方法返回事件拦截。
2. `NXNavigationBackActionClickBackButton`: 点击返回按钮返回事件拦截。
3. `NXNavigationBackActionClickBackButtonMenu`: 长按返回按钮选择菜单返回事件拦截。
4. `NXNavigationBackActionInteractionGesture`: 使用手势交互返回事件拦截。

```swift
func nx_navigationController(_ navigationController: UINavigationController, transitionViewController viewController: UIViewController, navigationBackAction action: NXNavigationBackAction) -> Bool {
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

### 支持视图控制器转场状态

需要遵守协议 `<NXNavigationTransitionDelegate>`，实现代理方法：

```swift
func nx_navigationController(_ navigationController: UINavigationController, transitionViewController viewController: UIViewController, navigationTransitionState state: NXNavigationTransitionState) {
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

### 长按返回按钮显示菜单功能

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/Shared/UIKit/Advanced/ViewController03_BackButtonEventIntercept.swift)

```swift
override var nx_useSystemBackButton: Bool {
    return true
}
```

![BackButtonMenu](https://raw.githubusercontent.com/l1Dan/NXNavigationExtension/main/Snapshots/BackButtonMenu.png)
