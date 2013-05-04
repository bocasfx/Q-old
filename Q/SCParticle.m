//
//  SCParticle.m
//  Q
//
//  Created by Bocas on 13-05-02.
//
//

#import "SCParticle.h"

@implementation SCParticle
@synthesize sprite, position;

-(id) initWithPosition:(CGPoint) particlePosition {
    
    self = [super init];

	if( self ) {
        self.sprite = [CCSprite spriteWithFile:@"ball0.png"];
        self.sprite.position = ccp(particlePosition.x, particlePosition.y);
        [self addChild:self.sprite];
	}
	return self;
}

-(void)position:(CGPoint) pos {
    self.sprite.position = pos;
}

-(void)dealloc {
    [super dealloc];
}

@end
