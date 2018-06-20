#import "DDYTOTPTestView.h"
#import "DDYTOTPGenerator.h"

static NSString *secretKey = @"IamRainDouWoJiaoDouDianYu000";

@interface DDYTOTPTestView ()

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) DDYTOTPGenerator *generator;

@property (nonatomic, strong) UILabel *testTOTPLabel;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation DDYTOTPTestView

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"ss";
    }
    return _dateFormatter;
}

- (DDYTOTPGenerator *)generator {
    if (!_generator) {
        _generator = [DDYTOTPGenerator generatorWithSecret:secretKey algorithm:DDYTOTPAlgorithmSHA1 digits:6 period:30];// 有效时间最好和定时器一致
    }
    return _generator;
}

- (UILabel *)testTOTLabel {
    if (!_testTOTPLabel) {
        _testTOTPLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _testTOTPLabel.font = [UIFont systemFontOfSize:30];
        _testTOTPLabel.textColor = [UIColor blackColor];
        _testTOTPLabel.textAlignment = NSTextAlignmentCenter;
        _testTOTPLabel.text = [self.generator generateWithDate:[NSDate date]];
    }
    return _testTOTPLabel;
}

+ (instancetype)testViewWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.testTOTLabel];
        self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(generateOTP) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)generateOTP {
    NSDate *currentDate = [NSDate date];
    NSInteger currentSecond = [[self.dateFormatter stringFromDate:currentDate] integerValue];
    
    if (currentSecond % 30 == 28 || currentSecond % 30 == 29) {
        self.testTOTPLabel.textColor = [UIColor redColor];
        self.testTOTPLabel.alpha = 1;
        self.testTOTPLabel.font = [UIFont systemFontOfSize:32];
        [UIView animateWithDuration:0.5 animations:^{
            self.testTOTPLabel.alpha = 0.3;
        } completion:^(BOOL finished) {
            self.testTOTPLabel.font = [UIFont systemFontOfSize:31];
            [UIView animateWithDuration:0.5 animations:^{
                self.testTOTPLabel.alpha = 1;
            }];
        }];
    } else if (currentSecond % 30 == 0) {
        self.testTOTPLabel.text = [self.generator generateWithDate:currentDate];
        self.testTOTPLabel.textColor = [UIColor blackColor];
        self.testTOTPLabel.alpha = 1;
        self.testTOTPLabel.font = [UIFont systemFontOfSize:30];
    }
}

- (void)dealloc {
    if (_timer) {
        if ([_timer isValid]) {
            [_timer invalidate];
        }
        _timer = nil;
    }
}

@end
