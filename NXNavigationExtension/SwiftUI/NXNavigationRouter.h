//
// NXNavigationRouter.h
//
// Copyright (c) 2020 Leo Lee NXNavigationExtension (https://github.com/l1Dan/NXNavigationExtension)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

API_AVAILABLE(ios(13.0), tvos(13.0))
@protocol NXNavigationContext <NSObject>

@property (nonatomic, copy, nullable) NSString *routeName;

@property (nonatomic, weak, nullable, readonly) __kindof UIViewController *hostingController;

@end


API_AVAILABLE(ios(13.0), tvos(13.0))
@interface NXNavigationRouter : NSObject

@property (nonatomic, strong, readonly) NXNavigationRouter *nx;

+ (instancetype)of:(id<NXNavigationContext>)context;

- (void)addContext:(id<NXNavigationContext>)context;

- (void)removeContext:(id<NXNavigationContext>)context;

- (void)setNeedsNavigationBarAppearanceUpdate;

- (BOOL)popWithRouteName:(nullable NSString *)routeName animated:(BOOL)animated NS_REFINED_FOR_SWIFT;

@end

NS_ASSUME_NONNULL_END
