//
//  SCNode.m
//  Q
//
//  Created by Bocas on 13-05-07.
//
//

#import "SCNode.h"

@implementation SCNode
@synthesize position, sprite;

-(id) initWithPosition:(CGPoint) pos {
    
    self = [super init];
    
	if( self ) {
        sprite = [CCSprite spriteWithFile:@"node.png"];
        sprite.position = ccp(pos.x, pos.y);
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

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
}

@end
