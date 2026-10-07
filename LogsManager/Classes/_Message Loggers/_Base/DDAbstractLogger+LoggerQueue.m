//
//  DDAbstractLogger+LoggerQueue.m
//  LogsManager
//
//  Created by Anton Plebanovich on 10/7/26.
//  Copyright © 2026 Anton Plebanovich. All rights reserved.
//

#if SPM
    #import "DDAbstractLogger+LoggerQueue.h"
#else
    #import <LogsManager/DDAbstractLogger+LoggerQueue.h>
#endif

@implementation DDAbstractLogger (LoggerQueue)

- (void)_replaceLoggerQueueWithQoS:(qos_class_t)qos {
    const char *loggerQueueName = NULL;
    if ([self respondsToSelector:@selector(loggerName)]) {
        loggerQueueName = self.loggerName.UTF8String;
    }
    
    __auto_type attributes = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, qos, 0);
    __auto_type loggerQueue = dispatch_queue_create(loggerQueueName, attributes);
    
    // The same mark `DDAbstractLogger` puts on its queue. `isOnInternalLoggerQueue` relies on it.
    __auto_type key = (__bridge void *)self;
    dispatch_queue_set_specific(loggerQueue, key, key, NULL);
    
    self.loggerQueue = loggerQueue;
}

@end
