//
//  IDENavigatorOutlineView+Plugin.m
//  ZHUnusedResourcesPlugin
//
//  Created by taffy on 15/11/6.
//  Copyright © 2015年 taffy. All rights reserved.
//

#import "IDENavigatorOutlineView+Plugin.h"
#import "MethodSwizzle.h"


@implementation IDENavigatorOutlineView (Plugin)

+(void)load {
  MethodSwizzle(self, @selector(mouseDown:), @selector(zh_mouseDown:));
  MethodSwizzle(self, @selector(sendAction:to:), @selector(zh_sendAction:to:));
  MethodSwizzle(self, @selector(expandItem:expandChildren:), @selector(zh_expandItem:expandChildren:));
}


- (void)zh_mouseDown:(id)arg1 {
//  NSLog(@"%@", arg1);
  [self zh_mouseDown:arg1];
}

- (void)zh_expandItem:(id)arg1 {
  
}
- (void)zh_expandItem:(id)arg1 expandChildren:(BOOL)arg2 {
//  NSLog(@"%@ \n %i", arg1, arg2);
  [self zh_expandItem:arg1 expandChildren:arg2];
}
- (BOOL)zh_sendAction:(SEL)arg1 to:(id)arg2 {
//  NSLog(@"%@", arg2);
  
  NSLog(@"%@", [self currentWorkspaceDocument]);
  
  return [self zh_sendAction:arg1 to:arg2];
}

//- (void)zh_collapseItem:(id)arg1 {
//
//}
//- (void)collapseItem:(id)arg1 collapseChildren:(BOOL)arg2 {
//
//}

- (id)currentWorkspaceDocument {
  NSWindowController *currentWindowController = [[NSApp keyWindow] windowController];
  id document = [currentWindowController document];
  if (currentWindowController && [document isKindOfClass:NSClassFromString(@"IDEWorkspaceDocument")]) {
    return document;
  }
  return nil;
}
@end
