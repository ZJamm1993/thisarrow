//
//  DotNode.m
//  thisarrow
//
//  Created by jam on 16-12-24.
//  Copyright (c) 2016年 jamstudio. All rights reserved.
//

#import "DotNode.h"

const CGFloat defaultFollowSpeed=24/60.0;
const CGFloat defaultTopSpeed=32/60.0;
const CGFloat defaultSlowDownRate=0.98;
const CGFloat defaultFastUpRate=2.0-defaultSlowDownRate;
const CGFloat defaultReboundRate=0.4;
const CGFloat defaultPointerSpeed=240/60.0;

@implementation DotNode

+(instancetype)defaultNode
{
    DotNode* dot=[DotNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"redDot"]];
    return dot;
}

+(CGFloat)defaultWidth
{
    return [DotNode defaultNode].size.width;
}

+(instancetype)randomPositionNodeOnSize:(CGSize)size
{
    DotNode* dot=[DotNode defaultNode];
    CGFloat r=dot.size.width/2;
    CGFloat x=(arc4random()%(int)(size.width-2*r));
    CGFloat y=(arc4random()%(int)(size.height-2*r));
    CGPoint p=CGPointMake(r+x, r+y);
    dot.position=p;
    return dot;
}

-(instancetype)initWithTexture:(SKTexture *)texture
{
    self=[super initWithTexture:texture];
    if (self) {
        self.zPosition=Dot_Z_Position;
        self.followSpeed=defaultFollowSpeed;
        self.groupType=DotGroupTypeNothing;
        
        shadow=[ZZSpriteNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"dotShadow"]];
        shadow.xScale=1.1;
        shadow.yScale=shadow.xScale;
        shadow.zPosition=-1;
        [self addChild:shadow];
    }
    return self;
}

-(void)setIsFreeze:(BOOL)isFreeze
{
    _isFreeze=isFreeze;
    
    if (isFreeze) {
        [self removeAllActions];
        self.xScale=1;
        self.yScale=1;
        self.texture=[MyTextureAtlas textureNamed:@"freezeIce"];
        [self removeActionForKey:@"unfreeze"];
        [self runAction:[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:10],[SKAction performSelector:@selector(setUnfreeze) onTarget:self], nil]] withKey:@"unfreeze"];
        
        self.size=self.texture.size;
//        if (!oldFre) {
//            if (![shadow hasActions]) {
//                [shadow removeAllActions];
//            }
//            [shadow runAction:[SKAction repeatActionForever:[SKAction sequence:[NSArray arrayWithObjects:[SKAction moveTo:CGPointMake(-2, 0) duration:0.1],[SKAction moveTo:CGPointMake(2, 0) duration:0.1], nil]]]];
//        }
    }
    else
    {
        self.texture=[MyTextureAtlas textureNamed:@"redDot"];
        
        self.size=self.texture.size;
        [shadow removeAllActions];
        shadow.position=CGPointZero;
        self.isAwake=YES;
        self.isDead=NO;
        self.followSpeed=defaultFollowSpeed;
    }
}
         
-(void)setUnfreeze
 {
     self.isFreeze=NO;
 }

+(SKAction*)wakeUpAction
{
    CFTimeInterval blinkTime=0.25;
    
    SKAction* scales=[SKAction sequence:[NSArray arrayWithObjects:[SKAction scaleTo:1 duration:blinkTime],[SKAction scaleTo:0.5 duration:blinkTime],[SKAction scaleTo:1 duration:blinkTime], nil]];
    
    return scales;
}

-(void)wakeUp
{
    _isAwake=NO;
    
    self.xScale=0;
    self.yScale=0;
    [self runAction:[DotNode wakeUpAction] completion:^{
        _isAwake=YES;
    }];
}

-(void)shootPointer
{
    if (self.groupType == DotGroupTypePointer) {
        self.originPoint=CGPointZero;
        self.speedX=defaultPointerSpeed*sinf(-self.zRotation);
        self.speedY=defaultPointerSpeed*cosf(-self.zRotation);
    }
}

-(void)actionWithTarget:(SKNode *)node
{
    if (node.parent==nil) {
        [self removeFromParent];
        return;
    }
    
    if (_isFreeze) {
        if (arc4random()%3==0) {
            shadow.position=CGPointMake(1*ZZRandom_1_0_1(), 1*ZZRandom_1_0_1());
        }
        return;
    }
    
    if (_isDead||!_isAwake) {
        return;
    }

    self.position=CGPointMake(self.position.x+self.speedX, self.position.y+self.speedY);
    
//    if (self.groupType!=DotGroupTypePointer&&self.groupType!=DotGroupTypeQueue) {
//        self.speedX=self.speedX*defaultSlowDownRate;
//        self.speedY=self.speedY*defaultSlowDownRate;
//    }
    
    if (self.touchTopBound) {
        self.speedY=-fabsf((float)self.speedY);
    }
    if (self.touchBottomBound) {
        self.speedY=fabsf((float)self.speedY);
    }
    if (self.touchLeftBound) {
        self.speedX=fabsf((float)self.speedX);
    }
    if (self.touchRightBound) {
        self.speedX=-fabsf((float)self.speedX);
    }
    
    if (self.groupType==DotGroupTypeNothing||self.groupType==DotGroupTypeSurround) {
        self.speedX=self.speedX*defaultSlowDownRate;
        self.speedY=self.speedY*defaultSlowDownRate;
        
        CGFloat dx=node.position.x-self.position.x;
        CGFloat dy=node.position.y-self.position.y;
        CGFloat rad=atan2f(dx, dy);
        CGFloat newDx=self.followSpeed*sin(rad);
        CGFloat newDy=self.followSpeed*cos(rad);
        if (self.followSpeed<defaultTopSpeed) {
            if (self.groupType==DotGroupTypeNothing) {
                if (arc4random()%5==0) {
                    self.followSpeed=self.followSpeed*defaultFastUpRate;
                }
            }
        }
        self.position=CGPointMake(self.position.x+newDx, self.position.y+newDy);
    }
    else if(self.groupType==DotGroupTypePointer)
    {
        if (self.touchTopBound) {
            self.speedY=self.speedY*ZZRandom_0_1()*defaultReboundRate;
            self.speedX=ZZRandom_1_0_1()*defaultFollowSpeed+self.speedX*defaultReboundRate;
        }
        if (self.touchBottomBound) {
            self.speedY=self.speedY*ZZRandom_0_1()*defaultReboundRate;
            self.speedX=ZZRandom_1_0_1()*defaultFollowSpeed+self.speedX*defaultReboundRate;
        }
        if (self.touchLeftBound) {
            self.speedX=self.speedX*ZZRandom_0_1()*defaultReboundRate;
            self.speedY=ZZRandom_1_0_1()*defaultFollowSpeed+self.speedY*defaultReboundRate;
        }
        if (self.touchRightBound) {
            self.speedX=self.speedX*ZZRandom_0_1()*defaultReboundRate;
            self.speedY=ZZRandom_1_0_1()*defaultFollowSpeed+self.speedY*defaultReboundRate;
        }
        
        if(self.touchBottomBound||self.touchLeftBound||self.touchRightBound||self.touchTopBound)
        {
            self.groupType=DotGroupTypeSurround;
        }
        
        CGPoint deltaOrigin=[ZZSpriteNode rotateVector:self.originPoint rotation:self.zRotation];
        CGPoint realOrigin=CGPointMake(deltaOrigin.x+self.position.x, deltaOrigin.y+self.position.y);
        CGFloat dx=node.position.x-realOrigin.x;
        CGFloat dy=node.position.y-realOrigin.y;
        CGFloat rad=-atan2f(dx, dy);
        self.zRotation=rad;
        
        // if its pointer group lost many dots, become normal and slow down
        NSInteger deadCount = 0;
        for (DotNode *dot in self->pointerGroup) {
            if (dot.isDead) {
                deadCount++;
            }
        }
        if (deadCount > 7) {
            for (DotNode *dot in self->pointerGroup) {
                dot.groupType = DotGroupTypeNothing;
                dot.speedX = 0;
                dot.speedY = 0;
            }
        }
    }
}

-(void)setZRotation:(CGFloat)zRotation
{
    if (self.groupType==DotGroupTypePointer) {
        CGPoint deltaOrigin=[ZZSpriteNode rotateVector:self.originPoint rotation:self.zRotation];
        CGPoint realOrigin=CGPointMake(deltaOrigin.x+self.position.x, deltaOrigin.y+self.position.y);
        
        CGPoint dotsRotatedPosition=[ZZSpriteNode rotatePoint:self.position origin:realOrigin rotation:(zRotation-self.zRotation)];
        self.position=dotsRotatedPosition;
        
//        ZZSpriteNode* originNode=[ZZSpriteNode spriteNodeWithColor:[SKColor cyanColor] size:CGSizeMake(2, 2)];
//        originNode.position=realOrigin;
//        originNode.zPosition=Arrow_Z_Position;
//        [self.parent addChild:originNode];
//        [originNode runAction:[SKAction fadeAlphaTo:0.1 duration:0.1] completion:^{
//            [originNode removeFromParent];
//        }];
    }
    
    [super setZRotation:zRotation];
}

-(CGPoint)originPoint
{
    if (self.groupType==DotGroupTypePointer) {
        return _originPoint;
    }
    else
    {
        return CGPointZero;
    }
}

-(void)setGroupType:(DotGroupType)groupType
{
    _groupType=groupType;
    self.zRotation=0;
}

-(void)beKilledByWeapon:(WeaponNode *)weapon
{
    if (self.isDead) {
        [self removeFromParent];
        return;
    }
//    if (self.xScale==0||self.yScale==0) {
//        return;
//    }
    if ([weapon isKindOfClass:[MegaBombNode class]])
    {
        ZZSpriteNode* burn=[ZZSpriteNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"burnup1"]];
        burn.alpha=0.6;
        burn.position=self.position;
        [self.parent addChild:burn];
        NSArray* burnTextures=[MyTextureAtlas burnUpTextures];
        CFTimeInterval timePer=0.02+0.01*ZZRandom_1_0_1();
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
    else if ([weapon isKindOfClass:[GreenCoverNode class]]) {
        GreenCoverNode* cover=(GreenCoverNode*)weapon;
        if (self.isAwake==NO||cover.blowedUp==YES||self.isFreeze) {
            return;
        }
        cover.blowedUp=YES;
        MegaBombNode* mega=[MegaBombNode defaultNode];
        mega.position=weapon.position;
        mega.texture=[MyTextureAtlas textureNamed:@"megabombGreen"];
        [self.parent addChild:mega];
        
        [weapon removeFromParent];
    }    
    else if([weapon isKindOfClass:[RailGunNode class]])
    {
        ZZSpriteNode* ball=[ZZSpriteNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"purpleBall"]];
        ball.position=self.position;
        [self.parent addChild:ball];
        [ball runAction:[SKAction scaleTo:0 duration:0.3+0.2*ZZRandom_1_0_1()] completion:^{
            [ball removeFromParent];
        }];
    }
    else if([weapon isKindOfClass:[MissileTrackNode class]])
    {
        ZZSpriteNode* ball=[ZZSpriteNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"yellowBall"]];
        ball.position=self.position;
        [self.parent addChild:ball];
        [ball runAction:[SKAction scaleTo:0 duration:0.5+0.2*ZZRandom_1_0_1()] completion:^{
            [ball removeFromParent];
        }];
    }
    else if([weapon isKindOfClass:[ElectricSawNode class]])
    {
        CGFloat rotaion=-atan2f(self.position.x-weapon.position.x, self.position.y-weapon.position.y);
        [self bleedingWithRotation:rotaion];
    }
    else if([weapon isKindOfClass:[FreezeNode class]])
    {
//        if(_isAwake)
//        {
        
            self.isFreeze=YES;
            self.groupType=DotGroupTypeNothing;
            self.followSpeed=0;
//        }
        
        return;
    }
    else if([weapon isKindOfClass:[ArrowNode class]])
    {
        if(_isFreeze)
        {
            ZZSpriteNode* ball=[ZZSpriteNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"freezeIceBroken"]];
            ball.zPosition=Weapon_Z_Position;
            ball.position=self.position;
            ball.zRotation=(CGFloat)(arc4random()%360)/180*M_PI;
            [self.parent addChild:ball];
            CFTimeInterval time=0.5+0.2*ZZRandom_1_0_1();
            [ball runAction:[SKAction group:[NSArray arrayWithObjects:[SKAction scaleTo:1.2 duration:time],[SKAction fadeAlphaTo:0 duration:time],nil]] completion:^{
                [ball removeFromParent];
            }];
        }
        else
        {
            return;
        }
    }
    self.isDead=YES;
    [self removeFromParent];
}

-(void)bleeding
{
    [self bleedingWithRotation:M_PI*2*ZZRandom_0_1()];
}

-(void)bleedingWithRotation:(CGFloat)rotation
{
//    rotation=rotation+M_PI_4*ZZRandom_1_0_1();
    CFTimeInterval timePer=0.02+0.02*ZZRandom_0_1();
    
    ZZSpriteNode* blood=[ZZSpriteNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"bloodRed1"]];
    blood.zRotation=rotation;
    blood.zPosition=Arrow_Z_Position;
    blood.position=self.position;
    [self.parent addChild:blood];
    
//    blood.position=[ZZSpriteNode rotatePoint:blood.position origin:self.position rotation:rotation];
    
    ZZSpriteNode* bloodWhite=[ZZSpriteNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"bloodWhite1"]];
    bloodWhite.zPosition=-1;
    [blood addChild:bloodWhite];
    [bloodWhite runAction:[SKAction animateWithTextures:[MyTextureAtlas bloodWhiteTextures] timePerFrame:timePer]];
    
    [blood runAction:[SKAction sequence:[NSArray arrayWithObjects:[SKAction animateWithTextures:[MyTextureAtlas bloodRedTextures] timePerFrame:timePer],nil]] completion:^{
        [blood removeFromParent];
    }];
}

-(BOOL)intersectsNode:(SKNode *)node
{
    BOOL crash=[super intersectsNode:node];
    if (_isDead||!_isAwake||_isFreeze) {
        return NO;
    }
//    CGRect r1=[ZZSpriteNode resizeRect:self.frame Scale:0.8];
//    CGRect r2=[ZZSpriteNode resizeRect:node.frame Scale:0.25];
//    return CGRectIntersectsRect(r1, r2);
    return crash;
}

-(void)removeFromParent
{
    [super removeFromParent];
}

@end
