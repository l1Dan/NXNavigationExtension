# CHANGELOG.md

## 5.0.0
1、适配 Xcode27，iOS27
2、最低支持 iOS 版本为 iOS15
3、移除过时 API 支持

## 4.2.5
1、适配 Xcode26，iOS26
Fixed: iOS26 下导航栏透明时或者导航栏不可用时返回按钮没有隐藏的问题

## 4.2.5
1、适配 Xcode16、Swift 6

## 4.2.4

Fixed: [手指在屏幕左边边缘往右滑动不能正确跳转下一个页面](https://github.com/l1Dan/NXNavigationExtension/issues/26)

## 4.2.3

代码优化

## 4.2.2

1. 过期 `disableInteractivePopGesture` 和 `nx_disableInteractivePopGesture` 属性，功能重复，可使用 `NXNavigationTransitionDelegate` 代理方法 `nx_navigationTransition:navigationBackAction:` 替代。
2. SwiftUI 接口优化，移除部分接口。

## 4.2.1

修复：页面全屏手势开启后从其他页面返回时，全屏手势失效问题。

## 4.2.0

1. 更新 NXNavigationExtensionSwiftUI 最低支持版本为 14.0。

## 4.1.9

1. 为避免开发人员不及更新废弃接口引起问题，现彻底移除废弃接口。

## 4.1.8

1. 新增 `nx_transitionStateHandler` 处理视图控制器转场状态
2. 新增 `nx_backActionHandler` 拦截视图控制器返回操作
3. 新增 `NXNavigationTransitionDelegate`
4. 新增 `NXNavigationTransitionState` 视图控制器转场状态枚举类型
5. 新增 `NXNavigationBackAction` 视图控制器返回事件枚举类型
6. 废弃 `NXNavigationAction` 使用 `NXNavigationTransitionState` 替代
7. 废弃 `NXNavigationInteractiveType` 使用 `NXNavigationBackAction` 替代
8. 废弃 `NXNavigationControllerDelegate` 使用 `NXNavigationTransitionDelegate` 替代
9. 废弃 `nx_setPreviousViewControllerWithClass:insertsInstanceToBelowWhenNotFoundUsingBlock`

## 4.1.7
1. 适配 Xcode15
2. 移除 过期方法

## 4.1.6

1. fix: 移除 ViewControllers 中 rootViewController 之后，新的 rootViewController 返回按钮显示不正确问题 #16
2. 代码优化

## 4.1.5

最低支持 iOS11.0

## 4.1.4

1. 修复 iOS14 以下系统无法拦截系统返回按钮点击事件问题
2. 修复使用手势返回时返回按钮文字颜色闪变问题

## 4.1.3

1. 转场 API 重构
2. 添加指定返回上一个页面的代理方法

## 4.1.2

1. 优化返回按钮图标显示效果；
2. 统一返回按钮点击时的交互事件为 NXNavigationInteractiveTypeBackButtonAction；
3. 修复初始化控制器时，interactivePopGestureRecognizer.delegate 没有设置的问题；
4. 修复系统导航栏隐藏时 NXNavigationBar 没有隐藏的问题。

## 4.1.1

1. 移除不必要的手势检查；
2. 修复因检查全屏手势是否可用的过程中移除全屏手势而导致的 `Pop` 失败「页面卡住」的问题。

## 4.1.0

1. 添加视图控制器转场周期事件逻辑，方便业务使用；
2. 新增多个导航控制器页面转场方法，添加动画完成时的回调；
3. 新增多个 Pop 的同时 Push、Present 一个新的视图控制器方法；
4. 优化全屏手势判断逻辑；
5. 优化视图控制器栈 Pop 控制器时的逻辑。

- 新增: `nx_navigationController:processViewController:navigationAction` 转场周期事件协议；
- 过期: `NXNavigationInteractable` 协议，推荐使用 `NXNavigationControllerDelegate` 协议。

对于 UIViewController

- 新增: `nx_popViewControllerWithPresent:animated:completion` 方法；
- 新增: `nx_popToViewController:withPresent:animated:completion` 方法；
- 新增: `nx_popToRootViewControllerWithPresent:animated:completion` 方法。

对于 UINavigationController

- 新增: `nx_pushViewController:animated:completion` 方法；
- 新增: `nx_popViewControllerAnimated:completion` 方法；
- 新增: `nx_popToViewController:animated:completion` 方法；
- 新增: `nx_popToRootViewControllerAnimated:completion` 方法；
- 新增: `nx_popViewControllerWithPush:animated:completion` 方法；
- 新增: `nx_popToViewController:withPush:animated:completion` 方法；
- 新增: `nx_popToRootViewControllerWithPush:animated:completion` 方法；
- 新增: `nx_setViewControllers:animated:completion` 方法；
- 新增: `nx_removeViewControllersUntilClass:withNavigationStackPosition:insertsToBelowWhenNotFoundUsingBlock` 方法；
- 过期: `nx_redirectViewControllerClass:initializeStandbyViewControllerUsingBlock:` 方法，推荐使用 `nx_removeViewControllersUntilClass:insertsToBelowWhenNotFoundUsingBlock:` 方法。

## 4.0.4

- 修复 edgesForExtendedLayout = UIRectEdge(rawValue: 0) 时在大标题模式下 NXNavigationBar 位置不正确问题
- 代码优化

## 4.0.3

- NXNavigationBar 支持 `semanticContentAttribute` 属性，方便从右往左的导航栏布局；
- 将 NXNavigationBar `originalNavigationBarFrame` 属性移动到内部类中；
- 添加对 UIViewController `edgesForExtendedLayout` 属性的全面支持 [#7](https://github.com/l1Dan/NXNavigationExtension/issues/7)；
- 添加 issues 模版。

## 4.0.2

- typo NXNavigatioVirtualWrapperViewFilterCallback -> NXNavigationVirtualWrapperViewFilterCallback
- 废弃 fullScreenInteractivePopGestureEnabled 相关启用全局返回手势属性，使得逻辑更加清晰
- 修复 NXNavigationBar contentView 在某些情况下无法隐藏的问题

## 4.0.1

- 修复启用全屏滑动返回手势后，在局部页面禁用滑动返回手势无效问题 [#6](https://github.com/l1Dan/NXNavigationExtension/issues/6)
- 修复在 SwiftUI 中切换 Color Scheme 时默认配置没有立即生效的问题
- Added GitHub Workflows
- 示例程序代码归类到 Examples 文件夹

## 4.0.0

重要更新‼️

- 添加 SwiftUI 支持；
- 添加 SwiftUI framework 支持；
- 添加 Swift Package Manager 支持，感谢 [@nrudnyk](https://github.com/nrudnyk) 的贡献[#5](https://github.com/l1Dan/NXNavigationExtension/pull/5/commits/9aa5eead35044fa4d70de349cbd813e01eb7be1e)；
- 使用 Swift 重写示例程序代码；
- 文档更新。

## 3.6.4

- 单词拼写错误修正：fullscreen -> fullScreen, Fullscreen -> FullScreen, contentViewWithoutNavigtionBar -> contentViewWithoutNavigationBar；
- 修复调用 nx_setNeedsNavigationBarAppearanceUpdate 更新导航栏时会修改 rootViewController leftItem 的问题；
- 使 nx_popToViewController:animated: 函数更加符合 Swift 的命名规范；
- 修复 index 索引获取错误的问题；
- 1.示例代码优化 2.修改错别字。

## 3.6.3

- 修复 UIViewController view frame 改变时 NXNavigationBar frame 不更新的问题；
- 移除 nx_navigationStackContained 变量，代码精简。

## 3.6.2

- 完善 SwiftUI 基础支持。

## 3.6.1

- 添加 SwiftUI 基础支持；
- 系统返回按钮标题自定义逻辑优化；
- 示例代码优化。

## 3.6.0

优化准备配置信息开始生效前期的调用逻辑、大幅减少重复调用次数，此功能可以针对修改一些第三方库内部以及 SwiftUI 内部使用的导航栏。优化同时注册多个有继承关系导航控制器的配置信息查找逻辑。将 `NXNavigationBar` 类中注册导航控制器的逻辑移动到 `NXNavigationConfiguration` 类中。

1. 添加系统导航栏返回按钮标题的自定义逻辑
2. 添加转场动画示例代码。

- 新增: `registerNavigationControllerClasses:` 方法；
- 新增: `registerNavigationControllerClasses:prepareConfigureViewControllerCallback:` 方法；
- 新增: `configurationFromNavigationControllerClass:` 方法；
- 新增: `prepareConfigureViewControllerCallbackFromNavigationControllerClass:` 方法；
- 过期: `registerNavigationControllerClass:withConfiguration:` 方法，推荐使用 `NXNavigationConfiguration registerNavigationControllerClasses:` 方法;
- 修改: README.md 文件;
- 示例代码优化。

## 3.5.3

- 修复一处 nx_configuration 赋值逻辑错误问题；
- 示例代码优化，修复部分示例代码界面横竖屏适配问题，添加 `UISearchController` 在导航栏中使用的示例代码;
- 修改: README.md 添加 FAQ 常见问题;

## 3.5.2

- 代码优化；
- 代码示例添加解决滑动返回手势冲突和导航栏渐变逻辑。

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
- 过期: `nx_fullScreenPopGestureEnabled` 属性，推荐使用 `NXNavigationControllerPreferences fullScreenInteractivePopGestureEnabled` 属性；
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

1. 框架代码优化，整理废弃 API，为后续 4.x 版本和 SwiftUI 作准备。示例代码适配 Xcode13。
2. 将视图控制器的属性 `nx_translucentNavigationBar` 的属性设置为 `YES` 时，可以达到隐藏导航栏的目的（只是将导航栏变为透明，并不是真正意义上的隐藏，不推荐直接使用系统导航栏提供的显示或隐藏的方法）。但是这样设置之后会发现 self.navigationItem.title/titleView 还是存在的，这显然是不太符合的导航栏透明或者隐藏的语意。所以为了解决这个问题，现在设置 `nx_translucentNavigationBar` 属性为 `YES` 时，不仅会将导航栏设置为透明的，还会将导航栏上面的所有元素设置为透明或者隐藏的，这样导航栏的外观看起来才更加符合设置 `nx_translucentNavigationBar = YES` 的预期效果。

- 新增: `contentViewEdgeInsets` 属性；
- 新增: `contentView` 属性；
- 新增: `backgroundEffectView` 属性；
- 新增: `nx_contentViewWithoutNavigationBar` 属性；
- 新增: `appearanceFromRegisterNavigationController:` 方法；
- 新增: `nx_redirectViewControllerClass:initializeStandbyViewControllerUsingBlock:` 方法；
- 过期: `containerViewEdgeInsets` 属性，推荐使用 `contentViewEdgeInsets` 属性；
- 过期: `containerView` 属性，推荐使用 `contentView` 属性；
- 过期: `visualEffectView` 属性，推荐使用 `backgroundEffectView` 属性；
- 过期: `nx_containerViewWithoutNavigtionBar` 属性，推荐使用 `nx_contentViewWithoutNavigationBar` 属性；
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
[示例代码](https://github.com/l1Dan/NXNavigationExtension/blob/main/Examples/NXNavigationExtensionDemo/UIKit/Advanced/ViewController06_WebView.swift)；

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
- 重命名: `UEFullScreenPopGestureRecognizerDelegate` 为 `NXFullScreenPopGestureRecognizerDelegate`；
- 移除: `UINavigationController+NXNavigationExtension.m` 的方法，以避免其他分类重写这些方法时造成不可预期的行为。
  > 1. `-childViewControllerForStatusBarStyle`
  > 2. `-childViewControllerForStatusBarHidden`
