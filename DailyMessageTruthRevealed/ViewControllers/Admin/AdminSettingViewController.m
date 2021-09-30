//
//  AdminSettingViewController.m
//  DailyMessageTruthRevealed
//
//  Created by Techsviewer on 5/15/18.
//  Copyright © 2018 brainyapps. All rights reserved.
//

#import "AdminSettingViewController.h"
#import "SignInViewController.h"
#import "AdminEditProfileViewController.h"

@interface AdminSettingViewController ()

@end

@implementation AdminSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
- (IBAction)onEditProfile:(id)sender {
    AdminEditProfileViewController * controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AdminEditProfileViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)onLogOut:(id)sender {
    [SVProgressHUD showWithStatus:@"Logging out..." maskType:SVProgressHUDMaskTypeGradient];
    [PFUser logOutInBackgroundWithBlock:^(NSError *error){
        [SVProgressHUD dismiss];
        if (error){
            [Util showAlertTitle:self title:@"Logout" message:[error localizedDescription]];
        } else {
            [Util setLoginUserName:@"" password:@""];
            
            UIViewController * targetCtr = nil;
            for(UIViewController * ctr in self.navigationController.viewControllers){
                if([ctr isKindOfClass:[SignInViewController class]]){
                    targetCtr = ctr;
                }
            }
            if(targetCtr){
                [self.navigationController popToViewController:targetCtr animated:YES];
            }
            
        }
    }];
    
    
    
}

@end
