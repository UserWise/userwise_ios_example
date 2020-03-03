//
//  ViewController.h
//
//  Copyright © 2020 UserWise. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserWiseSDK/UserWiseSDK-Swift.h>
#import "UIView+Toast.h"

@interface ViewController : UIViewController <UserWiseSurveyDelegate>

@property (strong, nonatomic) UserWise *userWise;

@end

