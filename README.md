YXTimer
==============
[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/xinghanjie/YXTimer/blob/master/LICENSE)&nbsp;
[![CocoaPods](https://img.shields.io/cocoapods/p/YXTimer.svg?style=flat)](https://github.com/xinghanjie/YXTimer)&nbsp;
[![Support](https://img.shields.io/badge/support-iOS%207%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)&nbsp;

A timer based on GCD implementation provides pause and recovery functions.

Features
==============
- **Timer**: Based on GCD.
- **Pause&Resume**: Provide pause and resume methods.
- **Block**: Support block callback.

Usage
==========================
```objc
    self.timer = [YXTimer timerWithTimeInterval:1.0 target:self selector:@selector(timer:)];

    [self.timer pause];
    [self.timer resume];

    self.timer1 = [YXTimer timerWithTimeInterval:1.0 block:^{
        NSLog(@"block");
    }];

    [self.timer1 pause];
    [self.timer1 resume];
    [self.timer1 invalidate];
```
Installation
==============

### CocoaPods

1. Add `pod 'YXTimer'` to your Podfile.
2. Run `pod install` or `pod update`.
3. import <YXTimer/YXTimer.h>.
