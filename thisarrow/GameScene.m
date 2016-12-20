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
const NSInteger maxPickUpCount=100;

@interface GameScene()<SKPhysicsContactDelegate>

@end

@implementation GameScene
{
    CMMotionManager* _motionManager;
    ArrowNode* arrow;
    CFTimeInterval currentTimeInterval;
    NSMutableArray* pickUps;
}

-(void)didMoveToView:(SKView *)view {
    
    self.physicsWorld.speed=60;
    self.physicsWorld.contactDelegate=self;
    self.scaleMode = SKSceneScaleModeAspectFit;
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    
    pickUps=[NSMutableArray array];
    
    self.backgroundColor=[UIColor blackColor];
    arrow=[ArrowNode defaultNode];
    arrow.position=CGPointMake(self.size.width/2, self.size.height/2);
    arrow.physicsBody=[SKPhysicsBody bodyWithEdgeLoopFromRect:arrow.frame];
    [self addChild:arrow];
    
    _motionManager=[[CMMotionManager alloc]init];
    [_motionManager startAccelerometerUpdates];
    [_motionManager setAccelerometerUpdateInterval:1/60.0];
    
    //acc push
//    if ([_motionManager isAccelerometerAvailable]) {
//        // 设置加速计频率
//        //开始采样数据
//        [_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
//            //            NSLog(@"%f,%f,%f",accelerometerData.acceleration.x,accelerometerData.acceleration.y,accelerometerData.acceleration.z);
//            [arrow actionWithAcceleration:accelerometerData.acceleration];
//        }];
//    }
    
}

-(void)addPickUp
{
    if (pickUps.count>=maxPickUpCount) {
        return;
    }
    PickUpNode* pick=[PickUpNode randomNode];
    CGFloat r=pick.size.width/2;
    CGFloat x=(arc4random()%(int)(self.size.width-2*r));
    CGFloat y=(arc4random()%(int)(self.size.height-2*r));
    CGPoint p=CGPointMake(r+x, r+y);
    pick.position=p;
//    pick.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:pick.size];
//    pick.physicsBody.categoryBitMask=pickUpCategory;
//    pick.physicsBody.contactTestBitMask=arrowCategory;
    [pick rotateAuto];
    [self addChild:pick];
    [pickUps addObject:pick];
}

-(void)update:(CFTimeInterval)currentTime {
//    NSLog(@"%f",currentTime);
////    if (currentTime>currentTimeInterval) {
////        currentTimeInterval=currentTime;
////    }
    
    [arrow actionWithAcceleration:_motionManager.accelerometerData.acceleration];
    
    if (currentTime-currentTimeInterval>=frequentPickUp) {
        currentTimeInterval=currentTime;
        [self addPickUp];
    }
    NSArray* picks=[NSArray arrayWithArray:pickUps];
    for (PickUpNode* pic in picks) {
        if ([arrow intersectsNode:pic]) {
            [pic removeFromParent];
            [pickUps removeObject:pic];
        }
    }
}
//
//-(void)didBeginContact:(SKPhysicsContact *)contact
//{
//    SKPhysicsBody* fir=contact.bodyA;
//    SKPhysicsBody* sec=contact.bodyB;
//    if (fir.categoryBitMask==arrowCategory&&sec.categoryBitMask==pickUpCategory) {
//        NSLog(@"contact:%@,",NSStringFromCGPoint(contact.contactPoint));
//    }
//}

@end
