

#import "NSUserDefaults+RefreshTime.h"

NSString *const XYLastTimeKey = @"lastUpdateTime";

@implementation NSUserDefaults (RefreshTime)


- (void)setLastUpdateTime:(NSString *)lastUpdateTime{
    [self setObject:lastUpdateTime forKey:XYLastTimeKey];
}

- (NSString *)lastUpdateTime{
    return [self stringForKey:XYLastTimeKey];
}
@end
