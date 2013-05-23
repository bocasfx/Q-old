//
//  SCSettings.h
//  Q
//
//  Created by Bocas on 13-05-22.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SCSettings : NSObject {
}

@property (nonatomic, retain) UIView *settingsView;

+ (SCSettings *) sharedInstance;

-(void) populate;
-(void) showSettings;
-(void) hideSettings;

@end