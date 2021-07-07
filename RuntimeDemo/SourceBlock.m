//
//  SourceBlock.m
//  RuntimeDemo
//
//  Created by zhang jb on 2020/8/6.
//  Copyright © 2020 tayo.com. All rights reserved.
//

#import "SourceBlock.h"

@interface SourceBlock()

@property (nonatomic, copy) MyBlock myBlock;

@property (nonatomic, copy) VoidBlock voidBlock;


@end

@implementation SourceBlock


-(id)initWithMyBlock:(MyBlock )myBlock withVoidBlock:(VoidBlock)voidBlock{
    if(self =[super init]){
        _myBlock=[myBlock copy];
        _voidBlock=[voidBlock copy];
    }
    return self;
};

-(void)userMyBolck:(NSString *)str1 voidBlock:(NSString *)str2{
    
    if (self.myBlock) {
        self.myBlock(str1);
    }
    if (self.voidBlock) {
        self.voidBlock(str2);
    }
}
@end
