//
//  AdminDonationViewController.m
//  DailyMessageTruthRevealed
//
//  Created by Techsviewer on 5/15/18.
//  Copyright © 2018 brainyapps. All rights reserved.
//

#import "AdminDonationViewController.h"
#import "AdminDonationCell.h"

@interface AdminDonationViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    int selectedIndex;
}
@property (weak, nonatomic) IBOutlet UITableView *tbldata;
@property (nonatomic, retain) NSMutableArray  * dataTable;
@end

@implementation AdminDonationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    selectedIndex = -1;
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
    PFQuery * query = [PFQuery queryWithClassName:PARSE_TABLE_DONATION];
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
                
                self.tbldata.delegate = self;
                self.tbldata.dataSource = self;
                [self.tbldata reloadData];
                
                
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataTable count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == selectedIndex)
        return 130;
    return 55;
}
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"AdminDonationCell";
    AdminDonationCell *cell = (AdminDonationCell *)[tv dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell){
        PFObject * donationObj = [self.dataTable objectAtIndex:indexPath.row];
        cell.lbl_name.text = donationObj[PARSE_DONATION_NAME];
        cell.lbl_amount.text = [NSString stringWithFormat:@"$%d", [donationObj[PARSE_DONATION_AMOUNT] intValue]];
        cell.lbl_email.text = donationObj[PARSE_DONATION_EMAIL];
        cell.lbl_dateTime.text = [Util convertDateToString:donationObj.updatedAt];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSArray * reloadIndexs = nil;
    if(selectedIndex == indexPath.row){
        reloadIndexs = [[NSArray alloc] initWithObjects:[NSIndexPath indexPathForRow:selectedIndex inSection:0], nil];
        selectedIndex = -1;
    }else{
        reloadIndexs = [[NSArray alloc] initWithObjects:[NSIndexPath indexPathForRow:selectedIndex inSection:0], [NSIndexPath indexPathForRow:indexPath.row inSection:0],nil];
        selectedIndex = indexPath.row;
    }
    [self.tbldata reloadRowsAtIndexPaths:reloadIndexs withRowAnimation:UITableViewRowAnimationMiddle];
}
@end
