//
//  Utils.m
//  DailyMessageTruthRevealed
//
//  Created by Techsviewer on 5/15/18.
//  Copyright © 2018 brainyapps. All rights reserved.
//

#import "Utils.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "SCLAlertView.h"
#import "Config.h"
#import "Reachability.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageView+AFNetworking_UIActivityIndicatorView.h"

#define PARSE_SERVER_BASE                  @"parse.brainyapps.com"
#define PARSE_CDN_BASE                     @"d2zvprcpdficqw.cloudfront.net"
#define PARSE_CDN_DECNUM                   10000

@implementation Util
+ (AppDelegate*) appDelegate{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

+ (BOOL) isConnectableInternet {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        return NO;
    } else {
        NSLog(@"There IS internet connection");
        return YES;
    }
}


+ (void)showAlertTitle:(UIViewController *)vc title:(NSString *)title message:(NSString *)message
{
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    
    alert.shouldDismissOnTapOutside = YES;
    alert.showAnimationType = SCLAlertViewShowAnimationSimplyAppear;
    [alert alertIsDismissed:^{
    }];
    alert.customViewColor = [UIColor colorWithRed:2/255.f green:114/255.f blue:202/255.f alpha:1.f];
    
    [alert showInfo:vc title:title subTitle:message closeButtonTitle:@"OK" duration:0.0f];
}
+ (void)showAlertTitle:(UIViewController *)vc title:(NSString *)title message:(NSString *)message finish:(void (^)(void))finish
{
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    
    alert.shouldDismissOnTapOutside = YES;
    alert.showAnimationType = SCLAlertViewShowAnimationSimplyAppear;
    [alert alertIsDismissed:^{
        if (finish) {
            finish ();
        }
    }];
    [alert setForceHideBlock:^{
        if (finish) {
            finish ();
        }
    }];
    alert.customViewColor = MAIN_COLOR;
    
    [alert showInfo:vc title:title subTitle:message closeButtonTitle:@"OK" duration:0.0f];
}

+ (void)showAlertTitle:(UIViewController *)vc title:(NSString *)title message:(NSString *)message info:(BOOL)info
{
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    
    alert.shouldDismissOnTapOutside = YES;
    alert.showAnimationType = SCLAlertViewShowAnimationSimplyAppear;
    [alert alertIsDismissed:^{
    }];
    alert.customViewColor = MAIN_COLOR;
    
    if (info)
        [alert showInfo:vc title:title subTitle:message closeButtonTitle:@"OK" duration:0.0f];
    else
        [alert showQuestion:vc title:title subTitle:message closeButtonTitle:@"OK" duration:0.0f];
}
+ (void) setLoginUserName:(NSString*) userName password:(NSString*) password {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userName forKey:@"userName"];
    [defaults setObject:password forKey:@"password"];
    [defaults synchronize];
    
    // Installation
    if (userName.length > 0 && password.length > 0) {
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation setObject:[PFUser currentUser] forKey:@"owner"];
        [currentInstallation saveInBackground];
    } else {
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation removeObjectForKey:@"owner"];
        [currentInstallation saveInBackground];
    }
}
+ (NSString*) getLoginUserName {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [defaults objectForKey:@"userName"];
    return userName;
}

+ (NSString*) getLoginUserPassword {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *password = [defaults objectForKey:@"password"];
    return password;
}


+ (BOOL) isPhotoAvaileble {
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusDenied || [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusRestricted){
        return NO;
    } else if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined){
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
        }];
        return YES;
    } else {
        return YES;
    }
}

+ (void) setImage:(UIImageView *)imgView imgFile:(PFFile *)imgFile {
    NSString *imageURL;
    
    imageURL = [Util downloadedURL:imgFile.url name:nil];
    if (!imageURL) {
        imageURL = [Util urlparseCDN:imgFile.url];
        [Util downloadFile:imageURL name:nil completionBlock:nil];
    }
    
    [imgView setImageWithURL:[NSURL URLWithString:imageURL] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

+ (NSString *) downloadedURL:(NSString *)url name:(NSString *) name {
    NSString *fileName = name;
    if (name == nil) {
        fileName = [url lastPathComponent];
    }
    NSString *filePath = [[self getDocumentDirectory] stringByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSURL *localurl = [NSURL fileURLWithPath:filePath];
        return localurl.absoluteString;
    }
    
    return nil;
}
+ (NSString *) getDocumentDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //create an array and store result of our search for the documents directory in it
    
    NSString *documentsDirectory = [NSString stringWithFormat:@"%@/", [paths objectAtIndex:0]]; //create NSString object, that holds our exact path to the documents directory
    return  documentsDirectory;
}
+ (void) downloadFile:(NSString *)url name:(NSString *) name completionBlock:(void (^)(NSURL *downloadurl, NSData *data, NSError *err))completionBlock {
    NSURL *remoteurl = [NSURL URLWithString:url];
    NSString *fileName = name;
    if (name == nil) {
        fileName = [url lastPathComponent];
    }
    NSString *filePath = [[self getDocumentDirectory] stringByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePath];
        NSURL *localurl = [NSURL fileURLWithPath:filePath];
        if (completionBlock)
            completionBlock(localurl, data, nil);
        return;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:remoteurl];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Download Error:%@",error.description);
            if (completionBlock)
                completionBlock(nil, data, error);
        } else if (data) {
            [data writeToFile:filePath atomically:YES];
            NSLog(@"File is saved to %@",filePath);
            
            NSURL *localurl = [NSURL fileURLWithPath:filePath];
            if (completionBlock)
                completionBlock(localurl, data, error);
        }
    }];
}
+ (NSString *)urlparseCDN:(NSString *)url
{
    NSArray *paths = [url pathComponents];
    
    if (paths && paths[1]) {
        NSArray *items = [paths[1] componentsSeparatedByString:@":"];
        if (items && [items[0] isEqualToString:PARSE_SERVER_BASE]) {
            NSInteger port = [items[1] integerValue] - PARSE_CDN_DECNUM;
            NSString *cdnURL = [NSString stringWithFormat:@"https://%@/process/%ld", PARSE_CDN_BASE, (long)port];
            
            for (int i=2; i<paths.count; i++) {
                cdnURL = [[cdnURL stringByAppendingString:@"/"] stringByAppendingString:paths[i]];
            }
            
            return cdnURL;
        }
    }
    
    return url;
}
+ (UIImage *)getUploadingImageFromImage:(UIImage *)image {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    
    // dont' resize, use the original image. we can adjust this value of maxResolution like 1024, 768, 640  and more less than current value.
    CGFloat maxResolution = 320.f;
    if (image.size.width < maxResolution) {
        CGSize newSize = CGSizeMake(image.size.width, image.size.height);
        UIGraphicsBeginImageContext(newSize);
        // CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor blackColor].CGColor);
        // CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, newSize.width, newSize.height));
        [image drawInRect:CGRectMake(0,
                                     0,
                                     image.size.width,
                                     image.size.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    } else {
        CGFloat rate = image.size.width / maxResolution;
        CGSize newSize = CGSizeMake(maxResolution, image.size.height / rate);
        UIGraphicsBeginImageContext(newSize);
        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }
}
+ (NSString*) convertDateToString:(NSDate*)date
{
    NSDateFormatter * formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"MMM dd, yyyy"];
    return [formatter stringFromDate:date];
}
@end
