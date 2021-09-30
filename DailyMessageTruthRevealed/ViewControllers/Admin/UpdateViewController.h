//
//  UpdateViewController.h
//  DailyMessageTruthRevealed
//
//  Created by Techsviewer on 5/15/18.
//  Copyright © 2018 brainyapps. All rights reserved.
//

#import "BaseViewController.h"

#define UPDATECTRL_MODE_CREATEPROGRAM   0
#define UPDATECTRL_MODE_CREATEUPDATE    1
#define UPDATECTRL_MODE_EDITPROGRAM     2
#define UPDATECTRL_MODE_EDITUPDATE      3

@interface UpdateViewController : BaseViewController
@property (nonatomic, retain) PFObject * programObj;
@property(atomic) int ctrMode;
@end
