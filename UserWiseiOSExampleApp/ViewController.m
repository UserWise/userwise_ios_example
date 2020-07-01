//
//  ViewController.m
//
//  Copyright © 2020 UserWise. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    self.userWise = [UserWise sharedInstance];
    
    [self.userWise setDebugMode:YES];
    [self.userWise setSurveyDelegate:self];
    NSLog(@"UserWise Survey Delegate Set");

    /** The appuser will be initialized once we've received both your API Key and user id. */
    [self.userWise setApiKey:@"6b6552ebc324a570262deb6bdd4e"];
    [self.userWise setUserId:@"userwise-ios-example"];
    // or: [self.userWise initializeWithApiKey:(NSString* _Nonnull) userId:(NSString* _Nonnull)];

    /** you can set the colors and logo used on the splash screen */
    //[self.userWise setColorsWithPrimaryColor:UIColor.purpleColor splashScreenBackgroundColor:UIColor.whiteColor];
    //[self.userWise setColorsWithPrimaryColor:UIColor.purpleColor backgroundColor:UIColor.whiteColor];
    //[self.userWise setSplashScreenLogo:[UIImage imageNamed:@"herowars-logo"]];
    
    /** You can also assign attributes and events from within your app. */
    NSDictionary *attributes = @{@"current_coins": @10000, @"current_diamonds": @20};
    [self.userWise setAttributes:attributes];
    //[self.userWise assignEvent:@"completed_tutorial" attributes:@{@"was_repeat_play": @NO}];
    
    [self.userWise onStart];

    NSLog(@"API Key and User ID Set");
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.userWise onStop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)forceRefreshHasSurveysAvailable:(id)sender {
    [self.userWise refreshHasAvailableSurveys];
}

-(void)onSurveyAvailable {
    [self.userWise initializeSurveyInviteWithDelegate:self];
}

-(void)onSurveyInviteInitialized:(BOOL)wasSuccessfullyInitialized {
    // The UserWise system could not properly initialize a new survey invite resource. The user will
    // be able to receive this survey again, for now you should bail out.
    if (!wasSuccessfullyInitialized) { return; }
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        SurveyOfferViewController *vc = [[SurveyOfferViewController alloc] init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }];
}

-(void)onSurveyEntered {
    [self showTemporaryMessage:@"Entering survey!"];
}

-(void)onSurveysUnavailable {
    [self showTemporaryMessage:@"No surveys are available to take."];
}

-(void)onSurveyClosed {
    [self showTemporaryMessage:@"Survey has been closed!"];
}

- (void)onSurveyEnterFailed {
    [self showTemporaryMessage:@"Survey failed to load!"];
}

-(void)onSurveyCompleted {
    [self showTemporaryMessage:@"Survey was successfully completed!"];
}

-(void)showTemporaryMessage:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self.view makeToast:message duration:3.0 position:CSToastPositionBottom];
    });
}

@end
