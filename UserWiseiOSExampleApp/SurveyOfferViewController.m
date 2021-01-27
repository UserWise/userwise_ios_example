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
    self.userWise = UserWise.sharedInstance;
}

- (IBAction)clickOfferClose:(id)sender {
    [self.userWise.surveysModule setSurveyInviteResponseWithSurvey:self.survey responseId:self.responseId inviteId:self.inviteId wasAccepted:NO];
    [self dismissSurveyOfferView];
}

- (IBAction)clickOfferAccept:(id)sender {
    [self.userWise.surveysModule setSurveyInviteResponseWithSurvey:self.survey responseId:self.responseId inviteId:self.inviteId wasAccepted:YES];
    [self dismissSurveyOfferView];
}

- (void)dismissSurveyOfferView {
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
