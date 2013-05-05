//
//  HelloWorldLayer.h
//  Q
//
//  Created by Bocas on 13-05-02.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "SCStream.h"
#import "CCTouchDispatcher.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <CCStandardTouchDelegate>
{
    int streamTag;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
