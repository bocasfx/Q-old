//
//  MainLayer.m
//  Q
//
//  Created by Bocas on 13-05-02.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

#import "MainLayer.h"
#import "AppDelegate.h"

#pragma mark - MainLayer

@implementation MainLayer

NSInteger const NO_TOOL_SELECTED = -1;
NSInteger const CREATE_NODE_BUTTON = 0;
NSInteger const CREATE_STREAM_BUTTON = 1;
NSInteger const SETTINGS_BUTTON = 2;
NSInteger const LINK_NODES_BUTTON = 3;
NSInteger const PLAY_PAUSE_BUTTON = 4;

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	MainLayer *layer = [MainLayer node];
	[scene addChild: layer];
	return scene;
}

// -----------------------------------------------------------------------

-(id) init
{
	if( (self=[super init]) ) {
        
        self.isTouchEnabled = YES;
        
        toolButtons = [NSMutableArray array];
        streams = [NSMutableArray array];
        nodes = [NSMutableArray array];
        midi = [[SCMidi alloc] init];
        
//        grid = [CCSprite spriteWithFile:@"grid.png"];
//        grid.position = ccp(self.boundingBox.size.width / 2.0, self.boundingBox.size.height / 2.0);
//        grid.opacity = 64;
//        ccBlendFunc bf;
//        bf.src = GL_ONE;
//        bf.dst = GL_ZERO;
//        grid.blendFunc = bf;
//        [self addChild:grid];
//        http://www.cocos2d-iphone.org/forum/topic/5196/page/3
        
        [self createButtons];
        selectedTool = -1;
	}

	return self;
}

// -----------------------------------------------------------------------

-(void)createButtons {
    UIButton * button;
    
    // Node
    button = [self addButtonWithImage:[UIImage imageNamed:@"node_up.png"]
                        selectedImage:[UIImage imageNamed:@"node_down.png"]
                                  tag:CREATE_NODE_BUTTON
                                frame:CGRectMake( 10, 10, 32, 32 )
                             selector:@"toolButtonTapped:"];
    
    [self addChild:[CCUIViewWrapper wrapperForUIView:button]];
    [toolButtons addObject:button];
    
    // Stream
    button = [self addButtonWithImage:[UIImage imageNamed:@"stream_up.png"]
                        selectedImage:[UIImage imageNamed:@"stream_down.png"]
                                  tag:CREATE_STREAM_BUTTON
                                frame:CGRectMake( 10, 52, 32, 32 )
                             selector:@"toolButtonTapped:"];
    
    [self addChild:[CCUIViewWrapper wrapperForUIView:button]];
    [toolButtons addObject:button];
    
    // Settings
    button = [self addButtonWithImage:[UIImage imageNamed:@"gear_up.png"]
                        selectedImage:[UIImage imageNamed:@"gear_down.png"]
                                  tag:SETTINGS_BUTTON
                                frame:CGRectMake( 10, 94, 32, 32 )
                             selector:@"toolButtonTapped:"];
    
    [self addChild:[CCUIViewWrapper wrapperForUIView:button]];
    [toolButtons addObject:button];
    
    // Link Nodes
    button = [self addButtonWithImage:[UIImage imageNamed:@"link_up.png"]
                        selectedImage:[UIImage imageNamed:@"link_down.png"]
                                  tag:LINK_NODES_BUTTON
                                frame:CGRectMake( 10, 136, 32, 32 )
                             selector:@"toolButtonTapped:"];
    
    [self addChild:[CCUIViewWrapper wrapperForUIView:button]];
    [toolButtons addObject:button];
    
    // Play/Pause
    button = [self addButtonWithImage:[UIImage imageNamed:@"play.png"]
                        selectedImage:[UIImage imageNamed:@"pause.png"]
                                  tag:PLAY_PAUSE_BUTTON
                                frame:CGRectMake( 10, 178, 32, 32 )
                             selector:@"playButtonTapped:"];
    
    button.selected = YES;
    [self addChild:[CCUIViewWrapper wrapperForUIView:button]];
}

// -----------------------------------------------------------------------

-(void) registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addStandardDelegate:self priority:0];
}

// -----------------------------------------------------------------------

-(UIButton *)addButtonWithImage:(UIImage *)normalImage
                  selectedImage:(UIImage *)selectedImage
                            tag:(NSInteger *)tag
                          frame:(CGRect)frame
                       selector:(NSString *)selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:NSSelectorFromString(selector) forControlEvents:UIControlEventTouchDown];
    button.frame = frame;
    button.tag = tag;
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateSelected];
    return button;
}

// -----------------------------------------------------------------------

-(IBAction)toolButtonTapped:(id) sender {
    UIButton *button = (UIButton *)sender;
    if (button.selected) {
        button.selected = NO;
        selectedTool = NO_TOOL_SELECTED;
    } else {
        for (UIButton *btn in toolButtons) {
            btn.selected = NO;
        }
        button.selected = YES;
        selectedTool = button.tag;
    }
    
    if (selectedTool == SETTINGS_BUTTON) {
        NSLog(@"Settings");
        [[SCNodeSettingsViewControllerInterface sharedInstance] sendContactMail];
    }
}

// -----------------------------------------------------------------------

-(IBAction)playButtonTapped:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    [streams makeObjectsPerformSelector:@selector(setActiveWithNSNumber:) withObject:[NSNumber numberWithBool:button.selected]];
}

// -----------------------------------------------------------------------

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"Main layer: Touches began.");
    UITouch *touch = [touches anyObject];
    CGPoint position = [[CCDirector sharedDirector] convertToGL: [touch locationInView: [touch view]]];
    
    if (selectedTool == CREATE_NODE_BUTTON) {
        
        SCNode *node = [[SCNode alloc] initWithPosition:position];
        [self addChild:node];
        [nodes addObject:node];
        [node showSettingsInLayer:self];
        NSLog(@"Created node");
    
    } else if (selectedTool == CREATE_STREAM_BUTTON) {
    
        SCStream *stream = [[SCStream alloc] initWithPosition:position];
        [stream setActiveWithNSNumber:[NSNumber numberWithBool:YES]];
        [stream setIgnoreTouchWithNSNumber:[NSNumber numberWithBool:NO]];
        [stream ccTouchesBegan:touches withEvent:event];
        [self addChild:stream];
        [streams addObject:stream];
        NSLog(@"Created stream");
    } else if (selectedTool == LINK_NODES_BUTTON) {
        NSLog(@"Link nodes");
    }
}

// -----------------------------------------------------------------------

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Sending ignore touch");
    [streams makeObjectsPerformSelector:@selector(setIgnoreTouchWithNSNumber:) withObject:[NSNumber numberWithBool:YES]];
}

@end
