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
}

- (void)test:(YXTimer *)sender {
    static long i = 0;
    if (i > 10) {
        [self.timer pause];
        sleep(5);
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
