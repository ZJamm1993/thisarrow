//
//  ArrowNode.h
//  thisarrow
//
//  Created by iMac206 on 16/12/13.
//  Copyright © 2016年 jamstudio. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ArrowNode : ZZSpriteNode

+(instancetype)defaultNode;

-(void)actionWithAcceleration:(CMAcceleration)acc;

-(void)actionWithPoint:(CGPoint)point;

@end
