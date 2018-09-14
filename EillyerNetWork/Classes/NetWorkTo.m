//
//  NetWorkTo.m
//  Share365
//
//  Created by eillyer on 2017/11/10.
//  Copyright © 2017年 eillyer. All rights reserved.
//

#import "NetWorkTo.h"
#import "NetWorkTemp.h"
#import "ServerAPIPath.h"
//#import "UIImage+image.h"
//#import "NSArray+array.h"

#define kLimit 10

@implementation NetWorkTo


+ (void)toGetRegisterSMSVC:(UIViewController *)vc
                   phone:(NSString *)phone
                 Success:(void(^)(NSDictionary *dict))successBlock
                   error:(void(^)(NSString *error))errorBlock{
//    NSDictionary *dic = @{@"mobile":phone};
    NSString *url = [NSString stringWithFormat:@"%@/%@?mobile=%@&platform=1",IAP_MAIN_URL,IAP_GETREGISTERMS_URL,phone];
    [[NetWorkTemp sharedNetWorkTemp] getMethodWithStringsOfURL:url selfVC:vc success:^(NSDictionary *responseDict) {
        successBlock(responseDict);
    } error:^(NSString *error) {
        errorBlock(error);
    }];
    
}

+ (void)toUserRegister:(UIViewController *)vc
        inviter_mobile:(NSString *)inviter_mobile
                 phone:(NSString *)phone
                   SMS:(NSString *)SMS
              password:(NSString *)password
               Success:(void(^)(NSDictionary *dict))successBlock
                 error:(void(^)(NSString *error))errorBlock{
    NSDictionary *dic = @{@"mobile":phone,
                          @"verify_code":SMS,
                          @"inviter_mobile":inviter_mobile,
                          @"password":password
                          };
    NSString *url = [NSString stringWithFormat:@"%@/%@",IAP_MAIN_URL,IAP_GETREGISTERMS_URL];
    
    [[NetWorkTemp sharedNetWorkTemp] postDataWithStringsOfURL:url selfVC:vc isShowProgress:NO parameters:dic success:^(NSDictionary *responseDict) {
        successBlock(responseDict);
    } error:^(NSString *error) {
        errorBlock(error);
    } number:nil];

}





+ (void)toUserUpdataMyICON:(UIViewController *)vc
                 ICONImage:(UIImage *)iconImage
                   Success:(void(^)(NSDictionary *dict))successBlock
                     error:(void(^)(NSString *error))errorBlock{
    NSDictionary *dic = @{
                          @"platform":@"1"
                          };
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",IAP_MAIN_URL,IAP_GETREGISTERMS_URL];
    [[NetWorkTemp sharedNetWorkTemp] postDataWithStringsOfURL:url selfVC:vc isShowProgress:NO imageDataArrOrMp4PathStrArr:@[iconImage] parameters:dic file:@"photo" success:^(NSDictionary *responseDict) {
        successBlock(responseDict);
    } error:^(NSString *error) {
        errorBlock(error);
    } number:^(double number) {
    }];
    
}

@end
