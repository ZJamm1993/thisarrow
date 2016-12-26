//
//  GameScene.m
//  thisarrow
//
//  Created by jam on 16/12/12.
//  Copyright (c) 2016年 jamstudio. All rights reserved.
//

#import "GameScene.h"
#import "ArrowNode.h"
#import "PickUpNode.h"
#import "WeaponNode.h"
#import "DotNode.h"

const CFTimeInterval frequentPickUp=0.1;
const CFTimeInterval pickUpLifeTime=8;
const NSInteger maxPickUpCount=10;
const NSInteger maxDotCount=20;
const CGFloat safeZoneRadius=32;

@interface GameScene()

@end

@implementation GameScene
{
    CMMotionManager* _motionManager;
    ArrowNode* arrow;
    CFTimeInterval currentTimeInterval;
}

-(void)didMoveToView:(SKView *)view {
    
    self.backgroundColor=[SKColor cyanColor];
    arrow=[ArrowNode defaultNode];
    arrow.position=CGPointMake(self.size.width/2, self.size.height/2);
    arrow.zPosition=Arrow_Z_Position;
    [self addChild:arrow];
    
    _motionManager=[[CMMotionManager alloc]init];
    [_motionManager startAccelerometerUpdates];
    [_motionManager setAccelerometerUpdateInterval:1/60.0];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(![_motionManager isAccelerometerAvailable])
    {
        UITouch* touch=[touches anyObject];
        CGPoint p=[touch locationInNode:self];
        [arrow actionWithPoint:p];
    }
}

-(void)addPickUp
{
    PickUpNode* pick=[PickUpNode randomNode];
    pick.createTime=currentTimeInterval+ZZRandom_0_1()*5;
    CGFloat r=pick.size.width/2;
    CGFloat x=(arc4random()%(int)(self.size.width-2*r));
    CGFloat y=(arc4random()%(int)(self.size.height-2*r));
    CGFloat dx=x-arrow.position.x;
    CGFloat dy=y-arrow.position.y;
    CGFloat duration=sqrtf(dx*dx+dy*dy);
    if (duration<safeZoneRadius) {
        [self addPickUp];
    }
    else
    {
        CGPoint p=CGPointMake(r+x, r+y);
        pick.position=p;
        [self addChild:pick];
    }
}

-(void)addDot
{
    DotNode* dot=[DotNode defaultNode];
    CGFloat r=dot.size.width/2;
    CGFloat x=(arc4random()%(int)(self.size.width-2*r));
    CGFloat y=(arc4random()%(int)(self.size.height-2*r));
    CGFloat dx=x-arrow.position.x;
    CGFloat dy=y-arrow.position.y;
    CGFloat duration=sqrtf(dx*dx+dy*dy);
    if (duration<safeZoneRadius) {
        [self addPickUp];
    }
    else
    {
        CGPoint p=CGPointMake(r+x, r+y);
        dot.position=p;
        [dot wakeUp];
        [self addChild:dot];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    if ([_motionManager isAccelerometerAvailable]) {
        [arrow actionWithAcceleration:_motionManager.accelerometerData.acceleration];
    }
    
    NSArray* children=[NSArray arrayWithArray:self.children];
    NSMutableArray* pickUps=[NSMutableArray array];
    NSMutableArray* dots=[NSMutableArray array];
    NSMutableArray* weapons=[NSMutableArray array];
    
    for (SKNode* node in children) {
        if ([node isKindOfClass:[PickUpNode class]]) {
            [pickUps addObject:node];
        }
        else if([node isKindOfClass:[WeaponNode class]]) {
            [weapons addObject:node];
        }
        else if([node isKindOfClass:[DotNode class]]) {
            [dots addObject:node];
        }
    }
    
    //add something if need
    
    if (currentTime-currentTimeInterval>=frequentPickUp) {
        currentTimeInterval=currentTime;
        if (pickUps.count<maxPickUpCount) {
            [self addPickUp];
        }
        if (dots.count<maxDotCount) {
            [self addDot];
        }
    }
    
    for (PickUpNode * pic in pickUps) {
        [pic movingAround];
        if (pic.type==PickUpTypePurple) {
            [pic runAction:[SKAction rotateToAngle:-arrow.zRotation+M_PI_2 duration:0.1 shortestUnitArc:YES]];
        }
        if ([arrow intersectsNode:pic]) {
            [pic bePickedUpByNode:arrow];
            continue;
        }
        if (currentTime-pic.createTime>=pickUpLifeTime) {
            [pic disappear];
            continue;
        }
    }
    
    for (DotNode* dot in dots) {
        [dot actionWithTarget:arrow];
    }
    
    for (WeaponNode* wea in weapons) {
        [wea actionWithTargets:dots];
        for (DotNode* dot in dots) {
            if ([wea intersectsNode:dot]) {
                [dot beKilledByWeapon:wea];
            }
        }
    }
}

@end
