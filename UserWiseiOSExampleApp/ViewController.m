//
//  ViewController.m
//
//  Copyright © 2020 UserWise. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userWise = [UserWise sharedInstance];
    
    [self.userWise setDebugMode:YES];
    [self.userWise setSurveyDelegate:self];
    NSLog(@"UserWise Survey Delegate Set");

    // The appuser will be initialized once we've received both your API Key
    // and user id.
    [self.userWise setApiKey:@"6b6552ebc324a570262deb6bdd4e"];
    [self.userWise setUserId:@"userwise-ios-example"];
    // or: [self.userWise initializeWithApiKey:(NSString* _Nonnull) userId:(NSString* _Nonnull)];

    // you can set the colors and logo used on the splash screen
    //[self.userWise setColorsWithPrimaryColor:UIColor.purpleColor splashScreenBackgroundColor:UIColor.whiteColor];
    //[self.userWise setColorsWithPrimaryColor:UIColor.purpleColor backgroundColor:UIColor.whiteColor];
    //[self.userWise setSplashScreenLogo:[UIImage imageNamed:@"herowars-logo"]];

    NSLog(@"API Key and User ID Set");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)forceRefreshHasSurveysAvailable:(id)sender {
    [self.userWise refreshHasAvailableSurveys];
}

- (IBAction)takeNextSurvey:(id)sender {
    //NSDictionary *attributes = @{@"current_coins": @10000, @"current_diamonds": @20};
    //[self.userWise setAttributes:attributes];
    //[self.userWise assignEvent:@"completed_tutorial" attributes:@{@"was_repeat_play": @NO}];
    
    if ([self.userWise hasSurveysAvailable]) {
        [self.userWise initializeSurveyInviteWithDelegate:self];
        return;
    }
    
    [self showTemporaryMessage:@"Cannot take survey. No surveys to take!"];
}

-(void)onSurveyInviteInitializedWithWasSuccessfullyInitialized:(BOOL)wasSuccessfullyInitialized {
    // The UserWise system could not properly initialize a new survey invite resource. The user will
    // be able to receive this survey again, for now you should bail out.
    if (!wasSuccessfullyInitialized) { return; }
    
    // NO will cause userwise to note the user's response (helpful for future targeting and estimations) and
    // bail. YES will cause UserWise to start the survey entry process. This is the point where UserWiseSurveyDelegate
    // methods start being called (e.g: onSurveyEntered, etc.)
    [self.userWise setSurveyInviteResponseWithSurveyInviteResponse:YES];
}

-(void)onSurveyEntered {
    [self showTemporaryMessage:@"Entering survey!"];
}

-(void)onSurveyAvailable {
    [self showTemporaryMessage:@"Surveys are available!"];
}

-(void)onSurveysUnavailable {
    [self showTemporaryMessage:@"No surveys are available to take."];
}

-(void)onSurveyClosed {
    [self showTemporaryMessage:@"Survey has been closed!"];
}

-(void)onSurveyCompleted {
    [self showTemporaryMessage:@"Survey was successfully completed!"];
}

- (void)onSurveyEnterFailed {
    [self showTemporaryMessage:@"Survey failed to load!"];
}

-(void)showTemporaryMessage:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self.view makeToast:message duration:3.0 position:CSToastPositionBottom];
    });
}

@end
