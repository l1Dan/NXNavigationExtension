//
//  TableViewSection.m
//  NXNavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/25.
//

#import "TableViewSection.h"

@implementation TableViewItem

- (instancetype)initWithTitle:(NSString *)title itemType:(TableViewItemType)itemType {
    if (self = [super init]) {
        _title = title;
        _itemType = itemType;
        _disclosureIndicator = itemType == TableViewItemTypeNavigationBarModal ? NO : YES;
    }
    return self;
}

+ (instancetype)itemWithTitle:(NSString *)title itemType:(TableViewItemType)itemType {
    return [[self alloc] initWithTitle:title itemType:itemType];
}

@end

@implementation TableViewSection

- (instancetype)initWithItems:(NSArray<TableViewItem *> *)items {
    if (self = [super init]) {
        _items = items;
    }
    return self;
}

+ (instancetype)sectionWithItems:(NSArray<TableViewItem *> *)items {
    return [[self alloc] initWithItems:items];
}

+ (NSArray<TableViewSection *> *)makeAllSections {
    NSArray *items1 = @[
        [TableViewItem itemWithTitle:@"修改导航栏背景颜色" itemType:TableViewItemTypeNavigationBarBackgroundColor],
        [TableViewItem itemWithTitle:@"修改导航栏背景图片" itemType:TableViewItemTypeNavigationBarBackgroundImage],
        [TableViewItem itemWithTitle:@"设置导航栏透明" itemType:TableViewItemTypeNavigationBarTransparent],
        [TableViewItem itemWithTitle:@"实现系统导航栏模糊效果" itemType:TableViewItemTypeLikeSystemBlurNavigationBar],
        [TableViewItem itemWithTitle:@"设置导航栏底部线条颜色" itemType:TableViewItemTypeNavigationBarShadowColor],
        [TableViewItem itemWithTitle:@"设置导航栏底部线条图片" itemType:TableViewItemTypeNavigationBarShadowImage],
        [TableViewItem itemWithTitle:@"自定义返回按钮图片" itemType:TableViewItemTypeNavigationBarCustomBackButtonImage],
        [TableViewItem itemWithTitle:@"自定义返回按钮" itemType:TableViewItemTypeNavigationBarCustomBackButton],
        [TableViewItem itemWithTitle:@"全屏背景色" itemType:TableViewItemTypeNavigationBarFullscreen],
        [TableViewItem itemWithTitle:@"UITabViewController" itemType:TableViewItemTypeNavigationBarTabViewController],
        [TableViewItem itemWithTitle:@"UITabViewController 全屏背景色" itemType:TableViewItemTypeNavigationBarTabViewControllerWithFullscreen],
        [TableViewItem itemWithTitle:@"模态窗口" itemType:TableViewItemTypeNavigationBarModal],
        [TableViewItem itemWithTitle:@"自定义导航栏模糊背景" itemType:TableViewItemTypeNavigationBarBlur],
    ];
    TableViewSection *section1 = [TableViewSection sectionWithItems:items1];
    section1.title = @"基础功能";
    
    NSArray *items2 = @[
        [TableViewItem itemWithTitle:@"禁用边缘手势滑动返回" itemType:TableViewItemTypeNavigationBarDisablePopGesture],
        [TableViewItem itemWithTitle:@"启用全屏手势滑动返回" itemType:TableViewItemTypeNavigationBarFullscreenPopGesture],
        [TableViewItem itemWithTitle:@"导航栏返回事件拦截" itemType:TableViewItemTypeNavigationBarBackEventIntercept],
        [TableViewItem itemWithTitle:@"重定向任一视图控制器跳转" itemType:TableViewItemTypeNavigationBarRedirectViewController],
        [TableViewItem itemWithTitle:@"完全自定义导航栏" itemType:TableViewItemTypeNavigationBarCustom],
        [TableViewItem itemWithTitle:@"导航栏点击事件穿透到底部视图" itemType:TableViewItemTypeNavigationBarClickEventHitToBack],
        [TableViewItem itemWithTitle:@"滑动改变导航栏样式" itemType:TableViewItemTypeNavigationBarScrollChangeNavigationBar],
        [TableViewItem itemWithTitle:@"WKWebView" itemType:TableViewItemTypeNavigationBarWebView],
        [TableViewItem itemWithTitle:@"更新导航栏样式" itemType:TableViewItemTypeNavigationBarUpdateNavigationBar],
    ];
    TableViewSection *section2 = [TableViewSection sectionWithItems:items2];
    section2.title = @"高级功能";
    
    return [NSMutableArray arrayWithObjects:section1, section2, nil];
}

@end
