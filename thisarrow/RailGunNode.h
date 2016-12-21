//
//  RailGunNode.h
//  thisarrow
//
//  Created by iMac206 on 16/12/21.
//  Copyright © 2016年 jamstudio. All rights reserved.
//

#import "WeaponNode.h"

@interface RailGunNode : WeaponNode

-(void)loadedToGun:(SKNode*)node;

-(void)shootFromPoint:(CGPoint)poi direction:(CGFloat)radian;

@end
