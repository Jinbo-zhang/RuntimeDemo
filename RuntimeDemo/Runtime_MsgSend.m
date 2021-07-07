//
//  Runtime_MsgSend.m
//  RuntimeDemo
//
//  Created by zhang jb on 2021/6/24.
//  Copyright © 2021 tayo.com. All rights reserved.
//

#import "Runtime_MsgSend.h"
#include "objc/runtime.h"

@interface Runtime_MsgSend ()

@end

@implementation Runtime_MsgSend

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.0消息动态解析
    //1.2 执行 fun 函数
    [self performSelector:@selector(fun)];
    
    //2.0 消息接受者重定向
}
/*1.0消息动态解析
// 类方法未找到时调起，可以在此添加方法实现
+ (BOOL)resolveClassMethod:(SEL)sel;
// 对象方法未找到时调起，可以在此添加方法实现
+ (BOOL)resolveInstanceMethod:(SEL)sel;
 
 
 // 重定向类方法的消息接收者，返回一个类或实例对象
 + (id)forwardingTargetForSelector:(SEL)aSelector;
 // 重定向方法的消息接收者，返回一个类或实例对象
 - (id)forwardingTargetForSelector:(SEL)aSelector;
 
  * class_addMethod    向具有给定名称和实现的类中添加新方法
  * @param cls         被添加方法的类
  * @param name        selector 方法名
  * @param imp         实现方法的函数指针
  * @param types imp   指向函数的返回值与参数类型
  * @return            如果添加方法成功返回 YES，否则返回 NO
  
 BOOL class_addMethod(Class cls, SEL name, IMP imp,
                 const char * _Nullable types);
*/

//1.3重写 resolveInstanceMethod: 添加对象方法实现
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(fun)) { // 如果是执行 fun 函数，就动态解析，指定新的 IMP
        class_addMethod([self class], sel, (IMP)funMethod, "v@:");
        return YES;
      
    }
    return [super resolveInstanceMethod:sel];
}
//1.4 定义方法
void funMethod(id obj, SEL _cmd) {
    NSLog(@"funMethod"); //新的 fun 函数
}

@end
