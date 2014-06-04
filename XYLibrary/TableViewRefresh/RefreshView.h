

#import <UIKit/UIKit.h>

@protocol RefreshViewDelegate;

@interface RefreshView : UIView{
    
}
//初始化并安装refreshView
- (id)initWithScrollView:(UIScrollView *)scrollView delegate:(id<RefreshViewDelegate>) delegate;
// 开始加载和结束加载动画
- (void)startLoading;

- (void)stopLoading;

// 拖动过程中
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
@end


@protocol RefreshViewDelegate <NSObject>

- (void)refreshViewDidCallBack;

@end