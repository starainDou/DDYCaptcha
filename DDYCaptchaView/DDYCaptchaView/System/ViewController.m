#import "ViewController.h"
#import "DDYCaptchaCodeView.h"
#import "DDYTOTPTestView.h"
#import "DDYCaptchaSlider.h"

#define DDYTopH (self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height)
#define DDYScreenW [UIScreen mainScreen].bounds.size.width

@interface ViewController ()<DDYCaptchaSliderDelegate>

@property (nonatomic, strong) DDYCaptchaSlider *slider;

@property (nonatomic, strong) UIButton *refreshButton;

@end

@implementation ViewController

- (DDYCaptchaSlider *)slider {
    if (!_slider) {
        _slider = [DDYCaptchaSlider sliderWithFrame:CGRectMake(15, DDYTopH+80, [UIScreen mainScreen].bounds.size.width-30, 40)];
        _slider.delegate = self;
    }
    return _slider;
}

- (NSArray *)getAnimationImages {
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 0; i < 15; i ++) {
        [imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"ddy_loading_%02d",i]]];
    }
    return imageArray;
}

- (UIButton *)refreshButton {
    if (!_refreshButton) {
        _refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refreshButton setFrame:CGRectMake(15, DDYTopH+140, [UIScreen mainScreen].bounds.size.width-30, 30)];
        [_refreshButton setBackgroundColor:[UIColor redColor]];
        [_refreshButton setTitle:@"刷新" forState:UIControlStateNormal];
        [_refreshButton addTarget:self action:@selector(handleRefresh) forControlEvents:UIControlEventTouchUpInside];
        [_refreshButton setHidden:YES];
    }
    return _refreshButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:[DDYTOTPTestView testViewWithFrame:CGRectMake(15, DDYTopH+20, DDYScreenW/2.-30, 40)]];
    [self.view addSubview:[DDYCaptchaCodeView codeViewWithFrame:CGRectMake(DDYScreenW/2.+15, DDYTopH+20, DDYScreenW/2.-30, 40)]];
    [self.view addSubview:self.slider];
    [self.view addSubview:self.refreshButton];
}

- (void)sliderValueBeginChanging:(DDYCaptchaSlider *)slider {
    
}

- (void)sliderValueChanging:(DDYCaptchaSlider *)slider {
    
}

- (void)sliderValueEndChanging:(DDYCaptchaSlider *)slider {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSUInteger randomNum = arc4random_uniform(2); //模拟结果 1验证成功 0验证失败
        [slider verifyResult:randomNum];
        self.refreshButton.hidden = NO;
    });
}

- (void)handleRefresh {
    [self.slider reset];
    self.refreshButton.hidden = YES;
}

@end

