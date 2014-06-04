##How to use:

###.h
``` objecitve-c
#import <UIKit/UIKit.h>
#import "RefreshView.h"

@interface XYViewController : UIViewController<RefreshViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@property (retain, nonatomic) RefreshView *refreshView;
@end
```
###.m

`viewDidLoad`中添加
```
_refreshView = [[RefreshView alloc] initWithScrollView:self.myTableView delegate:self];
```
并实现以下代理方法
```
#pragma mark - UIScrollView
// 刚拖动的时候
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.refreshView scrollViewWillBeginDragging:scrollView];
}
// 拖动过程中
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.refreshView scrollViewDidScroll:scrollView];
}
// 拖动结束后
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.refreshView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}
```