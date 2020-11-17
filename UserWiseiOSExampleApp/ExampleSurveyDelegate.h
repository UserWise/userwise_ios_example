#ifndef ExampleSurveyDelegate_h
#define ExampleSurveyDelegate_h

#import <Foundation/Foundation.h>
#import <UserWiseSDK/UserWiseSDK-Swift.h>
#import "SurveyOfferViewController.h"

@interface ExampleSurveyDelegate : NSObject <UserWiseSurveyDelegate>

@property UIViewController *controller;
@property UserWise *userWise;

+ (id)initWithController:(UIViewController *)controller andUserWise:(UserWise *)userWise;

@end

#endif
