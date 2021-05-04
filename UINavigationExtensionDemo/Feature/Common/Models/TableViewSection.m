//
//  TableViewSection.m
//  UINavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/25.
//

#import "TableViewSection.h"

@implementation TableViewSectionItem

- (instancetype)initWithTitle:(NSString *)title itemType:(TableViewSectionItemType)itemType {
    if (self = [super init]) {
        _title = title;
        _itemType = itemType;
        _disclosureIndicator = itemType == TableViewSectionItemTypeNavigationBarModal ? NO : YES;
    }
    return self;
}

+ (instancetype)itemWithTitle:(NSString *)title itemType:(TableViewSectionItemType)itemType {
    return [[self alloc] initWithTitle:title itemType:itemType];
}

@end

@implementation TableViewSection

- (instancetype)initWithItems:(NSArray<TableViewSectionItem *> *)items {
    if (self = [super init]) {
        _items = items;
    }
    return self;
}

+ (instancetype)sectionWithItems:(NSArray<TableViewSectionItem *> *)items {
    return [[self alloc] initWithItems:items];
}

+ (NSArray<TableViewSection *> *)makeAllSections {
    NSMutableArray *items1 = [NSMutableArray arrayWithObjects:
                              [TableViewSectionItem itemWithTitle:@"修改导航栏背景颜色" itemType:TableViewSectionItemTypeNavigationBarBackgroundColor],
                              [TableViewSectionItem itemWithTitle:@"修改导航栏背景图片" itemType:TableViewSectionItemTypeNavigationBarBackgroundImage],
                              [TableViewSectionItem itemWithTitle:@"设置导航栏透明" itemType:TableViewSectionItemTypeNavigationBarTransparent],
                              [TableViewSectionItem itemWithTitle:@"设置导航栏半透明" itemType:TableViewSectionItemTypeNavigationBarTranslucent],
                              [TableViewSectionItem itemWithTitle:@"设置导航栏底部线条颜色" itemType:TableViewSectionItemTypeNavigationBarShadowColor],
                              [TableViewSectionItem itemWithTitle:@"设置导航栏底部线条图片" itemType:TableViewSectionItemTypeNavigationBarShadowImage],
                              [TableViewSectionItem itemWithTitle:@"自定义返回按钮图片" itemType:TableViewSectionItemTypeNavigationBarCustomBackButtonImage],
                              [TableViewSectionItem itemWithTitle:@"自定义返回按钮" itemType:TableViewSectionItemTypeNavigationBarCustomBackButton],
                              [TableViewSectionItem itemWithTitle:@"全屏背景色" itemType:TableViewSectionItemTypeNavigationBarFullScreen],
                              [TableViewSectionItem itemWithTitle:@"UIScrollView with UENavigationBar" itemType:TableViewSectionItemTypeNavigationBarScrollView],
                              [TableViewSectionItem itemWithTitle:@"UIScrollView 全屏背景色" itemType:TableViewSectionItemTypeNavigationBarScrollViewWithFullScreen],
                              [TableViewSectionItem itemWithTitle:@"模态窗口" itemType:TableViewSectionItemTypeNavigationBarModal],
                              [TableViewSectionItem itemWithTitle:@"自定义导航栏模糊背景" itemType:TableViewSectionItemTypeNavigationBarBlur],
                              nil];
    TableViewSection *section1 = [TableViewSection sectionWithItems:items1];
    section1.title = @"基础功能";
    
    NSMutableArray *items2 = [NSMutableArray arrayWithObjects:
                              [TableViewSectionItem itemWithTitle:@"禁用边缘手势滑动返回" itemType:TableViewSectionItemTypeNavigationBarDisablePopGesture],
                              [TableViewSectionItem itemWithTitle:@"启用全屏手势滑动返回" itemType:TableViewSectionItemTypeNavigationBarFullPopGesture],
                              [TableViewSectionItem itemWithTitle:@"导航栏返回事件拦截" itemType:TableViewSectionItemTypeNavigationBarBackEventIntercept],
                              [TableViewSectionItem itemWithTitle:@"重定向任一视图控制器跳转" itemType:TableViewSectionItemTypeNavigationBarRedirectViewController],
                              [TableViewSectionItem itemWithTitle:@"完全自定义导航栏" itemType:TableViewSectionItemTypeNavigationBarCustom],
                              [TableViewSectionItem itemWithTitle:@"导航栏点击事件穿透到底部视图" itemType:TableViewSectionItemTypeNavigationBarClickEventHitToBack],
                              [TableViewSectionItem itemWithTitle:@"滑动改变导航栏样式" itemType:TableViewSectionItemTypeNavigationBarScrollChangeNavigationBar],
                              [TableViewSectionItem itemWithTitle:@"WKWebView with UENavigationBar" itemType:TableViewSectionItemTypeNavigationBarWebView],
                              [TableViewSectionItem itemWithTitle:@"更新导航栏样式" itemType:TableViewSectionItemTypeNavigationBarUpdateNavigationBar],
                              nil];
    TableViewSection *section2 = [TableViewSection sectionWithItems:items2];
    section2.title = @"高级功能";
    
    return [NSMutableArray arrayWithObjects:section1, section2, nil];
}

@end
