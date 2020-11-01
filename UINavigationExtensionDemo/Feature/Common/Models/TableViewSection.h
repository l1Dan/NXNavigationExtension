//
//  TableViewSection.h
//  UINavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TableViewSectionItemType) {
    TableViewSectionItemTypeNavigationBarBackgroundColor, // 修改导航栏背景颜色
    TableViewSectionItemTypeNavigationBarBackgroundImage, // 修改导航栏背景图片
    TableViewSectionItemTypeNavigationBarTransparent, // 设置导航栏透明
    TableViewSectionItemTypeNavigationBarTranslucent, // 设置导航栏半透明
    TableViewSectionItemTypeNavigationBarShadowColor, // 修改导航栏底部线条颜色
    TableViewSectionItemTypeNavigationBarShadowImage, // 修改导航栏底部线条图片
    TableViewSectionItemTypeNavigationBarCustomBackButtonImage, // 自定义返回按钮图片
    TableViewSectionItemTypeNavigationBarCustomBackButton, // 自定义返回按钮
    TableViewSectionItemTypeNavigationBarFullScreen, // 全屏背景色
    TableViewSectionItemTypeNavigationBarScrollView, // ScrollView(self.view) 添加 UENavigationBar
    TableViewSectionItemTypeNavigationBarScrollViewWithFullScreen, // ScrollView(self.view) 全屏背景色
    TableViewSectionItemTypeNavigationBarModal, // 模态窗口
    
    TableViewSectionItemTypeNavigationBarDisablePopGesture, // 禁用手势滑动
    TableViewSectionItemTypeNavigationBarFullPopGesture, // 启用全屏滑动手势
    TableViewSectionItemTypeNavigationBarBackEventIntercept, // 导航栏返回事件拦截
    TableViewSectionItemTypeNavigationBarRedirectViewController, // 重定向任一视图控制器跳转
    TableViewSectionItemTypeNavigationBarCustom, // 完全自定义导航栏
    TableViewSectionItemTypeNavigationBarClickEventHitToBack, // 导航栏点击事件穿透到底部视图
    TableViewSectionItemTypeNavigationBarScrollChangeNavigationBar, // 滑动改变导航栏背景
    TableViewSectionItemTypeNavigationBarWebView, // 使用 WebView 结合 UENavigationBar
    TableViewSectionItemTypeNavigationBarUpdateNavigationBar, // 更新导航栏样式
};

@interface TableViewSectionItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) TableViewSectionItemType itemType;
@property (nonatomic, assign, getter=showDisclosureIndicator) BOOL disclosureIndicator; // Default: YES

- (instancetype)initWithTitle:(NSString *)title itemType:(TableViewSectionItemType)itemType;

+ (instancetype)itemWithTitle:(NSString *)title itemType:(TableViewSectionItemType)itemType;

@end

@interface TableViewSection : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray<TableViewSectionItem *> *items;

- (instancetype)initWithItems:(NSArray<TableViewSectionItem *> *)items;

+ (instancetype)sectionWithItems:(NSArray<TableViewSectionItem *> *)items;

+ (NSArray<TableViewSection *> *)makeAllSections;

@end

NS_ASSUME_NONNULL_END
