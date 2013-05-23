//
//  SCAppSettings.m
//  Q
//
//  Created by Bocas on 13-05-22.
//
//

#import "SCAppSettings.h"

@implementation SCAppSettings

-(void) populate {
    [super populate];

    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    aButton.frame = CGRectMake(10,60,200,30);
    [aButton setTitle:@"Other" forState:UIControlStateNormal];
    [aButton addTarget:self action:@selector(testMethod) forControlEvents:UIControlEventTouchDown];
    [[self settingsView] addSubview:aButton];
}

-(void) testMethod {
    NSLog(@"Test Method");
}

// -----------------------------------------------------------------------

-(void) showSettings {
    [super showSettings];
}

// -----------------------------------------------------------------------

-(IBAction)hideSettings:(id)sender {
    [super hideSettings:sender];
}

@end
