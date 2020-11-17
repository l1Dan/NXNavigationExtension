//
//  AppDelegate.m
//  UINavigationExtensionDemo
//
//  Created by Leo Lee on 2020/9/22.
//

#import "AppDelegate.h"
#import "BaseSplitViewController.h"
#import "UIColor+RandomColor.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor customBackgroundColor];
    self.window.rootViewController = [[BaseSplitViewController alloc] init];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end
