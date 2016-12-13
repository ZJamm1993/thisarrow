//
//  GameScene.m
//  thisarrow
//
//  Created by jam on 16/12/12.
//  Copyright (c) 2016年 jamstudio. All rights reserved.
//

#import "GameScene.h"
#import "ArrowNode.h"

@implementation GameScene
{
    CMMotionManager* _motionManager;
    ArrowNode* arrow;
}

-(void)didMoveToView:(SKView *)view {
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

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
