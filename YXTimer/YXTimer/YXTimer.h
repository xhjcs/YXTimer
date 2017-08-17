//
//  YXTimer.h
//  ObjCTest
//
//  Created by baye on 2017/8/17.
//  Copyright © 2017年 baye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXTimer : NSObject

+ (YXTimer *)timerWithTimeInterval:(NSTimeInterval)seconds target:(id)aTarget selector:(SEL)aSelector;
+ (YXTimer *)timerWithTimeInterval:(NSTimeInterval)seconds block:(dispatch_block_t)block;


// 暂停timer
- (void)pause;
// 恢复timer
- (void)resume;


// 使timer失效
- (void)invalidate;
// 直接调用timer时间
- (void)fire;

@end
