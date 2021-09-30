//
//  AdminDonationCell.h
//  DailyMessageTruthRevealed
//
//  Created by Techsviewer on 5/15/18.
//  Copyright © 2018 brainyapps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdminDonationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbl_name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_amount;
@property (weak, nonatomic) IBOutlet UILabel *lbl_email;
@property (weak, nonatomic) IBOutlet UILabel *lbl_dateTime;

@end
