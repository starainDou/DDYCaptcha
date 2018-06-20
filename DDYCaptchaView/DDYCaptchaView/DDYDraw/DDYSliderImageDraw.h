#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DDYSliderImageDraw : NSObject
/** 滑道图片 */
+ (UIImage *)imgText:(NSString *)text mainColor:(UIColor *)mainColor bgColor:(UIColor *)bgColor size:(CGSize)size;

/** 滑块图片 */
+ (UIImage *)thumbImgMainColor:(UIColor *)mainColor bgColor:(UIColor *)bgColor size:(CGSize)size;

/** 正在验证loading */
+ (NSMutableArray<UIImage *> *)loadingImgWithMainColor:(UIColor *)mainColor bgColor:(UIColor *)bgColor size:(CGSize)size;

/** 验证成功或失败图片 */
+ (UIImage *)finishImg:(BOOL)yesOrNo mainColor:(UIColor *)mainColor bgColor:(UIColor *)bgColor size:(CGSize)size;

@end
