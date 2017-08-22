//
//  ViewController.m
//  YXTimer
//
//  Created by baye on 2017/8/17.
//  Copyright © 2017年 baye. All rights reserved.
//

#import "ViewController.h"
#import "YXTimer.h"

@interface ViewController ()

@property (nonatomic) YXTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.timer = [YXTimer timerWithTimeInterval:1.0 target:self selector:@selector(test:)];
    
    dispatch_apply(100, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t size) {
        if (arc4random_uniform(9)) {
            [self.timer resume];
        } else {
            [self.timer pause];
        }
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.timer invalidate];
        self.timer = nil;
    });
}

- (void)test:(YXTimer *)sender {
    static long i = 0;
    if (i > 10) {
        [self.timer pause];
        sleep(2);
        i = 0;
        [self.timer resume];
        return;
    }
    NSLog(@"%ld", i++);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
