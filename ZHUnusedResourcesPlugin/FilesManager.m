//
//  FilesManager.m
//  ZHUnusedResourcesPlugin
//
//  Created by taffy on 15/11/6.
//  Copyright © 2015年 taffy. All rights reserved.
//

#import "FilesManager.h"
#import "StringUtils.h"

@implementation FilesManager {
  
  NSMutableDictionary *_resourceNameList;
  NSString *_projectPath;
  NSArray *_fileSuffixs;
  BOOL _isRunding;
}

+ (instancetype)sharedObject {
  
  static FilesManager *manager;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[self alloc] init];
  });
  return manager;
}

- (void) startWithProjectPath:(NSString *)projectPath fileSuffixs:(NSString *)fileSuffixs {
  NSArray *suffixs = [StringUtils fileSuffixs:fileSuffixs];
  
  if (projectPath.length == 0 || suffixs.count == 0) {
    return;
  }
  
  BOOL pathExists = [[NSFileManager defaultManager] fileExistsAtPath:projectPath];
  if (!pathExists) {
    return;
  }
  
  _projectPath = projectPath;
  _fileSuffixs = suffixs;
  
  [self runSearchTask];
}

- (BOOL) isUsedAtResourceName: (NSString *)name {
 
  if (_isRunding) {
    return YES;
  }
  
  NSString *keyName = [StringUtils getNameFromFullName:name];
  if (!keyName || [keyName isEqualToString:@""]) {
    return YES;
  }
  
  if (![_resourceNameList objectForKey:keyName]) {
    return NO;
  }
  
  return YES;
}


#pragma mark - private method

- (void) runSearchTask {
  _resourceNameList = [NSMutableDictionary new];
  _isRunding = YES;
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [self handleFilesAtPath:_projectPath];
    
    dispatch_async(dispatch_get_main_queue(), ^{
      NSLog(@"files completion!!");
      _isRunding = NO;
    });
  });
}

- (BOOL)handleFilesAtPath: (NSString *)dir {
  
  //Get all files
  NSError *error = nil;
  NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dir error:&error];
  if (files.count == 0) {
    return NO;
  }
  
  for (NSString *file in files) {
    if ([file hasPrefix:@"."]) {
      // filter hide file
      continue;
    }
    
    NSString *tempPath = [[dir stringByAppendingString:@"/"] stringByAppendingString:file];
    if ([self isDirectory:tempPath]) {
      [self handleFilesAtPath: tempPath];
    } else {
      FileType fileType = [self fileTypeByName:tempPath];
      if (fileType == FileTypeNone) {
        continue;
      } else {
        [self parseFileAtPath:tempPath withType:fileType];
      }
    }
  }
  
  return YES;
}

- (void)parseFileAtPath:(NSString *)path withType:(FileType)fileType {
  NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
  if (!content) {
    return;
  }
  
  NSString *pattern = nil;
  NSInteger groupIndex = -1;
  switch (fileType) {
    case FileTypeObjC:
      pattern =  @"(imageNamed)(\\s*:\\s*)(@\"\\w+\")|(GET_IMAGE)(\\(\\w+\\))";
      groupIndex = 1;
      break;
    case FileTypeSwift:
      pattern = @"(imageNamed)(\\s*:\\s*)(@\"\\w+\")"; //@"named:\"(\\S+)\"";//UIImage(named:"xx")
      groupIndex = 1;
      break;
    case FileTypeXib:
      pattern = @"image name=\"(\\S+)\"";//image name="xx"
      groupIndex = 1;
      break;
    case FileTypeHtml:
      pattern = @"img\\s+src=\"(\\S+)\"";//<img src="xx">
      groupIndex = 1;
      break;
    case FileTypeJson:
      pattern = @":\\s+\"(\\S+)\"";//"xx"
      groupIndex = 1;
      break;
    case FileTypeCSS:
    case FileTypePlist:
    case FileTypeH:
    case FileTypeC:
      pattern = @"(\\S+)\\.(png|gif|jpg|jpeg)";//*.png
      groupIndex = 1;
      break;
    default:
      break;
  }
  
  if (pattern && groupIndex >= 0) {
    [self getMatchStringWithContent:content pattern:pattern];
  }
}

- (void)getMatchStringWithContent:(NSString *)content pattern:(NSString*)pattern {
  NSRegularExpression* regexExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
  NSArray* matchs = [regexExpression matchesInString:content options:0 range:NSMakeRange(0, content.length)];
  
  if (matchs.count) {
    for (NSTextCheckingResult *checkingResult in matchs) {
      NSString *res = [content substringWithRange:[checkingResult range]];
      res = [res lastPathComponent];
      res = [StringUtils getNameFormString:res];
      
      if (!res || [res isEqualToString:@""]) {
        continue;
      }
      
      NSString *v = [_resourceNameList objectForKey:res];
      if (!v) {
        [_resourceNameList setObject:res forKey:res];
      }
    }
  }
}




#pragma mark - helper method

- (BOOL)isDirectory:(NSString *)path {
  BOOL isDirectory;
  return [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory;
}

- (FileType)fileTypeByName:(NSString *)name {
  NSString *ext = [[name pathExtension] lowercaseString];
  if (![_fileSuffixs containsObject:ext]) {
    return FileTypeNone;
  }
  if ([ext isEqualTo:@"m"] || [ext isEqualTo:@"mm"]) {
    return FileTypeObjC;
  }
  if ([ext isEqualTo:@"xib"] || [ext isEqualTo:@"storyboard"]) {
    return FileTypeXib;
  }
  if ([ext isEqualTo:@"plist"]) {
    return FileTypePlist;
  }
  if ([ext isEqualTo:@"swift"]) {
    return FileTypeSwift;
  }
  if ([ext isEqualTo:@"h"]) {
    return FileTypeH;
  }
  if ([ext isEqualTo:@"c"] || [ext isEqualTo:@"cpp"]) {
    return FileTypeC;
  }
  if ([ext isEqualTo:@"html"]) {
    return FileTypeHtml;
  }
  if ([ext isEqualTo:@"json"]) {
    return FileTypeJson;
  }
  if ([ext isEqualTo:@"css"]) {
    return FileTypeCSS;
  }
  
  return FileTypeNone;
}


@end
