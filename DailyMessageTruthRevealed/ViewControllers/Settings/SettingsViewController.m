//
//  SettingsViewController.m
//  DailyMessageTruthRevealed
//
//  Created by Techsviewer on 5/15/18.
//  Copyright © 2018 brainyapps. All rights reserved.
//

#import "SettingsViewController.h"
#import "Utils.h"
#import "MainMenuViewController.h"
#import "SCLAlertView.h"
#import <MessageUI/MessageUI.h>
#import "AboutAppViewController.h"
#import "TermsViewController.h"

@interface SettingsViewController ()<MFMailComposeViewControllerDelegate>

@end

@implementation SettingsViewController

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
- (IBAction)onGoMenu:(id)sender {
    [[Util appDelegate].m_mainMenu showLeftView];
}
- (IBAction)onRateApp:(id)sender {
    NSString *msg = @"Are you sure rate app now?";
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    alert.customViewColor = MAIN_COLOR;
    alert.horizontalButtons = NO;
    
    AppDelegate * appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [alert addButton:@"Rate Now" actionBlock:^(void) {
        NSString * url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", @"1362913603"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        appDelegate.needTDBRate = NO;
    }];
    [alert addButton:@"Maybe later" actionBlock:^(void) {
        
        appDelegate.needTDBRate = YES;
        [appDelegate checkTDBRate];
    }];
    [alert addButton:@"No, Thanks" actionBlock:^(void) {
        appDelegate.needTDBRate = NO;
    }];
    [alert showError:@"Rate App" subTitle:msg closeButtonTitle:nil duration:0.0f];
}
- (IBAction)onSendFeedback:(id)sender {
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;
        
        [mailCont setSubject:@""];
        [mailCont setToRecipients:[NSArray arrayWithObject:@"dailymessagetruthrevealedga@gmail.com"]];
        [mailCont setMessageBody:@"" isHTML:NO];
        
        [self presentModalViewController:mailCont animated:YES];
    }
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissModalViewControllerAnimated:YES];
}
- (IBAction)onAbout:(id)sender {
    AboutAppViewController * controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AboutAppViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)onterms:(id)sender {
    TermsViewController * controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TermsViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}
@end
