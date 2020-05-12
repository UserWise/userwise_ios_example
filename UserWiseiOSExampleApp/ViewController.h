//
//  ViewController.h
//
//  Copyright © 2020 UserWise. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserWiseSDK/UserWiseSDK-Swift.h>
#import "UIView+Toast.h"
#import "SurveyOfferViewController.h"

@interface ViewController : UIViewController <UserWiseSurveyDelegate, UserWiseSurveyInviteDelegate>

@property (strong, nonatomic) UserWise *userWise;

@end

