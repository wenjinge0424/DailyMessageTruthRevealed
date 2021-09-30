//
//  AppDelegate.h
//  DailyMessageTruthRevealed
//
//  Created by Techsviewer on 5/14/18.
//  Copyright © 2018 brainyapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@class MainMenuViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) MainMenuViewController * m_mainMenu;
@property (atomic) BOOL needTDBRate;
- (void) checkTDBRate;

@end

