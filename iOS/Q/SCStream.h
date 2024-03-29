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
}

@property (nonatomic, strong) NSMutableArray *particleArray;
@property (nonatomic, strong) NSMutableArray *path;
@property (nonatomic, strong) NSMutableArray *streamQueue;
@property (nonatomic, assign) CGPoint easing;
@property (nonatomic, assign) CGPoint headPosition;
@property (nonatomic, assign) int particleCount;
@property (nonatomic, assign) int streamSize;
@property (nonatomic, assign) int pathIndex;
@property (nonatomic, assign) float easingFactor;
@property (nonatomic, assign) BOOL touchDown;
@property (nonatomic, assign) BOOL ignoreTouch;
@property (nonatomic, assign) BOOL active;
@property (nonatomic, assign) NSNumber *activeWithNSNumber;
@property (nonatomic, assign) NSNumber *ignoreTouchWithNSNumber;

-(id) initWithPosition:(CGPoint) position;
-(CGPoint) calculateEasingForPoint:(CGPoint)point withPrevEasing:(CGPoint)prevEasing andEasingFactor:(float)factor;
-(void) setActiveWithNSNumber:(NSNumber *)value;
-(void) setIgnoreTouchWithNSNumber:(NSNumber *)value;

@end
