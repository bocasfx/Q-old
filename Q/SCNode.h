//
//  SCNode.h
//  Q
//
//  Created by Bocas on 13-05-07.
//
//

#import "CCNode.h"
#import "CCTouchDispatcher.h"
#import "cocos2d.h"
#import "SCNodeSettings.h"

@interface SCNode : CCNode <CCStandardTouchDelegate> {
}

@property (nonatomic, assign) CGPoint position;
@property (nonatomic, strong) CCSprite *sprite;
@property (nonatomic, assign) BOOL ignoreTouch;
@property (nonatomic, assign) BOOL active;
@property (nonatomic, assign) NSNumber *activeWithNSNumber;
@property (nonatomic, assign) NSNumber *ignoreTouchWithNSNumber;

-(id) initWithPosition:(CGPoint) pos;
-(void) setActiveWithNSNumber:(NSNumber *)value;
-(void) setIgnoreTouchWithNSNumber:(NSNumber *)value;

@end
