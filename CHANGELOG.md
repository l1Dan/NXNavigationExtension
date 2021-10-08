# CHANGELOG.md

## 3.5.2

1. 代码优化
2. 添加解决滑动返回手势冲突和导航栏渐变的代码示例

## 3.5.1

优化 `backImageInsets` 和 `landscapeBackImageInsets` 属性处理方式，移除所有单例的使用。

- 修改: README.md 文件;
- 示例代码优化。

## 3.5.0

统一默认偏好设置和外观设置的方式，方面使用。以下三种设置都可以在 `NXNavigationConfiguration` 中使用。

1. `NXNavigationBarAppearance` 默认导航栏外观设置；
2. `NXNavigationControllerPreferences` 默认导航控制器偏好设置；
3. `NXViewControllerPreferences` 默认视图控制器偏好设置。

- 新增: `backgroundColor` 属性；
- 新增: `backgroundImage` 属性；
- 新增: `NXNavigationControllerPreferences` 类；
- 新增: `NXViewControllerPreferences` 类；
- 新增: `NXNavigationConfiguration` 类；
- 过期: `backgorundColor` 属性（拼写错误），推荐使用 `backgroundColor` 属性；
- 过期: `backgorundImage` 属性（拼写错误，推荐使用 `backgroundImage` 属性；
- 过期: `nx_fullscreenPopGestureEnabled` 属性，推荐使用 `NXNavigationControllerPreferences fullscreenInteractivePopGestureEnabled` 属性；
- 过期: `backButtonMenuSupported` 属性，推荐使用 `NXNavigationControllerPreferences menuSupplementBackButton` 属性；
- 过期: `appearanceFromRegisterNavigationController:` 方法，推荐使用 `configurationFromRegisterNavigationController:` 方法；
- 过期: `registerNavigationControllerClass:forAppearance:` 方法，推荐使用 `registerNavigationControllerClass:withConfiguration:` 方法；
- 修改: README.md 文件;
- 示例代码优化。

## 3.4.9

允许注册的导航栏控制器的子类使用基类的 `NXNavigationBarAppearance` 设置

- 修改: README.md 文件;
- 示例代码优化。

## 3.4.8

代码逻辑优化

## 3.4.7

NXNavigationBar 可以跟随系统导航栏的显示隐藏。虽然不推荐使用系统方法隐藏或者显示导航栏，但还是要尊重开发者的需求，如果开发者自己设置了系统导航栏的隐藏那么 NXNavigationBar 也会隐藏，设置系统导航栏显示 NXNavigationBar 也会显示。这样也更加符合直觉，避免产生歧义。

## 3.4.6

1. 框架代码优化，整理废弃 API，为后续 4.x 版本和 SwiftUI 作准备。示例程序代码适配 Xcode13。
2. 将视图控制器的属性 `nx_translucentNavigationBar` 的属性设置为 `YES` 时，可以达到隐藏导航栏的目的（只是将导航栏变为透明，并不是真正意义上的隐藏，不推荐直接使用系统导航栏提供的显示或隐藏的方法）。但是这样设置之后会发现 self.navigationItem.title/titleView 还是存在的，这显然是不太符合的导航栏透明或者隐藏的语意。所以为了解决这个问题，现在设置 `nx_translucentNavigationBar` 属性为 `YES` 时，不仅会将导航栏设置为透明的，还会将导航栏上面的所有元素设置为透明或者隐藏的，这样导航栏的外观看起来才更加符合设置 `nx_translucentNavigationBar = YES` 的预期效果。

- 新增: `contentViewEdgeInsets` 属性；
- 新增: `contentView` 属性；
- 新增: `backgroundEffectView` 属性；
- 新增: `nx_enableFullscreenInteractivePopGesture` 属性；
- 新增: `nx_contentViewWithoutNavigtionBar` 属性；
- 新增: `appearanceFromRegisterNavigationController:` 方法；
- 新增: `nx_redirectViewControllerClass:initializeStandbyViewControllerUsingBlock:` 方法；
- 过期: `containerViewEdgeInsets` 属性，推荐使用 `contentViewEdgeInsets` 属性；
- 过期: `containerView` 属性，推荐使用 `contentView` 属性；
- 过期: `visualEffectView` 属性，推荐使用 `backgroundEffectView` 属性；
- 过期: `nx_enableFullScreenInteractivePopGesture` 属性，推荐使用 `nx_enableFullscreenInteractivePopGesture` 属性；
- 过期: `nx_containerViewWithoutNavigtionBar` 属性，推荐使用 `nx_contentViewWithoutNavigtionBar` 属性；
- 过期: `addContainerViewSubview:` 方法，推荐使用 `contentView addSubview:` 方法；
- 过期: `setContainerViewEdgeInsets:` 方法，推荐使用 `contentViewEdgeInsets` 属性；
- 过期: `appearanceFromRegisterNavigationControllerClass:` 方法，推荐使用 `appearanceFromRegisterNavigationController:` 方法；
- 过期: `nx_redirectViewControllerClass:initializeStandbyViewControllerBlock:` 方法，推荐使用 `nx_redirectViewControllerClass:initializeStandbyViewControllerUsingBlock:` 方法；
- 修改: README.md 文件;
- 示例代码优化。

## 3.4.5

使用 `nx_useSystemBlurNavigationBar` 属性局限在于只能实现类似系统导航栏效果，而无法使用自定义颜色作为模糊效果的背景色，现在 `nx_useBlurNavigationBar` 和 `nx_navigationBarBackgroundColor` 属性的配合使用，可以支持自定义颜色作为模糊效果的背景色，加强了导航栏外观定制的能力。

- 新增: `nx_useBlurNavigationBar` 属性；
- 过期: `nx_useSystemBlurNavigationBar` 属性，推荐使用 `nx_useBlurNavigationBar` 和 `nx_navigationBarBackgroundColor` 属性实现类似系统导航栏效果；
- 过期: `enableBlurEffect:` 属性，`NXNavigationBar` 不再对外开放此属性;
- 修改: README.md 文件;
- 示例代码优化。

## 3.4.4

因为不断添加新特性和完善功能，导致大量 API 重命名，在这里对大家说声抱歉，后续的 API 尽量少做修改。最后希望大家食用快乐 😋。

- 新增: `nx_translucentNavigationBar` 属性；
- 新增: `appearanceFromRegisterNavigationControllerClass:` 方法；
- 新增: `registerNavigationControllerClass:forAppearance:` 方法；
- 过期: `nx_hidesNavigationBar` 属性，推荐使用 `nx_translucentNavigationBar` 属性；
- 过期: `standardAppearanceForNavigationControllerClass:` 方法，推荐使用 `appearanceFromRegisterNavigationControllerClass:` 方法；
- 过期: `registerStandardAppearanceForNavigationControllerClass:` 方法，推荐使用 `registerNavigationControllerClass:forAppearance` 方法；
- 修改: README.md 文件;
- 示例代码优化。

## 3.4.3

- 修复: 获取 `nx_navigationBar` 时的判断逻辑不对问题。修改为：如果之前已经创建过 `nx_navigationBar`，那么之后无论 `self.navigationController` 属性是否为空都会直接返回原来已经创建好的 `nx_navigationBar` 实例。
- 修复: 视图控制器同时重写 `extendedLayoutIncludesOpaqueBars` 和 `edgesForExtendedLayout` 属性时导航栏位置不对问题。

## 3.4.2

之前使用 UIViewController 的 `edgesForExtendedLayout` 属性会导致导航栏往下移动，这也就是 `README.md` 文档中提到不要使用 `edgesForExtendedLayout` 属性的原因，现在该问题已经修复。详细信息查看：
[示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/master/NXNavigationExtensionDemo/Feature/Advanced/Controllers/ViewController08_WebView.m)；

- 修改: README.md 文件;
- 示例代码优化。

## 3.4.1

添加返回页面交互方式，之前的 `-navigationController:willPopViewControllerUsingInteractiveGesture:` 方法只能判断使用手势或者不使用手势交互返回页面的方式，现在已经支持完整的返回页面交互方式；

1. `NXNavigationInteractiveTypeCallNXPopMethod`: 调用 `nx_pop` 系列方法返回。
2. `NXNavigationInteractiveTypeBackButtonAction`: 点击返回按钮返回。
3. `NXNavigationInteractiveTypeBackButtonMenuAction`: 长按返回按钮选择菜单返回。
4. `NXNavigationInteractiveTypePopGestureRecognizer`: 使用手势交互返回。

- 新增: `NXNavigationInteractiveType` 返回页面交互方式；
- 过期: `NXNavigationExtensionInteractable` 协议，请使用 `NXNavigationInteractable` 协议；
- 过期: `-navigationController:willPopViewControllerUsingInteractingGesture:` 方法，请使用 `-nx_navigationController:willPopViewController:interactiveType:` 方法；
- 修改: README.md 文件;
- 示例代码优化。

## 3.4.0

- 使用新的方式支持 iOS14 系统导航栏返回按钮显示菜单的功能，支持拦截系统返回按钮点击返回事件和拦截系统返回按钮菜单长按返回事件；
- 新增: `NXNavigationExtensionRuntime` 类；
- 新增: 导航栏全局属性 `backImageInsets`，`landscapeBackImageInsets`，`backButtonMenuSupported`；
- 新增: `UIViewController+NXNavigationExtension` 属性 `nx_largeTitleTextAttributes`;
- 移除: `NXNavigationMenuBackControl` 类；
- 移除: `NXNavigationExtensionMacro` 文件；
- 优化: 代码格式化、示例代码优化。

## 3.3.1

- _NXNavigationExtension_ 最低支持到 iOS 9.0；
- 示例代码优化。

## 3.3.0

- 新增: `nx_popViewControllerAnimated:` 方法；
- 新增: `nx_popToViewController:animated:` 方法；
- 新增: `nx_popToRootViewControllerAnimated:` 方法；
- 过期: `nx_triggerSystemBackButtonHandler` 方法，推荐使用 `[self.navigationController nx_popViewControllerAnimated:YES]` 方法；
- 修复: 返回按钮菜单无法拦截返回事件问题；
- 修复: 返回按钮菜单位置显示不正确问题；
- _移除_ Swift Demo 和 Swift Package Manager 支持；
- 文件夹目录调整。

## 3.2.0

- 新增: `NXNavigationMenuBackControl` 类；
- 新增: `nx_globalBackButtonMenuEnabled` 和 `nx_backButtonMenuEnabled` API，为 iOS14 及以上系统提供长按返回按钮显示菜单的功能；
- 重命名: `addContainerSubview:` 为 `addContainerViewSubview:`
- 重命名: `standardAppearanceInNavigationControllerClass:` 为 `standardAppearanceForNavigationControllerClass:`
- 优化: 代码格式化、示例代码优化。

## 3.1.0

- 重命名: `-nx_redirectViewControllerClass:createViewControllerUsingBlock:` 为 `-nx_redirectViewControllerClass:initializeStandbyViewControllerBlock:`；

## 3.0.0

- 项目结构调整
- 新增: CHANGELOG.md 文件；
- 重命名: `ue` 前缀为 `nx`，防止与第三方库冲突，并且更加符合语意；
- 重命名: `-navigationController:willPopViewControllerUsingInteractiveGesture:` 为 `-navigationController:willPopViewControllerUsingInteractingGesture:`；
- 重命名: `UINavigationController+UINavigationExtension` 为 `UINavigationController+NXNavigationExtension`；
- 重命名: `UIViewController+UINavigationExtension` 为 `UIViewController+NXNavigationExtension`；
- 重命名: `UENavigationBar` 为 `NXNavigationBar`；
- 重命名: `UINavigationExtension` 为 `NXNavigationExtension`；
- 重命名: `UINavigationExtensionMacro` 为 `NXNavigationExtensionMacro`；
- 重命名: `UINavigationExtensionPrivate` 为 `NXNavigationExtensionPrivate`；
- 重命名: `UEEdgeGestureRecognizerDelegate` 为 `NXEdgeGestureRecognizerDelegate`；
- 重命名: `UEFullscreenPopGestureRecognizerDelegate` 为 `NXFullscreenPopGestureRecognizerDelegate`；
- 移除: `UINavigationController+NXNavigationExtension.m` 的方法，以避免其他分类重写这些方法时造成不可预期的行为。
  > 1. `-childViewControllerForStatusBarStyle`
  > 2. `-childViewControllerForStatusBarHidden`
