#import "TestViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "MultistateButton.h"

@implementation TestViewController

- (CAAnimation *)rotationAnimation {
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    rotation.valueFunction = [CAValueFunction functionWithName:kCAValueFunctionRotateZ];
    rotation.fromValue = [NSNumber numberWithFloat:0.0];
    rotation.toValue = [NSNumber numberWithFloat:M_PI * 2];
    rotation.duration = 1.0f;
    rotation.repeatCount = INFINITY;
    
    return rotation;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    UIImageView *animatedImage = nil;
    UIImage *backgroundImage = [UIImage imageNamed:@"background"];
    UIImage *foregroundImage = [UIImage imageNamed:@"foreground"];
    CALayer *animatedLayer = nil;
    MultistateButton *button = nil;
    UIView *wrapperView = nil;
    UIActivityIndicatorView *aiv = nil;

    [super viewDidLoad];
            
    animatedImage = [[UIImageView alloc] initWithImage:backgroundImage];
    animatedLayer = [[CALayer alloc] init];
    animatedLayer.frame = animatedImage.layer.frame;
    animatedLayer.contents = (id)[foregroundImage CGImage];
    
    [animatedImage.layer addSublayer:animatedLayer];

    [animatedLayer addAnimation:[self rotationAnimation] forKey:@"animation"];
    NSLog(@"animatedLayer: %@", [animatedLayer debugDescription]);
    button = [[MultistateButton alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 100.0f, 100.0f)];
    [button addTarget:self action:@selector(pressed:) forControlEvents:UIControlEventTouchUpInside];
    button.title = @"Test";
    button.backgroundColor = [UIColor grayColor];
    
    // Commenting out the first two addView: calls makes the animation work...
    // 1st view: static image
    [button addView:[[UIImageView alloc] initWithImage:backgroundImage]];
    
    // 2nd view: spinner
    wrapperView = [[UIView alloc] initWithFrame:animatedImage.frame];
    aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    aiv.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [aiv startAnimating];
    [wrapperView addSubview:aiv];
    aiv.userInteractionEnabled = NO;
    wrapperView.userInteractionEnabled = NO;
    [aiv centerVerticallyInSuperview];
    [aiv centerHorizontallyInSuperview];
    [button addView:wrapperView];

    // 3rd view: custom animation
    [button addView:animatedImage];
    [self.view addSubview:button];
    [button centerHorizontallyInSuperview];
}

- (IBAction)pressed:(MultistateButton *)inButton {
    NSLog(@"pressed");
    switch (inButton.activeView) {
        case 0:
            inButton.activeView = 1;
            break;
        case 1:
            inButton.activeView = 2;
            break;
        case 2:
            inButton.activeView = 0;
            break;
        default:
            inButton.activeView = 0;
    }

}
@end
