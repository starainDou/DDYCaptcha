#import <Foundation/Foundation.h>

/** Algorithm 加密法则 */
typedef NS_ENUM(NSInteger, DDYTOTPAlgorithm) {
    DDYTOTPAlgorithmSHA1   = 0,
    DDYTOTPAlgorithmSHA256 = 1,
    DDYTOTPAlgorithmSHA512 = 2,
    DDYTOTPAlgorithmSHAMD5 = 3,
};

@interface DDYTOTPGenerator : NSObject

/**
 初始化
 @param secret 密钥
 @param algorithm 加密法则 默认SHA1
 @param digits 生成的动态码位数 范围[6, 8]
 @param period 有效期限 范围[1, 300]
 @return 生成器实例
 */
+ (instancetype)generatorWithSecret:(NSString *)secret
                     algorithm:(DDYTOTPAlgorithm)algorithm
                        digits:(NSUInteger)digits
                        period:(NSTimeInterval)period;

/**
 根据时间生成动态码
 @param date 时间Date
 @return 传入的时间对应的动态码字符串(唯一的，可以得到过去某时间动态码)
 */
- (NSString *)generateWithDate:(NSDate *)date;

@end
