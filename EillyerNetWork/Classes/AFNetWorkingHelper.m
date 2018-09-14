//
//  AFNetWorkingHelper.h
//
//  Created by liyonglong on 2016/8/7.
//  Copyright © 2016年 eillyer. All rights reserved.
//

#import "AFNetWorkingHelper.h"
#import "AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>



//#import "NSString+NowDate.h"
//#import "UIImage+image.h"

#define kProgressViewColor [UIColor redColor]
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface AFNetWorkingHelper ()
@property (nonatomic,strong) AFHTTPSessionManager *sessionManager;// 管理请求
@property (nonatomic,strong) UIActivityIndicatorView *activity;//菊花
@property (nonatomic,strong) UIProgressView * progressView;//进度条
@property (nonatomic,strong) NSString *responseObj;// 返回数据
@end


@implementation AFNetWorkingHelper
// 单例
+ (instancetype)sharedAFNetworkingHelper {
    static AFNetWorkingHelper *networkingHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkingHelper = [AFNetWorkingHelper new];
    });
    return networkingHelper;
}


- (void)getMethodWithStringsOfURL:(NSString *)urlStr
                           selfVC:(UIViewController *)vc
                          success:(void(^)(NSDictionary *responseDict))successBlock
                            error:(void(^)(NSString *error))errorBlock {
    //小菊花
    if (vc) {
        [vc.view addSubview:self.activity];
        self.activity.hidden = NO;
    }
    // 设置返回请求数据类型一般的可以为JSON,XML与NSData类型
    //    AFHTTPResponseSerializer              NSData类型
    //    AFXMLParserResponseSerializer         XML类型
    //    AFJSONResponseSerializer              JSON类型
    self.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.sessionManager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        // 相关下载操作
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功返回的数据
        if (responseObject) {
            //            NSLog(@"GET请求返回的数据为---------%@",responseObject);
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if ([NSJSONSerialization isValidJSONObject:jsonDict]) {
                successBlock(jsonDict);
            }
        } else {
            errorBlock(@"GET请求成功,未有数据!");
        }
        self.activity.hidden = YES;
        [self.activity removeFromSuperview];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败返回的数据
        if (error) {
            errorBlock(error.description);
        }
        self.activity.hidden = YES;
        [self.activity removeFromSuperview];


    }];
}





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
    
    
    
    //小菊花
    if (vc) {
        [vc.view addSubview:self.activity];
        self.activity.hidden = NO;
        self.progressView.hidden = !isShow;
    }
    self.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    if (dataArr.count) {
        //判断是图片还是视频
        if ([[dataArr[0] class] isSubclassOfClass:[NSString class]]) {
            //视频
            [self.sessionManager POST:urlStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                for (NSString *Mp4Path in dataArr) {
                    NSString *path;
                    if ([Mp4Path containsString:@"file://"]) {
                        path = [Mp4Path componentsSeparatedByString:@"file://"].lastObject;
                    }
                    NSData *data = [NSData dataWithContentsOfFile:path];
//                    NSURL *url = [NSURL URLWithString:Mp4Path];
                    NSString *fileName = [NSString stringWithFormat:@"%@ios.mp4",[self stringDateNowTime]];
                    [formData appendPartWithFileData:data
                                                name:parameter
                                            fileName:fileName
                                            mimeType:@"video/mpeg"];
                }
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                // 上传相关
                double a = (double)uploadProgress.completedUnitCount*1.0/(double)uploadProgress.totalUnitCount;
//                numberBlock(a);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.progressView setProgress:a];
                });
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                // 请求成功返回的数据
                if (responseObject) {
                    //            NSLog(@"GET请求返回的数据为---------%@",responseObject);
                    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                    if ([NSJSONSerialization isValidJSONObject:jsonDict]) {
                        successBlock(jsonDict);
                    }
                } else {
                    errorBlock(@"GET请求成功,未有数据!");
                }
                self.activity.hidden = YES;
                [self.activity removeFromSuperview];

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (error) {
                    NSLog(@"mp4上传请求出现错误------%@",error.description);
                    errorBlock(error.description);
                }
                self.activity.hidden = YES;
                [self.activity removeFromSuperview];

            }];
        }else{
            //图片
            [self.sessionManager POST:urlStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
                NSArray *nameArr = [parameter componentsSeparatedByString:@","];
                
                if (dataArr.count) {
                    for (int i = 0; i < dataArr.count; i++) {
                        UIImage *image = nil;
                        if ([dataArr[i] isKindOfClass:[UIImage class]]) {
                            image = dataArr[i];
                        }else{
                            image = [UIImage imageWithData:dataArr[i]];
                        }
                        
//                        if (image.size.width > 1080 || image.size.height > 1080) {
//                            image = [UIImage compressImage:image toTargetWidth:1080];
//                        }
                        
                        
                        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
                        NSString *fileName = [NSString stringWithFormat:@"%@%d.jpg",[self stringDateNowTime],i];
                        if (nameArr.count==1) {
                            
                            [formData appendPartWithFileData:imageData
                                                        name:parameter
                                                    fileName:fileName
                                                    mimeType:@"image/jpg"];
                        }else{
                            [formData appendPartWithFileData:imageData
                                                        name:nameArr[i]
                                                    fileName:fileName
                                                    mimeType:@"image/jpg"];
                        }

                    }
                }
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                // 上传相关
                double a = (double)uploadProgress.completedUnitCount*1.0/(double)uploadProgress.totalUnitCount;
                if( numberBlock ) numberBlock(a);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.progressView setProgress:a];
                });
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                // 请求成功返回的数据
                if (responseObject) {
                    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                    if ([NSJSONSerialization isValidJSONObject:jsonDict]) {
                        successBlock(jsonDict);
                    }
                } else {
                    errorBlock(@"GET请求成功,未有数据!");
                }
                self.activity.hidden = YES;
                [self.activity removeFromSuperview];

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                if (error) {
                    NSLog(@"图片上传请求出现错误------%@",error.description);
                    errorBlock(error.description);
                }
                self.activity.hidden = YES;
                [self.activity removeFromSuperview];

            }];
        }
    }else{
        //普通
        [self.sessionManager POST:urlStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        } progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 请求成功返回的数据
            if (responseObject) {
                //                        NSLog(@"GET请求返回的数据为---------%@",responseObject);
                NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                if ([NSJSONSerialization isValidJSONObject:jsonDict]) {
                    successBlock(jsonDict);
                }
            } else {
                errorBlock(@"Post请求成功,未有数据!");
            }
            self.activity.hidden = YES;
            [self.activity removeFromSuperview];

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error) {
                            NSLog(@"POST请求出现错误------%@",error.description);
                errorBlock(error.description);
            }
            self.activity.hidden = YES;
            [self.activity removeFromSuperview];

        }];
    }
}



- (void)postDataWithStringsOfURL:(NSString *)urlStr
                          selfVC:(UIViewController *)vc
                  isShowProgress:(BOOL)isShow
                      parameters:(NSDictionary *)parameters
                         success:(void(^)(NSDictionary *responseDict))successBlock
                           error:(void(^)(NSString *error))errorBlock
                          number:(void(^)(double number))numberBlock{
    
    //小菊花
    if (vc) {
        [vc.view addSubview:self.activity];
        self.activity.hidden = NO;
        self.progressView.hidden = !isShow;
    }
    self.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];

    [self.sessionManager POST:urlStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功返回的数据
        if (responseObject) {
            //                        NSLog(@"GET请求返回的数据为---------%@",responseObject);
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if ([NSJSONSerialization isValidJSONObject:jsonDict]) {
                successBlock(jsonDict);

//                if ([jsonDict[@"data"] isKindOfClass:[NSDictionary class]] && [[jsonDict[@"data"] allKeys] containsObject:@"session_token"]) {
//                    NSMutableDictionary *dict = [NSMutableDictionary new];
//                    for (NSString *key in [jsonDict allKeys]) {
//                        if (![key isEqualToString:@"data"]) {
//                            dict[key] = jsonDict[key];
//                        }else{
//                            for (NSString *subKey in [jsonDict[@"data"] allKeys]) {
//                                if (![subKey isEqualToString:@"session_token"]) {
//                                    dict[@"data"][key] = jsonDict[@"data"][key];
//                                }
//                            }
//                        }
//                    }
//
//                    [Utility saveUserInfoModel:jsonDict[@"data"]];
//                    successBlock(dict);
//                }else{
//                    successBlock(jsonDict);
//                }
            }
        } else {
            errorBlock(@"Post请求成功,未有数据!");
        }
        self.activity.hidden = YES;
        [self.activity removeFromSuperview];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"POST请求出现错误------%@",error.description);
            errorBlock(error.description);
        }
        self.activity.hidden = YES;
        [self.activity removeFromSuperview];

    }];
}



#pragma mark -- 懒加载
- (UIActivityIndicatorView *)activity{
    if (!_activity) {
        _activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [_activity startAnimating];
        _activity.color = [UIColor blackColor];
        _activity.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _activity.hidden = YES;
    }
    return _activity;
}

- (UIProgressView *)progressView{
    if (!_progressView) {
        //        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame = CGRectMake(0, 1, kScreenWidth, 10);
        //        _progressView.center = self.view.center;
        [_activity addSubview:_progressView];
        //        _progressView.progress = 0;
        _progressView.progressTintColor = kProgressViewColor;
        _progressView.trackTintColor = [UIColor whiteColor];
        _progressView.hidden = YES;
        [_progressView setProgress:0.0];
    }
    return _progressView;
}


- (AFHTTPSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
        [_sessionManager.requestSerializer setTimeoutInterval:10.0];
    }
    return _sessionManager;
}


- (NSString *)setPWD:(NSString *)str{
    NSString *pwd = [NSString stringWithFormat:@"****%@",str];
    const char* input = [pwd UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    return digest;
}

//- (void)mySecurityMeasures{
//    if ([self getNetWorkStates]) {
//            [Bmob registerWithAppKey:kAppKey];
//            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//        int a = arc4random() % 90;
//        NSString *name = [NSString stringWithFormat:@"share%d",a];
//            [BmobUser loginWithUsernameInBackground:name password:name block:^(BmobUser *user, NSError *error) {
//                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//                if (error != nil && user == nil){
//                    if ([[error.userInfo allKeys] containsObject:@"NSLocalizedDescription"]) {
//                        if ([error.userInfo[@"NSLocalizedDescription"] isEqualToString:@"username or password incorrect."]) {
//                            exit(1);
//                        }
//                    }
//                }
//            }];
//    }
//}

- (BOOL)getNetWorkStates{
    
    
    
    /*
    NSArray *typeStrings2G = @[CTRadioAccessTechnologyEdge,
                               CTRadioAccessTechnologyGPRS,
                               CTRadioAccessTechnologyCDMA1x];
    
    NSArray *typeStrings3G = @[CTRadioAccessTechnologyHSDPA,
                               CTRadioAccessTechnologyWCDMA,
                               CTRadioAccessTechnologyHSUPA,
                               CTRadioAccessTechnologyCDMAEVDORev0,
                               CTRadioAccessTechnologyCDMAEVDORevA,
                               CTRadioAccessTechnologyCDMAEVDORevB,
                               CTRadioAccessTechnologyeHRPD];
    
    NSArray *typeStrings4G = @[CTRadioAccessTechnologyLTE];
    // 该 API 在 iOS7 以上系统才有效
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        CTTelephonyNetworkInfo *teleInfo= [[CTTelephonyNetworkInfo alloc] init];
        NSString *accessString = teleInfo.currentRadioAccessTechnology;
        if ([typeStrings4G containsObject:accessString]) {
            NSLog(@"4G网络");
            return YES;
        } else if ([typeStrings3G containsObject:accessString]) {
            NSLog(@"3G网络");
            return YES;
            
        } else if ([typeStrings2G containsObject:accessString]) {
            NSLog(@"2G网络");
            return YES;
            
        } else {
            NSLog(@"未知网络");
            return YES;
            
        }
    } else {
        NSLog(@"未知网络");
        return NO;
        
    }
     */
    

    UIApplication *app = [UIApplication sharedApplication];
    
    NSMutableArray *arr = [NSMutableArray new];
    if ([[app valueForKeyPath:@"_statusBar"] isKindOfClass:NSClassFromString(@"UIStatusBar_Modern")]) {
        NSArray *childrena = [[[[app valueForKeyPath:@"_statusBar"] valueForKeyPath:@"_statusBar"] valueForKeyPath:@"foregroundView"] subviews];
        [arr addObjectsFromArray:childrena];
    } else {
        NSArray *childrena = [[[app valueForKeyPath:@"_statusBar"] valueForKeyPath:@"foregroundView"] subviews];
        [arr addObjectsFromArray:childrena];
        
    }
    //    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = [[NSString alloc]init];
    
    int netType = 0;
    //获取到网络返回码
    for (id child in arr) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
                    state = @"无网络";
                    //无网模式
                    break;
                case 1:
                    state =  @"2G";
                    break;
                case 2:
                    state =  @"3G";
                    break;
                case 3:
                    state =   @"4G";
                    break;
                case 5:
                {
                    state =  @"wifi";
                    break;
                default:
                    break;
                }
            }
        }
        //根据状态选择
    }
    if ([@[@"2G",@"3G",@"4G",@"wifi"] containsObject:state]) {
        return YES;
    }else{
        return NO;
    }
}

- (NSString *)stringDateNowTime{
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd-HH-mm-ss";
    NSDate *date = [NSDate date];
    NSString *dateNow = [formatter stringFromDate:date];
    return dateNow;
}
@end
