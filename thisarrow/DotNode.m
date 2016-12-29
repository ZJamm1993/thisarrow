//
//  DotNode.m
//  thisarrow
//
//  Created by jam on 16-12-24.
//  Copyright (c) 2016年 jamstudio. All rights reserved.
//

#import "DotNode.h"

const CGFloat defaultFollowSpeed=16/60.0;

@implementation DotNode
{
    ZZSpriteNode* shadow;
}

+(instancetype)defaultNode
{
    DotNode* dot=[DotNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"redDot"]];
    dot.followSpeed=defaultFollowSpeed;
    dot.groupType=DotGroupTypeNothing;
    return dot;
}

-(instancetype)initWithTexture:(SKTexture *)texture
{
    self=[super initWithTexture:texture];
    if (self) {
        self.zPosition=Dot_Z_Position;
        shadow=[ZZSpriteNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"dotShadow"]];
        shadow.position=self.position;
        shadow.zPosition=Shadow_Z_Position;
    }
    return self;
}

+(NSArray*)randomGroupNodeWithDots:(NSArray *)dots target:(SKNode *)target
{
    //dont add child here.
    
    DotGroupType ranType=arc4random()%DotGroupTypeNothing;
    
    NSMutableArray* newDots=[NSMutableArray array];
    
    CGSize bound=target.parent.frame.size;
    
    if (ranType==DotGroupTypeSurround) {
        CGFloat r=bound.height*0.5*0.9;
        int count=16;
        for (int i=0; i<count; i++) {
            CGFloat rad=M_PI*2*i/count;
            CGFloat x=target.position.x+r*sin(rad);
            CGFloat y=target.position.y+r*cos(rad);
            if (x<0||x>bound.width) {
                continue;
            }
            if (y<0||y>bound.height) {
                continue;
            }
            DotNode* dot=[DotNode defaultNode];
            dot.position=CGPointMake(x, y);
            dot.followSpeed=defaultFollowSpeed*1.3;
            [dot wakeUp];
            [newDots addObject:dot];
        }
    }
    
    return newDots;
}

-(void)wakeUp
{
    self.yScale=0;
    shadow.yScale=0;
    shadow.xScale=0;
    
    CFTimeInterval waitTime=0.25;
    
    [shadow runAction:[SKAction scaleTo:1.1 duration:waitTime]];
    
    SKAction* scales=[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:waitTime],[SKAction scaleYTo:1 duration:0.25],[SKAction scaleYTo:0.6 duration:0.25],[SKAction scaleYTo:1 duration:0.25], nil]];
    [self runAction:scales completion:^{
        _isAwake=YES;
    }];
}

-(void)actionWithTarget:(SKNode *)node
{
    if (node.parent==nil) {
        [self removeFromParent];
        return;
    }
    if (self.parent&&(shadow.parent==nil)) {
        [self.parent addChild:shadow];
    }
    if (_isDead||!_isAwake) {
        return;
    }
    if (self.groupType==DotGroupTypeNothing) {
        if ([node isKindOfClass:[ZZSpriteNode class]]) {
            ZZSpriteNode* z=(ZZSpriteNode*)node;
            CGFloat dx=z.position.x-self.position.x;
            CGFloat dy=z.position.y-self.position.y;
            CGFloat rad=atan2f(dx, dy);
            CGFloat newDx=self.followSpeed*sin(rad);
            CGFloat newDy=self.followSpeed*cos(rad);
            self.position=CGPointMake(self.position.x+newDx, self.position.y+newDy);
        }
    }
}

-(void)setPosition:(CGPoint)position
{
    [super setPosition:position];
    shadow.position=position;
}

-(void)beKilledByWeapon:(WeaponNode *)weapon
{
    [self removeAllActions];
    _isDead=YES;
    if ([weapon isKindOfClass:[MegaBombNode class]])
    {
        ZZSpriteNode* burn=[ZZSpriteNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"burnup1"]];
        burn.alpha=0.6;
        burn.position=self.position;
        [self.parent addChild:burn];
        NSArray* burnTextures=[MyTextureAtlas burnUpTextures];
        CFTimeInterval timePer=0.02;
        CGFloat dx=burn.position.x-weapon.position.x;
        CGFloat dy=burn.position.y-weapon.position.y;
        CGFloat rad=atan2f(dx, dy);
        CGFloat distance=10;
        CGFloat vx=distance*sin(rad);
        CGFloat vy=distance*cos(rad);
        [burn runAction:[SKAction group:[NSArray arrayWithObjects:[SKAction animateWithTextures:burnTextures timePerFrame:timePer],[SKAction moveBy:CGVectorMake(vx, vy) duration:burnTextures.count*timePer],nil]] completion:^{
            [burn removeFromParent];
        }];
    }
    else if([weapon isKindOfClass:[RailGunNode class]])
    {
        ZZSpriteNode* ball=[ZZSpriteNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"purpleBall"]];
        ball.position=self.position;
        [self.parent addChild:ball];
        [ball runAction:[SKAction scaleTo:0 duration:0.15] completion:^{
            [ball removeFromParent];
        }];
    }
    else if([weapon isKindOfClass:[MissileTrackNode class]])
    {
        ZZSpriteNode* ball=[ZZSpriteNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"yellowBall"]];
        ball.position=self.position;
        [self.parent addChild:ball];
        [ball runAction:[SKAction scaleTo:0 duration:0.5] completion:^{
            [ball removeFromParent];
        }];
    }
    [shadow removeFromParent];
    [self removeFromParent];
}

-(BOOL)intersectsNode:(SKNode *)node
{
    if (_isDead||!_isAwake) {
        return NO;
    }
    return [super intersectsNode:node];
}

@end
