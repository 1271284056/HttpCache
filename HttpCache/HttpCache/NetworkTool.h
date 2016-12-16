//
//  NetworkTool.h
//  WebCacheDemo
//
//  Created by 张江东 on 16/12/15.
//  Copyright © 2016年 YM. All rights reserved.
//  自己写的网络请求  经过NSURLProtocol处理 默认都是缓存的

#import <Foundation/Foundation.h>

@interface NetworkTool : NSObject
+ (void)getWithUrl:(NSString *)url andParams:(NSDictionary *)dict success:(void(^)(id json))success failure:(void(^)(NSError *error))failure;

//+ (void)postWithUrl:(NSString *)url andParams:(NSDictionary *)dict success:(void(^)(id json))success failure:(void(^)(NSError *error))failure;
@end
