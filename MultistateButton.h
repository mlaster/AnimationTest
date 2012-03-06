
@interface UIView (Centering)

- (void)centerHorizontallyInSuperview;
- (void)centerVerticallyInSuperview;

@end

@interface MultistateButton : UIButton

@property (nonatomic, strong) NSArray *customViews;
@property (nonatomic, assign) NSInteger activeView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSString *title;

- (void)addView:(UIView *)inView;
- (void)setLabelHeight:(CGFloat)inHeight;

@end
