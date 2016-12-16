//
//  HttpRequestCache.h
//  HttpCache
//
//  Created by 张江东 on 16/12/14.
//  Copyright © 2016年 58kuaipai. All rights reserved.
//  用afn作缓存 afn屏蔽了NSURLProtocol 

#import <Foundation/Foundation.h>

typedef void (^SuccessBlock)(NSDictionary * requestDic, NSString * msg);
typedef void (^FailureBlock)(NSString *errorInfo);
typedef void (^loadProgress)(float progress);

@interface HttpRequestCache : NSObject


#define kCachePath @"network/HttpCache1"

+ (void)getRequestCacheUrlStr:(NSString *)urlStr withDic:(NSDictionary *)parameters isCache:(BOOL)isCache success:(SuccessBlock)success failure:(FailureBlock)failuer;

@end
