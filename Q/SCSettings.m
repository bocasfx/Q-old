//
//  SCSettings.m
//  Q
//
//  Created by Bocas on 13-05-22.
//
//

#import "SCSettings.h"

@implementation SCSettings

static SCSettings *singletonDelegate = nil;

+ (SCSettings *) sharedInstance {
    @synchronized(self) {
        if (singletonDelegate == nil) {
            singletonDelegate = [[self alloc] init];
        }
    }
    return singletonDelegate;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (singletonDelegate == nil) {
            singletonDelegate = [super allocWithZone:zone];
            [singletonDelegate populate];
            return singletonDelegate;
        }
    }
    return nil;
}

// -----------------------------------------------------------------------

- (void)populate {
    _settingsView = [[UIView alloc] init];
    _settingsView.frame = CGRectMake(200, 200, 300, 600);
    _settingsView.alpha = 0.5;
    _settingsView.backgroundColor = [UIColor redColor];
    
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    aButton.frame = CGRectMake(10,20,200,30);
    [aButton setTitle:@"Close" forState:UIControlStateNormal];
    [aButton addTarget:self action:@selector(hideSettings:) forControlEvents:UIControlEventTouchDown];
    [_settingsView addSubview:aButton];
}

// -----------------------------------------------------------------------

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

// -----------------------------------------------------------------------

-(void) showSettings {
    NSLog(@"Show Settings");
    [[[CCDirector sharedDirector] view] addSubview:[self settingsView]];
}

// -----------------------------------------------------------------------

-(IBAction)hideSettings:(id)sender {
        NSLog(@"Hide Settings");
    [[self settingsView] removeFromSuperview];    
}

@end
