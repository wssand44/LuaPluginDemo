//
//  PluginManager.m
//  LuaPluginDemo
//
//  Created by song.wang on 14/10/30.
//  Copyright (c) 2014年 song.wang. All rights reserved.
//

#import "PluginManager.h"

#import "ZipArchive.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

@implementation PluginManager

+ (instancetype)sharedManager
{
    static PluginManager *sharedPlugin;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPlugin = [[PluginManager alloc] init];
    });
    return sharedPlugin;
}

+ (BOOL)pluginIsDownload:(NSString *)plugin
{
    NSString *path = [[self class] pluginPathWithPluginName:plugin];
    BOOL isDirectory = NO;
    return [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
}

+ (NSString *)pluginPathWithPluginName:(NSString *)pluginName
{
    return [[[self class] pluginRootPath] stringByAppendingPathComponent:pluginName];
}

+ (NSString *)pluginRootPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+ (void)pushViewController:(UIViewController *)vc
{
    UINavigationController *rootVC = (UINavigationController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    [rootVC pushViewController:vc animated:YES];
}

+ (void)pushViewController:(UIViewController *)vc navigationViewController:(UINavigationController *)navVC
{
    [navVC pushViewController:vc animated:YES];
}

+ (void)handlePluginWithPath:(NSString *)path withPassword:(NSString *)password
{
    ZipArchive *zip = [[ZipArchive alloc] initWithFileManager:[NSFileManager defaultManager]];
    if (password.length > 0) {
        [zip UnzipOpenFile:path Password:password];
    }else {
        [zip UnzipOpenFile:path];
    }
    [zip UnzipFileTo:[PluginManager pluginRootPath] overWrite:YES];
    [zip UnzipCloseFile];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

+ (void)downloadPluginWithURL:(NSString *)url pluginName:(NSString *)plugin success:(void(^)(NSString *))successBlock failure:(void(^)(NSError *))failureBlock
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.zip", url, plugin]]];
    AFHTTPRequestOperation *operation1 = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation1 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = (NSData *)responseObject;
        [data writeToFile:[[[self class] pluginRootPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"temp.zip"]] atomically:YES];
        [[self class] handlePluginWithPath:[[[self class] pluginRootPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"temp.zip"]]withPassword:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:keyWindow animated:YES];
            successBlock([[self class] pluginPathWithPluginName:plugin]);
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failureBlock(error);
            [MBProgressHUD hideAllHUDsForView:keyWindow animated:YES];
        });
    }];
    [operation1 start];
}

@end
