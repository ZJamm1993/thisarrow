//
//  PickUpNode.m
//  thisarrow
//
//  Created by jam on 16/12/19.
//  Copyright © 2016年 jamstudio. All rights reserved.
//

#import "PickUpNode.h"

@implementation PickUpNode

+(instancetype)randomNode
{
    /*
     + (UIColor *)grayColor;       // 0.5 white
     + (UIColor *)redColor;        // 1.0, 0.0, 0.0 RGB
     + (UIColor *)greenColor;      // 0.0, 1.0, 0.0 RGB
     + (UIColor *)blueColor;       // 0.0, 0.0, 1.0 RGB
     + (UIColor *)cyanColor;       // 0.0, 1.0, 1.0 RGB
     + (UIColor *)yellowColor;     // 1.0, 1.0, 0.0 RGB
     + (UIColor *)magentaColor;    // 1.0, 0.0, 1.0 RGB
     + (UIColor *)orangeColor;     // 1.0, 0.5, 0.0 RGB
     + (UIColor *)purpleColor;     // 0.5, 0.0, 0.5 RGB
     + (UIColor *)brownColor;      // 0.6, 0.4, 0.2 RGB
     */
    int ran=arc4random()%10;
    SKColor* randomColor;
    if (ran==0) {
        randomColor=[SKColor grayColor];
    }
    else if (ran==1) {
        randomColor=[SKColor redColor];
    }
    else if (ran==2) {
        randomColor=[SKColor greenColor];
    }
    else if (ran==3) {
        randomColor=[SKColor blueColor];
    }
    else if (ran==4) {
        randomColor=[SKColor cyanColor];
    }
    else if (ran==5) {
        randomColor=[SKColor yellowColor];
    }
    else if (ran==6) {
        randomColor=[SKColor magentaColor];
    }
    else if (ran==7) {
        randomColor=[SKColor orangeColor];
    }
    else if (ran==8) {
        randomColor=[SKColor purpleColor];
    }
    else if (ran==9) {
        randomColor=[SKColor brownColor];
    }
    PickUpNode* node=[PickUpNode spriteNodeWithColor:randomColor size:CGSizeMake(20,20)];
    return node;
}

-(void)rotateAuto
{
    int ra=arc4random();
    CFTimeInterval duration=(ra%100+100)/100.0;
    if (duration<0.1) {
        duration=0.1;
    }
    CGFloat radian=ra>0?M_PI_2:-M_PI_2;
    [self runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:radian duration:duration]]];
}

//-(void)blick
//{
//    SKAction* closeEye=[SKAction scaleYTo:0.5 duration:0.25];
//    SKAction* openEye=[SKAction scaleYTo:1 duration:0.25];
//    SKAction* blin=[SKAction sequence:[NSArray arrayWithObjects:closeEye,openEye, nil]];
//    SKAction* repeat=[SKAction repeatAction:blin count:2];
//    [self runAction:repeat completion:^{
//    }];
//}

//-(void)moveToParent:(SKNode *)parent // Did not work as I expected;
//{
//    [self runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:M_PI duration:(arc4random()%100+100)/100.0]]];
//}

@end
