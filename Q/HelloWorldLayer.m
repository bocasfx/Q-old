//
//  HelloWorldLayer.m
//  Q
//
//  Created by Bocas on 13-05-02.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        self.isTouchEnabled = YES;
	}
	return self;
}

-(void) registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addStandardDelegate:self priority:0];
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"Main layer: Touches began.");
    UITouch *touch = [touches anyObject];
    CGPoint position = [[CCDirector sharedDirector] convertToGL: [touch locationInView: [touch view]]];
    SCStream *stream = [[SCStream alloc] initWithPosition:position];
    [stream setActiveStatus:YES];
    [stream setIgnoreTouch:NO];
    [stream ccTouchesBegan:touches withEvent:event];
    [self addChild:stream z:0 tag:streamTag];
    streamTag++;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"Main layer: Touches ended.");
    
    // TODO: Replace with event.
    for (int i=0; i<streamTag; i++) {
        SCStream *stream = (SCStream *)[self getChildByTag:i];
        [stream setIgnoreTouch:YES];
    }
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
