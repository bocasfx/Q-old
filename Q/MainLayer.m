//
//  MainLayer.m
//  Q
//
//  Created by Bocas on 13-05-02.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// Import the interfaces
#import "MainLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - MainLayer

// MainLayer implementation
@implementation MainLayer

// Helper class method that creates a Scene with the MainLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainLayer *layer = [MainLayer node];
	
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
    
    NSString *selectedItem = @"stream";
    
    if ([selectedItem isEqual: @"node"]) {
        
        SCNode *node = [[SCNode alloc] initWithPosition:position];
        [self addChild:node];
    
    } else if ([selectedItem isEqual: @"stream"]) {
    
        SCStream *stream = [[SCStream alloc] initWithPosition:position];
        [stream active:YES];
        [stream ignoreTouch:NO];
        [stream ccTouchesBegan:touches withEvent:event];
        [self addChild:stream];
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"Main layer: Touches ended.");
    [[self children] makeObjectsPerformSelector:@selector(ignoreTouches)];
}

@end
