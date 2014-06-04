
#define REFRESH_LOADING_STATUS @"Loading..."
#define REFRESH_PULL_DOWN_STATUS @"Pull down to refresh"
#define REFRESH_RESLEASED_STATUS @"Release to refresh"
#define REFRESH_UPDATE_TIME_PREFIX @"Last update:"
#define REFRESH_TRIGGER_HEIGHT 60


#import "RefreshView.h"
#import "NSUserDefaults+RefreshTime.h"


@interface RefreshView ()

@property (nonatomic, retain) UIImageView *refreshArrowImageView;
@property (nonatomic, retain) UIActivityIndicatorView *refreshIndicator;
@property (nonatomic, retain) UILabel *refreshStatusLabel;
@property (nonatomic, retain) UILabel *refreshLastUpdatedTimeLabel;

@property (nonatomic, retain) UIScrollView *scrollView;

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL isDraging;

@property (nonatomic, assign) id<RefreshViewDelegate> delegate;

@end

@implementation RefreshView
@synthesize refreshArrowImageView = _refreshArrowImageView;
@synthesize refreshIndicator = _refreshIndicator;
@synthesize refreshStatusLabel = _refreshStatusLabel;
@synthesize refreshLastUpdatedTimeLabel = _refreshLastUpdatedTimeLabel;

@synthesize scrollView = _scrollView;

@synthesize isLoading = _isLoading;
@synthesize isDraging = _isDraging;

- (id)initWithScrollView:(UIScrollView *)scrollView delegate:(id<RefreshViewDelegate>)delegate{
    
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.frame = CGRectMake(0, -scrollView.frame.size.height, scrollView.bounds.size.width, scrollView.frame.size.height);
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor colorWithRed:226.0/255.0f green:231.0/255.0f blue:237.0/255.0f alpha:1.0];
        
        _refreshStatusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _refreshStatusLabel.frame = CGRectMake(0.0f, scrollView.frame.size.height - 48.0f, self.frame.size.width, 20.0f);
        _refreshStatusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _refreshStatusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        _refreshStatusLabel.textColor = [UIColor colorWithRed:87.0/255.0f green:108.0/255.0f blue:137.0/255.0f alpha:1.0];
        _refreshStatusLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0];
        _refreshStatusLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        _refreshStatusLabel.backgroundColor = [UIColor clearColor];
        _refreshStatusLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_refreshStatusLabel];
        
        _refreshLastUpdatedTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _refreshLastUpdatedTimeLabel.frame = CGRectMake(0.0f, scrollView.frame.size.height - 30.0f, self.frame.size.width, 20.0f);
        _refreshLastUpdatedTimeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _refreshLastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12.0f];
        _refreshLastUpdatedTimeLabel.textColor = [UIColor colorWithRed:87.0/255.0f green:108.0/255.0f blue:137.0/255.0f alpha:1.0];
        _refreshLastUpdatedTimeLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        _refreshLastUpdatedTimeLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        _refreshLastUpdatedTimeLabel.backgroundColor = [UIColor clearColor];
        _refreshLastUpdatedTimeLabel.textAlignment = NSTextAlignmentCenter;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (defaults.lastUpdateTime) {
            _refreshLastUpdatedTimeLabel.text = [NSString stringWithFormat:@"%@%@",REFRESH_UPDATE_TIME_PREFIX, defaults.lastUpdateTime];
        }else{
            _refreshLastUpdatedTimeLabel.text = @"never update...";
        }
        [self addSubview:_refreshLastUpdatedTimeLabel];
        
        _refreshIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _refreshIndicator.frame = CGRectMake(25.0f, scrollView.frame.size.height - 45.0f, 20.0f, 20.0f);
        [self addSubview:_refreshIndicator];
        
        _refreshArrowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _refreshArrowImageView.frame = CGRectMake(25.0f, scrollView.frame.size.height - 55.0f, 17.0f, 42.0f);
        _refreshArrowImageView.image = [UIImage imageNamed:@"blueArrow"];
        [self addSubview:_refreshArrowImageView];
        
        [scrollView insertSubview:self atIndex:0];
        
        [self setScrollView:scrollView];
        [self setDelegate:delegate];
        [_refreshIndicator stopAnimating];
    }
    
    return self;
}

- (void)stopLoading{
    [self setIsLoading:NO];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    self.scrollView.contentOffset = CGPointZero;
    self.refreshArrowImageView.transform = CGAffineTransformMakeRotation(0);
    [UIView commitAnimations];
    
    //UI 更新日期
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *outFormat = [[NSDateFormatter alloc] init];
    [outFormat setDateFormat:@"MM'-'dd HH':'mm':'ss"];
    NSString *timeStr = [outFormat stringFromDate:nowDate];
    [[NSUserDefaults standardUserDefaults] setLastUpdateTime:timeStr];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [outFormat release];
    //UI赋值
    self.refreshLastUpdatedTimeLabel.text = [NSString stringWithFormat:@"%@%@",REFRESH_UPDATE_TIME_PREFIX,timeStr];
    self.refreshStatusLabel.text = REFRESH_PULL_DOWN_STATUS;
    self.refreshArrowImageView.hidden = NO;
    [self.refreshIndicator stopAnimating];
}

- (void)startLoading{
    
    self.isLoading = YES;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.scrollView.contentOffset = CGPointMake(0, -REFRESH_TRIGGER_HEIGHT);
    self.scrollView.contentInset = UIEdgeInsetsMake(REFRESH_TRIGGER_HEIGHT, 0, 0, 0);
    self.refreshStatusLabel.text = REFRESH_LOADING_STATUS;
    self.refreshArrowImageView.hidden = YES;
    [self.refreshIndicator startAnimating];
    [UIView commitAnimations];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.isLoading) {
        return;
    }
    self.isDraging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.isLoading) {
        if (scrollView.contentOffset.y > 0) {
            scrollView.contentInset = UIEdgeInsetsZero;
        }else if (scrollView.contentOffset.y >= - REFRESH_TRIGGER_HEIGHT){
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }
    }else if (self.isDraging && scrollView.contentOffset.y < 0){
        [UIView beginAnimations:nil context:NULL];
        if (scrollView.contentOffset.y < - REFRESH_TRIGGER_HEIGHT) {
            self.refreshStatusLabel.text = REFRESH_RESLEASED_STATUS;
            self.refreshArrowImageView.transform = CGAffineTransformMakeRotation(3.14);
        }else{
            self.refreshStatusLabel.text = REFRESH_PULL_DOWN_STATUS;
            self.refreshArrowImageView.transform = CGAffineTransformMakeRotation(0);
        }
        [UIView commitAnimations];
    }else if (!self.isDraging && !self.isLoading){
        scrollView.contentInset = UIEdgeInsetsZero;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.isLoading) {
        return;
    }
    self.isDraging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_TRIGGER_HEIGHT) {
        if ([self.delegate respondsToSelector:@selector(refreshViewDidCallBack)]) {
            [self.delegate refreshViewDidCallBack];
        }
    }
}

- (void)dealloc{
    [_refreshArrowImageView release],_refreshArrowImageView= nil;
    [_refreshIndicator release], _refreshIndicator = nil;
    [_refreshLastUpdatedTimeLabel release], _refreshLastUpdatedTimeLabel = nil;
    [_refreshStatusLabel release], _refreshStatusLabel = nil;
    
    [_scrollView release],_scrollView = nil;
    [super dealloc];
}

@end
