//
// UINavigationExtension.h
//
// Copyright (c) 2020 Leo Lee UINavigationExtension (https://github.com/l1Dan/UINavigationExtension)
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

#ifndef UINavigationExtension_h
#define UINavigationExtension_h

#if __has_include(<UINavigationExtension/UINavigationExtension.h>)

//! Project version number for UINavigationExtension.
FOUNDATION_EXPORT double UINavigationExtensionVersionNumber;

//! Project version string for UINavigationExtension.
FOUNDATION_EXPORT const unsigned char UINavigationExtensionVersionString[];

#import <UINavigationExtension/UENavigationBar.h>
#import <UINavigationExtension/UINavigationExtensionMacro.h>
#import <UINavigationExtension/UINavigationController+UINavigationExtension.h>
#import <UINavigationExtension/UIViewController+UINavigationExtension.h>
#else

#import "UENavigationBar.h"
#import "UINavigationExtensionMacro.h"
#import "UINavigationController+UINavigationExtension.h"
#import "UIViewController+UINavigationExtension.h"

#endif /* __has_include */

#endif /* UINavigationExtension_h */
