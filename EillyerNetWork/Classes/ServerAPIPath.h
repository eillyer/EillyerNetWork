//
//  ServerAPIPath.h
//  etip
//


#import <Foundation/Foundation.h>


extern NSString *const APP_STORE_ID;

extern NSString *const IAP_MAIN_URL;

//用户
extern NSString *const IAP_GETREGISTERMS_URL;//用户注册获取验证码

//extern NSString *const IAP__URL;//
//extern NSString *const IAP__URL;//
//extern NSString *const IAP__URL;//
//extern NSString *const IAP__URL;//
//extern NSString *const IAP__URL;//
//extern NSString *const IAP__URL;//
//extern NSString *const IAP__URL;//
//extern NSString *const IAP__URL;//
//extern NSString *const IAP__URL;//
//extern NSString *const IAP__URL;//
//extern NSString *const IAP__URL;//
//extern NSString *const IAP__URL;//
//extern NSString *const IAP__URL;//
//extern NSString *const IAP__URL;//
//extern NSString *const IAP__URL;//
//extern NSString *const IAP__URL;//










@interface ServerAPIPath : NSObject
//加密
//+ (NSString *)setPWD:(NSString *)str;
//获取ip地址
+ (NSDictionary *)getIPAddresss;

+ (NSString *)getIPAddress;
/**
 十进制转二进制
 
 @param decimal 十进制数
 @return 二进制字符串
 */
+ (NSString *)getBinaryByDeciaml:(NSInteger)decimal;

/**
 反转字符串
 
 @param str 原字符串
 @return 反转后的字符串
 */
+ (NSString *)fanzhuanStr:(NSString *)str;


@end
