//
//  ViewController08_WebView.m
//  UNXNavigatorDemo
//
//  Created by Leo Lee on 2020/10/27.
//

#import <WebKit/WebKit.h>
#import <UNXNavigator/UNXNavigator.h>

#import "ViewController08_WebView.h"

#import "UIColor+RandomColor.h"
#import "UIDevice+Additions.h"

@interface ViewController08_WebView () <WKNavigationDelegate, UNXNavigatorInteractable>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) NSURL *requestURL;
@property (nonatomic, strong) UIBarButtonItem *backBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *closeBarButtonItem;

@end

@implementation ViewController08_WebView

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _requestURL = [NSURL URLWithString:@"https://l1dan.gitee.io/"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Loading...";
    
    if (UIDevice.isPhoneDevice) {
        self.navigationItem.leftBarButtonItems = @[self.backBarButtonItem];
    }
    [self.view addSubview:self.webView];
    [self.unx_navigationBar addSubview:self.progressView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.requestURL]];
    
    [self.progressView.topAnchor constraintEqualToAnchor:self.unx_navigationBar.bottomAnchor].active = YES;
    [self.progressView.leftAnchor constraintEqualToAnchor:self.unx_navigationBar.leftAnchor].active = YES;
    [self.progressView.rightAnchor constraintEqualToAnchor:self.unx_navigationBar.rightAnchor].active = YES;
    [self.progressView.heightAnchor constraintEqualToConstant:1.0 / [UIScreen mainScreen].scale].active = YES;
    
    [self.webView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.webView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.webView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [self.webView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    
    if (@available(iOS 13.0, *)) {
        self.webView.backgroundColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (self.view.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                self.webView.opaque = NO;
                return [UIColor clearColor];
            }
            self.webView.opaque = YES;
            return [UIColor whiteColor];
        }];
    } else {
        self.webView.opaque = YES;
        self.webView.backgroundColor = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress" context:NULL];
    [self.webView removeObserver:self forKeyPath:@"title" context:NULL];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.progressView setHidden:YES];
}

- (BOOL)unx_useSystemBlurNavigationBar {
    return YES;
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - Observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"] && object == self.webView) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        
        __weak typeof (self)weakSelf = self;
        if(self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [weakSelf.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [weakSelf.progressView setProgress:0.0f animated:NO];
            }];
        }
    } else if ([keyPath isEqualToString:@"title"] && object == self.webView) {
        self.navigationItem.title = self.webView.title;
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Action

- (void)clickBackButton:(UIButton *)button {
    if (UIDevice.isPhoneDevice) {
        [self.navigationController unx_triggerSystemBackButtonHandler];
    } else {
        if ([self.webView canGoBack]) {
            [self.webView goBack];
        }
    }
}

- (void)clickCloseButton:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Getter

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.trackTintColor = [UIColor customLightGrayColor];
        _progressView.progressTintColor = [UIColor customDarkGrayColor];
        _progressView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _progressView;
}

- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.preferences.minimumFontSize = 9.0;
        configuration.preferences.javaScriptEnabled = YES;
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        _webView.translatesAutoresizingMaskIntoConstraints = NO;
        _webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        _webView.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _webView.allowsBackForwardNavigationGestures = YES;
        _webView.gestureRecognizers.lastObject.enabled = NO;
        _webView.navigationDelegate = self;
    }
    return _webView;
}

- (UIBarButtonItem *)backBarButtonItem {
    if (!_backBarButtonItem) {
        UIButton *customView = [UIButton buttonWithType:UIButtonTypeCustom];
        [customView setImage:[[UIImage imageNamed:@"NavigationBarBack"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [customView setTintColor:UIColor.customTitleColor];
        [customView sizeToFit];
        [customView addTarget:self action:@selector(clickBackButton:) forControlEvents:UIControlEventTouchUpInside];
        _backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    }
    return _backBarButtonItem;
}

- (UIBarButtonItem *)closeBarButtonItem {
    if (!_closeBarButtonItem) {
        UIButton *customView = [UIButton buttonWithType:UIButtonTypeCustom];
        [customView setImage:[[UIImage imageNamed:@"NavigationBarClose"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [customView setTintColor:UIColor.customTitleColor];
        [customView sizeToFit];
        [customView addTarget:self action:@selector(clickCloseButton:) forControlEvents:UIControlEventTouchUpInside];
        _closeBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    }
    return _closeBarButtonItem;
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (UIDevice.isPhoneDevice) {
        if (webView.canGoBack) {
            self.navigationItem.leftBarButtonItems = @[self.backBarButtonItem, self.closeBarButtonItem];
        } else {
            self.navigationItem.leftBarButtonItems = @[self.backBarButtonItem];
        }
    } else {
        if (webView.canGoBack) {
            self.navigationItem.leftBarButtonItems = @[self.backBarButtonItem];
        } else {
            self.navigationItem.leftBarButtonItems = nil;
        }
    }
}

#pragma mark - UNXNavigatorInteractable

- (BOOL)navigationController:(__kindof UINavigationController *)navigationController willPopViewControllerUsingInteractingGesture:(BOOL)interactingGesture {
    if (!interactingGesture && self.webView.canGoBack) {
        [self.webView goBack];
        return NO;
    }
    return YES;
}

@end
