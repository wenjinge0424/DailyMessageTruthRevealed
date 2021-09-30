//
//  AppDelegate.m
//  DailyMessageTruthRevealed
//
//  Created by Techsviewer on 5/14/18.
//  Copyright © 2018 brainyapps. All rights reserved.
//

#import "AppDelegate.h"
#import "Landing1ViewController.h"
#import "MainMenuViewController.h"
#import "SCLAlertView.h"
#import "Config.h"
#import "SignInViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [PFUser enableAutomaticUser];
    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = @"";
        configuration.clientKey = @"";
        configuration.server = @"https://parse.brainyapps.com:20055/parse";
    }]];
    [PFUser enableRevocableSessionInBackground];
    PFInstallation *currentInstall = [PFInstallation currentInstallation];
    if (currentInstall) {
        currentInstall.badge = 0;
        [currentInstall saveInBackground];
    }
    
    BOOL isFirst = [[[NSUserDefaults standardUserDefaults] valueForKey:@"FIRST_USER"] boolValue];
    Landing1ViewController * rootView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Landing1ViewController"];//mainNav
    MainMenuViewController * menuView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MainMenuViewController"];
    UINavigationController * navCtrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"mainNav"];
    if(!isFirst){
        [navCtrl setViewControllers:@[rootView] animated:NO];
    }else{
        [navCtrl setViewControllers:@[menuView] animated:NO];
    }
    
    self.window.rootViewController = navCtrl;
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void) checkTDBRate
{
    [self performSelector:@selector(showRateDlg) withObject:nil afterDelay:50];
}
- (void) showRateDlg
{
    NSString *msg = @"Are you sure rate app now?";
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    alert.customViewColor = MAIN_COLOR;
    alert.horizontalButtons = NO;
    
    AppDelegate * appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [alert addButton:@"Rate Now" actionBlock:^(void) {
        NSString * url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", @"1237147"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        appDelegate.needTDBRate = NO;
    }];
    [alert addButton:@"Maybe later" actionBlock:^(void) {
        
        appDelegate.needTDBRate = YES;
        [self performSelector:@selector(showRateDlg) withObject:nil afterDelay:10];
    }];
    [alert addButton:@"No, Thanks" actionBlock:^(void) {
        appDelegate.needTDBRate = NO;
    }];
    [alert showError:@"Rate App" subTitle:msg closeButtonTitle:nil duration:0.0f];
}

@end
