//
//  AdminMainViewController.m
//  DailyMessageTruthRevealed
//
//  Created by Techsviewer on 5/15/18.
//  Copyright © 2018 brainyapps. All rights reserved.
//

#import "AdminMainViewController.h"
#import "AdminProgramsViewController.h"
#import "AdminDonationViewController.h"
#import "AdminSettingViewController.h"

@interface AdminMainViewController ()

@end

@implementation AdminMainViewController

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
- (IBAction)onPrograms:(id)sender {
    AdminProgramsViewController * controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AdminProgramsViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)onDonations:(id)sender {
    AdminDonationViewController * controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AdminDonationViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)onSettings:(id)sender {
    AdminSettingViewController * controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AdminSettingViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
