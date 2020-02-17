//
//  DDTTYLogger+Workaround.m
//  LogsManager
//
//  Created by Anton Plebanovich on 2/17/20.
//

#import "DDTTYLogger+Workaround.h"


@implementation DDTTYLogger (Workaround)
- (instancetype)initWithWorkaround:(NSInteger)nothing {
    NSLog(@"Please ignore the following warning for now");
    return self = [self init];
}
@end
