//
//  BaseTableViewController.m
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/8/14.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)dealloc {
    NSLog(@"Dealloced: %@", NSStringFromClass([self class]));
}

@end
