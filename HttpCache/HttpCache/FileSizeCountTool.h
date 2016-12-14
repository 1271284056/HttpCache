//
//  FileSizeCountTool.h
//  HttpCache
//
//  Created by 张江东 on 16/12/14.
//  Copyright © 2016年 58kuaipai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileSizeCountTool : NSObject


//设备可用容量
+ (NSString *)diskFreeSpaceSize;

//单个文件数据量
+ (NSString *)filesSizeAtPath:(NSString *)path;

//文件夹缓存数据量
+ (NSString *)folderSizeAtPath:(NSString *)path;

//清空缓存
+ (void)clearCache:(NSString *)path;



@end
