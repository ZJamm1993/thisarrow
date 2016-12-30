//
//  ZZSpriteNode.h
//  thisarrow
//
//  Created by iMac206 on 16/12/20.
//  Copyright © 2016年 jamstudio. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ZZSpriteNode : SKSpriteNode

@property (nonatomic,assign) CGFloat speedX;
@property (nonatomic,assign) CGFloat speedY;

@property (nonatomic,assign,readonly) BOOL touchTopBound;
@property (nonatomic,assign,readonly) BOOL touchBottomBound;
@property (nonatomic,assign,readonly) BOOL touchLeftBound;
@property (nonatomic,assign,readonly) BOOL touchRightBound;

/**
 counterclockwise rotation
 */

-(CGPoint)rotatePoint:(CGPoint)poi origin:(CGPoint)ori rotation:(CGFloat)rad;
-(CGPoint)rotateVector:(CGPoint)vec rotation:(CGFloat)rad;

@end
