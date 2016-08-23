//
//  RequestManager.m
//  AFN3.x
//
//  Created by admin on 16/4/13.
//  Copyright © 2016年 AlezJi. All rights reserved.
//

#import "RequestManager.h"
#import "AFNetworking.h"
#import "RealReachability.h"


@implementation RequestManager

+(RequestManager *)sharedManager{
    static RequestManager *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc]init];
    });
    return instance;
}
//get
-(void)getDataWithGetType:(NSString *)url
             successBlock:(SuccessBlock)success
             failureBlock:(FailedBlock)failure{
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
#ifdef DEBUG
    NSLog(@"GET url:\n%@",url);
#endif
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
#ifdef DEBUG
        NSLog(@"successed downloadProgress:\n%@",downloadProgress);
#endif
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        if (success) {
#ifdef DEBUG
        NSLog(@"successed responseObject:\n%@",responseObject);
#endif
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
#ifdef DEBUG
        NSLog(@"failed error:\n%@",error.localizedDescription);
#endif
        failure(error);
        }
    }];

}

//post
-(void)postDataByUrl:(NSString *)url
        byDictionary:(NSDictionary *)dictionary
        successBlock:(SuccessBlock)success
        failureBlock:(FailedBlock)failure{
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:SH_HOST]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setTimeoutInterval:5];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"",@"", nil];
    [params addEntriesFromDictionary:dictionary];
#ifdef DEBUG
    NSLog(@"POST url:\n%@\nparameters:\n%@",url,params );
#endif
    
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
#ifdef DEBUG
        NSLog(@"successed uploadProgress:\n%@",uploadProgress);
#endif
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success){
#ifdef DEBUG
        NSLog(@"successed responseObject:\n%@",responseObject);
#endif
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
#ifdef DEBUG
        NSLog(@"failed response:\n%@",error.description);
#endif
            failure(error);
        }
    }];
}


+(BOOL)isNetWorking
{
    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
    if (status == RealStatusNotReachable)
    {
        NSLog(@"没有网");
        return NO;
    }
    
    if (status == RealStatusViaWiFi)
    {
        NSLog(@"有WiFi");
        
        return YES;
    }
    
    if (status == RealStatusViaWWAN)
    {
        NSLog(@"有WLAN");
        
        return YES;
    }
    return NO;
    
}

//测试
+ (void)TestWithUrl:(NSString *)testUrl
            success:(SuccessBlock)success
             failed:(FailedBlock)failed{
    [[self sharedManager] getDataWithGetType:testUrl successBlock:success failureBlock:failed];
}


//上传头像
+(void)updateUserIconWithData:(NSData *)data
                      success:(SuccessBlock)success
                       failed:(FailedBlock)failed{
    
    NSString *url=[NSString stringWithFormat:@"%@",@"http://www.baidu.com"];
    NSDictionary *params = @{@"userIconFile":data};
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //这个就是参数
        [formData appendPartWithFileData:data name:@"file" fileName:@"123.png" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //打印下上传进度
        NSLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功
        NSLog(@"请求成功：%@",responseObject);
        //成功回调
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        NSLog(@"请求失败：%@",error);
        //失败回调
        failed(error);
    }];

}


@end
