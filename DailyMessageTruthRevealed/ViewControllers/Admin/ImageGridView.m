//
//  ImageGridView.m
//  DailyMessageTruthRevealed
//
//  Created by Techsviewer on 5/21/18.
//  Copyright © 2018 brainyapps. All rights reserved.
//

#import "ImageGridView.h"
#import "Utils.h"

@implementation PFImageView
- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:99/255.f]];
    [self setContentMode:UIViewContentModeScaleAspectFit];
    return self;
}
- (void) loadImageFrom:(PFFile*)imgFile
{
    [Util setImage:self imgFile:imgFile];
}
@end


#define IMAGE_DELTA     1

@interface ImageGridView ()
@end

@implementation ImageGridView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void) iniitialize
{
    for(UIView * subView in self.subviews){
        [subView removeFromSuperview];
    }
    if(self.pfFileArray.count == 1){
        float per_width = self.bounds.size.width - IMAGE_DELTA * 2;
        float per_height = self.bounds.size.height - IMAGE_DELTA * 2;
        PFImageView * imageView = [[PFImageView alloc] initWithFrame:CGRectMake(IMAGE_DELTA, IMAGE_DELTA, per_width, per_height)];
        [self addSubview:imageView];
        
        [imageView loadImageFrom:[self.pfFileArray firstObject]];
    }else if(self.pfFileArray.count == 2){
        float per_width = (self.bounds.size.width - IMAGE_DELTA * 3)/2;
        float per_height = self.bounds.size.height - IMAGE_DELTA * 2;
        
        PFImageView * imageView1 = [[PFImageView alloc] initWithFrame:CGRectMake(IMAGE_DELTA, IMAGE_DELTA, per_width, per_height)];
        [self addSubview:imageView1];
        
        PFImageView * imageView2 = [[PFImageView alloc] initWithFrame:CGRectMake(IMAGE_DELTA*2+per_width, IMAGE_DELTA, per_width, per_height)];
        [self addSubview:imageView2];
        
        [imageView1 loadImageFrom:[self.pfFileArray firstObject]];
        [imageView2 loadImageFrom:[self.pfFileArray objectAtIndex:1]];
    }else if(self.pfFileArray.count == 3){
        float per_width = (self.bounds.size.width - IMAGE_DELTA * 3)/3;
        float per_height = (self.bounds.size.height - IMAGE_DELTA * 3)/2;
        
        PFImageView * imageView1 = [[PFImageView alloc] initWithFrame:CGRectMake(IMAGE_DELTA, IMAGE_DELTA, per_width*2, per_height*2 + IMAGE_DELTA)];
        [self addSubview:imageView1];
        
        PFImageView * imageView2 = [[PFImageView alloc] initWithFrame:CGRectMake(IMAGE_DELTA*2 + per_width*2, IMAGE_DELTA, per_width, per_height)];
        [self addSubview:imageView2];
        
        PFImageView * imageView3 = [[PFImageView alloc] initWithFrame:CGRectMake(IMAGE_DELTA*2 + per_width*2, IMAGE_DELTA*2 + per_height, per_width, per_height)];
        [self addSubview:imageView3];
        
        [imageView1 loadImageFrom:[self.pfFileArray firstObject]];
        [imageView2 loadImageFrom:[self.pfFileArray objectAtIndex:1]];
        [imageView3 loadImageFrom:[self.pfFileArray objectAtIndex:2]];
    }else if(self.pfFileArray.count == 4){
        float per_width = (self.bounds.size.width - IMAGE_DELTA * 3)/2;
        float per_height = (self.bounds.size.height - IMAGE_DELTA * 3)/2;
        
        PFImageView * imageView1 = [[PFImageView alloc] initWithFrame:CGRectMake(IMAGE_DELTA, IMAGE_DELTA, per_width, per_height)];
        [self addSubview:imageView1];
        
        PFImageView * imageView2 = [[PFImageView alloc] initWithFrame:CGRectMake(IMAGE_DELTA*2 + per_width, IMAGE_DELTA, per_width, per_height)];
        [self addSubview:imageView2];
        
        PFImageView * imageView3 = [[PFImageView alloc] initWithFrame:CGRectMake(IMAGE_DELTA, IMAGE_DELTA*2+per_height, per_width, per_height)];
        [self addSubview:imageView3];
        
        PFImageView * imageView4 = [[PFImageView alloc] initWithFrame:CGRectMake(IMAGE_DELTA*2+per_width, IMAGE_DELTA*2+per_height, per_width, per_height)];
        [self addSubview:imageView4];
        
        [imageView1 loadImageFrom:[self.pfFileArray firstObject]];
        [imageView2 loadImageFrom:[self.pfFileArray objectAtIndex:1]];
        [imageView3 loadImageFrom:[self.pfFileArray objectAtIndex:2]];
        [imageView4 loadImageFrom:[self.pfFileArray objectAtIndex:3]];
    }else if(self.pfFileArray.count == 5){
        float per_width = (self.bounds.size.width - IMAGE_DELTA * 4)/3;
        float per_height = (self.bounds.size.height - IMAGE_DELTA * 4)/3;
        
        PFImageView * imageView1 = [[PFImageView alloc] initWithFrame:CGRectMake(IMAGE_DELTA, IMAGE_DELTA, self.bounds.size.width - per_width - IMAGE_DELTA * 3, self.bounds.size.height - per_height - IMAGE_DELTA * 3)];
        [self addSubview:imageView1];
        
        PFImageView * imageView2 = [[PFImageView alloc] initWithFrame:CGRectMake(IMAGE_DELTA, imageView1.frame.size.height+IMAGE_DELTA*2, imageView1.frame.size.width, per_height)];
        [self addSubview:imageView2];
        
        PFImageView * imageView3 = [[PFImageView alloc] initWithFrame:CGRectMake(IMAGE_DELTA*2+imageView1.frame.size.width , IMAGE_DELTA, per_width, per_height)];
        [self addSubview:imageView3];
        
        PFImageView * imageView4 = [[PFImageView alloc] initWithFrame:CGRectMake(IMAGE_DELTA*2+imageView1.frame.size.width , IMAGE_DELTA*2+per_height, per_width, per_height)];
        [self addSubview:imageView4];
        
        PFImageView * imageView5 = [[PFImageView alloc] initWithFrame:CGRectMake(IMAGE_DELTA*2+imageView1.frame.size.width , IMAGE_DELTA*3+per_height*2, per_width, per_height)];
        [self addSubview:imageView5];
        
        [imageView1 loadImageFrom:[self.pfFileArray firstObject]];
        [imageView2 loadImageFrom:[self.pfFileArray objectAtIndex:1]];
        [imageView3 loadImageFrom:[self.pfFileArray objectAtIndex:2]];
        [imageView4 loadImageFrom:[self.pfFileArray objectAtIndex:3]];
        [imageView5 loadImageFrom:[self.pfFileArray objectAtIndex:4]];
    }else if(self.pfFileArray.count == 6){
        float per_width = (self.bounds.size.width - IMAGE_DELTA * 4)/3;
        float per_height = (self.bounds.size.height - IMAGE_DELTA * 4)/3;
        
        PFImageView * imageView1 = [[PFImageView alloc] initWithFrame:CGRectMake(IMAGE_DELTA, IMAGE_DELTA, self.bounds.size.width - per_width - IMAGE_DELTA * 3, self.bounds.size.height - per_height - IMAGE_DELTA * 3)];
        [self addSubview:imageView1];
        
        PFImageView * imageView2 = [[PFImageView alloc] initWithFrame:CGRectMake(IMAGE_DELTA, imageView1.frame.size.height+IMAGE_DELTA*2, per_width, per_height)];
        [self addSubview:imageView2];
        
        PFImageView * imageView6 = [[PFImageView alloc] initWithFrame:CGRectMake(IMAGE_DELTA*2+per_width, imageView1.frame.size.height+IMAGE_DELTA*2, per_width, per_height)];
        [self addSubview:imageView6];
        
        PFImageView * imageView3 = [[PFImageView alloc] initWithFrame:CGRectMake(IMAGE_DELTA*2+imageView1.frame.size.width , IMAGE_DELTA, per_width, per_height)];
        [self addSubview:imageView3];
        
        PFImageView * imageView4 = [[PFImageView alloc] initWithFrame:CGRectMake(IMAGE_DELTA*2+imageView1.frame.size.width , IMAGE_DELTA*2+per_height, per_width, per_height)];
        [self addSubview:imageView4];
        
        PFImageView * imageView5 = [[PFImageView alloc] initWithFrame:CGRectMake(IMAGE_DELTA*2+imageView1.frame.size.width , IMAGE_DELTA*3+per_height*2, per_width, per_height)];
        [self addSubview:imageView5];
        
        [imageView1 loadImageFrom:[self.pfFileArray firstObject]];
        [imageView2 loadImageFrom:[self.pfFileArray objectAtIndex:1]];
        [imageView3 loadImageFrom:[self.pfFileArray objectAtIndex:2]];
        [imageView4 loadImageFrom:[self.pfFileArray objectAtIndex:3]];
        [imageView5 loadImageFrom:[self.pfFileArray objectAtIndex:4]];
        [imageView6 loadImageFrom:[self.pfFileArray objectAtIndex:5]];
    }
}
@end
