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
    
    // Do any additional setup after loading the view, typically from a nib.
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

@end
