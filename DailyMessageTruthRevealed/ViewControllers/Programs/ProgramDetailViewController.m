//
//  ProgramDetailViewController.m
//  DailyMessageTruthRevealed
//
//  Created by Techsviewer on 5/15/18.
//  Copyright © 2018 brainyapps. All rights reserved.
//

#import "ProgramDetailViewController.h"
#import "ProgramCell.h"

@interface ProgramDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray * updateFiles;
}
@property (weak, nonatomic) IBOutlet UITableView *tbl_data;

@end

@implementation ProgramDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    PFObject * progObj = self.programInfo;
    [progObj fetchInBackgroundWithBlock:^(PFObject * pfObj, NSError * error){
        [SVProgressHUD dismiss];
        self.programInfo = pfObj;
        dispatch_async(dispatch_get_main_queue(), ^{
            updateFiles = progObj[PARSE_PROGRAM_UPDATEFILES];
            
            [self.tbl_data setDelegate:self];
            [self.tbl_data setDataSource:self];
            [self.tbl_data reloadData];
        });
    }];
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
- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(updateFiles.count > 0)
        return 3;
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0) return 280;
    else if(indexPath.row == 1) return 60;
    else return 300;
}
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        static NSString *cellIdentifier = @"ProgramCell_title";
        ProgramCell *cell = (ProgramCell *)[tv dequeueReusableCellWithIdentifier:cellIdentifier];
        PFObject * progObj = self.programInfo;
        cell.txt_note.text = progObj[PARSE_PROGRAM_DESCRIPTION];
        cell.imageGrid.pfFileArray = progObj[PARSE_PROGRAM_FILES];
        return cell;
    }
    else if(indexPath.row == 1) {
        static NSString *cellIdentifier = @"ProgramCell_seperater";
        ProgramCell *cell = (ProgramCell *)[tv dequeueReusableCellWithIdentifier:cellIdentifier];
        return cell;
    }
    else {
        static NSString *cellIdentifier = @"ProgramCell_detail";
        ProgramCell *cell = (ProgramCell *)[tv dequeueReusableCellWithIdentifier:cellIdentifier];
        PFObject * progObj = self.programInfo;
        cell.txt_note.text = progObj[PARSE_PROGRAM_UPDATEDESCRIPTION];
        cell.imageGrid.pfFileArray = updateFiles;
        cell.lbl_updateTime.text = [NSString stringWithFormat:@"Last update:%@", [Util convertDateToString:progObj[PARSE_PROGRAM_UPDATEDATE]]];
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
@end
