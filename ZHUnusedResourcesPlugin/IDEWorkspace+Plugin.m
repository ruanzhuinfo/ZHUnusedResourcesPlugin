//
//  IDEWorkspace+Plugin.m
//  ZHUnusedResourcesPlugin
//
//  Created by taffy on 15/11/7.
//  Copyright © 2015年 taffy. All rights reserved.
//

#import "IDEWorkspace+Plugin.h"
#import "MethodSwizzle.h"

@implementation IDEWorkspace (Plugin)

+(void)load {
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    MethodSwizzle(self, @selector(_wrappingContainerPath), @selector(zh__wrappingContainerPath));
  });
}

- (id)zh__wrappingContainerPath {
  return [self zh__wrappingContainerPath];
}
@end
