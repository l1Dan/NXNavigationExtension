//
//  FakeNavigationBar.m
//  NXNavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/27.
//

#import "FakeNavigationBar.h"

#import "UIColor+RandomColor.h"
#import "UIDevice+Additions.h"

@interface FakeNavigationBar ()

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) CGFloat navigationBarAlpha;

@end

@implementation FakeNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addContentView];
    }
    return self;
}

#pragma mark - Private

- (void)addContentView {
    self.backgroundColor = [UIColor clearColor];
    self.titleLabel.alpha = 0.0;

    [self addSubview:self.backButton];
    [self addSubview:self.titleLabel];
    [self addSubview:self.rightButton];
    
    self.backButton.hidden = !UIDevice.isPhoneDevice;
    [self.backButton.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.backButton.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [self.backButton.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [self.backButton.widthAnchor constraintEqualToConstant:UIDevice.isPhoneDevice ? 44 : 0].active = YES;
    
    [self.titleLabel.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.titleLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [self.titleLabel.leftAnchor constraintEqualToAnchor:self.backButton.rightAnchor].active = YES;
    [self.titleLabel.rightAnchor constraintEqualToAnchor:self.rightButton.leftAnchor].active = YES;
    
    [self.rightButton.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.rightButton.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [self.rightButton.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    [self.rightButton.widthAnchor constraintEqualToConstant:44].active = YES;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self updateNavigationBarAlpha:self.navigationBarAlpha];
}

#pragma mark - Setter

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

#pragma mark - Private

- (void)clickBackButton:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(fakeNavigationBar:didClickNavigationItemWithItemType:)]) {
        [self.delegate fakeNavigationBar:self didClickNavigationItemWithItemType:FakeNavigationItemTypeBackButton];
    }
}

- (void)clickRightButton:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(fakeNavigationBar:didClickNavigationItemWithItemType:)]) {
        [self.delegate fakeNavigationBar:self didClickNavigationItemWithItemType:FakeNavigationItemTypeAddButton];
    }
}

#pragma mark - Getter

- (UIButton *)backButton {
    if (!_backButton) {
        UIImage *image = [[UIImage imageNamed:@"NavigationBarBack"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_backButton setImage:image forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(clickBackButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        UIImage *image = [[UIImage imageNamed:@"NavigationBarAdd"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_rightButton setImage:image forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}

#pragma mark - Public
- (void)updateNavigationBarAlpha:(CGFloat)alpha {
    self.navigationBarAlpha = alpha;
    UIColor *whiteColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]; // 不要使用 [UIColor whiteColor]
    UIColor *changeColor = [UIColor customColorWithLightModeColor:^UIColor * _Nonnull{
        return [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]; // ![UIColor blackColor]
    } darkModeColor:^UIColor * _Nonnull{
        return [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]; // ![UIColor redColor]
    }];
    self.backButton.tintColor = [UIColor mixColor1:changeColor color2:whiteColor ratio:alpha];
    self.rightButton.tintColor = [UIColor mixColor1:changeColor color2:whiteColor ratio:alpha];
    self.titleLabel.alpha = alpha;
    self.titleLabel.textColor = changeColor;
}

@end
