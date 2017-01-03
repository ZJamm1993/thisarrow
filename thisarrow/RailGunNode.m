//
//  RailGunNode.m
//  thisarrow
//
//  Created by iMac206 on 16/12/21.
//  Copyright © 2016年 jamstudio. All rights reserved.
//

#import "RailGunNode.h"

const CGFloat gainTime=1;

@implementation RailGunNode

+(instancetype)defaultNode
{
    RailGunNode* gun=[RailGunNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"purpleLoad"]];
    return gun;
}

-(void)loadedToGun:(SKNode *)node
{
    if (node) {
        for (SKNode* child in node.children) {
            if ([child isKindOfClass:[self class]]) {
                [self removeFromParent];
                return;
            }
        }
        [node addChild:self];
        [self runAction:[SKAction sequence:[NSArray arrayWithObjects:[SKAction scaleTo:0 duration:0],[SKAction scaleTo:1 duration:0.5], nil]]];
        self.position=CGPointMake(0, node.frame.size.height/2);
        [self performSelector:@selector(prepareToShoot) withObject:nil afterDelay:gainTime];
    }
}

-(void)prepareToShoot
{
    [self shootFromPoint:self.parent.position direction:self.parent.zRotation];
}

-(void)shootFromPoint:(CGPoint)poi direction:(CGFloat)radian
{
    //the radian should be the same as self.parent.zRotation;
    
    SKNode* parent=self.parent;
    if (parent==nil) {
        return;
    }
    [self removeFromParent];
    
    self.position=parent.position;
    self.zRotation=radian;//parent.zRotation;
    
    [parent.parent addChild:self];
    
    
    WeaponNode* head=[WeaponNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"purpleRailHead"]];
    head.position=CGPointMake(0, head.size.height*0.25);//self.size.height);//+head.size.height*0.4);
    head.yScale=0;
    [head runAction:[SKAction repeatActionForever:[SKAction sequence:[NSArray arrayWithObjects:[SKAction scaleYTo:1.3 duration:0.2],[SKAction scaleYTo:0.8 duration:0.2], nil]]]];
    [self addChild:head];
    
    self.texture=nil;
    NSInteger count=6;
    CGFloat ww=head.size.width/count;
    CGFloat ff=ww*0.3;
    
    SKNode* newParent=self.parent;
    CGSize sceneSize=newParent.frame.size; //should be a scene;
    CGFloat maxDistance=sqrtf(sceneSize.width*sceneSize.width+sceneSize.height*sceneSize.height)+100;
    
    CGFloat duration=maxDistance/320;
    
    CGFloat dx=maxDistance*sin(-radian);
    CGFloat dy=maxDistance*cos(-radian);
    
    for(NSInteger i=0;i<count/2;i++)
    {
        WeaponNode* leftNode=[WeaponNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(ww, ww)];
        leftNode.zPosition=1000;
        leftNode.position=CGPointMake(ww/2+i*ww-ff, head.position.y+head.size.height*0.3-(i*ff));
        leftNode.userData=[NSMutableDictionary dictionaryWithObject:@"invisable" forKey:@"invisable"];
        leftNode.zRotation=-radian;
        [self addChild:leftNode];
        
        WeaponNode* rightNode=[WeaponNode spriteNodeWithColor:leftNode.color size:leftNode.size];
        rightNode.zPosition=leftNode.zPosition;
        rightNode.position=CGPointMake(-leftNode.position.x, leftNode.position.y);
        rightNode.userData=[NSMutableDictionary dictionaryWithDictionary:leftNode.userData];
        rightNode.zRotation=leftNode.zRotation;
        [self addChild:rightNode];
    }
    
    
    CGFloat fadeDuration=0.3;
    CGFloat disppearDur=0.1;
    SKAction* fading=[SKAction repeatActionForever:[SKAction sequence:[NSArray arrayWithObjects:[SKAction scaleYTo:1 duration:fadeDuration+disppearDur],[SKAction scaleYTo:0.5 duration:fadeDuration+disppearDur], nil]]];
    CGFloat waitTime=0.3;
    
    WeaponNode* tail1=[WeaponNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"purpleRailTail1"]];
    tail1.position=CGPointMake(0, head.position.y-tail1.size.height*0.6);
    tail1.yScale=0;
    [tail1 runAction:[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:waitTime],fading, nil]]];
    [self addChild:tail1];
    
    WeaponNode* tail2=[WeaponNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"purpleRailTail2"]];
    tail2.position=tail1.position;
    tail2.yScale=tail1.yScale;
    [tail2 runAction:[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:waitTime+fadeDuration+disppearDur],fading, nil]]];
    [self addChild:tail2];
    
    CGPoint newPosition=CGPointMake(self.position.x+dx, self.position.y+dy);
    [self runAction:[SKAction moveTo:newPosition duration:duration] completion:^{
        [self removeFromParent];
    }];
}

-(BOOL)intersectsNode:(SKNode *)node
{
    BOOL inter=NO;
    NSArray*  children=self.children;
    for (ZZSpriteNode* n in children) {
        if (n.userData.count>0) {
            CGPoint or=[ZZSpriteNode rotateVector:n.position rotation:self.zRotation];
            CGPoint positionInScene=CGPointMake(self.position.x+or.x, self.position.y+or.y);
            //[n convertPoint:n.position toNode:self.parent]; //it's not so accurate;
            CGRect rectInScene=n.frame;
            rectInScene.origin=CGPointMake(positionInScene.x-rectInScene.size.width/2, positionInScene.y-rectInScene.size.height/2);
            if (CGRectIntersectsRect(rectInScene, node.frame)) {
                inter=YES;
//                NSLog(@"%@",NSStringFromCGRect(rectInScene));
                
                
                ////testing intersects
//                [n removeFromParent];
//                n.position=positionInScene;
//                [self.parent addChild:n];
//                n.color=[SKColor yellowColor];
//                n.zRotation=0;
//                [n runAction:[SKAction fadeAlphaTo:0 duration:2] completion:^{
//                    [n removeFromParent];
//                }];
                ////testing end
            }
        }
    }
    return inter;
}

@end
