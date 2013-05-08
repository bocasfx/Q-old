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
}

@property (nonatomic, assign) CGPoint position;
@property (nonatomic, strong) CCSprite *sprite;

-(id) initWithPosition:(CGPoint) particlePosition;
-(id) initWithPosition:(CGPoint) particlePosition andBall:(NSString *) ballName;
-(void)position:(CGPoint) pos;
-(CGPoint)position;

@end
