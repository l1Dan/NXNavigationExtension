# CHANGELOG.md

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
- *NXNavigationExtension* 最低支持到 iOS 9.0；
- 示例代码优化。

## 3.3.0
- 新增: `nx_popViewControllerAnimated:` 方法；
- 新增: `nx_popToViewController:animated:` 方法；
- 新增: `nx_popToRootViewControllerAnimated:` 方法；
- 过期: `nx_triggerSystemBackButtonHandler` 方法，推荐使用 `[self.navigationController nx_popViewControllerAnimated:YES]` 方法；
- 修复: 返回按钮菜单无法拦截返回事件问题；
- 修复: 返回按钮菜单位置显示不正确问题；
- *移除* Swift Demo 和 Swift Package Manager 支持；
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
