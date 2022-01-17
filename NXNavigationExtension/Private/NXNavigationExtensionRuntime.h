//
// NXNavigationExtensionRuntime.h
//
// Copyright (c) 2021 Leo Lee NXNavigationExtension (https://github.com/l1Dan/NXNavigationExtension)
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

// https://github.com/Tencent/QMUI_iOS/blob/0f4a3eb3365c2a43ca175e37bf2cff6703d1b074/QMUIKit/QMUICore/QMUIRuntime.h
// https://github.com/Tencent/QMUI_iOS/blob/0f4a3eb3365c2a43ca175e37bf2cff6703d1b074/QMUIKit/UIKitExtensions/NSString%2BQMUI.h

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

/// 支持 UIEdgeInsets 适配 semanticContentAttribute 属性
/// @param edgeInsets 普通的 UIEdgeInsets 属性
/// @param semanticContentAttribute UISemanticContentAttribute 属性
CG_INLINE UIEdgeInsets
NXDirectionalEdgeInsetsMake(UIEdgeInsets edgeInsets, UISemanticContentAttribute semanticContentAttribute) {
    if (semanticContentAttribute == UISemanticContentAttributeForceRightToLeft) {
        return UIEdgeInsetsMake(edgeInsets.top, edgeInsets.right, edgeInsets.bottom, edgeInsets.left);
    }
    return edgeInsets;
}

/// 将颜色转换成图片
/// @param color UIColor
CG_INLINE UIImage *
NXNavigationExtensionGetImageFromColor(UIColor *color) {
    CGSize size = CGSizeMake(1.0, 1.0);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [color setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/// 根据使用的类查找到最适合的类或者基类，不同于 `isKindOfClass:`
/// @param aClass 需要查找的类
/// @param classes 包含所有待查找的类
CG_INLINE __nullable Class
NXNavigationExtensionLookupClass(__nullable Class aClass, NSArray<Class> *classes) {
    if (!aClass) return nil;
    
    NSString *className = NSStringFromClass(aClass);
    if ([className isEqualToString:NSStringFromClass([UIResponder class])] || [className isEqualToString:NSStringFromClass([NSObject class])]) {
        return nil;
    }
    
    for (Class cls in classes) {
        if ([className isEqualToString:NSStringFromClass(cls)]) {
            return cls;
        }
    }
    
    return NXNavigationExtensionLookupClass([aClass superclass], classes);
}


@interface NSString (NXNavigationExtension)

+ (NSString *)nx_stringByConcat:(id)firstArgv, ...;

@end


@interface NSMethodSignature (NXNavigationExtension)

- (NSString *)nx_typeString;

- (const char *)nx_typeEncoding;

@end

CG_INLINE BOOL
NXNavigationExtensionHasOverrideSuperclassMethod(Class targetClass, SEL targetSelector) {
    Method method = class_getInstanceMethod(targetClass, targetSelector);
    if (!method) return NO;
    
    Method methodOfSuperclass = class_getInstanceMethod(class_getSuperclass(targetClass), targetSelector);
    if (!methodOfSuperclass) return YES;
    
    return method != methodOfSuperclass;
}

/**
 *  用 block 重写某个 class 的指定方法
 *  @param targetClass 要重写的 class
 *  @param targetSelector 要重写的 class 里的实例方法，注意如果该方法不存在于 targetClass 里，则什么都不做
 *  @param implementationBlock 该 block 必须返回一个 block，返回的 block 将被当成 targetSelector 的新实现，所以要在内部自己处理对 super 的调用，以及对当前调用方法的 self 的 class 的保护判断（因为如果 targetClass 的 targetSelector 是继承自父类的，targetClass 内部并没有重写这个方法，则我们这个函数最终重写的其实是父类的 targetSelector，所以会产生预期之外的 class 的影响，例如 targetClass 传进来  UIButton.class，则最终可能会影响到 UIView.class），implementationBlock 的参数里第一个为你要修改的 class，也即等同于 targetClass，第二个参数为你要修改的 selector，也即等同于 targetSelector，第三个参数是一个 block，用于获取 targetSelector 原本的实现，由于 IMP 可以直接当成 C 函数调用，所以可利用它来实现“调用 super”的效果，但由于 targetSelector 的参数个数、参数类型、返回值类型，都会影响 IMP 的调用写法，所以这个调用只能由业务自己写。
 */
CG_INLINE BOOL
NXNavigationExtensionOverrideImplementation(Class targetClass, SEL targetSelector, id (^implementationBlock)(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void))) {
    Method originMethod = class_getInstanceMethod(targetClass, targetSelector);
    IMP imp = method_getImplementation(originMethod);
    BOOL hasOverride = NXNavigationExtensionHasOverrideSuperclassMethod(targetClass, targetSelector);
    
    // 以 block 的方式达到实时获取初始方法的 IMP 的目的，从而避免先 swizzle 了 subclass 的方法，再 swizzle superclass 的方法，会发现前者调用时不会触发后者 swizzle 后的版本的 bug。
    IMP (^originalIMPProvider)(void) = ^IMP(void) {
        IMP result = NULL;
        if (hasOverride) {
            result = imp;
        } else {
            // 如果 superclass 里依然没有实现，则会返回一个 objc_msgForward 从而触发消息转发的流程
            // https://github.com/Tencent/QMUI_iOS/issues/776
            Class superclass = class_getSuperclass(targetClass);
            result = class_getMethodImplementation(superclass, targetSelector);
        }
        
        // 这只是一个保底，这里要返回一个空 block 保证非 nil，才能避免用小括号语法调用 block 时 crash
        // 空 block 虽然没有参数列表，但在业务那边被转换成 IMP 后就算传多个参数进来也不会 crash
        if (!result) {
            result = imp_implementationWithBlock(^(id selfObject) {
                NSLog(([NSString stringWithFormat:@"%@", targetClass]), @"%@ 没有初始实现，%@\n%@", NSStringFromSelector(targetSelector), selfObject, [NSThread callStackSymbols]);
            });
        }
        
        return result;
    };
    
    if (hasOverride) {
        method_setImplementation(originMethod, imp_implementationWithBlock(implementationBlock(targetClass, targetSelector, originalIMPProvider)));
    } else {
        const char *typeEncoding = method_getTypeEncoding(originMethod) ?: [targetClass instanceMethodSignatureForSelector:targetSelector].nx_typeEncoding;
        class_addMethod(targetClass, targetSelector, imp_implementationWithBlock(implementationBlock(targetClass, targetSelector, originalIMPProvider)), typeEncoding);
    }
    
    return YES;
}

/**
 *  用 block 重写某个 class 的某个无参数且返回值为 void 的方法，会自动在调用 block 之前先调用该方法原本的实现。
 *  @param targetClass 要重写的 class
 *  @param targetSelector 要重写的 class 里的实例方法，注意如果该方法不存在于 targetClass 里，则什么都不做，注意该方法必须无参数，返回值为 void
 *  @param implementationBlock targetSelector 的自定义实现，直接将你的实现写进去即可，不需要管 super 的调用。参数 selfObject 代表当前正在调用这个方法的对象，也即 self 指针。
 */
CG_INLINE BOOL
NXNavigationExtensionExtendImplementationOfVoidMethodWithoutArguments(Class targetClass, SEL targetSelector, void (^implementationBlock)(__kindof NSObject *selfObject)) {
    return NXNavigationExtensionOverrideImplementation(targetClass, targetSelector, ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
        void (^block)(__unsafe_unretained __kindof NSObject *selfObject) = ^(__unsafe_unretained __kindof NSObject *selfObject) {
            void (*originSelectorIMP)(id, SEL);
            originSelectorIMP = (void (*)(id, SEL))originalIMPProvider();
            originSelectorIMP(selfObject, originCMD);
            
            implementationBlock(selfObject);
        };
        return block;
    });
}

/**
 *  用 block 重写某个 class 的带一个参数且返回值为 void 的方法，会自动在调用 block 之前先调用该方法原本的实现。
 *  @param _targetClass 要重写的 class
 *  @param _targetSelector 要重写的 class 里的实例方法，注意如果该方法不存在于 targetClass 里，则什么都不做，注意该方法必须带一个参数，返回值为 void
 *  @param _argumentType targetSelector 的参数类型
 *  @param _implementationBlock 格式为 ^(NSObject *selfObject, _argumentType firstArgv) {}，内容即为 targetSelector 的自定义实现，直接将你的实现写进去即可，不需要管 super 的调用。第一个参数 selfObject 代表当前正在调用这个方法的对象，也即 self 指针；第二个参数 firstArgv 代表 targetSelector 被调用时传进来的第一个参数，具体的类型请自行填写
 */
#define NXNavigationExtensionExtendImplementationOfVoidMethodWithSingleArgument(_targetClass, _targetSelector, _argumentType, _implementationBlock) NXNavigationExtensionOverrideImplementation(_targetClass, _targetSelector, ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {\
    return ^(__unsafe_unretained __kindof NSObject *selfObject, _argumentType firstArgv) {\
        \
        void (*originSelectorIMP)(id, SEL, _argumentType);\
        originSelectorIMP = (void (*)(id, SEL, _argumentType))originalIMPProvider();\
        originSelectorIMP(selfObject, originCMD, firstArgv);\
        \
        _implementationBlock(selfObject, firstArgv);\
        };\
    });


NS_ASSUME_NONNULL_END
