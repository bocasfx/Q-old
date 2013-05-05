//
//  SCStream.h
//  Q
//
//  Created by Bocas on 13-05-02.
//
//

#import <Foundation/Foundation.h>
#import "SCParticle.h"
#import "CCTouchDispatcher.h"

@interface SCStream : CCNode <CCStandardTouchDelegate> {
    NSMutableArray *particleArray;
    NSMutableArray *path;
    NSMutableArray *streamQueue;
    CGPoint easing;
    CGPoint headPosition;
    int particleCount;
    int streamSize;
    int pathIndex;
    BOOL active;
    float easingFactor;
    BOOL touchDown;
    BOOL ignoreTouch;
}

-(id) initWithPosition:(CGPoint) position;
-(CGPoint) calculateEasingForPoint:(CGPoint)point withPrevEasing:(CGPoint)prevEasing andEasingFactor:(float)factor;
-(void) setActiveStatus:(BOOL) activate;
-(void) ignoreTouch;
-(void) acknowledgeTouch;

@end
