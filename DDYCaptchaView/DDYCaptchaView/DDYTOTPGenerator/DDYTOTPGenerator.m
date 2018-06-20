/**
 *  HOTP（HMAC-based One-Time Password, 基于HMAC的一次性口令）
 *  TOTP（Time-Based One-Time Password, 基于时间的一次性口令）
 *  HMAC (Hash-based message authentication code, 基于散列函数的消息认证码算法)
 */

#import "DDYTOTPGenerator.h"
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonDigest.h>

static NSUInteger DIGITS_POWER[] = {
    1,
    10,
    100,
    1000,
    10000,
    100000,
    1000000,
    10000000,
    100000000,
};

@interface DDYTOTPGenerator ()
/** 秘钥 */
@property (nonatomic, strong) NSString *secret;
/** 加密法则 */
@property (nonatomic, assign) DDYTOTPAlgorithm algorithm;
/** 生成的动态码位数 */
@property (nonatomic, assign) NSUInteger digits;
/** 有效期限 */
@property (nonatomic, assign) NSTimeInterval period;

@end

@implementation DDYTOTPGenerator

+ (instancetype)generatorWithSecret:(NSString *)secret
                          algorithm:(DDYTOTPAlgorithm)algorithm
                             digits:(NSUInteger)digits
                             period:(NSTimeInterval)period {
    return [[self alloc] initWithSecret:secret algorithm:algorithm digits:digits period:period];
    
}

- (instancetype)initWithSecret:(NSString *)secret
                     algorithm:(DDYTOTPAlgorithm)algorithm
                        digits:(NSUInteger)digits
                        period:(NSTimeInterval)period {
    if (self = [super init]) {
        _secret = secret;
        _algorithm = algorithm;
        _digits = digits;
        _period = period;
        
        if (_digits<6 || _digits>8 || !_digits) NSLog(@"digits error");
        if (_period<1 || _period>300) NSLog(@"period error");
    }
    return self;
}

- (NSString *)generateWithDate:(NSDate *)date {
    if (!date) date = [NSDate date];
    
    NSTimeInterval seconds = [date timeIntervalSince1970];
    
    CCHmacAlgorithm alg;
    NSUInteger hashLength = 0;
    
    if (_algorithm == 1) {
        alg = kCCHmacAlgSHA256;
        hashLength = CC_SHA256_DIGEST_LENGTH;
    } else if (_algorithm == 2) {
        alg = kCCHmacAlgSHA512;
        hashLength = CC_SHA512_DIGEST_LENGTH;
    } else if (_algorithm == 3) {
        alg = kCCHmacAlgMD5;
        hashLength = CC_MD5_DIGEST_LENGTH;
    } else {
        alg = kCCHmacAlgSHA1;
        hashLength = CC_SHA1_DIGEST_LENGTH;
    }
    
    NSMutableData *hashData = [NSMutableData dataWithLength:hashLength];
    uint64_t counter = CFSwapInt64HostToBig((uint64_t)(seconds / _period)); //NSSwapHostLongLongToBig()
    NSData *counterData = [NSData dataWithBytes:&counter length:sizeof(counter)];
    
    NSData *secretData = [_secret dataUsingEncoding:NSASCIIStringEncoding];
    
    CCHmacContext ctx;
    CCHmacInit(&ctx, alg, [secretData bytes], [secretData length]);
    CCHmacUpdate(&ctx, [counterData bytes], [counterData length]);
    CCHmacFinal(&ctx, [hashData mutableBytes]);
    
    const char *ptr = [hashData bytes];
    unsigned char offset = ptr[hashLength-1] & 0x0f;
    uint32_t truncatedHash =
    NSSwapBigIntToHost(*((uint32_t *)&ptr[offset])) & 0x7fffffff;
    uint32_t pinValue = truncatedHash % DIGITS_POWER[_digits];
    
    return [NSString stringWithFormat:@"%0*u", (int)_digits, pinValue];
}

@end

/**
 public class PasscodeGenerator {
 private static final int MAX_PASSCODE_LENGTH = 8;
 
 private static final int[] DIGITS_POWER
 // 0 1  2   3    4     5      6       7        8
 = {1,10,100,1000,10000,100000,1000000,10000000,100000000};
 
 private final Signer signer;
 private final int codeLength;
 
 interface Signer {
 byte[] sign(byte[] data) throws GeneralSecurityException;
 }
 
 public PasscodeGenerator(Signer signer, int passCodeLength) {
 if ((passCodeLength < 0) || (passCodeLength > MAX_PASSCODE_LENGTH)) {
 throw new IllegalArgumentException(
 "PassCodeLength must be between 1 and " + MAX_PASSCODE_LENGTH
 + " digits.");
 }
 this.signer = signer;
 this.codeLength = passCodeLength;
 }
 
 private String padOutput(int value) {
 String result = Integer.toString(value);
 for (int i = result.length(); i < codeLength; i++) {
 result = "0" + result;
 }
 return result;
 }
 
 public String generateResponseCode(long state)
 throws GeneralSecurityException {
 byte[] value = ByteBuffer.allocate(8).putLong(state).array();
 return generateResponseCode(value);
 }
 
 public String generateResponseCode(byte[] challenge)
 throws GeneralSecurityException {
 byte[] hash = signer.sign(challenge);
 
 int offset = hash[hash.length - 1] & 0xF;
 int truncatedHash = hashToInt(hash, offset) & 0x7FFFFFFF;
 int pinValue = truncatedHash % DIGITS_POWER[codeLength];
 return padOutput(pinValue);
 }
 
 private int hashToInt(byte[] bytes, int start) {
 DataInput input = new DataInputStream(
 new ByteArrayInputStream(bytes, start, bytes.length - start));
 int val;
 try {
 val = input.readInt();
 } catch (IOException e) {
 throw new IllegalStateException(e);
 }
 return val;
 }
 }
 */
