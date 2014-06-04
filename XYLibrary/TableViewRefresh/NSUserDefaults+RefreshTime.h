

#import <Foundation/Foundation.h>

@interface NSUserDefaults (RefreshTime)
@property (assign, getter = lastUpdateTime, setter = setLastUpdateTime:) NSString *lastUpdateTime;
@end
