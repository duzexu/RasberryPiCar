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
#import <MobileVLCKit/MobileVLCKit.h>

@interface ViewController ()<ADRockerDelegate,UIGestureRecognizerDelegate> {
    CGPoint _point;
    BOOL _isTurning;
}

@property (strong, nonatomic) IBOutlet ADRocker *rockerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[ADSocketLoger sharedLogger] connectWithHost:@"192.168.1.110" port:@"8080"];
    VLCMediaPlayer *player = [[VLCMediaPlayer alloc] initWithOptions:nil];
    player.drawable = self.view;
    player.media = [VLCMedia mediaWithURL:[NSURL URLWithString:@"http://192.168.1.110:8090"]];
    [player play];
}

- (IBAction)swipeAction:(UIPanGestureRecognizer *)sender {
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            _point = [sender locationInView:self.view];
            break;
        case UIGestureRecognizerStateChanged:{
            CGPoint point = [sender locationInView:self.view];
            if (point.x > _point.x) {
                [[ADSocketLoger sharedLogger] sendCommand:ADCommandTurnRight];
            }else{
                [[ADSocketLoger sharedLogger] sendCommand:ADCommandTurnLeft];
            }
            [sender setTranslation:CGPointZero inView:self.view];
            _point = point;
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            [[ADSocketLoger sharedLogger] sendCommand:ADCommandStop];
            break;
        default:
            break;
    }
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

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:_rockerView]) {
        return NO;
    }
    return YES;
}
@end
