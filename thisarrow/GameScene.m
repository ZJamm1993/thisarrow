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

const CFTimeInterval frequentPickUp=0.1;
const CFTimeInterval pickUpLifeTime=5;
const NSInteger maxPickUpCount=3;

@interface GameScene()<SKPhysicsContactDelegate>

@end

@implementation GameScene
{
    CMMotionManager* _motionManager;
    ArrowNode* arrow;
    CFTimeInterval currentTimeInterval;
}

-(void)didMoveToView:(SKView *)view {
    
    self.physicsWorld.speed=60;
    self.physicsWorld.contactDelegate=self;
    self.scaleMode = SKSceneScaleModeAspectFit;
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    
    self.backgroundColor=[UIColor blackColor];
    arrow=[ArrowNode defaultNode];
    arrow.position=CGPointMake(self.size.width/2, self.size.height/2);
    arrow.physicsBody=[SKPhysicsBody bodyWithEdgeLoopFromRect:arrow.frame];
    [self addChild:arrow];
    
    _motionManager=[[CMMotionManager alloc]init];
    [_motionManager startAccelerometerUpdates];
    [_motionManager setAccelerometerUpdateInterval:1/60.0];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch=[touches anyObject];
    CGPoint p=[touch locationInNode:self];
    NSLog(@"%@",NSStringFromCGPoint(p));
    [arrow actionWithPoint:p];
}

-(void)addPickUp
{
    NSInteger pickUpCount=0;
    for (SKNode* node in self.children) {
        if ([node isKindOfClass:[PickUpNode class]]) {
            pickUpCount++;
        }
    }
    if (pickUpCount>=maxPickUpCount) {
        return;
    }
    
//    if (pickUps.count>=maxPickUpCount) {
//        return;
//    }
    
    PickUpNode* pick=[PickUpNode randomNode];
    pick.createTime=currentTimeInterval+ZZRandom_0_1()*5;
    CGFloat r=pick.size.width/2;
    CGFloat x=(arc4random()%(int)(self.size.width-2*r));
    CGFloat y=(arc4random()%(int)(self.size.height-2*r));
    CGPoint p=CGPointMake(r+x, r+y);
    pick.position=p;
    [self addChild:pick];
}

-(void)update:(CFTimeInterval)currentTime {
    if ([_motionManager isAccelerometerAvailable]) {
        [arrow actionWithAcceleration:_motionManager.accelerometerData.acceleration];
    }
    
    if (currentTime-currentTimeInterval>=frequentPickUp) {
        currentTimeInterval=currentTime;
        [self addPickUp];
    }
    
    NSArray* children=[NSArray arrayWithArray:self.children];
    for (SKNode* node in children) {
        if ([node isKindOfClass:[PickUpNode class]]) {
            PickUpNode* pic=(PickUpNode*)node;
            [pic movingAround];
            if (pic.type==PickUpTypePurple) {
                [pic runAction:[SKAction rotateToAngle:-arrow.zRotation+M_PI_2 duration:0.1 shortestUnitArc:YES]];
            }
            if ([arrow intersectsNode:pic]) {
                [pic bePickedUpByNode:arrow];
            }
            if (currentTime-pic.createTime>=pickUpLifeTime) {
                [pic disappear];
            }
        }
    }
}

@end
