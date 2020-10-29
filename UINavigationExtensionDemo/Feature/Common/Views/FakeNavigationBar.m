//
//  FakeNavigationBar.m
//  UINavigationExtensionDemo
//
//  Created by lidan on 2020/10/27.
//

#import "FakeNavigationBar.h"
#import "UIColor+RandomColor.h"

@interface FakeNavigationBar ()

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UILabel *titleLabel;

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
}

#pragma mark - Setter

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

#pragma mark - Private

- (void)ue_triggerSystemBackButtonHandler:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(fakeNavigationBar:didClickNavigationItemwithItemType:)]) {
        [self.delegate fakeNavigationBar:self didClickNavigationItemwithItemType:FakeNavigationItemTypeBackButton];
    }
}

- (void)clickRightButton:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(fakeNavigationBar:didClickNavigationItemwithItemType:)]) {
        [self.delegate fakeNavigationBar:self didClickNavigationItemwithItemType:FakeNavigationItemTypeAddButton];
    }
}

#pragma mark - Getter

- (UIButton *)backButton {
    if (!_backButton) {
        UIImage *image = [[UIImage imageNamed:@"NavigationBarBack"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(0, 0, 44, 44);
        [_backButton setImage:image forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(ue_triggerSystemBackButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        UIImage *image = [[UIImage imageNamed:@"NavigationBarAdd"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 8, 0, 44, 44);
        [_rightButton setImage:image forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        CGFloat padding = 44 + 8;
        CGFloat width = CGRectGetWidth(self.frame) - padding * 2.0;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, 0, width, 44)];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor customDarkGrayColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}

#pragma mark - Public
- (void)updateNavigationBarAlpha:(CGFloat)alpha {
    UIColor *whiteColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]; // 不要使用 [UIColor whiteColor]
    self.backButton.tintColor = [UIColor mixColor1:[UIColor customDarkGrayColor] color2:whiteColor ratio:alpha];
    self.rightButton.tintColor = [UIColor mixColor1:[UIColor customDarkGrayColor] color2:whiteColor ratio:alpha];
    self.titleLabel.alpha = alpha;
}

@end
