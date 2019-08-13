//
//  DotNode.h
//  thisarrow
//
//  Created by jam on 16-12-24.
//  Copyright (c) 2016年 jamstudio. All rights reserved.
//

#import "ZZSpriteNode.h"
#import "ArrowNode.h"
#import "WeaponNode.h"
#import "MegaBombNode.h"
#import "RailGunNode.h"
#import "MissileTrackNode.h"
#import "GreenCoverNode.h"
#import "ElectricSawNode.h"
#import "FreezeNode.h"

FOUNDATION_EXPORT const CGFloat defaultFollowSpeed;
FOUNDATION_EXPORT const CGFloat defaultTopSpeed;
FOUNDATION_EXPORT const CGFloat defaultSlowDownRate;
FOUNDATION_EXPORT const CGFloat defaultFastUpRate;
FOUNDATION_EXPORT const CGFloat defaultReboundRate;
FOUNDATION_EXPORT const CGFloat defaultPointerSpeed;

typedef NS_ENUM(NSInteger,DotGroupType)
{
    DotGroupTypeQueue,
    DotGroupTypeSurround,
    DotGroupTypePointer,
//    DotGroupTypeTennis,
//    DotGroupType
    DotGroupTypeNothing,  // default
};

@interface DotNode : ZZSpriteNode
{
    ZZSpriteNode* shadow;
    NSArray* pointerGroup;
}

@property (nonatomic,assign) BOOL isFreeze;
@property (nonatomic,assign) BOOL isDead;
@property (nonatomic,assign) BOOL isAwake;
@property (nonatomic,assign) CGFloat followSpeed;
@property (nonatomic,assign) DotGroupType groupType;
@property (nonatomic,assign) CGPoint originPoint;

+(instancetype)defaultNode;
+(CGFloat)defaultWidth;
+(instancetype)randomPositionNodeOnSize:(CGSize)size;

-(void)actionWithTarget:(SKNode*)node;
+(SKAction*)wakeUpAction;
-(void)wakeUp;
-(void)beKilledByWeapon:(WeaponNode*)weapon;
-(void)shootPointer;
-(void)bleeding;

@end
