//
//  SCNodeSettingsViewControllerInterface.h
//  Q
//
//  Created by Bocas on 13-05-22.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <UIKit/UIKit.h>

@interface SCNodeSettingsViewControllerInterface : NSObject {
    UIViewController *nodeSettingsViewController;
}

@property (nonatomic, retain) UIViewController *nodeSettingsViewController;

#pragma mark - Singleton Methods
+ (SCNodeSettingsViewControllerInterface *) sharedInstance;

-(void) presentModalViewController:(UIViewController*)controller animated:(BOOL)animated;
-(void) sendContactMail;

@end
