//
//  ViewController+SurveyOfferViewController.m
//  UserWiseDemoAPP
//
//  Created by David Jenkins on 5/12/20.
//  Copyright © 2020 theoremreach. All rights reserved.
//

#import "SurveyOfferViewController.h"

@implementation SurveyOfferViewController
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)clickOfferClose:(id)sender {
    [[UserWise sharedInstance] setSurveyInviteResponse:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickOfferAccept:(id)sender {
    [[UserWise sharedInstance] setSurveyInviteResponse:YES];
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
