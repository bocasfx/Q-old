//
//  SCStream.m
//  Q
//
//  Created by Bocas on 13-05-02.
//
//

#import "SCStream.h"

@implementation SCStream

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
        ignoreTouch = NO;

        particleArray = [[NSMutableArray alloc] init];
        streamQueue   = [[NSMutableArray alloc] init];
        path          = [[NSMutableArray alloc] init];

        for (int i=0; i<particleCount; i++) {
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
    [[[CCDirector sharedDirector] touchDispatcher] addStandardDelegate:self priority:0];
	[super onEnter];
}

-(void)onExit
{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [super onExit];
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"SCStream: Touces began.");
    if ( ignoreTouch ) return;
    touchDown = YES;
    [path removeAllObjects];
    pathIndex = 0;
    UITouch *touch = [touches anyObject];
    headPosition = [[CCDirector sharedDirector] convertToGL: [touch locationInView: [touch view]]];
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"SCStream: Touches moved.");
    UITouch *touch = [touches anyObject];
    headPosition = [[CCDirector sharedDirector] convertToGL: [touch locationInView: [touch view]]];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"SCStream: Touces ended.");
    touchDown = NO;
}

-(void) setActiveStatus:(BOOL) activate {
    active = activate;
}

-(void) ignoreTouch {
    ignoreTouch = YES;
}

-(void) acknowledgeTouch {
    ignoreTouch = NO;
}

-(void) dealloc {
    // Dealloc particles
    for (int i=0; i<particleCount; i++) {
        id particle = [particleArray objectAtIndex: i];
        [particle dealloc];
    }

    [particleArray dealloc];
    [streamQueue dealloc];
    [path dealloc];

    [super dealloc];
}
@end
