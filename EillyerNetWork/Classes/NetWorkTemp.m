//
//  NetWorkTemp.m
//  affffffffff
//
//  Created by eillyer on 2018/9/14.
//  Copyright © 2018年 eillyer. All rights reserved.
//

#import "NetWorkTemp.h"
#import "AFNetWorkingHelper.h"
#import "MBProgressHUD.h"


#define kAfterDelay 1.5f

@implementation NetWorkTemp

// 单例
+ (instancetype)sharedNetWorkTemp{
    static NetWorkTemp *netWorkTemp = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netWorkTemp = [NetWorkTemp new];
    });
    return netWorkTemp;
}
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
                            error:(void(^)(NSString *error))errorBlock{
    
    
    [[AFNetWorkingHelper sharedAFNetworkingHelper] getMethodWithStringsOfURL:urlStr selfVC:vc success:^(NSDictionary *responseDict) {
        successBlock(responseDict);
    } error:^(NSString *error) {
        errorBlock(error);
        [self showMSG:@"链接失败"];
    }];
}

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
                          number:(void(^)(double number))numberBlock{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    dict[@"platform"] = @"1";
    
//    参数处理 。。。
    
    
    
    [[AFNetWorkingHelper sharedAFNetworkingHelper] postDataWithStringsOfURL:urlStr selfVC:vc isShowProgress:isShow imageDataArrOrMp4PathStrArr:dataArr parameters:dict file:parameter success:^(NSDictionary *responseDict) {
        successBlock(responseDict);
    } error:^(NSString *error) {
        errorBlock(error);
        [self showMSG:@"链接失败"];

    } number:^(double number) {
        numberBlock(number);
    }];
}


- (void)postDataWithStringsOfURL:(NSString *)urlStr
                          selfVC:(UIViewController *)vc
                  isShowProgress:(BOOL)isShow
                      parameters:(NSDictionary *)parameters
                         success:(void(^)(NSDictionary *responseDict))successBlock
                           error:(void(^)(NSString *error))errorBlock
                          number:(void(^)(double number))numberBlock{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    dict[@"platform"] = @"1";
    //    参数处理 。。。

    
    [[AFNetWorkingHelper sharedAFNetworkingHelper] postDataWithStringsOfURL:urlStr selfVC:vc isShowProgress:isShow parameters:parameters success:^(NSDictionary *responseDict) {
        successBlock(responseDict);
    } error:^(NSString *error) {
        errorBlock(error);
        [self showMSG:@"链接失败"];
    } number:^(double number) {
        numberBlock(number);
    }];
}


- (void)showMSG:(NSString *)MSG{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow
                                              animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = MSG;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:kAfterDelay];
}

@end
