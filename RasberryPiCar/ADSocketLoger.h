//
//  ADSocketLoger.h
//  ADRevealTools
//
//  Created by duzexu on 2017/3/10.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ADCommond) {
    ADCommondForward,
    ADCommondBackward,
    ADCommondLeft,
    ADCommondRight,
    ADCommondTurnLeft,
    ADCommondTurnRight,
    ADCommondStop,
    ADCommondShutDown
};

@interface ADSocketLoger : NSObject

+ (instancetype)sharedLogger;
- (void)connectWithHost:(NSString *)host port:(NSString *)port;
- (void)sendCommand:(ADCommond)commond;
- (void)sendCommandData:(NSData *)commond;

@end
