//
//  SignInViewController.m
//  DailyMessageTruthRevealed
//
//  Created by Techsviewer on 5/15/18.
//  Copyright © 2018 brainyapps. All rights reserved.
//

#import "SignInViewController.h"
#import "MainMenuViewController.h"
#import "AdminMainViewController.h"

@interface SignInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txt_userName;
@property (weak, nonatomic) IBOutlet UITextField *txt_password;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _txt_userName.text = [Util getLoginUserName];
    _txt_password.text = [Util getLoginUserPassword];
    
    [_txt_userName resignFirstResponder];
    [_txt_password resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)onSignIn:(id)sender {
    NSString *errMsg = @"";
    NSString *email = self.txt_userName.text;
    NSString *password = self.txt_password.text;
    if (![email isEmail] && email.length > 0){
        errMsg = [errMsg stringByAppendingString:@"Please enter valid email."];
        [Util showAlertTitle:self title:@"Error" message:errMsg];
        return;
    }
    if ([email containsString:@".."] && email.length > 0){
        errMsg = [errMsg stringByAppendingString:@"Please enter valid email."];
        [Util showAlertTitle:self title:@"Error" message:errMsg];
        return;
    }
    if ([password containsString:@" "]){
        [Util showAlertTitle:self title:@"Error" message:@"Blank space is not allowed in password."];
        return;
    }
    if (email.length == 0 && password.length == 0){
        errMsg = [errMsg stringByAppendingString:@"Please enter your email and password."];
    } else if (email.length > 0 && password.length == 0){
        errMsg = [errMsg stringByAppendingString:@"Please enter your password."];
    } else if (email.length == 0 && password.length > 0){
        errMsg = [errMsg stringByAppendingString:@"Please enter your email."];
    }
    if (errMsg.length > 0){
        [Util showAlertTitle:self title:@"Error" message:errMsg];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"Please wait..." maskType:SVProgressHUDMaskTypeGradient];
    PFQuery *query = [PFUser query];
    [query whereKey:PARSE_USER_EMAIL equalTo:_txt_userName.text];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error && object) {
            PFUser *user = (PFUser *)object;
            NSString *username = user.username;
            [PFUser logInWithUsernameInBackground:username password:self.txt_password.text block:^(PFUser *user, NSError *error) {
                [SVProgressHUD dismiss];
                if (user) {
                    int userType = [user[PARSE_USER_TYPE] intValue];
                    if(userType == 300){
                        [Util setLoginUserName:user.email password:self.txt_password.text];
                        AdminMainViewController * controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AdminMainViewController"];
                        [self.navigationController pushViewController:controller animated:YES];
                    }else{
                        NSString *errorString = @"Email address and Password entered is incorrect.";
                        [Util showAlertTitle:self title:@"Login Failed" message:errorString finish:^{
                            [self.txt_password becomeFirstResponder];
                        }];
                    }
                } else {
                    if (![Util isConnectableInternet]){
                        if ([SVProgressHUD isVisible]){
                            [SVProgressHUD dismiss];
                        }
                        [Util showAlertTitle:self title:@"Error" message:@"No internet connectivity detected."];
                        return;
                    }
                    NSString *errorString = @"Password entered is incorrect.";
                    [Util showAlertTitle:self title:@"Login Failed" message:errorString finish:^{
                        [self.txt_password becomeFirstResponder];
                    }];
                }
            }];
        }else  {
            if (![Util isConnectableInternet]){
                if ([SVProgressHUD isVisible]){
                    [SVProgressHUD dismiss];
                }
                [Util showAlertTitle:self title:@"Error" message:@"No internet connectivity detected."];
                return;
            }
            [SVProgressHUD dismiss];
            [Util setLoginUserName:@"" password:@""];
        }
    }];
    
    
}
- (IBAction)onForgotPassword:(id)sender {
//    MainMenuViewController * controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MainMenuViewController"];
//    [self.navigationController pushViewController:controller animated:YES];
}

@end
