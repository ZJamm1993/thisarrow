//
//  WeaponNode.m
//  thisarrow
//
//  Created by iMac206 on 16/12/21.
//  Copyright © 2016年 jamstudio. All rights reserved.
//

#import "WeaponNode.h"

@implementation WeaponNode

-(void)disappear
{
    [self runAction:[SKAction scaleTo:0.1 duration:0.25] completion:^{
        [self removeFromParent];
    }];
}

@end
