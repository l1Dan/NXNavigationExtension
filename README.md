<p align="center" >
  <img src="https://raw.githubusercontent.com/l1Dan/UINavigationExtension/master/Snapshots/Slogan.png" alt="UINavigationExtension" title="UINavigationExtension">
</p>

[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/UINavigationExtension.svg?style=flat)](https://img.shields.io/cocoapods/v/UINavigationExtension.svg) ![Language](https://img.shields.io/github/languages/top/l1dan/UINavigationExtension.svg?style=flat) [![MIT Licence](https://img.shields.io/github/license/l1dan/UINavigationExtension.svg?style=flat)](https://opensource.org/licenses/mit-license.php) [![Platform](https://img.shields.io/cocoapods/p/UINavigationExtension.svg?style=flat)](https://github.com/l1Dan/UINavigationExtension/blob/master/README.md) [![GitHub last commit](https://img.shields.io/github/last-commit/l1Dan/UINavigationExtension.svg?style=flat)](https://img.shields.io/github/last-commit/l1Dan/UINavigationExtension) 

UINavigationExtension 是为 iOS 应用设计的一个简单、易用的导航栏处理框架。框架对现有代码入侵非常小，只需要简单的几个方法调用就可以满足大部分的应用场景。UINavigationExtension 和 [示例程序代码](https://github.com/l1Dan/UINavigationExtension/archive/master.zip) 都已经适配暗黑模式（Dark Mode）。

## 🎉 [预览](https://raw.githubusercontent.com/l1Dan/UINavigationExtension/master/Snapshots/PreviewLightMode.png) & [暗黑模式](https://raw.githubusercontent.com/l1Dan/UINavigationExtension/master/Snapshots/PreviewDarkMode.png)

![Preview](https://raw.githubusercontent.com/l1Dan/UINavigationExtension/master/Snapshots/PreviewLightMode.png)

## 🌟 开始使用

[下载 UINavigationExtension](https://github.com/l1Dan/UINavigationExtension/archive/master.zip) 示例程序代码。

## 使用 CocoaPods 安装

使用 CocoaPods 将 UINavigationExtension 集成到 Xcode 项目中，需要在 `Podfile` 中指定：

```ruby
pod 'UINavigationExtension'
```
或者
```ruby
pod 'UINavigationExtension', ~> 2.3.11
```

### 使用 Carthage 安装

[Carthage](https://github.com/Carthage/Carthage) 是一个去中心化的包管理器，它构建依赖项并为您提供二进制框架。 要集成 UINavigationExtension，请将以下内容添加到您的 `Cartfile` 文件中：
```ogdl
github "l1Dan/UINavigationExtension"
```
或者
```ogdl
github "l1Dan/UINavigationExtension" ~> 2.3.11
```

## 🌈 要求

| UINavigationExtension Version | Minimum iOS Target  | Minimum macOS Target  | Minimum watchOS Target  | Minimum tvOS Target  |                                   Notes                                   |
|:--------------------:|:---------------------------:|:----------------------------:|:----------------------------:|:----------------------------:|:-------------------------------------------------------------------------:|
| 2.x | iOS 11 | macOS 10.15 | n/a | n/a | macOS: macCatalyst

## 👏 功能

### 基本功能

- ✅` 修改返回按钮箭头颜色`
- ✅` 修改导航栏标题颜色`
- ✅` 修改导航栏背景颜色`
- ✅` 修改导航栏背景图片`
- ✅` 设置导航栏透明`
- ✅` 设置导航栏半透明`
- ✅` 修改导航栏底部线条颜色`
- ✅` 修改导航栏底部线条颜色图片`
- ✅` 自定义返回按钮图片`
- ✅` 自定义返回按钮`

### 高级功能

- ✅` 禁用滑动返回手势`
- ✅` 启用全屏滑动返回手势`
- ✅` 导航栏返回事件拦截`
- ✅` 重定向任一控制器跳转`
- ✅` 导航栏点击事件穿透到底部`
- ✅` 动态修改导航栏样式`
- ✅` 更新导航栏样式`

## 🍽 使用
所有对导航栏外观的修改都是基于视图控制器 `UIViewController` 修改的，而不是基于导航控制器 `UINavigationController` 修改，这种设计逻辑更加符合实际应用场景。也就是自己所在的导航栏的外观自己管理就好。

1. 💉 导入头文件 `#import <UINavigationExtension/UINavigationExtension.h>`
2. 💉 使用之前需要先注册需要修改的导航控制器，以 `FeatureNavigationController` 为例：
```objective-c
[UENavigationBar registerStandardAppearanceForNavigationControllerClass:[FeatureNavigationController class]];
```

**注意**：
- 👉 使用之前需要先注册导航控制器，注册之后对导航栏的修改才会生效，也仅限于修改本类所管理的视图控制器，对于子类导航控制器所管理的视图控制器是不会生效的，这样可以有效避免框架污染到其他的导航控制器，保持“谁使用，谁注册”的原则。
- 🚫 不要直接注册 `UINavigationController`，这个影响范围比较太广，建议创建一个 `UINavigationController` 的子类，对这个类进行注册。
- 🚫 不要使用系统导航栏隐藏、显示方法, `setNavigationBarHidden:`、`setNavigationBarHidden:animated`、`setHidden:`。
- 🚫 不要使用系统导航栏修改透明度。
- 🚫 不要使用系统导航栏或导航控制器 `appearance` 相关属性修改。
- 🚫 不要使用全局 `edgesForExtendedLayout` 修改。
- 🚫 不要使用 `<UIGestureRecognizerDelegate>` 相关方法禁用手势返回。
- 💉 一句话“不要直接操作导航栏或者导航控制器，把这些都交给 `UINavigationExtension` 处理吧“。

建议：除非你非常明白修改全局性东西的后果，否则不要修改，这么做的原因就是为了减少走一些弯路！

## 🍻 基本功能
### 修改返回按钮箭头颜色
📝 [示例代码](https://github.com/l1Dan/UINavigationExtension/blob/master/UINavigationExtensionDemo/Feature/Advanced/Controllers/ViewController07_ScrollChangeNavigationBar.m)

**导航栏返回按钮颜色默认使用系统蓝色 `[UIColor systemBlueColor]`，要改变返回按钮颜色可以使用以下方式配合：**

```objective-c
// 全局统一修改，不会覆盖基于视图控制器修改
UENavigationBarAppearance.standardAppearance.tintColor = [UIColor redColor];

// 基于视图控制器修改
- (UIColor *)ue_barTintColor {
    return self.isDarkMode ? [UIColor whiteColor] : [UIColor blackColor];
}
```

## 修改导航栏标题颜色
📝 [示例代码](https://github.com/l1Dan/UINavigationExtension/blob/master/UINavigationExtensionDemo/Feature/Advanced/Controllers/ViewController07_ScrollChangeNavigationBar.m)

```objective-c
- (NSDictionary<NSAttributedStringKey,id> *)ue_titleTextAttributes {
    return @{NSForegroundColorAttributeName: [self ue_barTintColor]};
}
```

#### 修改导航栏背景颜色
📝 [示例代码](https://github.com/l1Dan/UINavigationExtension/blob/master/UINavigationExtensionDemo/Feature/Basic/Controllers/ViewController01_BackgroundColor.m)

```objective-c
- (UIColor *)ue_navigationBarBackgroundColor {
    return [UIColor customDarkGrayColor];
}
```

#### 修改导航栏背景图片
📝 [示例代码](https://github.com/l1Dan/UINavigationExtension/blob/master/UINavigationExtensionDemo/Feature/Basic/Controllers/ViewController02_BackgroundImage.m)

```objective-c
- (UIImage *)ue_navigationBarBackgroundImage {
    return UIImage.navigationBarBackgorundImage;
}
```

#### 设置导航栏透明
📝 [示例代码](https://github.com/l1Dan/UINavigationExtension/blob/master/UINavigationExtensionDemo/Feature/Basic/Controllers/ViewController03_Transparent.m)

```objective-c
- (UIColor *)ue_navigationBarBackgroundColor {
    return [UIColor clearColor];
}
```

#### 设置导航栏半透明
📝 [示例代码](https://github.com/l1Dan/UINavigationExtension/blob/master/UINavigationExtensionDemo/Feature/Basic/Controllers/ViewController04_Translucent.m)

```objective-c
- (BOOL)ue_useSystemBlurNavigationBar {
    return YES;
}
```

### 修改导航栏底部线条颜色
📝 [示例代码](https://github.com/l1Dan/UINavigationExtension/blob/master/UINavigationExtensionDemo/Feature/Basic/Controllers/ViewController05_ShadowColor.m)

```objective-c
- (UIColor *)ue_shadowImageTintColor {
    return [UIColor redColor];
}
```

### 修改导航栏底部线条颜色图片
📝 [示例代码](https://github.com/l1Dan/UINavigationExtension/blob/master/UINavigationExtensionDemo/Feature/Basic/Controllers/ViewController06_ShadowImage.m)

```objective-c
- (UIColor *)ue_shadowImageTintColor {
    return [UIColor redColor];
}
```

### 修改导航栏底部线条颜色图片
📝 [示例代码](https://github.com/l1Dan/UINavigationExtension/blob/master/UINavigationExtensionDemo/Feature/Basic/Controllers/ViewController06_ShadowImage.m)

```objective-c
- (UIImage *)ue_shadowImage {
    return [UIImage imageNamed:@"NavigationBarShadowImage"];
}
```

### 自定义返回按钮图片
📝 [示例代码](https://github.com/l1Dan/UINavigationExtension/blob/master/UINavigationExtensionDemo/Feature/Basic/Controllers/ViewController07_CustomBackButtonImage.m)

```objective-c
- (UIImage *)ue_backImage {
    return [UIImage imageNamed:@"NavigationBarBack"];
}
```

### 自定义返回按钮
📝 [示例代码](https://github.com/l1Dan/UINavigationExtension/blob/master/UINavigationExtensionDemo/Feature/Basic/Controllers/ViewController08_CustomBackButton.m)

```objective-c
- (UIView *)ue_backButtonCustomView {
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
📝 [示例代码](https://github.com/l1Dan/UINavigationExtension/blob/master/UINavigationExtensionDemo/Feature/Advanced/Controllers/ViewController01_DisablePopGesture.m)

```objective-c
- (BOOL)ue_disableInteractivePopGesture {
    return YES;
}
```

#### 启用全屏滑动返回手势
📝 [示例代码](https://github.com/l1Dan/UINavigationExtension/blob/master/UINavigationExtensionDemo/Feature/Advanced/Controllers/ViewController02_FullPopGesture.m)

- 局部有效（在所处页面设置）
```objective-c
- (BOOL)ue_enableFullScreenInteractivePopGesture {
    return YES;
}
```

- 全局有效（在注册导航栏之前设置）
 ```objective-c
 UINavigationExtensionFullscreenPopGestureEnable = YES;
```

#### 导航栏返回事件拦截
📝 [示例代码](https://github.com/l1Dan/UINavigationExtension/blob/master/UINavigationExtensionDemo/Feature/Advanced/Controllers/ViewController03_BackEventIntercept.m)

需要遵守协议 `<UINavigationControllerCustomizable>`，实现代理方法：
```objective-c
- (BOOL)navigationController:(__kindof UINavigationController *)navigationController willPopViewControllerUsingInteractiveGesture:(BOOL)usingGesture {
    // TODO...
    return YES;
}
```

- 拦截点击返回按钮事件 & 手势返回事件
- 拦截点击返回按钮事件
- 拦截手势返回事件

```objective-c
- (BOOL)navigationController:(__kindof UINavigationController *)navigationController willPopViewControllerUsingInteractiveGesture:(BOOL)usingGesture {
    if (self.currentItemType == EventInterceptItemTypeBoth) { // 拦截点击返回按钮事件 & 手势返回事件
        [self showAlertController];
        return NO;
    }
    
    if (self.currentItemType == EventInterceptItemTypeBackButton) { // 拦截点击返回按钮事件
        if (!usingGesture) {
            [self showAlertController];
            return NO;
        }
    }
    
    if (self.currentItemType == EventInterceptItemTypePopGesture) { // 拦截手势返回事件
        if (usingGesture) {
            [self showAlertController];
            return NO;
        }
    }
    
    return YES;
}
```

自定义返回按钮事件拦截需要调用方法：`[self.navigationController ue_triggerSystemBackButtonHandler];`

### 重定向任一控制器跳转
📝 [示例代码](https://github.com/l1Dan/UINavigationExtension/blob/master/UINavigationExtensionDemo/Feature/Advanced/Controllers/ViewController04_RedirectViewController.m)

- 以重定向到 `RandomColorViewController` 为例，如果之前有 Push 过 `RandomColorViewController` 的实例，则最后会跳转到实例中，如果没有则会调用 `block`，如果 `block == NULL` 或者 `return nil;` 则重定向跳转不会发生。
- 执行重定向操作之后，并不会直接跳转到对应的视图控制器，如果需要 `跳转` 操作，可以调用 `popViewControllerAnimated:` 、`使用手势返回`、`点击返回按钮返回`。

```objective-c
[self.navigationController ue_redirectViewControllerClass:[RandomColorViewController class] createViewControllerUsingBlock:^__kindof UIViewController * _Nonnull {
    return [[RandomColorViewController alloc] init];
}];
```

**注意**：
执行上面代码之后并不会立即跳转，下面代码可以实现立即跳转：
```objective-c
[self.navigationController ue_redirectViewControllerClass:[RandomColorViewController class] createViewControllerUsingBlock:^__kindof UIViewController * _Nonnull {
    return [[RandomColorViewController alloc] init];
}];
[self.navigationController popViewControllerAnimated:YES];
```
上面代码大意为：首先查找 `self.navigationController.ViewConrollers` 是否存在一个类型为 `[RandomColorViewController class]` 的实例对象，如果存在则重定向到此视图控制器，没有则使用 `[[RandomColorViewController alloc] init]` 来创建一个新的 `[RandomColorViewController class]` 的实例对象。

### 导航栏点击事件穿透到底部
📝 [示例代码](https://github.com/l1Dan/UINavigationExtension/blob/master/UINavigationExtensionDemo/Feature/Advanced/Controllers/ViewController06_ClickEventHitToBack.m)

```objective-c
- (BOOL)ue_hidesNavigationBar {
    return YES;
}
```

### 动态修改导航栏样式
📝 [示例代码](https://github.com/l1Dan/UINavigationExtension/blob/master/UINavigationExtensionDemo/Feature/Advanced/Controllers/ViewController07_ScrollChangeNavigationBar.m)

```objective-c
- (BOOL)ue_containerViewWithoutNavigtionBar {
    return YES;
}
```

可以动态调整 ContainerView 透明度实现：`self.ue_navigationBar.containerView.alpha = value`

### 更新导航栏样式
📝 [示例代码](https://github.com/l1Dan/UINavigationExtension/blob/master/UINavigationExtensionDemo/Feature/Common/Controllers/RandomColorViewController.m)

```objective-c
[self ue_setNeedsNavigationBarAppearanceUpdate];
```

如果**状态栏**样式没有发生变化，请检查是否需要调用方法 `[self setNeedsStatusBarAppearanceUpdate]`，或者在 `UINavigationController` 的子类中设置如下代码：
```objective-c
- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}
```

## 📄 协议

UINavigationExtension 框架是在 MIT 许可下发布的。详情请参见 [LICE*N*SE](https://github.com/l1Dan/UINavigationExtension/blob/master/LICENSE)。
