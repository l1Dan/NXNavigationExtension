//
// NXNavigationExtensionHeaders.h
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

#ifndef NXNavigationExtensionHeaders_h
#define NXNavigationExtensionHeaders_h

#import <NXNavigationBar.h>

#import <NXNavigationConfiguration.h>


@interface NXNavigationBar ()

/// 是否使用 NXNavigationBar 背景模糊效果；默认 NO
@property (nonatomic, assign) BOOL blurEffectEnabled;

@end


@interface NXViewControllerPreferences ()

/// 当前视图控制器的 traitCollection 对象
@property (nonatomic, strong) UITraitCollection *traitCollection;

@end

#endif /* NXNavigationExtensionHeaders_h */
