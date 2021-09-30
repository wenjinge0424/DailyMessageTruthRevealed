//
//  ImageGridView.h
//  DailyMessageTruthRevealed
//
//  Created by Techsviewer on 5/21/18.
//  Copyright © 2018 brainyapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface PFImageView : UIImageView
- (void) loadImageFrom:(PFFile*)imgFile;
@end

@interface ImageGridView : UIView
@property (nonatomic, retain) NSMutableArray * pfFileArray;
- (void) iniitialize;
@end
