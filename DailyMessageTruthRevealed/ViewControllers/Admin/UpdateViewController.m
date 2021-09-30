//
//  UpdateViewController.m
//  DailyMessageTruthRevealed
//
//  Created by Techsviewer on 5/15/18.
//  Copyright © 2018 brainyapps. All rights reserved.
//

#import "UpdateViewController.h"
#import "Utils.h"
#import "ImageItemCollectionViewCell.h"
#import "Utils.h"
#import "AdminProgramsViewController.h"

@interface UpdateViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSMutableArray * m_imageArray;
}
@property (weak, nonatomic) IBOutlet UILabel *lbl_CtrTitle;
@property (weak, nonatomic) IBOutlet UIView *view_EdtprogramTitle;
@property (weak, nonatomic) IBOutlet UIView *view_lblProgramTitle;
@property (weak, nonatomic) IBOutlet UITextField *edt_programTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbl_programTitle;
@property (weak, nonatomic) IBOutlet UITextView *txt_programDetail;
@property (weak, nonatomic) IBOutlet UIView *view_collectionContainer;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *view_selectGallery;

@property (weak, nonatomic) IBOutlet UIButton *btn_create;
@property (weak, nonatomic) IBOutlet UIButton *btn_addMore;

@property (weak, nonatomic) IBOutlet UIView *view_btnRecycle;
@property (nonatomic, retain) UIImagePickerController * picker;
@end

@implementation UpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    m_imageArray  = [NSMutableArray new];
    if(self.ctrMode == UPDATECTRL_MODE_CREATEPROGRAM){
        self.lbl_CtrTitle.text = @"New Program";
        [_view_lblProgramTitle setHidden:YES];
        [_view_EdtprogramTitle setHidden:NO];
        [_view_collectionContainer setHidden:YES];
        [_view_selectGallery setHidden:NO];
        [_btn_addMore setHidden:YES];
        [_view_btnRecycle setHidden:YES];
    }else if(self.ctrMode == UPDATECTRL_MODE_CREATEUPDATE){
        self.lbl_CtrTitle.text = @"New Update";
        [_view_lblProgramTitle setHidden:NO];
        [_view_EdtprogramTitle setHidden:YES];
        [_view_collectionContainer setHidden:YES];
        [_view_selectGallery setHidden:NO];
        [_btn_addMore setHidden:YES];
        [_view_btnRecycle setHidden:YES];
    }else if(self.ctrMode == UPDATECTRL_MODE_EDITPROGRAM){
        self.lbl_CtrTitle.text = @"Edit Program";
        [_view_lblProgramTitle setHidden:YES];
        [_view_EdtprogramTitle setHidden:NO];
        [_view_collectionContainer setHidden:YES];
        [_view_selectGallery setHidden:NO];
        [_btn_addMore setHidden:YES];
        [_view_btnRecycle setHidden:NO];
        
        self.edt_programTitle.text = self.programObj[PARSE_PROGRAM_NAME];
        self.txt_programDetail.text = self.programObj[PARSE_PROGRAM_DESCRIPTION];
        NSMutableArray * programImages = self.programObj[PARSE_PROGRAM_FILES];
        m_imageArray = [NSMutableArray new];
        for(PFFile * items in programImages){
            [m_imageArray addObject:items];
        }
        [self reloadImageCollection];
        
    }else if(self.ctrMode == UPDATECTRL_MODE_EDITPROGRAM){
        self.lbl_CtrTitle.text = @"Edit Update";
        [_view_lblProgramTitle setHidden:NO];
        [_view_EdtprogramTitle setHidden:YES];
        [_view_collectionContainer setHidden:YES];
        [_view_selectGallery setHidden:NO];
        [_btn_addMore setHidden:YES];
        [_view_btnRecycle setHidden:NO];
    }
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
- (IBAction)onClose:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSelectFromGallery:(id)sender {
    if (![Util isPhotoAvaileble]){
        [Util showAlertTitle:self title:@"Error" message:@"Check your permissions in Settings > Privacy > Photo"];
        return;
    }
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
- (IBAction)onCreate:(id)sender {
    if(self.ctrMode == UPDATECTRL_MODE_CREATEPROGRAM){
        PFObject * progObj = [PFObject objectWithClassName:PARSE_TABLE_PROGRAM];
        progObj[PARSE_PROGRAM_NAME] = self.edt_programTitle.text;
        progObj[PARSE_PROGRAM_DESCRIPTION] = self.txt_programDetail.text;
        NSMutableArray * imageArray = [NSMutableArray new];
        for(NSObject * items in m_imageArray){
            if([items isKindOfClass:[PFFile class]]){
                [imageArray addObject:items];
            }else if([items isKindOfClass:[UIImage class]]){
                NSData *imageData = UIImageJPEGRepresentation((UIImage*)items, 0.8);
                PFFile * pfItem = [PFFile fileWithData:imageData];
                [imageArray addObject:pfItem];
            }
        }
        progObj[PARSE_PROGRAM_FILES] = imageArray;
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [progObj saveInBackgroundWithBlock:^(BOOL success, NSError * error){
            [SVProgressHUD dismiss];
            dispatch_async(dispatch_get_main_queue(), ^{
                [Util showAlertTitle:self title:@"Create Program" message:@"Your program was successfully created." finish:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            });
        }];
        
    }else if(self.ctrMode == UPDATECTRL_MODE_EDITPROGRAM){
        PFObject * progObj = self.programObj;
        progObj[PARSE_PROGRAM_NAME] = self.edt_programTitle.text;
        progObj[PARSE_PROGRAM_DESCRIPTION] = self.txt_programDetail.text;
        NSMutableArray * imageArray = [NSMutableArray new];
        for(NSObject * items in m_imageArray){
            if([items isKindOfClass:[PFFile class]]){
                [imageArray addObject:items];
            }else if([items isKindOfClass:[UIImage class]]){
                NSData *imageData = UIImageJPEGRepresentation((UIImage*)items, 0.8);
                PFFile * pfItem = [PFFile fileWithData:imageData];
                [imageArray addObject:pfItem];
            }
        }
        progObj[PARSE_PROGRAM_FILES] = imageArray;
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [progObj saveInBackgroundWithBlock:^(BOOL success, NSError * error){
            [SVProgressHUD dismiss];
            dispatch_async(dispatch_get_main_queue(), ^{
                [Util showAlertTitle:self title:@"Edit Program" message:@"Your program was successfully modified." finish:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            });
        }];
    }
}
- (IBAction)onDelete:(id)sender {
    if(self.ctrMode == UPDATECTRL_MODE_EDITPROGRAM){
        PFObject * progObj = self.programObj;
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [progObj deleteInBackgroundWithBlock:^(BOOL success, NSError * error){
            [SVProgressHUD dismiss];
            dispatch_async(dispatch_get_main_queue(), ^{
                [Util showAlertTitle:self title:@"Delete" message:@"Your program was successfully deleted." finish:^{
                    UIViewController * targetCtr = nil;
                    for(UIViewController * ctr in self.navigationController.viewControllers){
                        if([ctr isKindOfClass:[AdminProgramsViewController class]]){
                            targetCtr = ctr;
                        }
                    }
                    if(targetCtr){
                        [self.navigationController popToViewController:targetCtr animated:YES];
                    }
                }];
            });
        }];
    }
}
- (IBAction)onAddMorePhoto:(id)sender {
    if (![Util isPhotoAvaileble]){
        [Util showAlertTitle:self title:@"Error" message:@"Check your permissions in Settings > Privacy > Photo"];
        return;
    }
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
- (void) reloadImageCollection
{
    if(m_imageArray.count > 0){
        [_view_collectionContainer setHidden:NO];
        [_view_selectGallery setHidden:YES];
        [_btn_addMore setHidden:NO];
    }else{
        [_view_collectionContainer setHidden:YES];
        [_view_selectGallery setHidden:NO];
        [_btn_addMore setHidden:YES];
    }
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView reloadData];
}
///////
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [m_imageArray count];
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Adjust cell size for orientation
    return CGSizeMake(100, 100);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageItemCollectionViewCell" forIndexPath:indexPath];
    if(cell){
        cell.btn_delete.tag = indexPath.row;
        NSObject * currentItem = [m_imageArray objectAtIndex:indexPath.row];
        if([currentItem isKindOfClass:[UIImage class]]){
            cell.img_thumb.image = (UIImage*)currentItem;
        }else{
            PFFile * fileItem = (PFFile*)currentItem;
            [Util setImage:cell.img_thumb imgFile:fileItem];
        }
        [cell.btn_delete addTarget:self action:@selector(onDeleteImage:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}
- (void) onDeleteImage:(UIButton*)button
{
    int index = button.tag;
    [m_imageArray removeObjectAtIndex:index];
    [self reloadImageCollection];
}
///////
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (![Util isPhotoAvaileble]){
        [Util showAlertTitle:self title:@"Error" message:@"Check your permissions in Settings > Privacy > Photo"];
        return;
    }
    UIImage *image = (UIImage *)[info valueForKey:UIImagePickerControllerOriginalImage];
    if(image){
        if(!m_imageArray)
            m_imageArray = [NSMutableArray new];
        [m_imageArray addObject:image];
        [self reloadImageCollection];
    }
}
- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (![Util isPhotoAvaileble]){
        [Util showAlertTitle:self title:@"Error" message:@"Check your permissions in Settings > Privacy > Cameras"];
        return;
    }
}
@end
