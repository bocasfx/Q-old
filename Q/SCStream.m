//
//  SCStream.m
//  Q
//
//  Created by Bocas on 13-05-02.
//
//

#import "SCStream.h"

@implementation SCStream
@synthesize particleCount, streamSize, pathIndex;

-(id) initWithPosition:(CGPoint) position {
    
    self = [super init];
    
    if (self) {

        self.particleCount = 5;

        particleArray = [[NSMutableArray alloc] init];
        streamQueue   = [[NSMutableArray alloc] init];
        path          = [[NSMutableArray alloc] init];


        for (int i=0; i<self.particleCount; i++) {
            SCParticle *particle = [[SCParticle alloc] initWithPosition: position];
            [self addChild:particle];
            [particleArray addObject:particle];
        }

        self.streamSize = 400;
        easing = position;
        headPosition = position;

        active = YES;

        [self scheduleUpdate];
    }

    return self;
}

-(void) update:(ccTime) deltaTime {
    if ( [path count] > 0 ) {
        id newPosition = [path objectAtIndex: pathIndex];
        if ( [streamQueue count] < streamSize ) {
            [streamQueue insertObject:newPosition atIndex:0];
        }

        [self rotateStreamQueue];
        pathIndex++;
        if ( pathIndex >= [path count] ) {
            pathIndex = 0;
        }
    }
}

-(void) draw {

    int i = 1;
    int j = 0;
    while ( i < [streamQueue count] ) {
        SCParticle *particle = [particleArray objectAtIndex: j];
        NSValue *value = [streamQueue objectAtIndex: i];
        CGPoint pt;
        [value getValue:&pt];
        [particle position: CGPointMake(pt.x, pt.y)];
        i += 40;
        j += 1;
    }
}

-(void) rotateStreamQueue {
    for (int i = 1; i > 0; i--) {
        NSObject* obj = [streamQueue lastObject];
        [streamQueue insertObject:obj atIndex:0];
        [streamQueue removeLastObject];
    }
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
    if (active) {
        [path removeAllObjects];
        CGPoint position = [touch locationInView: [touch view]];
        position = [[CCDirector sharedDirector] convertToGL: position];
        [path addObject:[NSValue valueWithCGPoint:position]];
        return YES;
    }

    return NO;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint position = [touch locationInView: [touch view]];
    position = [[CCDirector sharedDirector] convertToGL: position];
    [path addObject:[NSValue valueWithCGPoint:position]];
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
