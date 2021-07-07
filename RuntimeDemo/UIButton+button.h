//
//  UIButton+button.h
//  RuntimeDemo
//
//  Created by zhang jb on 2021/6/24.
//  Copyright © 2021 tayo.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (button)

@property (nonatomic, assign) NSTimeInterval acceptEventInterval; // 时间间隔
@property (nonatomic, assign) NSTimeInterval acceptEventTime;

@end


NS_ASSUME_NONNULL_END
