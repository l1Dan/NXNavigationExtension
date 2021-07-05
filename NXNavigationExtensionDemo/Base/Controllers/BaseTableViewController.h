//
//  BaseTableViewController.h
//  NXNavigationExtensionDemo
//
//  Created by Leo Lee on 2020/9/22.
//

#import "BaseViewController.h"

@interface BaseTableViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong, readonly) UITableView *tableView;

@end
