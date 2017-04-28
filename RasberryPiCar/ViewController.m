//
//  ViewController.m
//  RasberryPiCar
//
//  Created by 杜 泽旭 on 2017/4/25.
//  Copyright © 2017年 杜 泽旭. All rights reserved.
//

#import "ViewController.h"
#import "ADSocketLoger.h"
#import "ADRocker.h"

@interface ViewController ()<ADRockerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[ADSocketLoger sharedLogger] connectWithHost:@"192.168.1.110" port:@"8080"];
}

- (IBAction)controlAction:(UIButton *)sender {
    [[ADSocketLoger sharedLogger] sendCommand:sender.tag];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rockerDidChangeAngle:(CGFloat)angle zRate:(CGFloat)rate {
    NSDictionary *dictionary = @{
                                 @"angle":[NSString stringWithFormat:@"%.2f",angle],
                                 @"speed":[NSString stringWithFormat:@"%.2f",rate],
                                 };
    NSData *json = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    [[ADSocketLoger sharedLogger] sendCommandData:json];
}

@end
