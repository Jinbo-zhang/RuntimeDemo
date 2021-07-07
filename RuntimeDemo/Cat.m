//
//  Cat.m
//  RuntimeDemo
//
//  Created by zhang jb on 2020/7/2.
//  Copyright © 2020 tayo.com. All rights reserved.
//

#import "Cat.h"
#import <objc/message.h>

 //iOS 动态添加方法和消息转发

@implementation Cat

/**  +resolveInstanceMethod: 对象方法未找到时 调用        +resolveClassMethod: 类方法未找到时 调用
   *  当调用了没有实现的方法没有实现就会调用
   *
   *  @param sel 没有实现方法
   *
   *  @return 如果方法被发现并添加return：Yes 否则NO
   */
+(BOOL)resolveInstanceMethod:(SEL)sel{
    if (sel == @selector(eat:)) {
        
        /**
         *  动态添加方法
         *
         *  param self cls:为哪个类添加方法
         *  param sel  SEL:添加方法的方法编号（方法名）是什么
         *  param IMP  IMP:方法实现
         *  param const char * types方法类型
         *
         *  return 返回是否添加成功
         */
        BOOL isSuccess = class_addMethod(self, sel, (IMP)eat, "v@:@");//”v@:”意思就是这已是一个void类型的方法，有对象传入。
        
        return isSuccess;
        
    }
    
    return [super resolveInstanceMethod:sel];
}

void eat(id self, SEL _cmd, NSString *param){
   NSLog(@"调用eat 参数：1%@ 参数2：%@ 参数3：%@",self,NSStringFromSelector(_cmd),param);
}

@end

