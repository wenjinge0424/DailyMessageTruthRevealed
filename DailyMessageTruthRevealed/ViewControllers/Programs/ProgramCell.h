//
//  ProgramCell.h
//  DailyMessageTruthRevealed
//
//  Created by Techsviewer on 5/15/18.
//  Copyright © 2018 brainyapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageGridView.h"

@interface ProgramCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btn_edit;
@property (weak, nonatomic) IBOutlet UIButton *btn_edit_update;

@property (weak, nonatomic) IBOutlet UIButton *btn_updatePlus;
@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet UITextView *txt_note;
@property (weak, nonatomic) IBOutlet ImageGridView *imageGrid;
@property (weak, nonatomic) IBOutlet UILabel *lbl_updateTime;
@end
