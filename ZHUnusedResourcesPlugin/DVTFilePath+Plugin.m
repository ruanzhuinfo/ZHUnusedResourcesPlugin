//
//  DVTFilePath+Plugin.m
//  ZHUnusedResourcesPlugin
//
//  Created by taffy on 15/11/7.
//  Copyright © 2015年 taffy. All rights reserved.
//

#import "DVTFilePath+Plugin.h"
#import "MethodSwizzle.h"

@implementation DVTFilePath (Plugin)

+(void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    MethodSwizzle(self, @selector(fileName), @selector(zh_fileName));
    MethodSwizzle(self, @selector(pathString), @selector(zh_pathString));
  });
}


- (NSString *)zh_fileName {
  return [self zh_fileName];
}
- (NSString *)zh_pathString {
  return [self zh_pathString];
}

@end
