//
//  MainLayer.h
//  Q
//
//  Created by Bocas on 13-05-02.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "SCConstants.h"
#import "SCStream.h"
#import "SCNode.h"
#import "CCTouchDispatcher.h"
#import <UIKit/UIKit.h>
#import "CCUIViewWrapper.h"
#import "SCMidi.h"
#import "SCNodeSettings.h"
#import "SCAppSettings.h"

// MainLayer.h
@interface MainLayer : CCLayer <CCStandardTouchDelegate>
{
    NSInteger       selectedTool;
    NSMutableArray  *toolButtons;
    NSMutableArray  *streams;
    NSMutableArray  *nodes;
    CCSprite        *grid;
    SCMidi          *midi;
}

// returns a CCScene that contains the MainLayer as the only child
+(CCScene *) scene;

@end
