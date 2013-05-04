//
//  SCStream.m
//  Q
//
//  Created by Bocas on 13-05-02.
//
//

#import "SCStream.h"

@implementation SCStream
@synthesize particleCount, streamSize, pathIndex, easingFactor, touchDown;

-(id) initWithPosition:(CGPoint) position {
    
    self = [super init];
    
    if (self) {

        particleCount = 1;
        streamSize = 100;
        easing = position;
        headPosition = position;
        easingFactor = 0.08;
        active = YES;
        touchDown = NO;

        particleArray = [[NSMutableArray alloc] init];
        streamQueue   = [[NSMutableArray alloc] init];
        path          = [[NSMutableArray alloc] init];

        for (int i=0; i<self.particleCount; i++) {
            id ball = [NSString stringWithFormat:@"ball%i.png", i];
            SCParticle *particle = [[SCParticle alloc] initWithPosition: position andBall:ball];
            [self addChild:particle];
            [particleArray addObject:particle];
        }

        [self scheduleUpdate];
    }

    return self;
}

-(void) update:(ccTime) deltaTime {
    @try {
        
        CGPoint pathPoint = headPosition;
        
        if (touchDown == YES) {
            pathPoint = headPosition;
            [path addObject:[NSValue valueWithCGPoint:headPosition]];
        } else {
            if ( [path count] > 0 ) {
                NSValue *value = [path objectAtIndex: pathIndex];
                [value getValue:&pathPoint];
            }
        }
        
        easing = [self calculateEasingForPoint:pathPoint withPrevEasing:easing andEasingFactor:easingFactor];
        
        if ( [streamQueue count] < streamSize ) {
            [streamQueue insertObject:[NSValue valueWithCGPoint:easing] atIndex:0];
        } else {
            [streamQueue insertObject:[NSValue valueWithCGPoint:easing] atIndex:0];
            [streamQueue removeLastObject];
        }

        pathIndex++;
        if ( pathIndex >= [path count] ) {
            pathIndex = 0;
        }
    } @catch (NSException * exception) {
        NSLog(@"Update exception: %@", exception);
    }
}

-(void) draw {
    @try {
        int i = 0;
        int j = 0;
        int step = streamSize / particleCount;
        while ( i < [streamQueue count] ) {
            SCParticle *particle = [particleArray objectAtIndex: j];
            NSValue *value = [streamQueue objectAtIndex: i];
            CGPoint pt;
            [value getValue:&pt];
            [particle position: CGPointMake(pt.x, pt.y)];
            i += step;
            j += 1;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Drawing exception: %@", exception);
    }
}

-(CGPoint) calculateEasingForPoint:(CGPoint)point withPrevEasing:(CGPoint)prevEasing andEasingFactor:(float)factor {
    float dx = point.x - prevEasing.x;
    CGPoint newEasing = CGPointMake(prevEasing.x + (dx * factor), prevEasing.y);

    float dy = point.y - newEasing.y;
    return CGPointMake(newEasing.x, newEasing.y + (dy * factor));
}

-(void)onEnter
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    [super onEnter];
}

-(void)onExit
{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [super onExit];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    if ( !active ) { return NO;}
    touchDown = YES;
    [path removeAllObjects];
    pathIndex = 0;
    headPosition = [[CCDirector sharedDirector] convertToGL: [touch locationInView: [touch view]]];
    return YES;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint position = [touch locationInView: [touch view]];
    headPosition = [[CCDirector sharedDirector] convertToGL: position];
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    touchDown = NO;
}

-(void) dealloc {
    // Dealloc particles
    for (int i=0; i<self.particleCount; i++) {
        id particle = [particleArray objectAtIndex: i];
        [particle dealloc];
    }

    [particleArray dealloc];
    [streamQueue dealloc];
    [path dealloc];

    [super dealloc];
}
@end
