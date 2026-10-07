//
//  DDAbstractLogger+LoggerQueue.h
//  LogsManager
//
//  Created by Anton Plebanovich on 10/7/26.
//  Copyright © 2026 Anton Plebanovich. All rights reserved.
//

#import <CocoaLumberjack/DDLog.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDAbstractLogger (LoggerQueue)

/// Replaces the logger queue with a new one that has the specified QoS.
///
/// `DDAbstractLogger` creates its queue without a QoS and a queue QoS can not be changed after creation.
/// Must be called right after initialization, before the logger is configured, added or used.
- (void)_replaceLoggerQueueWithQoS:(qos_class_t)qos NS_SWIFT_NAME(_replaceLoggerQueue(qos:));

@end

NS_ASSUME_NONNULL_END
