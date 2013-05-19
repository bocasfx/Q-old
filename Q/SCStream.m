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

        _particleCount =  1;
        _streamSize = 100;
        _easing = position;
        _headPosition = position;
        _easingFactor = 0.08;
        _active = YES;
        _touchDown = NO;
        _ignoreTouch = NO;

        _particleArray = [[NSMutableArray alloc] init];
        _streamQueue   = [[NSMutableArray alloc] init];
        _path          = [[NSMutableArray alloc] init];

        for (int i=0; i<_particleCount; i++) {
            id ball = [NSString stringWithFormat:@"ball%i.png", i];
            SCParticle *particle = [[SCParticle alloc] initWithPosition: position andBall:ball];
            [self addChild:particle];
            [_particleArray addObject:particle];
        }

        [self scheduleUpdate];
    }

    return self;
}

-(void) update:(ccTime) deltaTime {
    
    if ( ![self active] ) {
        return;
    }
    
    @try {
        
        CGPoint pathPoint = [self headPosition];
        
        if ( [self touchDown] == YES ) {
            pathPoint = [self headPosition];
            [[self path] addObject:[NSValue valueWithCGPoint:[self headPosition]]];
        } else {
            if ( [[self path] count] > 0 ) {
                NSValue *value = [[self path] objectAtIndex: [self pathIndex]];
                [value getValue:&pathPoint];
            }
        }
        
        [self setEasing: [self calculateEasingForPoint:pathPoint withPrevEasing:[self easing] andEasingFactor:[self easingFactor]]];
        
        if ( [[self streamQueue] count] < [self streamSize] ) {
            [[self streamQueue] insertObject:[NSValue valueWithCGPoint:[self easing]] atIndex:0];
        } else {
            [[self streamQueue] insertObject:[NSValue valueWithCGPoint:[self easing]] atIndex:0];
            [[self streamQueue] removeLastObject];
        }

        _pathIndex++;
        if ( [self pathIndex] >= [[self path] count] ) {
            [self setPathIndex: 0];
        }
    } @catch (NSException * exception) {
        NSLog(@"Update exception: %@", exception);
    }
}

-(void) draw {
    @try {
        int i = 0;
        int j = 0;
        int step = [self streamSize] / [self particleCount];
        while ( i < [[self streamQueue] count] ) {
            SCParticle *particle = [[self particleArray] objectAtIndex: j];
            NSValue *value = [[self streamQueue] objectAtIndex: i];
            CGPoint pt;
            [value getValue:&pt];
            [particle setPosition: CGPointMake(pt.x, pt.y)];
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
    if ( [self ignoreTouch] ) return;
    [self setTouchDown: YES];
    [[self path] removeAllObjects];
    [self setPathIndex: 0];
    UITouch *touch = [touches anyObject];
    [self setHeadPosition: [[CCDirector sharedDirector] convertToGL: [touch locationInView: [touch view]]]];
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"SCStream: Touches moved.");
    UITouch *touch = [touches anyObject];
    [self setHeadPosition: [[CCDirector sharedDirector] convertToGL: [touch locationInView: [touch view]]]];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"SCStream: Touces ended.");
    [self setTouchDown: NO];
}

-(void) setIgnoreTouchWithNSNumber:(NSNumber *)value {
    [self setIgnoreTouch: [value boolValue]];
}

-(void) setActiveWithNSNumber:(NSNumber *)value {
    [self setActive: [value boolValue]];
}

@end
