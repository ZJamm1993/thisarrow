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
    int ran=arc4random()%8;
    SKColor* randomColor;
    if (ran==0) {
        randomColor=[SKColor orangeColor];
    }
    else if (ran==1) {
        randomColor=[SKColor greenColor];
    }
    else if (ran==2) {
        randomColor=[SKColor blueColor];
    }
    else if (ran==3) {
        randomColor=[SKColor redColor];
    }
    else if (ran==4) {
        randomColor=[SKColor purpleColor];
    }
    else if (ran==5) {
        randomColor=[SKColor yellowColor];
    }
    else if (ran==6) {
        randomColor=[SKColor brownColor];
    }
    else if (ran==7) {
        randomColor=[SKColor grayColor];
    }
    PickUpNode* node=[PickUpNode spriteNodeWithColor:randomColor size:CGSizeMake(20,20)];
    return node;
}

@end
