//
//  ADRocker.m
//  ADRockerDemo
//
//  Created by duzexu on 17-1-26.
//  Copyright (c) 2015年 com.duzexu. All rights reserved.
//

#import "ADRocker.h"

#define kRadius ([self bounds].size.width * 0.5f)
#define kTrackRadius kRadius * 0.8f

@interface ADRocker ()
{
    CGFloat _x;
    CGFloat _y;
    CGPoint _point;
}

@property (strong, nonatomic) UIImageView *handleImageView;
@end

@implementation ADRocker

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _direction = RockDirectionCenter;
    
    if (!_handleImageView) {
        UIImage *handleImage = [UIImage imageNamed:@"handlePressed"];
        
        _handleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width*0.5f-handleImage.size.width*0.5f,
                                                                         self.bounds.size.height*0.5f-handleImage.size.height*0.5f,
                                                                         handleImage.size.width,
                                                                         handleImage.size.height)];
        _handleImageView.image = handleImage;

        [self addSubview:_handleImageView];
    }
    
    _x = 0;
    _y = 0;
    
    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"rockerOpaqueBg"]]];
}

- (void)resetHandle {
    _handleImageView.image = [UIImage imageNamed:@"handleNormal"];

    _x = 0.0;
    _y = 0.0;
    
    CGRect handleImageFrame = [_handleImageView frame];
    handleImageFrame.origin = CGPointMake(([self bounds].size.width - [_handleImageView bounds].size.width) * 0.5f,
                                          ([self bounds].size.height - [_handleImageView bounds].size.height) * 0.5f);
    [_handleImageView setFrame:handleImageFrame];
}

- (void)setHandlePositionWithLocation:(CGPoint)location
{
    _x = location.x - kRadius;
    _y = -(location.y - kRadius);
    
    float r = sqrt(_x * _x + _y * _y);
    
    if (r >= kTrackRadius) {
        
        _x = kTrackRadius * (_x / r);
        _y = kTrackRadius * (_y / r);
        
        location.x = _x + kRadius;
        location.y = -_y + kRadius;
    }
    
    CGRect handleImageFrame = [_handleImageView frame];
    handleImageFrame.origin = CGPointMake(location.x - ([_handleImageView bounds].size.width * 0.5f),
                                          location.y - ([_handleImageView bounds].size.width * 0.5f));
    [_handleImageView setFrame:handleImageFrame];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _handleImageView.image = [UIImage imageNamed:@"handlePressed"];
    
    CGPoint location = [[touches anyObject] locationInView:self];
    
    [self setHandlePositionWithLocation:location];
    
    _point = location;
    [self rockerValueChanged];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[touches anyObject] locationInView:self];
    
    [self setHandlePositionWithLocation:location];
    
    if (fabs(location.x - _point.x) > 5 || fabs(location.y - _point.y) > 5) {
        _point = location;
        [self rockerValueChanged];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resetHandle];
    _point = CGPointZero;
    [self rockerValueChanged];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resetHandle];
    _point = CGPointZero;
    [self rockerValueChanged];
}

- (void)rockerValueChanged
{
    NSInteger rockerDirection = -1;

    float arc = atan2f(_y,_x);
    
    if ((arc > (3.0f/4.0f)*M_PI &&  arc < M_PI) || (arc < -(3.0f/4.0f)*M_PI &&  arc > -M_PI)) {
        rockerDirection = RockDirectionLeft;
    }else if (arc > (1.0f/4.0f)*M_PI &&  arc < (3.0f/4.0f)*M_PI) {
        rockerDirection = RockDirectionUp;
    }else if ((arc > 0 &&  arc < (1.0f/4.0f)*M_PI) || (arc < 0 &&  arc > -(1.0f/4.0f)*M_PI)) {
        rockerDirection = RockDirectionRight;
    }else if (arc > -(3.0f/4.0f)*M_PI &&  arc < -(1.0f/4.0f)*M_PI) {
        rockerDirection = RockDirectionDown;
    }else if (0 == _x && 0 == _y)
    {
        rockerDirection = RockDirectionCenter;
    }
    _direction = rockerDirection;
    
    CGFloat x = _handleImageView.center.x;
    CGFloat y = _handleImageView.center.y;
    CGFloat xd = x > kRadius ? x - kRadius : kRadius - x;
    CGFloat yd = y > kRadius ? y - kRadius : kRadius - y;
    CGFloat zRate = sqrtf(xd*xd+yd*yd)/kRadius/0.8;
    
    if ([_delegate respondsToSelector:@selector(rockerDidChangeAngle:zRate:)]) {
        [_delegate rockerDidChangeAngle:arc/M_PI_2 zRate:zRate];
    }
}

@end
