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

OR

当然也可以同时注册多个导航控制器

```swift
NXNavigationConfiguration().registerNavigationControllerClasses([YourNavigationController.self, YourNavigationController2.self])
```

OR

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
- 👉 使用 `NXNavigationExtension` 之前需要先注册导航控制器，注册之后对导航栏的修改才会生效，也仅限于修改已经注册的导航控制器以及子类所管理的视图控制器，~~对于子类导航控制器所管理的视图控制器是不会生效的~~。*3.4.9*及以后的版本已经可以。
- 👉 为了有效避免框架污染到其他的导航控制器，请保持“谁使用，谁注册”的原则。
- 🚫 不要直接注册 `UINavigationController`，会影响全局导航栏的外观，建议创建一个 `UINavigationController` 的子类，对这个子类进行外观的设置。
- 🚫 不要使用 `setNavigationBarHidden:`、`setNavigationBarHidden:animated`、`setHidden:` 等方法显示或隐藏系统导航栏。
- 🚫 不要使用系统导航栏修改透明度。
- 🚫 不要使用系统导航栏或导航控制器 `appearance` 相关属性修改。
- 🚫 不要使用全局 `edgesForExtendedLayout` 修改。
- 🚫 不要使用 `<UIGestureRecognizerDelegate>` 相关方法禁用手势返回。
- 💉 一句话“不要直接操作导航栏或者导航控制器，把这些都交给 `NXNavigationExtension` 处理吧“。

建议：除非你非常明白修改全局性东西的后果，否则不要修改，这么做的原因就是为了减少走一些弯路！

## 🍻 基本功能

### 修改返回按钮箭头颜色

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Shared/UIKit/Advanced/ViewController07_UpdateNavigationBar.swift)

```swift
override var nx_barTintColor: UIColor? {
    return isDarkMode ? .white : .black
}
```

## 修改系统返回按钮文字

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Shared/UIKit/Advanced/ViewController07_UpdateNavigationBar.swift)

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

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Shared/UIKit/Advanced/ViewController07_UpdateNavigationBar.swift)

```swift
override var nx_titleTextAttributes: [NSAttributedString.Key : Any]? {
    return [NSAttributedString.Key.foregroundColor: nx_barTintColor ?? (isDarkMode ? .white : .black)]
}
```

#### 修改导航栏背景颜色

**导航栏背景颜色默认使用系统蓝色 `UIColor.systemBlue`，这样处理能够快速辨别框架是否生效，也可以使用以下方式进行重写：**

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Shared/UIKit/Basic/ViewController01_BackgroundColor.swift)

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

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Shared/UIKit/Basic/ViewController02_BackgroundImage.swift)

```swift
override var nx_navigationBarBackgroundImage: UIImage? {
    return UIImage.navigationBarBackground
}
```

#### 设置导航栏透明

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Shared/UIKit/Basic/ViewController03_Transparent.swift)

```swift
override var nx_navigationBarBackgroundColor: UIColor? {
    return .clear
}

// 设置导航栏底部颜色
override var nx_shadowImageTintColor: UIColor? {
    return .clear
}
```

#### 实现系统导航栏模糊效果

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Shared/UIKit/Basic/ViewController04_LikeSystemNavigationBar.swift)

```swift
override var nx_navigationBarBackgroundColor: UIColor? {
    return .clear
}

override var nx_useBlurNavigationBar: Bool {
    return true
}
```

### 修改导航栏底部线条颜色

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Shared/UIKit/Basic/ViewController05_ShadowColor.swift)

```swift
override var nx_shadowImageTintColor: UIColor? {
    return .red
}
```

### 修改导航栏底部线条图片

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Shared/UIKit/Basic/ViewController06_ShadowImage.swift)

```swift
override var nx_shadowImage: UIImage? {
    return UIImage(named: "NavigationBarShadowImage")
}
```

### 自定义返回按钮图片

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Shared/UIKit/Basic/ViewController07_CustomBackImage.swift)

```swift
override var nx_backImage: UIImage? {
    return UIImage(named: "NavigationBarBack")
}
```

### 自定义返回按钮

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Shared/UIKit/Basic/ViewController08_CustomBackView.swift)

```swift
override var nx_backButtonCustomView: UIView? {
    return backButton
}
```

---

## 🍺 高级功能

#### 禁用滑动返回手势

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Shared/UIKit/Advanced/ViewController01_EdgePopGestureDisable.swift)

```swift
override var nx_disableInteractivePopGesture: Bool {
    return true
}
```

#### 启用全屏滑动返回手势

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Shared/UIKit/Advanced/ViewController02_FullScreenPopGestureEnable.swift)

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

#### 导航栏返回事件拦截

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Shared/UIKit/Advanced/ViewController03_BackButtonEventIntercept.swift)

需要遵守协议 `<NXNavigationInteractable>`，实现代理方法：

```swift
func nx_navigationController(_ navigationController: UINavigationController, willPop viewController: UIViewController, interactiveType: NXNavigationInteractiveType) -> Bool {
    // TODO...
    return true
}
```

1. `NXNavigationInteractiveTypeCallNXPopMethod`: 调用 `nx_pop` 系列方法返回事件拦截。
2. `NXNavigationInteractiveTypeBackButtonAction`: 点击返回按钮返回事件拦截。
3. `NXNavigationInteractiveTypeBackButtonMenuAction`: 长按返回按钮选择菜单返回事件拦截。
4. `NXNavigationInteractiveTypePopGestureRecognizer`: 使用手势交互返回事件拦截。

```swift
func nx_navigationController(_ navigationController: UINavigationController, willPop viewController: UIViewController, interactiveType: NXNavigationInteractiveType) -> Bool {
    print("interactiveType: \(interactiveType), viewController: \(viewController)")

    if selectedItemType == .backButtonAction && interactiveType == .backButtonAction ||
        selectedItemType == .backButtonMenuAction && interactiveType == .backButtonMenuAction ||
        selectedItemType == .popGestureRecognizer && interactiveType == .popGestureRecognizer ||
        selectedItemType == .callNXPopMethod && interactiveType == .callNXPopMethod ||
        selectedItemType == .all {
        showAlertController(in: viewController)
        return false
    }

    return true
}
```

自定义返回按钮事件需要拦截可以调用 `nx_popViewControllerAnimated:`、`nx_popToViewController:animated:` 或 `nx_popToRootViewControllerAnimated:` 等方法来触发上面的代理回调。

### 重定向任一控制器跳转

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Shared/UIKit/Advanced/ViewController08_RedirectViewController.swift)

- 以重定向到 `ViewController08_RedirectViewController` 为例，如果之前有 Push 过 `ViewController08_RedirectViewController` 的实例，则最后会跳转到实例中，如果没有则会调用 `block`，如果 `block == nil` 或者 `return nil;` 则重定向跳转不会发生。
- 执行重定向操作之后，并不会直接跳转到对应的视图控制器，如果需要 `跳转` 操作，可以调用 `popViewControllerAnimated:` 方法返回页面，也可以使用手势滑动返回页面，还可以点击返回按钮返回页面。

```swift
navigationController?.nx_redirectViewControllerClass(ViewController08_RedirectViewController.self, initializeStandbyViewControllerUsing: {
    return ViewController08_RedirectViewController()
})
```

**注意**：
执行上面代码之后并不会立即跳转，下面代码可以实现立即跳转：

```swift
navigationController?.nx_redirectViewControllerClass(ViewController08_RedirectViewController.self, initializeStandbyViewControllerUsing: {
    return ViewController08_RedirectViewController()
})
navigationController?.popViewController(animated: true)
```

意思是：首先查找 `navigationController?.viewControllers` 是否存在一个类型为 `ViewController08_RedirectViewController.self` 的实例对象，如果存在则重定向到此视图控制器，没有则使用 `ViewController08_RedirectViewController()` 来创建一个新的实例对象。

### 导航栏点击事件穿透到底部

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Shared/UIKit/Advanced/ViewController05_NavigationBarDisable.swift)

```swift
override var nx_translucentNavigationBar: Bool {
    return true
}
```

### 动态修改导航栏样式

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Shared/UIKit/Advanced/ViewController09_ScrollChangeNavigationBar.swift)

```swift
override var nx_contentViewWithoutNavigationBar: Bool {
    return true
}
```

可以动态调整 contentView 透明度实现：`nx_navigationBar?.alpha = value`

### 更新导航栏样式

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Shared/UIKit/Advanced/ViewController07_UpdateNavigationBar.swift)

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

### 长按返回按钮显示菜单功能

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Shared/UIKit/Advanced/ViewController08_RedirectViewController.swift)

```swift
override var nx_useSystemBackButton: Bool {
    return true
}
```

![BackButtonMenu](https://raw.githubusercontent.com/l1Dan/NXNavigationExtension/main/Snapshots/BackButtonMenu.png)
