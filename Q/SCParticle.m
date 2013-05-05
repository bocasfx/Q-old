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
        [sprite release];
        sprite = [CCSprite spriteWithFile:@"ball0.png"];
        sprite.position = ccp(particlePosition.x, particlePosition.y);
        [self addChild:sprite];
	}
	return self;
}

-(id) initWithPosition:(CGPoint) particlePosition andBall:(NSString *) ballName {
    
    self = [super init];
    
	if( self ) {
        [sprite release];
        sprite = [CCSprite spriteWithFile:ballName];
        sprite.position = ccp(particlePosition.x, particlePosition.y);
        [self addChild:sprite];
	}
	return self;
}

-(void)position:(CGPoint) pos {
    sprite.position = pos;
}

-(CGPoint)position {
    return sprite.position;
}

-(void)dealloc {
    [sprite release];
    [super dealloc];
}

@end
