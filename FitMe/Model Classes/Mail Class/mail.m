//
//  mail_Settings.m
//  iKiss
//
//  Created by Debasish Pal on 24/11/11.
//  Copyright 2011 ObjectSol. All rights reserved.
//

#import "mail.h"
#import "Decode64.h"

@implementation mail
@synthesize con1;
-(void)mailWithVC:(UIViewController*)vc withMessage:(NSString *)strTitle withImage:(UIImage*)img
{
    if(![self callForSendingMail]) 
        return;

    con1=vc;
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    controller.title=@"FitMi App";
    
     NSArray * toBody = [[NSArray alloc] initWithObjects:@"test@dreamztech.com", nil];
    [controller setToRecipients:toBody];
    
    NSData *imgData=[[NSData alloc]init];
    UIImage *image1=img;
    imgData=UIImageJPEGRepresentation(image1,0.2);

    NSString *imageStr = [Base64 encode:imgData];
    
    NSString *htmlStr = [NSString stringWithFormat:@"<img src='data:image/jpeg;base64,%@'/>",imageStr];

   /* NSString *str1=@"<b><br>Check out this cool application  ---<br>It allows you to send a kiss to anyone using Email,Twitter,Facebook or Text.</b><br><br><b>iTunes Link :</b><br><a href=\"http://apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=428954015&mt=8\">Correct link will go here.</a> ";*/
    NSString *str1=@"FitMi App";
    
    NSMutableString *emailBody=[[NSMutableString alloc]initWithString:htmlStr ];
    [emailBody appendString:str1];
    
    [controller setMessageBody:emailBody isHTML:YES];

    [controller setSubject:strTitle];
    controller.modalPresentationStyle=UIModalPresentationFullScreen;
    [controller setEditing:TRUE];
    [con1 presentViewController:controller animated:YES completion:nil];
  //  [con1 presentModalViewController:controller animated:YES];
}

-(BOOL)callForSendingMail
{
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		if ([mailClass canSendMail])
		{
            return YES;
		}
		else
		{
			[self launchMailAppOnDevice];
		}
	}
	else
	{
		[self launchMailAppOnDevice];
	}
	
	return NO;
}
-(void)launchMailAppOnDevice
{
	NSString *emailBody = @"";
	NSString *recipients = [NSString stringWithFormat:@"mailto:?to=%@&subject=%@",@"",@""];
	NSString *body = [NSString stringWithFormat:@"&body=%@",emailBody];
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

#pragma mark Compose Mail
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{		
	switch (result)
	{
		case MFMailComposeResultCancelled:
			NSLog(@"%@", @"Result: canceled");
			break;
		case MFMailComposeResultSaved:
			NSLog(@"%@", @"Result: saved");
			break;
		case MFMailComposeResultSent:
		    [self mailSuccess];
			NSLog(@"%@", @"Result: sent");
			break;
		case MFMailComposeResultFailed:
			NSLog(@"%@", @"Result: failed");
			break;
		default:
			NSLog(@"%@", @"Result: not sent");
			break;
	}
    [con1 dismissViewControllerAnimated:YES completion:nil];
	//[con1 dismissModalViewControllerAnimated:YES];
}
-(void)mailSuccess
{
     UIAlertView *myAlert1 = [[UIAlertView alloc]initWithTitle:nil
                                                      message:@"Mail was sent Successfully."
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"OK", nil];
    myAlert1.tag=5;
    [myAlert1 show];
 }
@end

