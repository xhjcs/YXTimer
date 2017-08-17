//
//  YXTimer.m
//  ObjCTest
//
//  Created by baye on 2017/8/17.
//  Copyright © 2017年 baye. All rights reserved.
//

#import "YXTimer.h"

@interface YXTimer ()

@property (nonatomic, copy) dispatch_block_t block;
@property (nonatomic) dispatch_source_t source;

@property (nonatomic) id target;
@property (nonatomic) SEL selector;

@end

@implementation YXTimer

+ (YXTimer *)timerWithTimeInterval:(NSTimeInterval)seconds block:(dispatch_block_t)block {
    YXTimer *timer = [self new];
    timer.block = block;
    timer.source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    
    uint64_t nsec = (uint64_t)(seconds * NSEC_PER_SEC);
    dispatch_source_set_timer(timer.source, dispatch_time(DISPATCH_TIME_NOW, nsec), nsec, 0);
    dispatch_source_set_event_handler(timer.source, block);
    dispatch_resume(timer.source);
    
    return timer;
}

+ (YXTimer *)timerWithTimeInterval:(NSTimeInterval)seconds target:(id)aTarget selector:(SEL)aSelector {
    YXTimer *timer = [self new];
    timer.target = aTarget;
    timer.selector = aSelector;
    timer.source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    
    uint64_t nsec = (uint64_t)(seconds * NSEC_PER_SEC);
    dispatch_source_set_timer(timer.source, dispatch_time(DISPATCH_TIME_NOW, nsec), nsec, 0);
    dispatch_source_set_event_handler(timer.source, ^{
        [timer callSelector];
    });
    dispatch_resume(timer.source);
    
    return timer;
}

- (void)dealloc {
    [self invalidate];
}

- (void)resume {
    if (self.source) {
        dispatch_resume(self.source);
    }
}

- (void)pause {
    if (self.source) {
        dispatch_suspend(self.source);
    }
}

- (void)invalidate {
    if (self.source) {
        dispatch_source_cancel(self.source);
        self.source = nil;
    }
}

- (void)fire {
    if (self.block) {
        self.block();
    }
    [self callSelector];
}

#pragma mark - private
- (void)callSelector {
    if ([self.target respondsToSelector:self.selector]) {
        IMP imp = [self.target methodForSelector:self.selector];
        void (*func)(id, SEL, YXTimer *) = (void *)imp;
        func(self.target, self.selector, self);
    }
}



@end
