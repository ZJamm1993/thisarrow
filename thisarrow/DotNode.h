//
//  DotNode.h
//  thisarrow
//
//  Created by jam on 16-12-24.
//  Copyright (c) 2016年 jamstudio. All rights reserved.
//

#import "ZZSpriteNode.h"
#import "WeaponNode.h"
#import "MegaBombNode.h"
#import "RailGunNode.h"

@interface DotNode : ZZSpriteNode

@property (nonatomic,assign) BOOL isGrouping;
@property (nonatomic,assign) BOOL isDead;
@property (nonatomic,assign) BOOL isAwake;

+(instancetype)defaultNode;
+(instancetype)groupingNode;

-(void)actionWithTarget:(SKNode*)node;
-(void)wakeUp;
-(void)beKilledByWeapon:(WeaponNode*)weapon;

@end
