//
//  MainLayer.m
//  Q
//
//  Created by Bocas on 13-05-02.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

#import "MainLayer.h"
#import "AppDelegate.h"

int RandomNoteNumber() { return rand() / (RAND_MAX / 127); }

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

-(id) init
{
	if( (self=[super init]) ) {
        
        self.isTouchEnabled = YES;
        
        toolButtons = [NSMutableArray array];
        streams = [NSMutableArray array];
        nodes = [NSMutableArray array];
        
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
        
        IF_IOS_HAS_COREMIDI
        (
             // We only create a MidiInput object on iOS versions that support CoreMIDI
             midi = [[PGMidi alloc] init];
             midi.networkEnabled = YES;
         )
	}

	return self;
}

-(void)createButtons {
    UIButton * button;
    button = [self addButtonWithImage:[UIImage imageNamed:@"node_up.png"]
                        selectedImage:[UIImage imageNamed:@"node_down.png"]
                                  tag:CREATE_NODE_BUTTON
                                frame:CGRectMake( 10, 10, 32, 32 )
                             selector:@"toolButtonTapped:"];
    
    [self addChild:[CCUIViewWrapper wrapperForUIView:button]];
    [toolButtons addObject:button];
    
    button = [self addButtonWithImage:[UIImage imageNamed:@"stream_up.png"]
                        selectedImage:[UIImage imageNamed:@"stream_down.png"]
                                  tag:CREATE_STREAM_BUTTON
                                frame:CGRectMake( 10, 52, 32, 32 )
                             selector:@"toolButtonTapped:"];
    
    [self addChild:[CCUIViewWrapper wrapperForUIView:button]];
    [toolButtons addObject:button];
    
    button = [self addButtonWithImage:[UIImage imageNamed:@"gear_up.png"]
                        selectedImage:[UIImage imageNamed:@"gear_down.png"]
                                  tag:SETTINGS_BUTTON
                                frame:CGRectMake( 10, 94, 32, 32 )
                             selector:@"toolButtonTapped:"];
    
    [self addChild:[CCUIViewWrapper wrapperForUIView:button]];
    [toolButtons addObject:button];
    
    button = [self addButtonWithImage:[UIImage imageNamed:@"link_up.png"]
                        selectedImage:[UIImage imageNamed:@"link_down.png"]
                                  tag:LINK_NODES_BUTTON
                                frame:CGRectMake( 10, 136, 32, 32 )
                             selector:@"toolButtonTapped:"];
    
    [self addChild:[CCUIViewWrapper wrapperForUIView:button]];
    [toolButtons addObject:button];
    
    button = [self addButtonWithImage:[UIImage imageNamed:@"pause.png"]
                        selectedImage:[UIImage imageNamed:@"play.png"]
                                  tag:PLAY_PAUSE_BUTTON
                                frame:CGRectMake( 10, 178, 32, 32 )
                             selector:@"playButtonTapped:"];
    
    [self addChild:[CCUIViewWrapper wrapperForUIView:button]];
}

-(void) registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addStandardDelegate:self priority:0];
}

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
    }
}

-(IBAction)playButtonTapped:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.selected) {
        button.selected = NO;
        NSLog(@"Pause");
    } else {
        button.selected = YES;
        NSLog(@"Play");
    }
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"Main layer: Touches began.");
    UITouch *touch = [touches anyObject];
    CGPoint position = [[CCDirector sharedDirector] convertToGL: [touch locationInView: [touch view]]];
    
    if (selectedTool == CREATE_NODE_BUTTON) {
        
        SCNode *node = [[SCNode alloc] initWithPosition:position];
        [self addChild:node];
        [nodes addObject:node];
        NSLog(@"Created node");
    
    } else if (selectedTool == CREATE_STREAM_BUTTON) {
    
        SCStream *stream = [[SCStream alloc] initWithPosition:position];
        [stream active:YES];
        [stream ignoreTouch:NO];
        [stream ccTouchesBegan:touches withEvent:event];
        [self addChild:stream];
        [streams addObject:stream];
        NSLog(@"Created stream");
    } else if (selectedTool == LINK_NODES_BUTTON) {
        NSLog(@"Link nodes");
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [streams makeObjectsPerformSelector:@selector(ignoreTouches)];
}

#pragma mark - PGMidi

//NSString *ToString(PGMidiConnection *connection)
//{
//    return [NSString stringWithFormat:@"< PGMidiConnection: name=%@ isNetwork=%@ >",
//            connection.name, ToString(connection.isNetworkSession)];
//}

//- (IBAction) listAllInterfaces
//{
//    IF_IOS_HAS_COREMIDI
//    ({
//        [self addString:@"\n\nInterface list:"];
//        for (PGMidiSource *source in midi.sources)
//        {
////            NSString *description = [NSString stringWithFormat:@"Source: %@", ToString(source)];
////            [self addString:description];
//        }
//        [self addString:@""];
//        for (PGMidiDestination *destination in midi.destinations)
//        {
////            NSString *description = [NSString stringWithFormat:@"Destination: %@", ToString(destination)];
////            [self addString:description];
//        }
//    })
//}

//- (IBAction) sendMidiData
//{
//    [self performSelectorInBackground:@selector(sendMidiDataInBackground) withObject:nil];
//}

#pragma mark - Shenanigans

- (void) attachToAllExistingSources
{
    for (PGMidiSource *source in midi.sources)
    {
        [source addDelegate:self];
    }
}

- (void) setMidi:(PGMidi*)m
{
    midi.delegate = nil;
    midi = m;
    midi.delegate = self;
    
    [self attachToAllExistingSources];
}

- (void) addString:(NSString*)string
{
    NSLog(@"addString: %@", string);
}

- (void) updateCountLabel
{
    NSLog(@"sources=%u destinations=%u", midi.sources.count, midi.destinations.count);
}

- (void) midi:(PGMidi*)midi sourceAdded:(PGMidiSource *)source
{
    [source addDelegate:self];
    [self updateCountLabel];
//    [self addString:[NSString stringWithFormat:@"Source added: %@", ToString(source)]];
}

- (void) midi:(PGMidi*)midi sourceRemoved:(PGMidiSource *)source
{
    [self updateCountLabel];
//    [self addString:[NSString stringWithFormat:@"Source removed: %@", ToString(source)]];
}

- (void) midi:(PGMidi*)midi destinationAdded:(PGMidiDestination *)destination
{
    [self updateCountLabel];
//    [self addString:[NSString stringWithFormat:@"Desintation added: %@", ToString(destination)]];
}

- (void) midi:(PGMidi*)midi destinationRemoved:(PGMidiDestination *)destination
{
    [self updateCountLabel];
//    [self addString:[NSString stringWithFormat:@"Desintation removed: %@", ToString(destination)]];
}

NSString *StringFromPacket(const MIDIPacket *packet)
{
    // Note - this is not an example of MIDI parsing. I'm just dumping
    // some bytes for diagnostics.
    // See comments in PGMidiSourceDelegate for an example of how to
    // interpret the MIDIPacket structure.
    return [NSString stringWithFormat:@"  %u bytes: [%02x,%02x,%02x]",
            packet->length,
            (packet->length > 0) ? packet->data[0] : 0,
            (packet->length > 1) ? packet->data[1] : 0,
            (packet->length > 2) ? packet->data[2] : 0
            ];
}

- (void) midiSource:(PGMidiSource*)midi midiReceived:(const MIDIPacketList *)packetList
{
    [self performSelectorOnMainThread:@selector(addString:)
                           withObject:@"MIDI received:"
                        waitUntilDone:NO];
    
    const MIDIPacket *packet = &packetList->packet[0];
    for (int i = 0; i < packetList->numPackets; ++i)
    {
        [self performSelectorOnMainThread:@selector(addString:)
                               withObject:StringFromPacket(packet)
                            waitUntilDone:NO];
        packet = MIDIPacketNext(packet);
    }
}

- (void) sendMidiDataInBackground
{
    for (int n = 0; n < 20; ++n)
    {
        const UInt8 note      = RandomNoteNumber();
        const UInt8 noteOn[]  = { 0x90, note, 127 };
        const UInt8 noteOff[] = { 0x80, note, 0   };
        
        [midi sendBytes:noteOn size:sizeof(noteOn)];
        [NSThread sleepForTimeInterval:0.1];
        [midi sendBytes:noteOff size:sizeof(noteOff)];
    }
}

@end
