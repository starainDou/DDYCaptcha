#import "DDYSliderImageDraw.h"

@implementation DDYSliderImageDraw

#pragma mark 滑道图片
+ (UIImage *)imgText:(NSString *)text mainColor:(UIColor *)mainColor bgColor:(UIColor *)bgColor size:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 背景
    CGContextSetFillColorWithColor(context, bgColor.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    // 边框
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, mainColor.CGColor);
    CGContextAddRect(context, CGRectMake(0, 0, size.width, size.height));
    CGContextStrokePath(context);
    // 文字
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName:mainColor, NSFontAttributeName:[UIFont systemFontOfSize:18]};
    [text drawInRect:CGRectMake(0, size.height/2.-10, size.width, 20) withAttributes:attributes];
    // 生成图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark 滑块图片
+ (UIImage *)thumbImgMainColor:(UIColor *)mainColor bgColor:(UIColor *)bgColor size:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 背景
    CGContextSetFillColorWithColor(context, bgColor.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    // 边框
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, mainColor.CGColor);
    CGContextAddRect(context, CGRectMake(0, 0, size.width, size.height));
    CGContextStrokePath(context);
    // 箭头1
    CGContextMoveToPoint(context, size.width/4., size.height/4.);
    CGContextAddLineToPoint(context, size.width/2., size.height/2.);
    CGContextAddLineToPoint(context, size.width/4., size.height*3./4.);
    // 箭头2
    CGContextMoveToPoint(context, size.width/2., size.height/4.);
    CGContextAddLineToPoint(context, size.width*3./4., size.height/2.);
    CGContextAddLineToPoint(context, size.width/2., size.height*3./4.);
    CGContextDrawPath(context, kCGPathStroke);
    // 生成图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark 正在验证loading
+ (NSMutableArray<UIImage *> *)loadingImgWithMainColor:(UIColor *)mainColor bgColor:(UIColor *)bgColor size:(CGSize)size {
    NSMutableArray *tempImgArray = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        UIGraphicsBeginImageContext(size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        // 背景
        CGContextSetFillColorWithColor(context, bgColor.CGColor);
        CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
        // 边框
        CGContextSetLineWidth(context, 1);
        CGContextSetStrokeColorWithColor(context, mainColor.CGColor);
        CGContextAddRect(context, CGRectMake(0, 0, size.width, size.height));
        CGContextStrokePath(context);
        // 进度扇形
        for (int j = 0; j < 4; j++) {
            CGContextMoveToPoint(context, size.width/2., size.height/2.);
            CGContextAddArc(context, size.width/2., size.height/2., size.height/3.,  (i+j*3)*30*M_PI/180, (i+j*3+1)*30*M_PI/180, 0);
        }
        CGContextSetFillColorWithColor(context, mainColor.CGColor);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke);
        
        // 生成图片
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [tempImgArray addObject:img];
    }
    return tempImgArray;
}

#pragma mark 验证成功或失败图片
+ (UIImage *)finishImg:(BOOL)yesOrNo mainColor:(UIColor *)mainColor bgColor:(UIColor *)bgColor size:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 背景
    CGContextSetFillColorWithColor(context, bgColor.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    // 边框
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, mainColor.CGColor);
    CGContextAddRect(context, CGRectMake(0, 0, size.width, size.height));
    CGContextStrokePath(context);
    // 圆圈
    CGContextMoveToPoint(context, size.width/2., size.height/2.);
    CGContextAddArc(context, size.width/2., size.height/2., size.height/4.,  0, 360*M_PI/180, 0);
    CGContextSetFillColorWithColor(context, mainColor.CGColor);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    // 符号
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    if (yesOrNo) {
        CGContextMoveToPoint(context, size.width/4.+2, size.height/2.);
        CGContextAddLineToPoint(context, size.width*5./12., size.height*2./3.-2);
        CGContextAddLineToPoint(context, size.width*3./4-2., size.height*3./8.);
    } else {
        CGContextMoveToPoint(context, size.width*3./8., size.height*3./8.);
        CGContextAddLineToPoint(context, size.width*5./8., size.height*5./8.);
        CGContextMoveToPoint(context, size.width*3./8., size.height*5./8.);
        CGContextAddLineToPoint(context, size.width*5./8., size.height*3./8.);
    }
    CGContextDrawPath(context, kCGPathStroke);
    // 生成图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
