//
//  ZHHFPSLabel.m
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/9/23.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "ZHHFPSLabel.h"

const CGFloat left = 20;
const CGFloat top = 100;

@interface ZHHFPSLabel()
@property (strong, nonatomic) UIFont *mainFont;
@property (strong, nonatomic) UIFont *subFont;
@end

@implementation ZHHFPSLabel{
    CADisplayLink *_link;
    NSInteger _count;
    NSTimeInterval _lastTime;
}

#pragma mark - life cycle
+ (void)showInWindow:(UIWindow *)window {
#if defined(DEBUG)||defined(_DEBUG)
    if (!window || ![window isKindOfClass:[UIWindow class]]) { return; }
    
    [window makeKeyAndVisible];
    ZHHFPSLabel *fpsLabel = [[ZHHFPSLabel alloc] initWithFrame:CGRectMake(left, top, 0, 0)];
    [window addSubview:fpsLabel];
#endif
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (CGSizeEqualToSize(frame.size, CGSizeZero)) {
        frame.size = CGSizeMake(60, 25);
    }
    
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)dealloc {
    [_link invalidate];
    self.mainFont = nil;
    self.subFont = nil;
}


#pragma mark - private functions
- (void)commonInit {
    self.layer.cornerRadius = 5;
    self.layer.zPosition = MAXFLOAT; //make label on ways on the most top.
    
    self.clipsToBounds = YES;
    self.textAlignment = NSTextAlignmentCenter;
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
    
    __weak typeof(self) weakSelf = self;
    _link = [CADisplayLink displayLinkWithTarget:weakSelf selector:@selector(tick:)];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:weakSelf action:@selector(didDrag:)];
    [self addGestureRecognizer:pan];
}

- (UIFont *)fontWithSize:(CGFloat)size {
    UIFont *fontMenlo = [UIFont fontWithName:@"Menlo" size:size];
    if (fontMenlo) { return fontMenlo; }
    
    UIFont *fontCourier = [UIFont fontWithName:@"Courier" size:size];
    if (fontCourier) { return fontCourier; }
    
    return [UIFont systemFontOfSize:size];
}

- (void)tick:(CADisplayLink *)link {
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    
    _count++;
    NSTimeInterval diff = link.timestamp - _lastTime;
    if (diff < 1) return;
    _lastTime = link.timestamp;
    float fps = _count / diff;
    _count = 0;
    
    CGFloat progress = fps / 60.0;
    UIColor *color = [UIColor colorWithHue:0.33 * (progress - 0.2) saturation:1 brightness:0.9 alpha:1];

    NSString *displayText = [NSString stringWithFormat:@"%d FPS", (int)round(fps)];
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:displayText];
    [attrText addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, displayText.length - 3)];
    [attrText addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(displayText.length - 3, 3)];
    [attrText addAttribute:NSFontAttributeName value:self.mainFont range:NSMakeRange(0, displayText.length)];
    [attrText addAttribute:NSFontAttributeName value:self.subFont range:NSMakeRange(displayText.length - 4, 1)];
    
    self.attributedText = attrText;
}

- (void)didDrag:(UIPanGestureRecognizer *)panGesture {
    CGPoint touchPoint = [panGesture translationInView:self];
    self.transform = CGAffineTransformTranslate(self.transform, touchPoint.x, touchPoint.y);
    
    //rest
    [panGesture setTranslation:CGPointZero inView:self];
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = weakSelf.frame;
            CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
            CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;
            frame.origin.x = frame.origin.x - screenWidth / 2 > 0 ? (screenWidth - frame.size.width - left) : left;
            frame.origin.y = frame.origin.y > top ? ((frame.origin.y > screenHeight - top) ? screenHeight - top : frame.origin.y) : top;
            weakSelf.frame = frame;
        }];
    }
}

#pragma mark - Lazy
- (UIFont *)mainFont {
    if (!_mainFont) {
        _mainFont = [self fontWithSize:14];
    }
    return _mainFont;
}

- (UIFont *)subFont {
    if (!_subFont) {
        _subFont = [self fontWithSize:4];
    }
    return _subFont;
}

@end
