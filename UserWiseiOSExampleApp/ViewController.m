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
    [self.userWise setSplashScreenColorsWithPrimaryColor: UIColor.purpleColor backgroundColor:UIColor.whiteColor];
    [self.userWise setSplashScreenLogo:[UIImage imageNamed:@"herowars-logo"]];

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
    if ([self.userWise hasSurveysAvailable]) {
        [self.userWise takeNextSurvey];
        return;
    }
    
    [self showTemporaryMessage:@"Cannot take survey. No surveys to take!"];
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
