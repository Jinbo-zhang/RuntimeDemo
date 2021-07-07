//
//  SourceBlock.h
//  RuntimeDemo
//
//  Created by zhang jb on 2020/8/6.
//  Copyright © 2020 tayo.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MyBlock)(NSString *);

typedef void(^VoidBlock)(NSString *);

@interface SourceBlock : NSObject

-(id)initWithMyBlock:(MyBlock )myBlock withVoidBlock:(VoidBlock)voidBlock;

-(void)userMyBolck:(NSString *)str1 voidBlock:(NSString *)str2;

@end

NS_ASSUME_NONNULL_END
