#import "DDYCaptchaCodeView.h"

static inline UIColor * ddy_Color(int r, int g, int b) { return [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:1]; }
static inline int ddy_random(int upper) { return arc4random_uniform(upper); }

@implementation DDYCaptchaCodeView
@synthesize captchaString = _captchaString;

+ (instancetype)codeViewWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.charCodeArray = [[NSArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",nil];
        self.interferenceLineCount = 6;
        self.interferenceLineWidth = 1.5;
        self.randomCharCount = 6;

        [self getRandomCaptchaCode];
    }
    return self;
}

#pragma mark 得到随机验证码
- (void)getRandomCaptchaCode {
    _captchaString = [NSString stringWithFormat:@""];
    for (int i = 0; i < _randomCharCount; i++) {
        NSInteger index = arc4random() % ([self.charCodeArray count]);
        _captchaString = [NSString stringWithFormat:@"%@%@",_captchaString ? _captchaString : @"", self.charCodeArray[index]];
    }
    self.image = [self getRandomCaptchaImage];;
}

#pragma mark 点击界面，刷新生成新的验证码
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self getRandomCaptchaCode];
}

- (UIImage *)getRandomCaptchaImage {
    UIGraphicsBeginImageContext(CGSizeMake(self.bounds.size.width, self.bounds.size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [ddy_Color(ddy_random(150)+50, ddy_random(150)+50, ddy_random(150)+50) CGColor]);
    CGContextFillRect(context, self.bounds);
    CGContextSetLineWidth(context, _interferenceLineWidth);
    
    NSString *text = [NSString stringWithFormat:@"%@", _captchaString];
    CGSize cSize = [@"S" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:25]}];
    int width = self.bounds.size.width / text.length - cSize.width;
    int height = self.bounds.size.height - cSize.height;
    
    // 依次绘制每一个字符,可以设置显示的每个字符的字体大小、颜色、样式等
    for (int i = 0; i < text.length; i++) {
        float pX = ddy_random(width) + self.bounds.size.width / text.length * i;
        float pY = ddy_random(height);
        unichar c = [text characterAtIndex:i];
        NSString *textC = [NSString stringWithFormat:@"%C", c];
        NSDictionary *Attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:ddy_random(10)+ 15], NSForegroundColorAttributeName:[UIColor whiteColor]};
        [textC drawAtPoint:CGPointMake(pX, pY) withAttributes:Attributes];
    }
    
    //绘制干扰的彩色直线
    for (int i = 0; i < _interferenceLineCount; i++) {
        // 设置线的随机颜色
        CGContextSetStrokeColorWithColor(context, [ddy_Color(ddy_random(230), ddy_random(230), ddy_random(230)) CGColor]);
        // 设置线的起点
        CGContextMoveToPoint(context, ddy_random((int)self.bounds.size.width), ddy_random((int)self.bounds.size.height));
        // 设置线终点
        CGContextAddLineToPoint(context, ddy_random((int)self.bounds.size.width), ddy_random((int)self.bounds.size.height));
        CGContextStrokePath(context);
    }
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end

/**
 *  单纯本地生成一个随机码并不能真正识别人机
 *  如果想要真正识别人机，可以利用特定算法(和后台一致的算法)结合时间戳以及密钥生成随机码，类似google Authenticator
 *  
 *  https://www.vtrois.com/totp-tutorial.html
 *  https://github.com/google/google-authenticator
 */
