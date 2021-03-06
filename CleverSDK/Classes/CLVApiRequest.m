//
//  CLVApiRequest.m
//  CleverSDK
//
//  Created by Nikhil Pandit on 4/7/15.
//
//

#import "CLVApiRequest.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "CLVOAuthManager.h"
#import "AFHTTPSessionManager.h"

@interface CLVApiRequest : AFHTTPSessionManager

+ (instancetype)sharedManager;

+ (void)endpoint:(NSString *)endpoint params:(NSDictionary *)params
         success:(void (^)(NSURLSessionDataTask *task, id responseObject))successHandler
         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failureHandler;

@end

@implementation CLVApiRequest

+ (instancetype)sharedManager {
    static CLVApiRequest *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        _sharedManager = [[CLVApiRequest alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.clever.com/"]];
        _sharedManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _sharedManager.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    [_sharedManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [CLVOAuthManager accessToken]] forHTTPHeaderField:@"Authorization"];
    return _sharedManager;
}

+ (void)endpoint:(NSString *)endpoint params:(NSDictionary *)params
         success:(void (^)(NSURLSessionDataTask *task, id responseObject))successHandler
         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failureHandler {
    
    [[CLVApiRequest sharedManager] GET:endpoint parameters:params success:successHandler failure:failureHandler];
}

@end
