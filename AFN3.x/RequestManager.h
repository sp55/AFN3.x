//
//  RequestManager.h
//  AFN3.x
//
//  Created by admin on 16/4/13.
//  Copyright © 2016年 AlezJi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define SH_HOST  @"http://192.168.1.1"


/**
 *  请求成功回调
 *
 *  @param returnData 回调block
 */
typedef void (^SuccessBlock)(id resultData);

/**
 *  请求失败回调
 *
 *  @param error 回调block
 */
typedef void (^FailedBlock)(NSError *error);


@interface RequestManager : NSObject

+ (RequestManager*)sharedManager;



//测试
+ (void)TestWithUrl:(NSString *)testUrl
            success:(SuccessBlock)success
            failed:(FailedBlock)failed;

//上传头像
+(void)updateUserIconWithData:(NSData *)data
                       success:(SuccessBlock)success
                        failed:(FailedBlock)failed;


@end
