//
//  SCNodeSettingsViewControllerInterface.m
//  Q
//
//  Created by Bocas on 13-05-22.
//
//

#import "SCNodeSettingsViewControllerInterface.h"

@implementation SCNodeSettingsViewControllerInterface

@synthesize nodeSettingsViewController;

#pragma mark - Singleton Variables

static SCNodeSettingsViewControllerInterface *singletonDelegate = nil;

#pragma mark Singleton Methods
+ (SCNodeSettingsViewControllerInterface *) sharedInstance {
    @synchronized(self) {
        if (singletonDelegate == nil) {
            return [[self alloc] init]; // assignment not done here
        }
    }
    return singletonDelegate;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (singletonDelegate == nil) {
            singletonDelegate = [super allocWithZone:zone];
            // assignment and return on first allocation
            return singletonDelegate;
        }
    }
    // on subsequent allocation attempts return nil
    return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

-(void) presentModalViewController:(UIViewController*)controller animated:(BOOL)animated {
    [[CCDirector sharedDirector] presentModalViewController:controller animated:animated];
}

-(void) sendContactMail {
    
    UIView *viewController = [[UIView alloc] init];
    viewController.frame = CGRectMake(200, 200, 300, 600);
    viewController.alpha = 0.5;
    viewController.backgroundColor = [UIColor redColor];
    
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    aButton.frame = CGRectMake(10,20,200,30);
    [aButton setTitle:@"My BUTTON" forState:UIControlStateNormal];
    [aButton addTarget:self action:@selector(buttonPushed:) forControlEvents:UIControlEventTouchDown];
    [viewController addSubview:aButton];
    viewController.tag = 999;
    
    [[[CCDirector sharedDirector] view] addSubview:viewController];
}

-(IBAction)buttonPushed:(id)sender {
    NSLog(@"Button PUshed");
    for (UIView *subView in [[CCDirector sharedDirector] view].subviews)
    {
        if (subView.tag == 999)
        {
            [subView removeFromSuperview];
        }
    }
}

@end
