//
//  BaseViewController.h
//  UINavigationExtensionDemo
//
//  Created by Leo Lee on 2020/9/22.
//

#import <UINavigationExtension/UINavigationExtension.h>

#import "UIColor+RandomColor.h"

@interface BaseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong, readonly) UITableView *tableView;

@end
