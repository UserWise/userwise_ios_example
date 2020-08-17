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
    if (@available(iOS 14, *)) {
        [self askForIDFAPermissions];
    } else {
        [self initializeUserWiseSDK];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    // Step 6) Make sure you stop userwise when the game is not actively running!
    [self.userWise onStop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)askForIDFAPermissions {
    if (@available(iOS 14, *)) {
#if __has_include(<AppTrackingTransparency/AppTrackingTransparency.h>)
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus authStatus) {
                
            if (authStatus == ATTrackingManagerAuthorizationStatusAuthorized) {
                NSLog(@"You have allowed the example app to retrieve your IDFA.");
            } else {
                NSLog(@"You have denied the example app the right to retrieve your IDFA.");
            }

            [self initializeUserWiseSDK];
        }];
#else
        [self initializeUserWiseSDK];
#endif
    }
}

- (void)initializeUserWiseSDK {
    self.userWise = [UserWise sharedInstance];
    
    if (![self.userWise isInitialized]) {
        // Step 1) Set our debug mode, and survey delegate
        [self.userWise setDebugMode:YES];
        [self.userWise setSurveyDelegate:self];

        // Step 2) We set our app's api key and initialize the user by their _UNIQUE_ id.
        [self.userWise setApiKey:@"f0d040021dcb9f26765e25da6b57"];
        [self.userWise setUserId:@"userwise-ios-example-user"];
        // or: [self.userWise initializeWithApiKey:(NSString* _Nonnull) userId:(NSString* _Nonnull)];
    }

    // Step 3) We call the onStart lifecycle method
    [self.userWise onStart];
    
    // Step 4) We can override some of the loading screen design (e.g. colors and logo)
    //[self.userWise setColorsWithPrimaryColor:UIColor.purpleColor splashScreenBackgroundColor:UIColor.whiteColor];
    //[self.userWise setColorsWithPrimaryColor:UIColor.purpleColor backgroundColor:UIColor.whiteColor];
    //[self.userWise setSplashScreenLogo:[UIImage imageNamed:@"herowars-logo"]];

    // Step 5) You can assign your app user attributes and events directly within the SDK!
    //NSDictionary *attributes = @{@"current_coins": @10000, @"current_diamonds": @20};
    //[self.userWise setAttributes:attributes];
    //[self.userWise assignEvent:@"completed_tutorial" attributes:@{@"was_repeat_play": @NO}];
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
