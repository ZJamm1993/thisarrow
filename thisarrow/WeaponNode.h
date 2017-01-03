//
//  WeaponNode.h
//  thisarrow
//
//  Created by iMac206 on 16/12/21.
//  Copyright © 2016年 jamstudio. All rights reserved.
//

#import "ZZSpriteNode.h"

@interface WeaponNode : ZZSpriteNode

+(instancetype)defaultNode;

-(void)actionWithTargets:(NSArray*)targets;
-(void)actionWithHero:(SKNode*)hero;
-(void)disappear;

@end
