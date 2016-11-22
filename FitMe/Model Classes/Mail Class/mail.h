//
//  mail_Settings.m
//  iKiss
//
//  Created by Debasish Pal on 24/11/11.
//  Copyright 2011 ObjectSol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface mail : NSObject<MFMailComposeViewControllerDelegate> {
    UIViewController* con1;
}
@property(nonatomic,retain)UIViewController* con1;
-(void)launchMailAppOnDevice;
-(BOOL)callForSendingMail;
-(void)mailWithVC:(UIViewController*)vc withMessage:(NSString *)strTitle withImage:(UIImage*)img;
-(void)mailSuccess;
@end
