//
//  IDEOutlineBasedNavigator+Plugin.m
//  ZHUnusedResourcesPlugin
//
//  Created by taffy on 15/11/6.
//  Copyright © 2015年 taffy. All rights reserved.
//

#import "IDEOutlineBasedNavigator+Plugin.h"
#import "MethodSwizzle.h"

@implementation IDEOutlineBasedNavigator (Plugin)

+(void)load {
  MethodSwizzle(self, @selector(openClickedNavigableItemAction:), @selector(zh_openClickedNavigableItemAction:));
}

- (void)zh_openClickedNavigableItemAction:(id)arg1 {
  NSLog(@"%@", arg1);

//  IDENavigatorOutlineView *outLineView = arg1;
  
  [self zh_openClickedNavigableItemAction:arg1];
}

@end
