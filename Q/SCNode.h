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

@interface SCNode : CCNode <CCStandardTouchDelegate> {
}

@property (nonatomic, assign) CGPoint position;
@property (nonatomic, strong) CCSprite *sprite;

-(id) initWithPosition:(CGPoint) pos;
-(void)position:(CGPoint) pos;
-(CGPoint)position;

@end
