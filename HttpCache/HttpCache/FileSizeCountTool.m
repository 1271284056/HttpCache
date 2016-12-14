//
//  FileSizeCountTool.m
//  HttpCache
//
//  Created by 张江东 on 16/12/14.
//  Copyright © 2016年 58kuaipai. All rights reserved.
//

#import "FileSizeCountTool.h"
#import "SDImageCache.h"

@implementation FileSizeCountTool

static NSString *kDiskSpaceFreeString(int64_t size) {
    
    
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


+ (NSString *)filesSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return kDiskSpaceFreeString(size);
    }
    return @"0";
}

+ (long long)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size;
    }
    return 0;
}

+ (NSString *)folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSString *cachePath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    cachePath=[cachePath stringByAppendingPathComponent:path];
    long long folderSize=0;
    if ([fileManager fileExistsAtPath:cachePath])
    {
        NSArray *childerFiles=[fileManager subpathsAtPath:cachePath];
        for (NSString *fileName in childerFiles)
        {
            NSString *fileAbsolutePath=[cachePath stringByAppendingPathComponent:fileName];
            long long size=[self fileSizeAtPath:fileAbsolutePath];
            folderSize += size;
            NSLog(@"fileAbsolutePath=%@",fileAbsolutePath);
            
        }
        //SDWebImage框架自身计算缓存的实现
        return kDiskSpaceFreeString(folderSize);
    }
    return @"0";
}

static int64_t kDiskSpaceFree() {
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemFreeSize] longLongValue];
    if (space < 0) space = -1;
    return space;
}

+ (NSString *)diskFreeSpaceSize{
    
    return kDiskSpaceFreeString(kDiskSpaceFree());
}


//同样也是利用NSFileManager API进行文件操作，SDWebImage框架自己实现了清理缓存操作，我们可以直接调用。
+ (void)clearCache:(NSString *)path{
    NSString *cachePath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    cachePath=[cachePath stringByAppendingPathComponent:path];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:cachePath]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:cachePath];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *fileAbsolutePath=[cachePath stringByAppendingPathComponent:fileName];
            NSLog(@"fileAbsolutePath=%@",fileAbsolutePath);
            [fileManager removeItemAtPath:fileAbsolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
}

@end
