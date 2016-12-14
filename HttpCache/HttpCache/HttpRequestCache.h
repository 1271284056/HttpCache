//
//  HttpRequestCache.h
//  HttpCache
//
//  Created by 张江东 on 16/12/14.
//  Copyright © 2016年 58kuaipai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <YYCache/YYCache.h>

typedef void (^SuccessBlock)(NSDictionary * requestDic, NSString * msg);
typedef void (^FailureBlock)(NSString *errorInfo);
typedef void (^loadProgress)(float progress);

@interface HttpRequestCache : NSObject


#define kCachePath @"network/HttpCache1"

+ (void)getRequestCacheUrlStr:(NSString *)urlStr withDic:(NSDictionary *)parameters success:(SuccessBlock)success failure:(FailureBlock)failuer ;

@end
