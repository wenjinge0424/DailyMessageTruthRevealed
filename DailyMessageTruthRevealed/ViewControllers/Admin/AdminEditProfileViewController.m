//
//  AdminEditProfileViewController.m
//  DailyMessageTruthRevealed
//
//  Created by Techsviewer on 5/15/18.
//  Copyright © 2018 brainyapps. All rights reserved.
//

#import "AdminEditProfileViewController.h"

@interface AdminEditProfileViewController ()
{
    NSString * userPassword;
}
@property (weak, nonatomic) IBOutlet UITextField *edt_emailAddress;
@property (weak, nonatomic) IBOutlet UITextField *edt_oldPassword;
@property (weak, nonatomic) IBOutlet UITextField *edt_newPassword;
@property (weak, nonatomic) IBOutlet UITextField *edt_confirmPassword;

@end

@implementation AdminEditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    PFUser * me = [PFUser currentUser];
    [me fetchInBackgroundWithBlock:^(PFObject *object, NSError *error){
        [SVProgressHUD dismiss];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.edt_emailAddress.text = me[PARSE_USER_EMAIL];
        });
    }];
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
- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onSave:(id)sender {
    PFUser * me = [PFUser currentUser];
    NSString * oldPassword = self.edt_oldPassword.text;
    NSString * password = self.edt_newPassword.text;
    NSString * recentPassword = me[PARSE_USER_PREVIEWPWD];
    if(oldPassword.length < 6 || oldPassword.length > 20){
        [Util showAlertTitle:self title:@"Edit Profile" message:@"We detected an error. Help me review your answer and try again." finish:^(void) {
            [self.edt_oldPassword becomeFirstResponder];
        }];
    }else if(password.length < 6 || password.length > 20){
        [Util showAlertTitle:self title:@"Edit Profile" message:@"We detected an error. Help me review your answer and try again." finish:^(void) {
            [self.edt_newPassword becomeFirstResponder];
        }];
    }else if(self.edt_confirmPassword.text.length < 6 || self.edt_confirmPassword.text.length > 20){
        [Util showAlertTitle:self title:@"Edit Profile" message:@"We detected an error. Help me review your answer and try again." finish:^(void) {
            [self.edt_newPassword becomeFirstResponder];
        }];
    }else if(![oldPassword isEqualToString:recentPassword]){
        [Util showAlertTitle:self title:@"Edit Profile" message:@"We detected an error. Help me review your answer and try again." finish:^(void) {
            [self.edt_oldPassword becomeFirstResponder];
        }];
    }else if(![self.edt_confirmPassword.text isEqualToString:password]){
        [Util showAlertTitle:self title:@"Edit Profile" message:@"We detected an error. Help me review your answer and try again." finish:^(void) {
            [self.edt_confirmPassword becomeFirstResponder];
        }];
    }else{
        me.password = password;
        me[PARSE_USER_PREVIEWPWD] = password;
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [me saveInBackgroundWithBlock:^(BOOL success, NSError * error){
            [PFUser logInWithUsernameInBackground:me.email password:me.password block:^(PFObject *object, NSError *error){
                [SVProgressHUD dismiss];
                if(!error){
                    [Util showAlertTitle:self title:@"Success" message:@"Your profile successfully changed."];
                }else{
                    [Util showAlertTitle:self title:@"Error" message:[error localizedDescription]];
                }
            }];
        }];
    }
}
@end
