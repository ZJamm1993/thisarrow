//
//  MyTextureAtlas.m
//  thisarrow
//
//  Created by iMac206 on 16/12/13.
//  Copyright © 2016年 jamstudio. All rights reserved.
//

#import "MyTextureAtlas.h"

static MyTextureAtlas* sharedTextureAtlasInstancetype;
@implementation MyTextureAtlas

+(instancetype)sharedTextureAtlas
{
    if (sharedTextureAtlasInstancetype==nil) {
        sharedTextureAtlasInstancetype=[MyTextureAtlas atlasNamed:@"texture.atlas"];
    }
    return sharedTextureAtlasInstancetype;
}

@end
