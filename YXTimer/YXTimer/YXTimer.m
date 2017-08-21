//
//  YXTimer.m
//  ObjCTest
//
//  Created by baye on 2017/8/17.
//  Copyright © 2017年 baye. All rights reserved.
//

#import "YXTimer.h"

typedef NS_ENUM(NSUInteger, YXTimerState) {
    YXTimerStateActive,
    YXTimerStateSuspend,
    YXTimerStateInvalid
};

@interface YXTimer ()

@property (nonatomic, copy) dispatch_block_t block;
@property (nonatomic) dispatch_source_t source;

@property (nonatomic) id target;
@property (nonatomic) SEL selector;

@property (nonatomic) YXTimerState state;

@end

@implementation YXTimer {
    id _token;
}

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
        [timer fire];
    });
    
    dispatch_resume(timer.source);
    
    return timer;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _token = [NSObject new];
    }
    return self;
}

- (void)dealloc {
    [self invalidate];
}

- (void)resume {
    @synchronized (_token) {
        if (self.state != YXTimerStateSuspend) {
            return;
        }
        
        if (self.source) {
            self.state = YXTimerStateActive;
            dispatch_resume(self.source);
        }
    }
}

- (void)pause {
    @synchronized (_token) {
        if (self.state != YXTimerStateActive) {
            return;
        }
        if (self.source) {
            self.state = YXTimerStateSuspend;
            dispatch_suspend(self.source);
        }
    }
}

- (void)invalidate {
    self.state = YXTimerStateInvalid;
    if (self.source) {
        dispatch_source_cancel(self.source);
        self.source = nil;
    }
}

- (void)fire {
    if (self.block) {
        self.block();
    }
    
    if ([self.target respondsToSelector:self.selector]) {
        IMP imp = [self.target methodForSelector:self.selector];
        void (*func)(id, SEL, YXTimer *) = (void *)imp;
        func(self.target, self.selector, self);
    }
}

@end
