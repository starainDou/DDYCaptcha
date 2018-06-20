#import "DDYCaptchaSlider.h"
#import "DDYSliderImageDraw.h"
#import "Masonry.h"

#define thumbW self.bounds.size.height

static inline UIColor * ddy_Color(int r, int g, int b) { return [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:1]; }
static inline UIColor * backBgColor(void) { return ddy_Color(247, 247, 247); }
static inline UIColor * backColor(void) { return ddy_Color(200, 200, 200); }
static inline UIColor * foreColor(void) { return ddy_Color(121, 172, 73); }
static inline UIColor * foreBgColor(void) { return ddy_Color(231, 254, 231); }
static inline UIColor * failColor(void) { return ddy_Color(234, 70, 51); }
static inline UIColor * failBgColor(void) { return ddy_Color(250, 219, 216); }

@interface DDYCaptchaSlider ()
/** 前景视图 */
@property (nonatomic, strong) UIView *foregroundView;
/** 前景ImageView */
@property (nonatomic, strong) UIImageView *foreImageView;
/** 背景视图 */
@property (nonatomic, strong) UIView *backgroundView;
/** 背景ImageView */
@property (nonatomic, strong) UIImageView *backImageView;
/** 滑块视图 */
@property (nonatomic, strong) UIImageView *thumbImageView;

@end

@implementation DDYCaptchaSlider

#pragma mark - 懒加载
- (UIView *)foregroundView {
    if (!_foregroundView) {
        _foregroundView = [[UIView alloc] init];
        _foregroundView.clipsToBounds = YES;
        [_foregroundView addSubview:self.foreImageView];
    }
    return _foregroundView;
}

- (UIImageView *)foreImageView {
    if (!_foreImageView) {
        _foreImageView = [[UIImageView alloc] init];
    }
    return _foreImageView;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.clipsToBounds = YES;
        [_backgroundView addSubview:self.backImageView];
    }
    return _backgroundView;
}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
    }
    return _backImageView;
}

- (UIImageView *)thumbImageView {
    if (!_thumbImageView) {
        _thumbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, thumbW, thumbW)];
        _thumbImageView.userInteractionEnabled = YES;
    }
    return _thumbImageView;
}

+ (instancetype)sliderWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.backgroundView];
        [self addSubview:self.foregroundView];
        [self addSubview:self.thumbImageView];
        [self defaultSetting];
        [self fillWithSliderX:0 thumbX:0];
    }
    return self;
}

- (void)defaultSetting {
    _thumbStartImage = [DDYSliderImageDraw thumbImgMainColor:backColor() bgColor:backBgColor() size:CGSizeMake(thumbW, thumbW)];
    _thumbMovingImage = [DDYSliderImageDraw thumbImgMainColor:foreColor() bgColor:foreBgColor() size:CGSizeMake(thumbW, thumbW)];
    _thumbSuccessImage = [DDYSliderImageDraw finishImg:YES mainColor:foreColor() bgColor:foreBgColor() size:CGSizeMake(thumbW, thumbW)];
    _thumbFailImage = [DDYSliderImageDraw finishImg:NO mainColor:failColor() bgColor:failBgColor() size:CGSizeMake(thumbW, thumbW)];
    _thumbVerifyImages = [DDYSliderImageDraw loadingImgWithMainColor:foreColor() bgColor:foreBgColor() size:CGSizeMake(thumbW, thumbW)];
    _trackBackImage = [DDYSliderImageDraw imgText:@"请向右滑动校验" mainColor:backColor() bgColor:backBgColor() size:self.bounds.size];
    _trackForeImage = [DDYSliderImageDraw imgText:@"请向右滑动校验" mainColor:foreColor() bgColor:foreBgColor() size:self.bounds.size];
    _trackForeAnimateImages = [self getTrackAnimationImages];
    _trackForeSuccessImage = [DDYSliderImageDraw imgText:@"校验成功" mainColor:foreColor() bgColor:foreBgColor() size:self.bounds.size];
    _trackForeFailImage = [DDYSliderImageDraw imgText:@"校验失败,请重新校验" mainColor:failColor() bgColor:failBgColor() size:self.bounds.size];
    
    _thumbAutoBack = YES;
    _interactionEnabledWhenEnd = YES;
}

- (NSArray *)getTrackAnimationImages {
    NSMutableArray *imageArray = [NSMutableArray array];
    [imageArray addObject:[DDYSliderImageDraw imgText:@"校验中" mainColor:foreColor() bgColor:foreBgColor() size:self.bounds.size]];
    [imageArray addObject:[DDYSliderImageDraw imgText:@"<校验中>" mainColor:foreColor() bgColor:foreBgColor() size:self.bounds.size]];
    [imageArray addObject:[DDYSliderImageDraw imgText:@"<<校验中>>" mainColor:foreColor() bgColor:foreBgColor() size:self.bounds.size]];
    [imageArray addObject:[DDYSliderImageDraw imgText:@"<<<校验中>>>" mainColor:foreColor() bgColor:foreBgColor() size:self.bounds.size]];
    [imageArray addObject:[DDYSliderImageDraw imgText:@"<<<<校验中>>>>" mainColor:foreColor() bgColor:foreBgColor() size:self.bounds.size]];
    return imageArray;
}

#pragma mark - touches
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self handleTouches:touches];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self handleTouches:touches];
}

- (void)handleTouches:(NSSet<UITouch *> *)touches {
    UITouch *touch = touches.anyObject;
    if (touch.view != _thumbImageView) {
        return;
    }
    CGPoint pointSlider = [touch locationInView:self];
    CGPoint pointThumb = [touch locationInView:_thumbImageView];
    
    if (UITouchPhaseMoved == touch.phase) {
        [self fillWithSliderX:pointSlider.x thumbX:pointThumb.x];
    } else if (UITouchPhaseEnded == touch.phase) {
        if (self.thumbImageView.userInteractionEnabled) {
            [UIView animateWithDuration:0.5 animations:^{
                [self fillWithSliderX:0 thumbX:0];
            }];
        }
    }
}

- (void)fillWithSliderX:(CGFloat)sliderX thumbX:(CGFloat)thumbX {
    if (_thumbImageView.userInteractionEnabled == NO) {
        return;
    }
    if (thumbX <= 0) {
        thumbX = 0;
    } else if (thumbX >= thumbW) {
        thumbX = thumbW;
    }
    
    if (sliderX <= 0) {
        sliderX = 0;
        _thumbImageView.image = _thumbStartImage;
        _foreImageView.image = _trackForeImage;
        _backImageView.image = _trackBackImage;
    } else if (sliderX >= self.bounds.size.width - (thumbW/2.)) {
        sliderX = self.bounds.size.width;
        
        _thumbImageView.animationImages = _thumbVerifyImages;
        _thumbImageView.animationDuration = 0.3;
        _thumbImageView.animationRepeatCount = 0;
        [_thumbImageView startAnimating];
        
        _foreImageView.animationImages = _trackForeAnimateImages;
        _foreImageView.animationDuration = 1.2;
        _foreImageView.animationRepeatCount = 0;
        [_foreImageView startAnimating];
        
        _thumbImageView.userInteractionEnabled = NO;
        if ([self.delegate respondsToSelector:@selector(sliderValueEndChanging:)]) {
            [self.delegate sliderValueEndChanging:self];
        }
    } else {
        _thumbImageView.image = _thumbMovingImage;
        _foreImageView.image = _trackForeImage;
        _backImageView.image = _trackBackImage;
    }
    
    [self.thumbImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sliderX-thumbX);
        make.width.height.mas_equalTo(thumbW);
        make.top.mas_equalTo(self);
    }];
}

- (void)updateConstraints {
    [super updateConstraints];NSLog(@"1234567890");
    [self.foregroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(self);
        make.right.mas_equalTo(self.thumbImageView.mas_left);
    }];
    [self.foreImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(self);
    }];
    [self.backgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self.thumbImageView.mas_right);
    }];
    [self.backImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(self);
    }];
}

- (void)startAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.toValue = [NSNumber numberWithFloat:M_PI * 2.];
    animation.duration = 360.f/120.f;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.thumbImageView.layer addAnimation:animation forKey:@"rotationAnimation"];
}

- (void)verifyResult:(BOOL)result {
    if (_thumbImageView.isAnimating) [_thumbImageView stopAnimating];
    if (_foreImageView.isAnimating) [_foreImageView stopAnimating];
    _thumbImageView.image = result ? _thumbSuccessImage : _thumbFailImage;
    _foreImageView.image = result ? _trackForeSuccessImage : _trackForeFailImage;
}

- (void)reset {
    if (_thumbImageView.isAnimating) [_thumbImageView stopAnimating];
    if (_foreImageView.isAnimating) [_foreImageView stopAnimating];
    _thumbImageView.userInteractionEnabled = YES;
    [self fillWithSliderX:0 thumbX:0];
}

@end
