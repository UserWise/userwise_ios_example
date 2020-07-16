//
//  ViewController.h
//
//  Copyright © 2020 UserWise. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserWiseSDK/UserWiseSDK-Swift.h>
#import "UIView+Toast.h"
#import "SurveyOfferViewController.h"
#if __has_include(<AppTrackingTransparency/AppTrackingTransparency.h>)
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#endif

@interface ViewController : UIViewController <UserWiseSurveyDelegate, UserWiseSurveyInviteDelegate>

@property (strong, nonatomic) UserWise *userWise;

- (void)askForIDFAPermissions;
- (void)initializeUserWiseSDK;

@end

