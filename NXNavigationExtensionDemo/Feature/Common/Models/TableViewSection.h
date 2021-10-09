//
//  TableViewSection.h
//  NXNavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TableViewItemType) {
    TableViewItemTypeNavigationBarBackgroundColor,                  // 修改导航栏背景颜色
    TableViewItemTypeNavigationBarBackgroundImage,                  // 修改导航栏背景图片
    TableViewItemTypeNavigationBarTransparent,                      // 设置导航栏透明
    TableViewItemTypeLikeSystemBlurNavigationBar,                   // 实现系统导航栏模糊效果
    TableViewItemTypeNavigationBarShadowColor,                      // 设置导航栏底部线条颜色
    TableViewItemTypeNavigationBarShadowImage,                      // 设置导航栏底部线条图片
    TableViewItemTypeNavigationBarCustomBackButtonImage,            // 自定义返回按钮图片
    TableViewItemTypeNavigationBarCustomBackButton,                 // 自定义返回按钮
    TableViewItemTypeNavigationBarFullscreen,                       // 全屏背景色
    TableViewItemTypeNavigationBarTabViewController,                // UITabViewController
    TableViewItemTypeNavigationBarTabViewControllerWithFullscreen,  // UITabViewController 全屏背景色
    TableViewItemTypeNavigationBarModal,                            // 模态窗口
    TableViewItemTypeNavigationBarBlur,                             // 自定义导航栏模糊背景

    TableViewItemTypeNavigationBarDisablePopGesture,                // 禁用边缘手势滑动返回
    TableViewItemTypeNavigationBarFullscreenPopGesture,             // 启用全屏手势滑动返回
    TableViewItemTypeNavigationBarBackEventIntercept,               // 导航栏返回事件拦截
    TableViewItemTypeNavigationBarRedirectViewController,           // 重定向任一视图控制器跳转
    TableViewItemTypeNavigationBarCustom,                           // 完全自定义导航栏
    TableViewItemTypeNavigationBarClickEventHitToBack,              // 导航栏点击事件穿透到底部视图
    TableViewItemTypeNavigationBarScrollChangeNavigationBar,        // 滑动改变导航栏样式
    TableViewItemTypeNavigationBarWebView,                          // WKWebView
    TableViewItemTypeNavigationBarUpdateNavigationBar,              // 更新导航栏样式
};

@interface TableViewItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) TableViewItemType itemType;
@property (nonatomic, assign, getter=showDisclosureIndicator) BOOL disclosureIndicator; // Default: YES

- (instancetype)initWithTitle:(NSString *)title itemType:(TableViewItemType)itemType;

+ (instancetype)itemWithTitle:(NSString *)title itemType:(TableViewItemType)itemType;

@end

@interface TableViewSection : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray<TableViewItem *> *items;

- (instancetype)initWithItems:(NSArray<TableViewItem *> *)items;

+ (instancetype)sectionWithItems:(NSArray<TableViewItem *> *)items;

+ (NSArray<TableViewSection *> *)makeAllSections;

@end

NS_ASSUME_NONNULL_END
