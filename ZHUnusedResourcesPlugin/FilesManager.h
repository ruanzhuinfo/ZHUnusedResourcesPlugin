//
//  FilesManager.h
//  ZHUnusedResourcesPlugin
//
//  Created by taffy on 15/11/6.
//  Copyright © 2015年 taffy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FileType) {
  FileTypeNone  = 0,
  FileTypeH     = 1,
  FileTypeObjC  = 2,
  FileTypeC     = 3,
  FileTypeSwift = 4,
  FileTypeHtml  = 5,
  FileTypeCSS   = 6,
  FileTypeXib   = 7,
  FileTypePlist = 8,
  FileTypeJson  = 9,
};

@interface FilesManager : NSObject

+ (instancetype)sharedObject;

- (void) startWithProjectPath:(NSString *)projectPath fileSuffixs:(NSString *)fileSuffixs;

- (BOOL) isUsedAtResourceName: (NSString *)name;

@end
