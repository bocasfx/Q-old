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
    BOOL ignoreTouch;
    BOOL active;
}

@property (nonatomic, strong) NSMutableArray *particleArray;
@property (nonatomic, strong) NSMutableArray *path;
@property (nonatomic, strong) NSMutableArray *streamQueue;
@property (nonatomic, assign) CGPoint easing;
@property (nonatomic, assign) CGPoint headPosition;
@property (nonatomic, assign) int particleCount;
@property (nonatomic, assign) int streamSize;
@property (nonatomic, assign) int pathIndex;
//@property (nonatomic, assign) BOOL active;
@property (nonatomic, assign) float easingFactor;
@property (nonatomic, assign) BOOL touchDown;
//@property (nonatomic, assign) BOOL ignoreTouch;

-(id) initWithPosition:(CGPoint) position;
-(CGPoint) calculateEasingForPoint:(CGPoint)point withPrevEasing:(CGPoint)prevEasing andEasingFactor:(float)factor;

-(void)active:(NSNumber *)value;
-(void)ignoreTouch:(NSNumber *)value;

@end
