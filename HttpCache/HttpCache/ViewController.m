//
//  ViewController.m
//  HttpCache
//
//  Created by 张江东 on 16/12/14.
//  Copyright © 2016年 58kuaipai. All rights reserved.
//

#import "ViewController.h"
#import "HttpRequestCache.h"
#import "FileSizeCountTool.h"
#import "AllCacheTool.h"
#import "WebViewController.h"
#import "NetworkTool.h"
//容量单位转换器
static NSString *DiskSpaceFreeString(int64_t size) {
    if(size < 1024) { //B
        return [NSString stringWithFormat:@"%lldB",size];
    } //KB
    else if (size < 1024.0 * 1024.0) {
        return [NSString stringWithFormat:@"%.1fKB",size / 1024.0f];
    }
    else if (size < 1024.0 * 1024.0 * 1024.0) {
        return [NSString stringWithFormat:@"%.1fMB",size / (1024.0 * 1024.0)];
    } else {
        return [NSString stringWithFormat:@"%.1fG",size / (1024.0 * 1024.0 * 1024.0)];
    }
}

@interface ViewController ()

@end

@implementation ViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
}

//web以及自定义网络请求缓存
- (void)allCache{
    [AllCacheTool start];
    NSArray *arr = @[@"http://www.baidu.com", @"http://www.163.com", @"http://www.tianya.cn", @"http://www.youku.com", @"http://v.baidu.com"];
    for (int i = 0; i < 5; i++) {
        NSString *str = arr[i];
        
        UIButton* button =[UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:str forState:UIControlStateNormal];
        button.frame = CGRectMake(10, 100 * (i + 1), 300, 50);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    
    //   用自己写的网络请求默认经过nsurlprotocal过滤处理  默认缓存
    [NetworkTool getWithUrl:@"http://carprice.58.com/comm/brand.json" andParams:nil success:^(id json) {
        NSLog(@"%@",json);
    } failure:^(NSError *error) {

    }];
    
    

}

-(void)click:(UIButton *)button
{
    WebViewController *web = [[WebViewController alloc] init];
    web.url = button.titleLabel.text;
    [self.navigationController pushViewController:web animated:YES];
}


//用afn做缓存
- (void)afnCache{
    //afn绕过nsurlprotol过滤 默认不做离线缓存
    
    //    [self deleteCache];
    
    
    //isCache== yes时候请求成功一次就一直存着 ,no时候每次都请求最新的并刷新缓存数据,没网时候再用缓存数据
    [HttpRequestCache getRequestCacheUrlStr:@"http://carprice.58.com/comm/brand.json" withDic:nil isCache:YES success:^(NSDictionary *requestDic, NSString *msg) {
        //        NSLog(@"----->hahahha %@",requestDic);
        
    } failure:^(NSString *errorInfo) {
        
    }];
    
    
    YYCache *cache = [[YYCache alloc] initWithName:kCachePath] ;
    cache.diskCache.ageLimit = 3600*12*7;//保存的最大天数单位秒 隔几天删除一次重新请求  一般用于isCache yes时候
    //    cache.diskCache.costLimit 允许占用的最大容量单位是db
    //cache.diskCache.totalCost : 占用的容量单位是db
    
    NSLog(@"---->  %@,%@",DiskSpaceFreeString(cache.diskCache.totalCost),[FileSizeCountTool diskFreeSpaceSize]);
}

-(void)deleteCache
{
    [[[YYCache alloc] initWithName:kCachePath] removeAllObjectsWithProgressBlock:nil endBlock:^(BOOL error) {
        if (!error) {
            NSLog(@"清除成功");
        }
    }];
}





@end
