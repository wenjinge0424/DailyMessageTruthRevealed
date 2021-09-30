//
//  AdminProgramsViewController.m
//  DailyMessageTruthRevealed
//
//  Created by Techsviewer on 5/15/18.
//  Copyright © 2018 brainyapps. All rights reserved.
//

#import "AdminProgramsViewController.h"
#import "ProgramCell.h"
#import "AdminProgramDetailViewController.h"
#import "UpdateViewController.h"

@interface AdminProgramsViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    
}
@property (weak, nonatomic) IBOutlet UITableView *tbl_data;
@property (nonatomic, retain) NSMutableArray  * dataTable;
@end

@implementation AdminProgramsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getDatas];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) getDatas
{
    self.dataTable = [NSMutableArray new];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    PFQuery * query = [PFQuery queryWithClassName:PARSE_TABLE_PROGRAM];
    [query findObjectsInBackgroundWithBlock:^(NSArray *arrays, NSError *errs){
        if (errs){
            [SVProgressHUD dismiss];
            [Util showAlertTitle:self title:@"Error" message:[errs localizedDescription]];
        }else{
            if(arrays.count == 0){/// is friend
          }else{
                for(PFObject * object in arrays){
                    [self.dataTable addObject:object];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                
                [self.view layoutSubviews];
                
                self.tbl_data.delegate = self;
                self.tbl_data.dataSource = self;
                [self.tbl_data reloadData];
                
                
            });
        }
    }];
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
- (IBAction)onAdd:(id)sender {
    UpdateViewController * controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UpdateViewController"];
    controller.ctrMode = UPDATECTRL_MODE_CREATEPROGRAM;
    [self.navigationController pushViewController:controller animated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataTable count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300;
}
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ProgramCell";
    ProgramCell *cell = (ProgramCell *)[tv dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell){
        cell.btn_edit.tag = indexPath.row;
        [cell.btn_edit addTarget:self action:@selector(onEditProgram:) forControlEvents:UIControlEventTouchUpInside];
        
        PFObject * progObj = [self.dataTable objectAtIndex:indexPath.row];
        cell.lbl_title.text = progObj[PARSE_PROGRAM_NAME];
        cell.txt_note.text = progObj[PARSE_PROGRAM_DESCRIPTION];
        cell.imageGrid.pfFileArray = progObj[PARSE_PROGRAM_FILES];
        
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    PFObject * progObj = [self.dataTable objectAtIndex:indexPath.row];
    AdminProgramDetailViewController * controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AdminProgramDetailViewController"];
    controller.programInfo = progObj;
    [self.navigationController pushViewController:controller animated:YES];
 }
- (void) onEditProgram:(UIButton*)sender
{
    PFObject * progObj = [self.dataTable objectAtIndex:sender.tag];
    UpdateViewController * controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UpdateViewController"];
    controller.ctrMode = UPDATECTRL_MODE_EDITPROGRAM;
    controller.programObj = progObj;
    [self.navigationController pushViewController:controller animated:YES];
}
@end
