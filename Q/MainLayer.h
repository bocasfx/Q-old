//
//  MainLayer.h
//  Q
//
//  Created by Bocas on 13-05-02.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "SCStream.h"
#import "SCNode.h"
#import "CCTouchDispatcher.h"
#import <UIKit/UIKit.h>
#import "CCUIViewWrapper.h"
#import "PGMidi.h"
#import "iOSVersionDetection.h"
#import "PGArc.h"
#import <CoreMIDI/CoreMIDI.h>

@class PGMidi;

// MainLayer.h
@interface MainLayer : CCLayer <CCStandardTouchDelegate, PGMidiDelegate, PGMidiSourceDelegate>
{
    NSInteger       selectedTool;
    PGMidi          *midi;
    NSMutableArray  *toolButtons;
    NSMutableArray  *streams;
    NSMutableArray  *nodes;
    CCSprite        *grid;
}

extern NSInteger const CREATE_NODE_BUTTON;
extern NSInteger const CREATE_STREAM_BUTTON;
extern NSInteger const SETTINGS_BUTTON;
extern NSInteger const NO_TOOL_SELECTED;
extern NSInteger const LINK_NODES_BUTTON;
extern NSInteger const PLAY_PAUSE_BUTTON;

// returns a CCScene that contains the MainLayer as the only child
+(CCScene *) scene;

- (void) updateCountLabel;
- (void) addString:(NSString*)string;
- (void) sendMidiDataInBackground;

@end
