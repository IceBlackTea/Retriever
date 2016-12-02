//
//  REHelper.h
//  Retriever
//
//  Created by cyan on 2016/10/21.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface REHelper : NSObject

+ (NSArray *)installedApplications;

+ (NSArray *)installedPlugins;

+ (NSString *)bundleIdentifierForApplication:(id)app;

+ (NSString *)displayNameForApplication:(id)app;

+ (UIImage *)iconImageForApplication:(id)app;

+ (id)applicationForIdentifier:(NSString *)identifier;

+ (NSArray *)applicationsForIdentifiers:(NSArray *)identifiers;

+ (void)openApplication:(id)app;

+ (void)shareRetriever;

+ (NSDictionary *)dictForObject:(id)obj;

@end
