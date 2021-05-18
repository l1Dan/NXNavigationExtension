# Change Log

---
## 3.0

- 重命名：ue 前缀为 unx，防止与第三方库冲突。
- 重命名：-navigationController:willPopViewControllerUsingInteractiveGesture 为 -navigationController:willPopViewControllerUsingInteractingGesture
- 重命名：UINavigationController+UINavigationExtension 为 UINavigationController+UNXNavigator
- 重命名：UIViewController+UINavigationExtension 为 UIViewController+UNXNavigator
- 重命名：UENavigationBar 为 UNXNavigationBar
- 重命名：UINavigationExtension 为 UNXNavigator
- 重命名：UINavigationExtensionMacro 为 UNXNavigatorMacro
- 重命名：UINavigationExtensionPrivate 为 UNXNavigatorPrivate
- 添加 CHANGELOG.md 文件