//
// NXNavigationConfiguration.h
//
// Copyright (c) 2020 Leo Lee NXNavigationExtension (https://github.com/l1Dan/NXNavigationExtension)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class NXNavigationConfiguration, NXNavigationVirtualWrapperView;

typedef __kindof NXNavigationVirtualWrapperView *_Nullable(^_Nullable NXNavigatioVirtualWrapperViewFilterCallback)(__kindof UIViewController *hostingController);

typedef NXNavigationConfiguration *_Nullable(^_Nullable NXNavigationControllerPrepareConfigurationCallback)(__kindof UINavigationController *navigationController, NXNavigationConfiguration *configuration);

typedef void (^_Nullable NXViewControllerPrepareConfigurationCallback)(__kindof UIViewController *viewController, NXNavigationConfiguration *configuration);

/// 返回页面使用的交互方式
/// `NXNavigationInteractiveTypeCallNXPopMethod` 执行 `nx_popViewControllerAnimated:`、`nx_popToViewController:animated:` 或 `nx_popToRootViewControllerAnimated:` 回调方式
/// `NXNavigationInteractiveTypeBackButtonMenuAction` 需要设置 `useSystemBackButton = YES` 或者 `nx_useSystemBackButton = YES`
typedef NS_ENUM(NSUInteger, NXNavigationInteractiveType) {
    NXNavigationInteractiveTypeCallNXPopMethod,      // 调用 `nx_pop` 系列方法返回
    NXNavigationInteractiveTypeBackButtonAction,     // 点击返回按钮返回
    NXNavigationInteractiveTypeBackButtonMenuAction, // 长按返回按钮选择菜单返回
    NXNavigationInteractiveTypePopGestureRecognizer, // 使用手势交互返回
};

@protocol NXNavigationInteractable <NSObject>

/// 使用手势滑动返回或点击系统返回按钮过程中可以拦截或中断返回继而执行其他操作
/// 执行 `nx_popViewControllerAnimated:`、`nx_popToViewController:animated:` 或 `nx_popToRootViewControllerAnimated:` 等方法后也会触发这个代理回调
/// @param navigationController 当前使用的导航控制器
/// @param viewController 即将要 Pop 的视图控制器
/// @param interactiveType 返回页面使用的交互方式
/// @return `YES` 表示不中断返回操作继续执行；`NO` 表示中断返回操作
- (BOOL)nx_navigationController:(__kindof UINavigationController *)navigationController willPopViewController:(__kindof UIViewController *)viewController interactiveType:(NXNavigationInteractiveType)interactiveType;

@end


NS_SWIFT_NAME(NXNavigationBar.Appearance) @interface NXNavigationBarAppearance : NSObject <NSCopying>

/// 设置 NXNavigationBar 背景颜色，默认：[UIColor systemBlueColor]，这样处理能够快速辨别框架是否生效
@property (nonatomic, strong) UIColor *backgroundColor;

/// 设置 UINavigationBar tintColor（返回按钮颜色），默认：iOS13 之前 [UIColor whiteColor]，iOS13及以后 [UIColor systemBackgroundColor]
@property (nonatomic, strong) UIColor *tintColor;

/// 设置 UINavigationBar barTintColor
@property (nonatomic, strong, nullable) UIColor *barTintColor;

/// 设置 NXNavigationBar 底部阴影图片
@property (nonatomic, strong, nullable) UIImage *shadowImage;

/// 设置 NXNavigationBar 底部阴影
@property (nonatomic, strong, nullable) UIColor *shadowColor;

/// 设置 UINavigationBar titleTextAttributes
@property (nonatomic, strong, nullable) NSDictionary<NSAttributedStringKey, id> *titleTextAttributes;

/// 设置 UINavigationBar largeTitleTextAttributes
@property (nonatomic, strong, nullable) NSDictionary<NSAttributedStringKey, id> *largeTitleTextAttributes API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos);

/// 设置 NXNavigationBar 背景图片
@property (nonatomic, strong, nullable) UIImage *backgroundImage;

/// 自定义返回按钮
@property (nonatomic, strong, nullable) UIView *backButtonCustomView;

/// 设置返回按钮图片
@property (nonatomic, strong, nullable) UIImage *backImage;

/// 设置横屏时显示的返回按钮图片
@property (nonatomic, strong, nullable) UIImage *landscapeBackImage;

/// 系统返回按钮的 2 种标题：1. 使用系统默认返回标题，2.自定义系统返回按钮标题(或者标题为空)；
/// 默认：空字符串（不显示标题）。如果返回 nil，则使用系统返回按钮自带的标题
@property (nonatomic, copy, nullable) NSString *systemBackButtonTitle;

/// 设置返回按钮图片 `backImage` 的偏移量，默认：backImageInsets = {0, -8, 0, 0}
@property (nonatomic, assign) UIEdgeInsets backImageInsets;

/// 设置横屏时显示返回按钮图片 `landscapeBackImage` 的偏移量，默认：landscapeBackImageInsets = {0, -8, 0, 0}
@property (nonatomic, assign) UIEdgeInsets landscapeBackImageInsets;

/// 是否使用系统返回按钮；默认 NO
@property (nonatomic, assign) BOOL useSystemBackButton;

@end


@interface NXNavigationControllerPreferences : NSObject <NSCopying>


@end


@interface NXViewControllerPreferences : NSObject <NSCopying>

/// 当前视图控制器的 traitCollection 对象
@property (nonatomic, strong, nullable, readonly) UITraitCollection *traitCollection;

/// 是否使用模糊导航栏模糊；默认 NO。需要设置 nx_navigationBarBackgroundColor 的 alpha 颜色通道才会有效果
/// 将 nx_navigationBarBackgroundColor 设置为 [UIColor clearColor]，可以实现类似系统导航栏的模糊效果
@property (nonatomic, assign) BOOL useBlurNavigationBar;

/// 是否禁用边缘滑动返回手势；默认 NO
@property (nonatomic, assign) BOOL disableInteractivePopGesture;

/// 是否启用全屏返回；默认 NO
@property (nonatomic, assign) BOOL enableFullScreenInteractivePopGesture;

/// 是否自动隐藏 NavigationBar；默认 YES
@property (nonatomic, assign) BOOL automaticallyHideNavigationBarInChildViewController;

/// 设置导航栏是否透明（类似导航栏隐藏的效果，当不是真正意思的隐藏）。不推荐直接设置系统导航栏的显示或隐藏。
/// 开启这个属性会将 self.navigationController.navigationBar.barTintColor/tintColor/titleTextAttributes/largeTitleTextAttributes 的颜色都设置为：[UIColor clearColor]
/// 还会将 self.navigationItem.titleView.hidden 属性设置为 `YES`，以及将 self.navigationController.navigationBar.userInteractionEnabled 属性设置为 `NO`，
/// 这样可以实现导航栏“看起来”被隐藏了。设置为透明之后导航栏将无法接收到事件响应，底部的视图此时将会接收到事件响应。
/// 将导航栏底部视图层接收到事件响应也符合导航栏被“隐藏”的行为。
@property (nonatomic, assign) BOOL translucentNavigationBar;

/// 设置系统导航栏能够处理用户交互；默认 NO。如果需要 NXNavigationBar 可以处理用户交互，则需要设置这个属性为 `YES`。
@property (nonatomic, assign) BOOL systemNavigationBarUserInteractionDisabled;

/// 设置全屏手势触发距离
@property (nonatomic, assign) CGFloat interactivePopMaxAllowedDistanceToLeftEdge;

@end


@interface NXNavigationConfiguration : NSObject <NSCopying>

/// 全局默认配置
@property (nonatomic, strong, readonly, class) NXNavigationConfiguration *defaultConfiguration;

/// 默认导航栏外观
@property (nonatomic, strong) NXNavigationBarAppearance *navigationBarAppearance;

/// 默认导航控制器偏好设置
@property (nonatomic, strong) NXNavigationControllerPreferences *navigationControllerPreferences;

/// 默认视图控制器偏好设置
@property (nonatomic, strong) NXViewControllerPreferences *viewControllerPreferences;

/// 使用当前配置注册需要设置的导航控制器
/// @param navigationControllerClasses 需要注册的 UINavigationController 或子类类对象集合
- (void)registerNavigationControllerClasses:(NSArray<Class> *)navigationControllerClasses;

/// 使用当前配置注册需要设置的导航控制器。如果 callback 中 NXNavigationConfiguration 返回为 nil，则此导航控制器及导航控制器管理的所有视图控制器的配置都将不会生效（相当于没有注册） 。
/// @param navigationControllerClasses 需要注册的 UINavigationController 或子类类对象集合
/// @param callback 即将应用配置到当前视图控制器的回调，每个导航控制器实例对象只会调用一次。
- (void)registerNavigationControllerClasses:(NSArray<Class> *)navigationControllerClasses prepareConfigureNavigationControllerCallback:(NXNavigationControllerPrepareConfigurationCallback)callback;

/// 通过导航控制器获取对应的配置信息
/// @param navigationControllerClass 需要注册的 UINavigationController 或子类类对象
+ (nullable NXNavigationConfiguration *)configurationFromNavigationControllerClass:(nullable Class)navigationControllerClass;

/// 通过导航控制器获取对应的配置信息回调
/// @param navigationControllerClass 需要注册的 UINavigationController 或子类类对象
+ (nullable NXNavigationControllerPrepareConfigurationCallback)prepareConfigurationCallbackFromNavigationControllerClass:(nullable Class)navigationControllerClass;

@end

NS_ASSUME_NONNULL_END
