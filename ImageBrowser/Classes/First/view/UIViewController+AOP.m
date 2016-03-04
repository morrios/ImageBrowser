//
//  UIViewController+AOP.m
//  ImageBrowser
//
//  Created by adu on 16/1/6.
//  Copyright © 2016年 adu. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "UIViewController+AOP.h"
#import <objc/runtime.h>

@implementation UIViewController (AOP)

+(void)load1{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        swizzleMethod(class, @selector(viewDidLoad), @selector(aop_viewDidLoad));
        swizzleMethod(class, @selector(viewDidAppear:), @selector(aop_viewDidAppear:));
        swizzleMethod(class, @selector(viewWillAppear:), @selector(aop_viewWillAppear:));
        swizzleMethod(class, @selector(viewWillDisappear:), @selector(aop_viewWillDisappear:));
        
    });
}

void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector){
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(swizzledMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
}

- (void)aop_viewDidAppear:(BOOL)animated{
    [self aop_viewDidAppear:animated];
    NSLog(@"aop_viewDidAppear");
}
- (void)aop_viewWillAppear:(BOOL)animated{
    [self aop_viewWillAppear:animated];
    NSLog(@"aop_viewWillAppear");

}
- (void)aop_viewWillDisappear:(BOOL)animated{
    [self aop_viewWillDisappear:animated];
    NSLog(@"aop_viewWillDisappear");
}
- (void)aop_viewDidLoad{
    [self aop_viewDidLoad];
    NSLog(@"aop_viewDidLoad");
}


@end
