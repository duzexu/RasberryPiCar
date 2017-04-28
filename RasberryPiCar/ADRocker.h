//
//  ADRocker.h
//  ADRockerDemo
//
//  Created by duzexu on 17-1-26.
//  Copyright (c) 2015年 com.duzexu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RockDirection)
{
    RockDirectionLeft = 0,
    RockDirectionUp,
    RockDirectionRight,
    RockDirectionDown,
    RockDirectionCenter,
};

@protocol ADRockerDelegate;

@interface ADRocker : UIView

@property (weak ,nonatomic) IBOutlet id <ADRockerDelegate> delegate;
@property (nonatomic, readonly) RockDirection direction;

@end


@protocol ADRockerDelegate <NSObject>
@optional
- (void)rockerDidChangeAngle:(CGFloat)angle zRate:(CGFloat)rate;
@end
