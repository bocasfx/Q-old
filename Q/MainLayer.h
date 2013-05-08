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

// MainLayer.h
@interface MainLayer : CCLayer <CCStandardTouchDelegate>
{
    UIButton *button;
    CCUIViewWrapper *buttonWrapper;
}

// returns a CCScene that contains the MainLayer as the only child
+(CCScene *) scene;

@end
