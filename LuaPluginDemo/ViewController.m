//
//  ViewController.m
//  LuaPluginDemo
//
//  Created by song.wang on 14/10/29.
//  Copyright (c) 2014年 song.wang. All rights reserved.
//

#import "ViewController.h"

#import "wax/wax.h"

#import "PluginManager.h"
#import "ZipArchive.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    NSString *plugin = [NSString stringWithFormat:@"Plugin%d", indexPath.row];
    cell.textLabel.text = plugin;
    if ([PluginManager pluginIsDownload:plugin]) {
        cell.backgroundColor = [UIColor greenColor];
    }else {
        cell.backgroundColor = [UIColor purpleColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    wax_end();
    NSString *plugin = [NSString stringWithFormat:@"Plugin%d", indexPath.row];
    char *pluginPath = (char *)[[PluginManager pluginPathWithPluginName:plugin] UTF8String];
    
    NSLog(@"%s", pluginPath);
   
    if ([PluginManager pluginIsDownload:plugin]) {
         wax_start_plugin(pluginPath, "init.lua", nil);
    }else {
        [PluginManager downloadPluginWithURL:@"http://goldbasket.sinaapp.com" pluginName:plugin success:^(NSString *pluginPath) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.backgroundColor = [UIColor greenColor];
            wax_start_plugin((char *)[pluginPath UTF8String], "init.lua", nil);
        } failure:^(NSError *error) {
            
        }];
    }
}

@end
