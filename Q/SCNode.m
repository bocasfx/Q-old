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
        [_sprite position: ccp(pos.x, pos.y)];
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

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
}

@end
