//
//  GameScene.m
//  thisarrow
//
//  Created by jam on 16/12/12.
//  Copyright (c) 2016年 jamstudio. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene
{
    CMMotionManager* _motionManager;
    SKSpriteNode* arrow;
}

-(void)didMoveToView:(SKView *)view {
    arrow=[SKSpriteNode spriteNodeWithImageNamed:@"arrow"];
    arrow.position=CGPointMake(self.size.width/2, self.size.height/2);
    [self addChild:arrow];
    
    _motionManager=[[CMMotionManager alloc]init];
    if ([_motionManager isAccelerometerAvailable]) {
        // 设置加速计频率
        [_motionManager setAccelerometerUpdateInterval:1/60.0];
        //开始采样数据
        [_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            //            NSLog(@"%f,%f,%f",accelerometerData.acceleration.x,accelerometerData.acceleration.y,accelerometerData.acceleration.z);
            CGFloat m=20;
            CGFloat y=-accelerometerData.acceleration.x*m;
            CGFloat x=accelerometerData.acceleration.y*m;
            CGFloat ra=atan2f(-x, y);
            arrow.zRotation=ra;
            //            NSLog(@"%f",arrow.zRotation);
            CGFloat sx=arrow.position.x+x;
            CGFloat sy=arrow.position.y+y;
            CGFloat w=arrow.size.width/2;
            if (sx-w<0) {
                sx=w;
            }
            if (sx+w>self.size.width) {
                sx=self.size.width-w;
            }
            if (sy-w<0) {
                sy=w;
            }
            if (sy+w>self.size.height) {
                sy=self.size.height-w;
            }
            CGPoint newP=CGPointMake(sx, sy);
            arrow.position=newP;
        }];
    }

}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
