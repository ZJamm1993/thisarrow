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
const NSInteger maxPickUpCount=1000;

@implementation GameScene
{
    CMMotionManager* _motionManager;
    ArrowNode* arrow;
    CFTimeInterval currentTimeInterval;
    NSMutableArray* pickUps;
}

-(void)didMoveToView:(SKView *)view {
    pickUps=[NSMutableArray array];
    
    self.backgroundColor=[UIColor blackColor];
    arrow=[ArrowNode defaultNode];
    arrow.position=CGPointMake(self.size.width/2, self.size.height/2);
    [self addChild:arrow];
    
    _motionManager=[[CMMotionManager alloc]init];
    if ([_motionManager isAccelerometerAvailable]) {
        // 设置加速计频率
        [_motionManager setAccelerometerUpdateInterval:1/60.0];
        //开始采样数据
        [_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            //            NSLog(@"%f,%f,%f",accelerometerData.acceleration.x,accelerometerData.acceleration.y,accelerometerData.acceleration.z);
            [arrow actionWithAcceleration:accelerometerData.acceleration];
        }];
    }
    
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
    [self addChild:pick];
    [pickUps addObject:pick];
    [pick runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:M_PI duration:(arc4random()%100+100)/100.0]]];
}

-(void)update:(CFTimeInterval)currentTime {
//    NSLog(@"%f",currentTime);
////    if (currentTime>currentTimeInterval) {
////        currentTimeInterval=currentTime;
////    }
    
    if (currentTime-currentTimeInterval>=frequentPickUp) {
        currentTimeInterval=currentTime;
        [self addPickUp];
    }
    NSArray* picks=[NSArray arrayWithArray:pickUps];
    CGRect arrRct=arrow.frame;
    for (PickUpNode* pic in picks) {
        CGRect picRct=pic.frame;
        if (CGRectIntersectsRect(arrRct, picRct)) {
            [pic removeFromParent];
            [pickUps removeObject:pic];
        }
    }
}

@end
