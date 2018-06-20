#import <UIKit/UIKit.h>

@interface DDYCaptchaCodeView : UIImageView
/** 验证码字符集 默认数字和字母 */
@property (nonatomic, strong) NSArray *charCodeArray;
/** 干扰线数目 默认6 */
@property (nonatomic, assign) NSUInteger interferenceLineCount;
/** 干扰线线宽 默认1.5 */
@property (nonatomic, assign) CGFloat interferenceLineWidth;
/** 随机字符个数 默认6 */
@property (nonatomic, assign) NSUInteger randomCharCount;

/** 验证码字符串 */
@property (nonatomic, strong, readonly) NSString *captchaString;

+ (instancetype)codeViewWithFrame:(CGRect)frame;

@end
