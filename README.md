<p align="center" >
  <img src="https://raw.githubusercontent.com/l1Dan/NXNavigationExtension/master/Snapshots/Slogan.png" alt="NXNavigationExtension" title="NXNavigationExtension">
</p>

[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/NXNavigationExtension.svg?style=flat)](https://img.shields.io/cocoapods/v/NXNavigationExtension.svg) ![Language](https://img.shields.io/github/languages/top/l1dan/NXNavigationExtension.svg?style=flat) [![MIT Licence](https://img.shields.io/github/license/l1dan/NXNavigationExtension.svg?style=flat)](https://opensource.org/licenses/mit-license.php) [![Platform](https://img.shields.io/cocoapods/p/NXNavigationExtension.svg?style=flat)](https://github.com/l1Dan/NXNavigationExtension/blob/master/README.md) [![GitHub last commit](https://img.shields.io/github/last-commit/l1Dan/NXNavigationExtension.svg?style=flat)](https://img.shields.io/github/last-commit/l1Dan/NXNavigationExtension)

🔥 NXNavigationExtension 是为 iOS 应用设计的一个轻量级的导航栏处理框架。框架对现有代码入侵非常小，只需要简单的几个方法调用就可以满足大部分的应用场景。NXNavigationExtension 和 [示例程序代码](https://github.com/l1Dan/NXNavigationExtension/archive/master.zip) 都已经适配暗黑模式（Dark Mode）。

## 🎉 预览

![Preview](https://raw.githubusercontent.com/l1Dan/NXNavigationExtension/master/Snapshots/Preview.png)

## 🌟 开始使用

下载 [NXNavigationExtension](https://github.com/l1Dan/NXNavigationExtension/archive/master.zip) 示例程序代码。

## 使用 CocoaPods 安装

使用 CocoaPods 将 NXNavigationExtension 集成到 Xcode 项目中，需要在 `Podfile` 中指定：

```ruby
pod 'NXNavigationExtension'
```

### 使用 Carthage 安装

[Carthage](https://github.com/Carthage/Carthage) 是一个去中心化的包管理器，它构建依赖项并为您提供二进制框架。 要集成 NXNavigationExtension，请将以下内容添加到您的 `Cartfile` 文件中：

```ogdl
github "l1Dan/NXNavigationExtension"
```

## 🌈 要求

最新版本最低支持 iOS 9.0

| NXNavigationExtension Version | Minimum iOS Target | Minimum macOS Target |       Notes        |
| :---------------------------: | :----------------: | :------------------: | :----------------: |
|              3.x              |      iOS 9.0       |     macOS 10.15      | macOS: macCatalyst |
|              2.x              |       iOS 11       |     macOS 10.15      | macOS: macCatalyst |

## 优点

- API 设计通俗易懂，容易上手。
- 没有继承关系，所有操作基于方法重写，对项目入侵较小。
- 按需注册导航控制器 `UINavigationController` 的外观，这样才不会影响所有的导航控制器。
- 没有对原生导航栏视图层级进行修改，无需担心升级系统兼容性问题。
- 适配 iOS、iPadOS、macOS，Dark Mode。
- 支持 CocoaPods、Carthage、Project 方式集成。

## 👏 功能

特别实用的功能，总有一款适合你的项目

### 基本功能

- ✅` 设置导航栏透明`
- ✅` 实现系统导航栏模糊效果`
- ✅` 自定义返回按钮图片`
- ✅` 自定义返回按钮`
- ✅` 自定义导航栏模糊背景`
- ✅` 修改返回按钮箭头颜色`
- ✅` 修改导航栏标题颜色`
- ✅` 修改导航栏背景颜色`
- ✅` 修改导航栏背景图片`
- ✅` 修改导航栏底部线条颜色`
- ✅` 修改导航栏底部线条图片`

### 高级功能

- ✅` 禁用滑动返回手势`
- ✅` 启用全屏滑动返回手势`
- ✅` 导航栏返回事件拦截`
- ✅` 重定向任一控制器跳转`
- ✅` 导航栏点击事件穿透到底部`
- ✅` 动态修改导航栏样式`
- ✅` 更新导航栏样式`
- ✅` 长按返回按钮显示菜单功能`
- 更多功能请查看示例程序...

## 🍽 使用

所有对导航栏外观的修改都是基于视图控制器 `UIViewController` 修改的，而不是基于导航控制器 `UINavigationController` 修改，这种设计逻辑更加符合实际应用场景。也就是说视图控制器管理自己的导航栏，而不是使用导航控制器来全局管理。

1. 💉 导入头文件 `#import <NXNavigationExtension/NXNavigationExtension.h>`
2. 💉 使用之前需要先注册需要修改的导航控制器，以 `FeatureNavigationController` 和 `OtherNavigationController` 为例：

✅ 推荐

```objc
// 1
NXNavigationConfiguration *configuration = [NXNavigationConfiguration defaultConfiguration];
configuration.navigationBarAppearance.tintColor = [UIColor customTitleColor];
if (@available(iOS 14.0, *)) {
    configuration.navigationControllerPreferences.menuSupplementBackButton = YES;
}
[NXNavigationBar registerNavigationControllerClass:[FeatureNavigationController class] withConfiguration:configuration];

// 2
NXNavigationConfiguration *otherConfiguration = [[NXNavigationConfiguration alloc] init];
otherConfiguration.navigationBarAppearance.backgroundColor = [UIColor redColor];
if (@available(iOS 14.0, *)) {
    otherConfiguration.navigationControllerPreferences.menuSupplementBackButton = YES;
}
[NXNavigationBar registerNavigationControllerClass:[OtherNavigationController class] withConfiguration:otherConfiguration];
```

❌ 不推荐

```objc
NXNavigationConfiguration *configuration = [NXNavigationConfiguration defaultConfiguration];
configuration.navigationBarAppearance.tintColor = [UIColor customTitleColor];
if (@available(iOS 14.0, *)) {
    configuration.navigationControllerPreferences.menuSupplementBackButton = YES;
}
[NXNavigationBar registerNavigationControllerClass:[UINavigationController class] withConfiguration:configuration];

// OR

[NXNavigationBar registerNavigationControllerClass:[UINavigationController class]];
```

**注意**：

- 👉 使用 `NXNavigationExtension` 之前需要先注册导航控制器，注册之后对导航栏的修改才会生效，也仅限于修改已经注册的导航控制器以及子类所管理的视图控制器，~~对于子类导航控制器所管理的视图控制器是不会生效的~~。*3.4.9*及以后的版本已经可以。
- 👉 为了有效避免框架污染到其他的导航控制器，请保持“谁使用，谁注册”的原则。
- 🚫 不要直接注册 `UINavigationController`，会影响全局导航栏的外观，建议创建一个 `UINavigationController` 的子类，对这个子类进行外观的设置。
- 🚫 不要使用 `setNavigationBarHidden:`、`setNavigationBarHidden:animated`、`setHidden:` 等方法显示或隐藏系统导航栏。
- 🚫 不要使用系统导航栏修改透明度。
- 🚫 不要使用系统导航栏或导航控制器 `appearance` 相关属性修改。
- 🚫 ~~不要使用全局 `edgesForExtendedLayout` 修改~~。*3.4.2*及以后的版本已经支持。
- 🚫 不要使用 `<UIGestureRecognizerDelegate>` 相关方法禁用手势返回。
- 💉 一句话“不要直接操作导航栏或者导航控制器，把这些都交给 `NXNavigationExtension` 处理吧“。

建议：除非你非常明白修改全局性东西的后果，否则不要修改，这么做的原因就是为了减少走一些弯路！

## 🍻 基本功能

### 修改返回按钮箭头颜色

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/master/NXNavigationExtensionDemo/Feature/Advanced/Controllers/ViewController07_ScrollChangeNavigationBar.m)

**导航栏返回按钮颜色默认使用系统蓝色 `[UIColor systemBlueColor]`，要改变返回按钮颜色可以使用以下方式配合：**

```objc
// 全局统一修改，不会覆盖基于视图控制器修改
NXNavigationBarAppearance.standardAppearance.tintColor = [UIColor redColor];

// 基于视图控制器修改
- (UIColor *)nx_barTintColor {
    return self.isDarkMode ? [UIColor whiteColor] : [UIColor blackColor];
}
```

## 修改导航栏标题颜色

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/master/NXNavigationExtensionDemo/Feature/Advanced/Controllers/ViewController07_ScrollChangeNavigationBar.m)

```objc
- (NSDictionary<NSAttributedStringKey,id> *)nx_titleTextAttributes {
    return @{NSForegroundColorAttributeName: [self nx_barTintColor]};
}
```

#### 修改导航栏背景颜色

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/master/NXNavigationExtensionDemo/Feature/Basic/Controllers/ViewController01_BackgroundColor.m)

```objc
- (UIColor *)nx_navigationBarBackgroundColor {
    return [UIColor customDarkGrayColor];
}
```

#### 修改导航栏背景图片

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/master/NXNavigationExtensionDemo/Feature/Basic/Controllers/ViewController02_BackgroundImage.m)

```objc
- (UIImage *)nx_navigationBarBackgroundImage {
    return UIImage.navigationBarbackgroundImage;
}
```

#### 设置导航栏透明

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/master/NXNavigationExtensionDemo/Feature/Basic/Controllers/ViewController03_Transparent.m)

```objc
- (UIColor *)nx_navigationBarBackgroundColor {
    return [UIColor clearColor];
}
```

#### 实现系统导航栏模糊效果

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/master/NXNavigationExtensionDemo/Feature/Basic/Controllers/ViewController04_LikeSystemBlurNavigationBar.m)

```objc
- (UIColor *)nx_navigationBarBackgroundColor {
    return [UIColor clearColor];
}

- (BOOL)nx_useBlurNavigationBar {
    return YES;
}
```

### 修改导航栏底部线条颜色

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/master/NXNavigationExtensionDemo/Feature/Basic/Controllers/ViewController05_ShadowColor.m)

```objc
- (UIColor *)nx_shadowImageTintColor {
    return [UIColor redColor];
}
```

### 修改导航栏底部线条颜色图片

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/master/NXNavigationExtensionDemo/Feature/Basic/Controllers/ViewController06_ShadowImage.m)

```objc
- (UIColor *)nx_shadowImageTintColor {
    return [UIColor redColor];
}
```

### 修改导航栏底部线条颜色图片

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/master/NXNavigationExtensionDemo/Feature/Basic/Controllers/ViewController06_ShadowImage.m)

```objc
- (UIImage *)nx_shadowImage {
    return [UIImage imageNamed:@"NavigationBarShadowImage"];
}
```

### 自定义返回按钮图片

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/master/NXNavigationExtensionDemo/Feature/Basic/Controllers/ViewController07_CustomBackButtonImage.m)

```objc
- (UIImage *)nx_backImage {
    return [UIImage imageNamed:@"NavigationBarBack"];
}
```

### 自定义返回按钮

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/master/NXNavigationExtensionDemo/Feature/Basic/Controllers/ViewController08_CustomBackButton.m)

```objc
- (UIView *)nx_backButtonCustomView {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"😋" forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"NavigationBarBack"] forState:UIControlStateNormal];
    [backButton setTitleColor:UIColor.customDarkGrayColor forState:UIControlStateNormal];
    return backButton;
}
```

---

## 🍺 高级功能

#### 禁用滑动返回手势

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/master/NXNavigationExtensionDemo/Feature/Advanced/Controllers/ViewController01_DisablePopGesture.m)

```objc
- (BOOL)nx_disableInteractivePopGesture {
    return YES;
}
```

#### 启用全屏滑动返回手势

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/master/NXNavigationExtensionDemo/Feature/Advanced/Controllers/ViewController02_FullPopGesture.m)

- 局部有效（在所处页面设置）

```objc
- (BOOL)nx_enableFullscreenInteractivePopGesture {
    return YES;
}
```

- 全局有效（在调用`registerNavigationControllerClass:`或`registerNavigationControllerClass:withConfiguration:`方法之前设置）

```objc
[NXNavigationControllerPreferences standardPreferences].fullscreenInteractivePopGestureEnabled = YES;

// OR

NXNavigationConfiguration *configuration = [[NXNavigationConfiguration alloc] init];
configuration.navigationControllerPreferences.fullscreenInteractivePopGestureEnabled = YES;

```

#### 导航栏返回事件拦截

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/master/NXNavigationExtensionDemo/Feature/Advanced/Controllers/ViewController03_BackEventIntercept.m)

需要遵守协议 `<NXNavigationInteractable>`，实现代理方法：

```objc
- (BOOL)nx_navigationController:(__kindof UINavigationController *)navigationController willPopViewController:(__kindof UIViewController *)viewController interactiveType:(NXNavigationInteractiveType)interactiveType {
    // TODO...
    return YES;
}
```

1. `NXNavigationInteractiveTypeCallNXPopMethod`: 调用 `nx_pop` 系列方法返回事件拦截。
2. `NXNavigationInteractiveTypeBackButtonAction`: 点击返回按钮返回事件拦截。
3. `NXNavigationInteractiveTypeBackButtonMenuAction`: 长按返回按钮选择菜单返回事件拦截。
4. `NXNavigationInteractiveTypePopGestureRecognizer`: 使用手势交互返回事件拦截。

```objc
- (BOOL)nx_navigationController:(__kindof UINavigationController *)navigationController willPopViewController:(__kindof UIViewController *)viewController interactiveType:(NXNavigationInteractiveType)interactiveType {
    NSLog(@"interactiveType: %zd %@", interactiveType, viewController);

    if (self.currentItemType == EventInterceptItemTypeBackButtonAction && interactiveType == NXNavigationInteractiveTypeBackButtonAction) {
        [self showAlertControllerWithViewController:viewController];
        return NO;
    }

    if (self.currentItemType == EventInterceptItemTypeBackButtonMenuAction && interactiveType == NXNavigationInteractiveTypeBackButtonMenuAction) {
        [self showAlertControllerWithViewController:viewController];
        return NO;
    }

    if (self.currentItemType == EventInterceptItemTypePopGestureRecognizer && interactiveType == NXNavigationInteractiveTypePopGestureRecognizer) {
        [self showAlertControllerWithViewController:viewController];
        return NO;
    }

    if (self.currentItemType == EventInterceptItemTypeCallNXPopMethod && interactiveType == NXNavigationInteractiveTypeCallNXPopMethod) {
        [self showAlertControllerWithViewController:viewController];
        return NO;
    }

    if (self.currentItemType == EventInterceptItemTypeAll) {
        [self showAlertControllerWithViewController:viewController];
        return NO;
    }

    return YES;
}
```

自定义返回按钮事件需要拦截可以调用 `nx_popViewControllerAnimated:`、`nx_popToViewController:animated:` 或 `nx_popToRootViewControllerAnimated:` 等方法来触发上面的代理回调。

### 重定向任一控制器跳转

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/master/NXNavigationExtensionDemo/Feature/Advanced/Controllers/ViewController04_RedirectViewController.m)

- 以重定向到 `RandomColorViewController` 为例，如果之前有 Push 过 `RandomColorViewController` 的实例，则最后会跳转到实例中，如果没有则会调用 `block`，如果 `block == NULL` 或者 `return nil;` 则重定向跳转不会发生。
- 执行重定向操作之后，并不会直接跳转到对应的视图控制器，如果需要 `跳转` 操作，可以调用 `popViewControllerAnimated:` 方法返回页面，也可以使用手势滑动返回页面，还可以点击返回按钮返回页面。

```objc
[self.navigationController nx_redirectViewControllerClass:[RandomColorViewController class] initializeStandbyViewControllerUsingBlock:^__kindof UIViewController * _Nonnull {
    return [[RandomColorViewController alloc] init];
}];
```

**注意**：
执行上面代码之后并不会立即跳转，下面代码可以实现立即跳转：

```objc
[self.navigationController nx_redirectViewControllerClass:[RandomColorViewController class] initializeStandbyViewControllerUsingBlock:^__kindof UIViewController * _Nonnull {
    return [[RandomColorViewController alloc] init];
}];
[self.navigationController popViewControllerAnimated:YES];
```

上面代码大意为：首先查找 `self.navigationController.ViewConrollers` 是否存在一个类型为 `[RandomColorViewController class]` 的实例对象，如果存在则重定向到此视图控制器，没有则使用 `[[RandomColorViewController alloc] init]` 来创建一个新的 `[RandomColorViewController class]` 的实例对象。

### 导航栏点击事件穿透到底部

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/master/NXNavigationExtensionDemo/Feature/Advanced/Controllers/ViewController06_ClickEventHitToBack.m)

```objc
- (BOOL)nx_translucentNavigationBar {
    return YES;
}
```

### 动态修改导航栏样式

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/master/NXNavigationExtensionDemo/Feature/Advanced/Controllers/ViewController07_ScrollChangeNavigationBar.m)

```objc
- (BOOL)nx_contentViewWithoutNavigtionBar {
    return YES;
}
```

可以动态调整 contentView 透明度实现：`self.nx_navigationBar.contentView.alpha = value`

### 更新导航栏样式

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/master/NXNavigationExtensionDemo/Feature/Common/Controllers/RandomColorViewController.m)

```objc
[self nx_setNeedsNavigationBarAppearanceUpdate];
```

如果**状态栏**样式没有发生变化，请检查是否需要调用方法 `[self setNeedsStatusBarAppearanceUpdate]`，或者在 `UINavigationController` 的子类中设置如下代码：

```objc
- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}
```

### 长按返回按钮显示菜单功能

📝 [示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/master/NXNavigationExtensionDemo/Feature/Advanced/Controllers/ViewController04_RedirectViewController.m)

- 设置 NXNavigationControllerPreferences `menuSupplementBackButton` 属性

```objc
if (@available(iOS 14.0, *)) {
    [NXNavigationControllerPreferences standardPreferences].menuSupplementBackButton = YES;
}

// OR

NXNavigationConfiguration *configuration = [[NXNavigationConfiguration alloc] init];
if (@available(iOS 14.0, *)) {
    configuration.navigationControllerPreferences.menuSupplementBackButton = YES;
}

```

- 还需要在页面内设置

```objc
- (BOOL)nx_backButtonMenuEnabled {
    return YES;
}
```

![BackButtonMenu](https://raw.githubusercontent.com/l1Dan/NXNavigationExtension/master/Snapshots/BackButtonMenu.png)

## 📄 协议

NXNavigationExtension 框架是在 MIT 许可下发布的。详情请参见 [LICE*N*SE](https://github.com/l1Dan/NXNavigationExtension/blob/master/LICENSE)。
