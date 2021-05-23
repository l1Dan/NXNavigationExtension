# Change Log

## 3.0.0

- 项目结构调整
- 添加 Swift Package Manager 支持
- 重命名：ue 前缀为 nx，防止与第三方库冲突；
- 重命名：-navigationController:willPopViewControllerUsingInteractiveGesture 为；-navigationController:willPopViewControllerUsingInteractingGesture；
- 重命名：UINavigationController+UINavigationExtension 为 UINavigationController+NXNavigationExtension；
- 重命名：UIViewController+UINavigationExtension 为 UIViewController+NXNavigationExtension；
- 重命名：UENavigationBar 为 NXNavigationBar；
- 重命名：UINavigationExtension 为 NXNavigationExtension；
- 重命名：UINavigationExtensionMacro 为 NXNavigationExtensionMacro；
- 重命名：UINavigationExtensionPrivate 为 NXNavigationExtensionPrivate；
- 重命名：UEEdgeGestureRecognizerDelegate 为 NXEdgeGestureRecognizerDelegate；
- 重命名：UEFullscreenPopGestureRecognizerDelegate 为 NXFullscreenPopGestureRecognizerDelegate；
- 移除 UINavigationController+NXNavigationExtension.m 重写方法 -childViewControllerForStatusBarStyle、-childViewControllerForStatusBarHidden 以避免其他分类重写这些方法时造成不可预期的行为。
- 添加 CHANGELOG.md 文件。
