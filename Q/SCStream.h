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

@interface SCStream : CCNode <CCTargetedTouchDelegate> {
    NSMutableArray *particleArray;
    NSMutableArray *path;
    NSMutableArray *streamQueue;
    CGPoint easing;
    CGPoint headPosition;
    int particleCount;
    int streamSize;
    int pathIndex;
    BOOL active;
}

@property int particleCount;
@property int streamSize;
@property int pathIndex;

-(id) initWithPosition:(CGPoint) position;
-(void) rotateStreamQueue;

@end
