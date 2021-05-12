#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    self.userWise = UserWise.sharedInstance;
    self.userIdField.text = @"userwise-ios-demo-user-new";
    self.userWise.userId = self.userIdField.text;
    [self.userWise onStart];

    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.userWise.isRunning) {
        [self.userWise onStop];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)changeUser:(id)sender {
    if (self.userWise.isRunning) {
        [self.userWise onStop];
    }
    
    self.userWise.userId = self.userIdField.text;
    [self.userWise onStart];
}
@end
