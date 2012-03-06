
#import "MultistateButton.h"

#import <QuartzCore/QuartzCore.h>

static CGFloat TopMargin = 7.0f;
static CGFloat BottomMargin = 7.0f;

@implementation UIView (Centering)

- (void)centerHorizontallyInSuperview {
    CGRect workFrame = CGRectZero;
    
    workFrame = self.frame;
    workFrame.origin.x = floorf((self.superview.frame.size.width - self.frame.size.width) / 2.0f);
    self.frame = workFrame;
}

- (void)centerVerticallyInSuperview {
    CGRect workFrame = CGRectZero;
    
    workFrame = self.frame;
    workFrame.origin.y = floorf((self.superview.frame.size.height - self.frame.size.height) / 2.0f);
    self.frame = workFrame;
}

@end

@interface MultistateButton()

@property(nonatomic) BOOL titleNeedsResized;
@end

@implementation MultistateButton

@synthesize customViews = _customViews;
@synthesize activeView = _activeView;

@synthesize title = _title;
@synthesize titleLabel = _titleLabel;
@synthesize titleNeedsResized = _titleNeedsResized;

- (id)initWithFrame:(CGRect)inFrame {
    self = [super initWithFrame:inFrame];

    if (self != nil) {
        CGRect labelFrame = CGRectZero;

        self.titleLabel = [[UILabel alloc] initWithFrame:inFrame];
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        self.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        self.titleLabel.textAlignment = UITextAlignmentCenter;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.text = @"";
        [self.titleLabel sizeToFit];
        self.titleNeedsResized = YES;

        [self addSubview:self.titleLabel];
        labelFrame = self.titleLabel.frame;
        labelFrame.origin.x = 0;
        labelFrame.origin.y = self.frame.size.height - labelFrame.size.height;
        labelFrame.size.width = self.frame.size.width;
        self.titleLabel.frame = labelFrame;
    }

    return self;
}

- (void)setActiveView:(NSInteger)inActiveView {
    UIView *view = nil;
    BOOL debug = NO;

    NSLog(@"setActiveView: %d", inActiveView);
    if (inActiveView == 2) {
        debug = YES;
    }
    
    if (inActiveView < [self.customViews count]) {
        view = [self.customViews objectAtIndex:_activeView];
        [view removeFromSuperview];
        
        [self willChangeValueForKey:@"activeView"];
        _activeView = inActiveView;
        [self didChangeValueForKey:@"activeView"];
        
        
        view = [self.customViews objectAtIndex:_activeView];
        if (debug) {
            NSLog(@"sublayer: %@", [[view.layer.sublayers objectAtIndex:0] debugDescription]);
        }
        [self addSubview:view];
        [self setNeedsLayout];
    } else {
        NSLog(@"Bad activeView: %d for button: %@", inActiveView, self);
    }
}

- (void)setTitle:(NSString *)inTitle {
    [self willChangeValueForKey:@"title"];
    _title = inTitle;
    [self didChangeValueForKey:@"title"];

    self.titleLabel.text = inTitle;
    self.titleNeedsResized = YES;
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)layoutSubviews {
    UIView *currentCustomView = nil;
    CGRect customViewFrame = CGRectZero;
    CGRect labelFrame = CGRectZero;
    CGSize labelSize = CGSizeZero;
    CGRect originalSelfFrame = self.frame;
    CGRect selfFrame = CGRectZero;

    [super layoutSubviews];

    if (self.titleNeedsResized) {
        self.titleNeedsResized = NO;
        labelSize = [self.titleLabel sizeThatFits:self.bounds.size];
        if (labelSize.height == 0.0f) {
            labelSize.height = 15.0f;
        }
    } else {
        labelSize = self.titleLabel.frame.size;
    }

    currentCustomView = [self.customViews objectAtIndex:self.activeView];
    
    customViewFrame = currentCustomView.frame;

    labelFrame.origin.x = 0.0f;
    labelFrame.origin.y = self.frame.size.height - labelSize.height - BottomMargin;
    labelFrame.size.width = self.frame.size.width;
    labelFrame.size.height = labelSize.height;

    customViewFrame.origin = self.bounds.origin;

    customViewFrame.origin.y = labelFrame.origin.y - customViewFrame.size.height;

    currentCustomView.frame = customViewFrame;
    self.titleLabel.frame = labelFrame;
    [currentCustomView centerHorizontallyInSuperview];

    selfFrame = self.frame;
    selfFrame.size.height = TopMargin + currentCustomView.bounds.size.height + labelFrame.size.height + BottomMargin;

    if (CGRectEqualToRect(originalSelfFrame, selfFrame) == NO) {
        self.frame = selfFrame; // Triggers relayout
    }
}

- (void)addView:(UIView *)inView {
    NSMutableArray *workArray = [self.customViews mutableCopy];
    BOOL isFirstView = NO;
    if (workArray == nil) {
        isFirstView = YES;
        workArray = [NSMutableArray array];
    }
    
    inView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;

    if (isFirstView) {
        [self addSubview:inView];
        [self setNeedsLayout];
    }

    [workArray addObject:inView];
    self.customViews = [workArray copy];
}

- (void)setLabelHeight:(CGFloat)inHeight {
    CGRect labelFrame = self.titleLabel.frame;

    labelFrame.size.height = inHeight;
    labelFrame.origin.y = self.frame.size.height - inHeight;
    self.titleLabel.frame = labelFrame;
    [self setNeedsLayout];
}

@end
