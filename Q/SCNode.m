//
//  SCNode.m
//  Q
//
//  Created by Bocas on 13-05-07.
//
//

#import "SCNode.h"

@implementation SCNode

-(id) initWithPosition:(CGPoint) pos {
    
    self = [super init];
    
	if( self ) {
        _sprite = [CCSprite spriteWithFile:@"node.png"];
        _sprite.position = ccp(pos.x, pos.y);
        [self addChild:_sprite];
	}
	return self;
}

// -----------------------------------------------------------------------

-(void)setPosition:(CGPoint) point {
    [[self sprite] setPosition: point];
}

// -----------------------------------------------------------------------

-(CGPoint)position {
    return [[self sprite] position];
}

// -----------------------------------------------------------------------

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
}

// -----------------------------------------------------------------------

-(void) setIgnoreTouchWithNSNumber:(NSNumber *)value {
    [self setIgnoreTouch: [value boolValue]];
}

// -----------------------------------------------------------------------

-(void) setActiveWithNSNumber:(NSNumber *)value {
    [self setActive: [value boolValue]];
}

@end
