//
//  SCParticle.h
//  Q
//
//  Created by Bocas on 13-05-02.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SCParticle : CCNode {
    CCSprite *sprite;
    CGPoint position;
}

@property (nonatomic, retain) CCSprite *sprite;
@property (nonatomic) CGPoint position;

-(id) initWithPosition:(CGPoint) position;
-(void)position:(CGPoint) pos;
-(void)dealloc;

@end
