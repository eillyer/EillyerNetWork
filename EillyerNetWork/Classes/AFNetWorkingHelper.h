//
//  AFNetWorkingHelper.h
//
//  Created by liyonglong on 2016/8/7.
//  Copyright © 2016年 eillyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerAPIPath.h"
#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    JSONTYPE = 1000,
    XMLTYPE,
    DataTYPE,
    OtherTYPE,
} GetDataType;
@interface AFNetWorkingHelper : NSObject
// 单例
+ (instancetype)sharedAFNetworkingHelper;
/**
   get 请求
 
 @param urlStr 服务器接口地址
 @param vc 当前控制器调用，有值为添加小菊花，无值时为不添加小菊花
 @param successBlock 成功
 @param errorBlock 错误信息
 */
- (void)getMethodWithStringsOfURL:(NSString *)urlStr
                           selfVC:(UIViewController *)vc
                          success:(void(^)(NSDictionary *responseDict))successBlock
                            error:(void(^)(NSString *error))errorBlock;

//通用上传
/**
 通用上传

 @param urlStr 服务器接口地址
 @param vc 有值为添加小菊花，无值时为不添加小菊花
 @param isShow 是否显示进度条
 @param dataArr 图片数组或者视频路径地址数组
 @param parameters 参数
 @param parameter 二进制数据的服务器地址名
 @param successBlock 成功回调
 @param errorBlock 失败回调
 @param numberBlock 进度条
 */
- (void)postDataWithStringsOfURL:(NSString *)urlStr
                          selfVC:(UIViewController *)vc
                  isShowProgress:(BOOL)isShow
     imageDataArrOrMp4PathStrArr:(NSArray *)dataArr
                      parameters:(NSDictionary *)parameters
                            file:(NSString *)parameter
                         success:(void(^)(NSDictionary *responseDict))successBlock
                           error:(void(^)(NSString *error))errorBlock
                          number:(void(^)(double number))numberBlock;


- (void)postDataWithStringsOfURL:(NSString *)urlStr
                          selfVC:(UIViewController *)vc
                  isShowProgress:(BOOL)isShow
                      parameters:(NSDictionary *)parameters
                         success:(void(^)(NSDictionary *responseDict))successBlock
                           error:(void(^)(NSString *error))errorBlock
                          number:(void(^)(double number))numberBlock;

@end
