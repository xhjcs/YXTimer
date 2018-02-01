//
//  ViewController.m
//  Benchmark
//
//  Created by baye on 2018/1/14.
//  Copyright © 2018年 Heikki. All rights reserved.
//

#import "ViewController.h"
#import "YXTimer.h"

@interface ViewController ()

@property (nonatomic) YXTimer *timer;
@property (nonatomic) YXTimer *timer1;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.timer = [YXTimer timerWithTimeInterval:1.0 target:self selector:@selector(timer:)];
    
    [self.timer pause];
    [self.timer resume];
    [self.timer fire];
    
    self.timer1 = [YXTimer timerWithTimeInterval:1.0 block:^{
        NSLog(@"block");
    }];
    
    [self.timer1 pause];
    [self.timer1 resume];
    [self.timer1 invalidate];
}

- (void)timer:(YXTimer *)sender {
    NSLog(@"target");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
