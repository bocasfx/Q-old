//
//  SCNodeSettings.m
//  Q
//
//  Created by Bocas on 13-05-22.
//
//

#import "SCNodeSettings.h"

@implementation SCNodeSettings

-(void) populate {
//    [super populate];

    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    aButton.frame = CGRectMake(10,60,200,30);
    [aButton setTitle:@"Other" forState:UIControlStateNormal];
    [aButton addTarget:self action:@selector(testMethod) forControlEvents:UIControlEventTouchDown];
//    [_settingsView addSubview:aButton];
}

-(void) testMethod {
    NSLog(@"Test Method");
}

@end
