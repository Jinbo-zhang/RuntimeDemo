//
//  UIButton+button.m
//  RuntimeDemo
//
//  Created by zhang jb on 2021/6/24.
//  Copyright © 2021 tayo.com. All rights reserved.
//

#import "UIButton+button.h"
#import <objc/runtime.h>

#define defaultClickInterval 0.5  //默认时间间隔
@interface UIButton (button)

/**
 *  bool YES 忽略点击事件   NO 允许点击事件
 */
@property (nonatomic, assign) BOOL isIgnoreEvent;

@end

//runtime的关联对象的方式 给分类增加属性
@implementation UIButton (button)

//@dynamic acceptEventInterval;
//@dynamic acceptEventTime;


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method normal = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
        Method newMethod = class_getInstanceMethod(self, @selector(my_sendAction:to:forEvent:));
        method_exchangeImplementations(normal, newMethod);
        
    });
}


static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";
/*
//关联对象
void objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy)
//获取关联的对象
id objc_getAssociatedObject(id object, const void *key)
//移除关联的对象
void objc_removeAssociatedObjects(id object)
 */

- (NSTimeInterval)acceptEventInterval {
    return  [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}

- (void)setacceptEventInterval:(NSTimeInterval)acceptEventInterval {
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



static const char *UIControl_acceptEventTime = "UIControl_acceptEventTime";

- (NSTimeInterval)acceptEventTime{
    return  [objc_getAssociatedObject(self, UIControl_acceptEventTime) doubleValue];
}

- (void)setacceptEventTime:(NSTimeInterval)acceptEventTime {
    objc_setAssociatedObject(self, UIControl_acceptEventTime, @(acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)my_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
   // NSLog(@"点击了新的有时间限制的按钮");
    if ([NSDate date].timeIntervalSince1970 - self.acceptEventTime < self.acceptEventInterval) {
        return;
    }

    if (self.acceptEventInterval > 0) {
        self.acceptEventTime = [NSDate date].timeIntervalSince1970;
        
        [self sendAction:action to:target forEvent:event];
    }
    
}
@end
