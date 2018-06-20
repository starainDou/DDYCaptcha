#import <UIKit/UIKit.h>

#pragma mark - - - - - - - - - - - - - - delegate - - - - - - - - - - - - - - -
@class DDYCaptchaSlider;

@protocol DDYCaptchaSliderDelegate <NSObject>

@optional
- (void)sliderValueBeginChanging:(DDYCaptchaSlider *)slider;
- (void)sliderValueChanging:(DDYCaptchaSlider *)slider;
- (void)sliderValueEndChanging:(DDYCaptchaSlider *)slider;
@end


#pragma mark - - - - - - - - - - - - - - - slider - - - - - - - - - - - - - - -

@interface DDYCaptchaSlider : UIView
/** 滑块初始时图片 */
@property (nonatomic, strong) UIImage *thumbStartImage;
/** 滑块移动时图片 */
@property (nonatomic, strong) UIImage *thumbMovingImage;
/** 验证通过时图片 */
@property (nonatomic, strong) UIImage *thumbSuccessImage;
/** 验证失败时图片 */
@property (nonatomic, strong) UIImage *thumbFailImage;
/** 正在验证图片组 */
@property (nonatomic, strong) NSArray<UIImage *> *thumbVerifyImages;
/** 滑道背景图 */
@property (nonatomic, strong) UIImage *trackBackImage;
/** 滑道前景图 */
@property (nonatomic, strong) UIImage *trackForeImage;
/** 滑道动图组 */
@property (nonatomic, strong) NSArray<UIImage *> *trackForeAnimateImages;
/** 滑道验证成功时图片 */
@property (nonatomic, strong) UIImage *trackForeSuccessImage;
/** 滑道验证失败时图片 */
@property (nonatomic, strong) UIImage *trackForeFailImage;
/** 未拖到最右边是否自动返回起始点 默认YES */
@property (nonatomic, assign) BOOL thumbAutoBack;
/** 滑块拖到最右边是否停止用户响应 默认YES */
@property (nonatomic, assign) BOOL interactionEnabledWhenEnd;
/** 滑动代理 */
@property (nonatomic, weak) id<DDYCaptchaSliderDelegate> delegate;


+ (instancetype)sliderWithFrame:(CGRect)frame;

- (void)verifyResult:(BOOL)result;

- (void)reset;

@end
