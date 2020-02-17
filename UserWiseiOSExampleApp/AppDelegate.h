//
//  AppDelegate.h
//
//  Copyright © 2020 UserWise. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserWiseSDK/UserWiseSDK-Swift.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UserWiseSurveyDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UserWise *userWise;

@end

