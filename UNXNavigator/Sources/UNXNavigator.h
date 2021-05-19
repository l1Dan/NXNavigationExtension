//
// UNXNavigator.h
//
// Copyright (c) 2021 Leo Lee UNXNavigator (https://github.com/l1Dan/UNXNavigator)
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

#ifndef UNXNavigator_h
#define UNXNavigator_h

#if __has_include(<UNXNavigator/UNXNavigator.h>)

//! Project version number for UNXNavigator.
FOUNDATION_EXPORT double UNXNavigatorVersionNumber;

//! Project version string for UNXNavigator.
FOUNDATION_EXPORT const unsigned char UNXNavigatorVersionString[];

#import <UNXNavigator/UINavigationController+UNXNavigator.h>
#import <UNXNavigator/UIViewController+UNXNavigator.h>
#import <UNXNavigator/UNXNavigationBar.h>

#else

#import "UINavigationController+UNXNavigator.h"
#import "UIViewController+UNXNavigator.h"
#import "UNXNavigationBar.h"

#endif /* __has_include */

#endif /* UNXNavigator_h */
