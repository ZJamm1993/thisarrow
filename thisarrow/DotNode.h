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
#import "MissileTrackNode.h"

typedef NS_ENUM(NSInteger,DotGroupType)
{
    DotGroupTypeSurround,
    DotGroupTypeNothing,  // default
};

@interface DotNode : ZZSpriteNode

@property (nonatomic,assign) BOOL isDead;
@property (nonatomic,assign) BOOL isAwake;
@property (nonatomic,assign) CGFloat followSpeed;
@property (nonatomic,assign) DotGroupType groupType;

+(instancetype)defaultNode;
+(NSArray*)randomGroupNodeWithDots:(NSArray*)dots target:(SKNode*)target;

-(void)actionWithTarget:(SKNode*)node;
-(void)wakeUp;
-(void)beKilledByWeapon:(WeaponNode*)weapon;

@end
