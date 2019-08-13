//
//  DotNode+Grouping.h
//  thisarrow
//
//  Created by ohaha on 2019/8/13.
//  Copyright © 2019年 jamstudio. All rights reserved.
//

#import "DotNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface DotNode (Grouping)

+(NSArray*)randomGroupNodeWithDots:(NSArray*)dots target:(SKNode*)target;

@end

NS_ASSUME_NONNULL_END
