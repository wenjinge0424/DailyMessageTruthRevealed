//
//  Landing1ViewController.m
//  DailyMessageTruthRevealed
//
//  Created by Techsviewer on 5/14/18.
//  Copyright © 2018 brainyapps. All rights reserved.
//

#import "Landing1ViewController.h"
#import "Landing2ViewController.h"
#import "MainMenuViewController.h"
#import "SignInViewController.h"

@interface Landing1ViewController ()<UIGestureRecognizerDelegate>

@end

@implementation Landing1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults * value = [NSUserDefaults standardUserDefaults];
    [value setBool:YES forKey:@"FIRST_USER"];
    [value synchronize];
    
    UISwipeGestureRecognizer * swipleft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    swipleft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipleft];
    
    UISwipeGestureRecognizer * swipRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    swipRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipRight];
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
- (IBAction)onNext:(id)sender {
    Landing2ViewController * controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Landing2ViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)onSkip:(id)sender {
    SignInViewController * controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SignInViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)swipeLeft:(UISwipeGestureRecognizer*)gesture
{
    [self onNext:nil];
}
- (void)swipeRight:(UISwipeGestureRecognizer*)gesture
{
}
@end
