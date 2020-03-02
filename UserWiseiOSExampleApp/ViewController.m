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
    NSLog(@"UserWise Delegate Set");

    // The appuser will be initialized once we've received both your API Key
    // and user id.
    [self.userWise setApiKey:@"6b6552ebc324a570262deb6bdd4e"];
    [self.userWise setUserId:@"user123"];
    NSLog(@"API Key and User ID Set");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)launchSurvey:(id)sender {
    UserWise* userWise = [UserWise sharedInstance];
    
    NSLog(@"Attempting to launch surveys manually");
    NSLog(@"Has surveys? %s", [userWise hasSurveysAvailable] ? "Yes" : "No");
    if ([userWise hasSurveysAvailable]) { // Access a cached version of available surveys
        [userWise takeNextSurvey];
    } else {
        // You can forcefully refresh using: [userWise refreshHasAvailableSurveys];
    }
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

-(void)showTemporaryMessage:(NSString *)message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:NULL
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
