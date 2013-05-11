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

@class PGMidi;

// MainLayer.h
@interface MainLayer : CCLayer <CCStandardTouchDelegate>
{
    NSInteger    selectedTool;
    PGMidi       *midi;
}



extern NSInteger const CREATE_NODE_BUTTON;
extern NSInteger const CREATE_STREAM_BUTTON;
extern NSInteger const NO_TOOL_SELECTED;

// returns a CCScene that contains the MainLayer as the only child
+(CCScene *) scene;

@end
