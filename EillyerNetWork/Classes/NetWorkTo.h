//
//  NetWorkTo.h
//  Share365
//
//  Created by eillyer on 2017/11/10.
//  Copyright © 2017年 eillyer. All rights reserved.
//
/*
 
 
 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,theType) {
   typt1,
   typt2,
   typt3
};


typedef NS_OPTIONS(NSInteger,anWeiYu) {
    typt11                                = 1,
    typt21                                = 1 << 1,
    typt31                                = 1 << 2
};


#import <Foundation/Foundation.h>

@interface NetWorkTo : NSObject
//@property (nonatomic,assign) cardType cardType;




/**
 用户注册获取验证码 [phone:电话号码]
 
 @param vc 当前vc，当传入参数显示小菊花，不传入不显示
 @param phone 参数：电话号码
 @param successBlock 成功回调
 @param errorBlock 失败回调
 */
+ (void)toGetRegisterSMSVC:(UIViewController *)vc
                phone:(NSString *)phone
              Success:(void(^)(NSDictionary *dict))successBlock
                error:(void(^)(NSString *error))errorBlock;


@end

