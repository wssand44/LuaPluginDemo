//
//  PluginManager.h
//  LuaPluginDemo
//
//  Created by song.wang on 14/10/30.
//  Copyright (c) 2014年 song.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PluginManager : NSObject

+ (instancetype)sharedManager;

/**
 *  <#Description#>
 *
 *  @param plugin <#plugin description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)pluginIsDownload:(NSString *)plugin;

/**
 *  根据pluginName返回plugin 路径
 *
 *  @param pluginName
 *
 *  @return plugin 路径
 */
+ (NSString *)pluginPathWithPluginName:(NSString *)pluginName;

/**
 *  返回Plugin的根目录
 *
 *  @return rootPath
 */
+ (NSString *)pluginRootPath;

/**
 *  适用于根视图是UINavigationController 的情况
 *
 *  @param vc
 */
+ (void)pushViewController:(UIViewController *)vc;

/**
 *  适用于根视图不是的情况,自己传人UINavigationController 对象
 *
 *  @param vc
 */
+ (void)pushViewController:(UIViewController *)vc navigationViewController:(UINavigationController *)navVC;

/**
 *  处理下载回来的plugin压缩包
 *
 *  @param path
 *  @param password
 */
+ (void)handlePluginWithPath:(NSString *)path withPassword:(NSString *)password;

/**
 *  下载
 *
 *  @param url          <#url description#>
 *  @param plugin       <#plugin description#>
 *  @param successBlock <#successBlock description#>
 *  @param failureBlock <#failureBlock description#>
 */
+ (void)downloadPluginWithURL:(NSString *)url pluginName:(NSString *)plugin success:(void(^)(NSString *))successBlock failure:(void(^)(NSError *))failureBlock;

@end
