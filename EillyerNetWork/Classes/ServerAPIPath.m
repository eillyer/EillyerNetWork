//
//  ServerAPIPath.m
//  etip
//

#import "ServerAPIPath.h"
#import <CommonCrypto/CommonCrypto.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

#import <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"


NSString *const APP_STORE_ID = @"....";

#ifdef DEBUG
NSString *const IAP_MAIN_URL = @"http://";
#else
NSString *const IAP_MAIN_URL = @"http://";
#endif


NSString *const IAP_GETREGISTERMS_URL = @"...";
//NSString *const  = @"";
//NSString *const  = @"";
//NSString *const  = @"";
//NSString *const  = @"";
//NSString *const  = @"";
//NSString *const  = @"";
//NSString *const  = @"";
//NSString *const  = @"";
//NSString *const  = @"";
//NSString *const  = @"";
//NSString *const  = @"";
//NSString *const  = @"";
//NSString *const  = @"";
//NSString *const  = @"";
//NSString *const  = @"";












@implementation ServerAPIPath

+ (NSDictionary *)getIPAddresss{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}


+ (NSString *)getIPAddress{
    /*
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;*/
    
    /*
    NSDictionary *dict = [ServerAPIPath getIPAddresss];
    
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
    if ([state isEqualToString:@"wifi"]) {
        return dict[@"en0/ipv4"];
    }else{
        return dict[@"pdp_ip0/ipv4"];
    }
     */
    
    return @"ASdf";
}




+ (NSString *)getBinaryByDeciaml:(NSInteger)decimal{
    NSString *binary = @"";
    while (decimal) {
        binary = [[NSString stringWithFormat:@"%ld",decimal%2] stringByAppendingString:binary];
        if (decimal/2<1) {
            break;
        }
        decimal = decimal / 2;
        
    }
    if (binary.length % 4 != 0) {
        NSMutableString *mStr = [NSMutableString new];
        for (int i = 0; i < 4 - binary.length%4; i++) {
            [mStr appendString:@"0"];
        }
        binary = [mStr stringByAppendingString:binary];
    }
    return binary;
}

+ (NSString *)fanzhuanStr:(NSString *)str{
    //    NSString *tempStr = str;
    if (str.length) {
        NSLog(@"===%@",str);
        NSMutableString *reString = [NSMutableString new];
        for (int i = 0 ;i < str.length-1;i++) {
            unichar c = [str characterAtIndex:str.length-1-i];
            [reString appendFormat:@"%c,",c];
        }
        NSLog(@"===%@",reString);
        return reString;
    }else{
        return @"0";
    }
}


@end
