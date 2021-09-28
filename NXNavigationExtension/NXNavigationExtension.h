//
// NXNavigationExtension.h
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

#import <Foundation/Foundation.h>

#ifndef NXNavigationExtension_h
#define NXNavigationExtension_h

#if __has_include(<NXNavigationExtension/NXNavigationExtension.h>)

//! Project version number for NXNavigationExtension.
FOUNDATION_EXPORT double NXNavigationExtensionVersionNumber;

//! Project version string for NXNavigationExtension.
FOUNDATION_EXPORT const unsigned char NXNavigationExtensionVersionString[];

#import <NXNavigationExtension/NXNavigationBar.h>
#import <NXNavigationExtension/UINavigationController+NXNavigationExtension.h>
#import <NXNavigationExtension/UIViewController+NXNavigationExtension.h>
#import <NXNavigationExtension/NXNavigationExtension+Deprecated.h>

#else

#import "NXNavigationBar.h"
#import "UINavigationController+NXNavigationExtension.h"
#import "UIViewController+NXNavigationExtension.h"
#import "NXNavigationExtension+Deprecated.h"

#endif /* __has_include */

#endif /* NXNavigationExtension_h */
