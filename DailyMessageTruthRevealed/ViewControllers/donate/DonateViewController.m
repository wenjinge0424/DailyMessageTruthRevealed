//
//  DonateViewController.m
//  DailyMessageTruthRevealed
//
//  Created by Techsviewer on 5/15/18.
//  Copyright © 2018 brainyapps. All rights reserved.
//

#import "DonateViewController.h"
#import "StripeSignViewController.h"
#import "IQDropDownTextField.h"
#import "AppStorePay.h"
#import "SCLAlertView.h"

@interface DonateViewController ()<IQDropDownTextFieldDelegate, AppStorePayDelegate>
{
    AppStorePay * appStorePay;
}
@property (weak, nonatomic) IBOutlet UITextField *edt_name;
@property (weak, nonatomic) IBOutlet UITextField *edt_email;

@property (weak, nonatomic) IBOutlet IQDropDownTextField *edt_amount;
@end

@implementation DonateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appStorePay = [[AppStorePay alloc] init];
    appStorePay.delegate = self;
    NSMutableArray * selectedAmounts = [[NSMutableArray alloc] initWithObjects:@"0.99", @"4.99", @"9.99", @"19.99", @"49.99", @"99.99", @"149.99", @"199.99", @"249.99", @"299.99", nil];
    self.edt_amount.itemList = selectedAmounts;
    self.edt_amount.isOptionalDropDown = YES;
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
- (IBAction)onDonate:(id)sender {
//    StripeSignViewController * controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"StripeSignViewController"];
//    [self.navigationController pushViewController:controller animated:YES];
    NSString * name = self.edt_name.text;
    NSString * email = self.edt_email.text;
    NSString * amount = self.edt_amount.selectedItem;
    
    NSString * errMsg = @"";
    if (![email isEmail] && email.length > 0){
        errMsg = [errMsg stringByAppendingString:@"Please enter valid email."];
        [Util showAlertTitle:self title:@"Error" message:errMsg];
        return;
    }
    if(amount.length == 0){
        errMsg = [errMsg stringByAppendingString:@"Please enter amount."];
        [Util showAlertTitle:self title:@"Error" message:errMsg];
        return;
    }
    if(name.length == 0){
        name = email;
    }
    
    
    NSString *msg = [NSString stringWithFormat:@"Confirm Your In-App Purchase. Do you want to buy purchase item for $%@?", amount];
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    alert.customViewColor = MAIN_COLOR;
    alert.horizontalButtons = YES;
    [alert addButton:@"Close" actionBlock:^(void) {
    }];
    [alert addButton:@"Buy" actionBlock:^(void) {
        float value = [amount floatValue];
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        NSString *formattedPrice = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:value]];
        
        NSString * productId = formattedPrice;
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [self->appStorePay startAppStorePay:productId :formattedPrice];
    }];
    [alert showError:@"In-App Purchase" subTitle:msg closeButtonTitle:nil duration:0.0f];
    
    
    
}
- (void) AppStorePayDeniedWithReson:(NSString *)errorMsg
{
    [SVProgressHUD dismiss];
    [Util showAlertTitle:self title:@"" message:errorMsg];
}
- (void) AppStorePaySuccessed:(NSString *)productId
{
    NSString * name = self.edt_name.text;
    NSString * email = self.edt_email.text;
    NSString * amount = self.edt_amount.selectedItem;
    
    if(name.length == 0){
        name = email;
    }
    
    PFObject * donationObj = [PFObject objectWithClassName:PARSE_TABLE_DONATION];
    donationObj[PARSE_DONATION_NAME] = name;
    donationObj[PARSE_DONATION_EMAIL] = email;
    donationObj[PARSE_DONATION_AMOUNT] = [NSNumber numberWithInt:[amount intValue]];
    
    [donationObj saveInBackgroundWithBlock:^(BOOL success, NSError * error){
        [SVProgressHUD dismiss];
        dispatch_async(dispatch_get_main_queue(), ^{
            [Util showAlertTitle:self title:@"Success" message:@"Your donation was successfully sent." finish:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        });
    }];
}
@end
