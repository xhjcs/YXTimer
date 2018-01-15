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

@property (nonatomic) NSTimeInterval seconds;

@property (nonatomic, copy) dispatch_block_t block;
@property (nonatomic) dispatch_source_t source;

@property (nonatomic, weak) id target;
@property (nonatomic) SEL selector;

@property (nonatomic) YXTimerState state;

@end

@implementation YXTimer

+ (YXTimer *)timerWithTimeInterval:(NSTimeInterval)seconds block:(dispatch_block_t)block {
    YXTimer *timer = [self new];
    timer.seconds = seconds;
    timer.block = block;
    
    [timer resume];
    
    return timer;
}

+ (YXTimer *)timerWithTimeInterval:(NSTimeInterval)seconds target:(id)aTarget selector:(SEL)aSelector {
    YXTimer *timer = [self new];
    timer.seconds = seconds;
    timer.target = aTarget;
    timer.selector = aSelector;
    
    [timer resume];
    
    return timer;
}

- (void)dealloc {
    [self invalidate];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _state = YXTimerStateSuspend;
    }
    return self;
}

- (void)resume {
    @synchronized (self) {
        if (_state != YXTimerStateSuspend) {
            return;
        }
        [self pause];
        self.source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        uint64_t nsec = (uint64_t)(self.seconds * NSEC_PER_SEC);
        dispatch_source_set_timer(self.source, dispatch_time(DISPATCH_TIME_NOW, nsec), nsec, 0);
        __weak typeof(self) wself = self;
        dispatch_source_set_event_handler(self.source, ^{
            [wself fire];
        });
        dispatch_resume(self.source);
        _state = YXTimerStateActive;
    }
}

- (void)pause {
    @synchronized (self) {
        if (_state != YXTimerStateActive) {
            return;
        }
        if (self.source) {
            dispatch_source_cancel(self.source);
            self.source = nil;
        }
        _state = YXTimerStateSuspend;
    }
}

- (void)invalidate {
    if (_state == YXTimerStateInvalid) {
        return;
    }
    [self pause];
    _block = nil;
    _selector = nil;
    _state = YXTimerStateInvalid;
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
