//
//  SCParticle.m
//  Q
//
//  Created by Bocas on 13-05-02.
//
//

#import "SCParticle.h"

@implementation SCParticle

-(id) initWithPosition:(CGPoint) particlePosition {
    
    self = [super init];
    
	if( self ) {
        _sprite = [CCSprite spriteWithFile:@"ball0.png"];
        [_sprite position: ccp(particlePosition.x, particlePosition.y)];
        [self addChild: _sprite];
	}
	return self;
}

-(id) initWithPosition:(CGPoint) particlePosition andBall:(NSString *) ballName {
    
    self = [super init];
    
	if( self ) {
        _sprite = [CCSprite spriteWithFile:ballName];
        [_sprite position: ccp(particlePosition.x, particlePosition.y)];
        [self addChild:_sprite];
	}
	return self;
}

-(void)setPosition:(CGPoint) point {
    [sprite position: point];
}

-(CGPoint)position {
    return [sprite position];
}

@end
