//
//  MainMenuViewController.m
//  DailyMessageTruthRevealed
//
//  Created by Techsviewer on 5/15/18.
//  Copyright © 2018 brainyapps. All rights reserved.
//

#import "MainMenuViewController.h"
#import "Utils.h"
#import "BaseTabbarViewController.h"

@interface MainMenuViewController ()
{
    BaseTabbarViewController * mainTabCtr;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constant_containerLeft;
@property (weak, nonatomic) IBOutlet UIButton *btn_show;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constant_containerTailing;

@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.btn_show setHidden:YES];
    [Util appDelegate].m_mainMenu = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"basicTabbar"]){
        mainTabCtr = [segue destinationViewController];
    }
}

- (void) hideLeftView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.constant_containerLeft.constant = 0;
        self.constant_containerTailing.constant = 0;
        [self.view layoutIfNeeded];
        [self.btn_show setHidden:YES];
    }];
}
- (void) showLeftView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.constant_containerLeft.constant = 250;
        self.constant_containerTailing.constant = 250;
        [self.view layoutIfNeeded];
        [self.btn_show setHidden:NO];
    }];
}
- (IBAction)onClickRightButton:(id)sender {
    [self hideLeftView];

}
- (IBAction)onSelectDailyScriptures:(id)sender {
    [mainTabCtr setSelectedIndex:0];
    [self hideLeftView];
}
- (IBAction)onSelectPrograms:(id)sender {
    [mainTabCtr setSelectedIndex:1];
    [self hideLeftView];
}
- (IBAction)onSelectSettings:(id)sender {
    [mainTabCtr setSelectedIndex:2];
    [self hideLeftView];
}
@end
