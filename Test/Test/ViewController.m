//
//  ViewController.m
//  Test
//
//  Created by ldy on 16/7/1.
//  Copyright © 2016年 ldy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSString *_name;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.name = @"132";
    NSLog(@"%@",self.name);
}
- (void)setName:(NSString *)name
{
    if (_name != name) {
        _name = name;
    }
}
- (NSString *)name
{
    return _name;
}


@end
