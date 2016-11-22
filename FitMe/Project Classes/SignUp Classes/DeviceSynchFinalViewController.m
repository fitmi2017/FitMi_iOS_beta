//
//  DeviceSynchFinalViewController.m
//  FitMe
//
//  Created by Debasish on 10/08/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import "DeviceSynchFinalViewController.h"
#import "ProfileTableViewCell.h"
#import "User.h"
#import "Utility.h"
#import "UserInfoViewController.h"
#import "Constant.h"
#import "MHCustomTabBarController.h"
#import "AppDelegate.h"
#import "SettingsViewController.h"
@interface DeviceSynchFinalViewController ()
{
    NSMutableArray *deviceArr;
    User *mUser;
    NSUserDefaults *user_defaults;
     AppDelegate *mAppDelegate;
    __weak IBOutlet UILabel *messageLbl;
    __weak IBOutlet UIButton *btnUserProfileImg;
    __weak IBOutlet UILabel *lblUserNm;
 NSString *selectedUserProfileID;
}

@end

@implementation DeviceSynchFinalViewController

#pragma mark - UIView LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    user_defaults = User_Defaults;
    
    selectedUserProfileID=[user_defaults valueForKey:@"selectedUserProfileID"];

    UIImage *userImg=[self getImage];
    lblUserNm.text=_userProfileObj.full_name;
    if ([_userProfileObj.gender isEqualToString:@"Male"])
    {
        [btnUserProfileImg setBackgroundImage:[UIImage imageNamed:@"User_Male@3x.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btnUserProfileImg setBackgroundImage:[UIImage imageNamed:@"User_Female@3x.png"] forState:UIControlStateNormal];
    }

    if(userImg)
        [btnUserProfileImg setBackgroundImage:userImg forState:UIControlStateNormal];

    mUser = [[Utility sharedManager] retriveUserDetailsFromDefault];
    
    _txtFldUserNm.text=mUser.userName;
    
    [self createNavigationView:@"Devices"];
    [self.navigationItem setHidesBackButton:YES animated:NO];
 
    UIFont *mediumFont = [UIFont fontWithName:@"SinkinSans-400Regular" size:16];
    NSDictionary *mediumDict = [NSDictionary dictionaryWithObject: mediumFont forKey:NSFontAttributeName];
    NSMutableAttributedString *mediumAttrString = [[NSMutableAttributedString alloc] initWithString:@"Congratulations! " attributes: mediumDict];
    
   // NSMutableAttributedString *spaceAttrString = [[NSMutableAttributedString alloc]initWithString:@"  " attributes: mediumDict];
   // [mediumAttrString appendAttributedString:spaceAttrString];
    
    UIFont *LightFont = [UIFont fontWithName:@"SinkinSans-200XLight" size:14];
    NSDictionary *LightDict = [NSDictionary dictionaryWithObject:LightFont forKey:NSFontAttributeName];
    NSMutableAttributedString *LightAttrString = [[NSMutableAttributedString alloc]initWithString:@"you have successfully synced your device."  attributes:LightDict];
    
    [mediumAttrString appendAttributedString:LightAttrString];
    
    NSMutableParagraphStyle *style=[NSMutableParagraphStyle new];
    style.lineSpacing=6;
 
    [mediumAttrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, mediumAttrString.length)];
    
    messageLbl.attributedText=mediumAttrString;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    APP_CTRL.CurrentControllerObj = self;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView
 willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileTableViewCell *cell=nil;
    NSArray *nib=nil;
    
    nib=[[ NSBundle  mainBundle]loadNibNamed:@"ProfileDeviceTableViewCell" owner:self options:nil];
    
    cell=(ProfileTableViewCell*)[nib objectAtIndex:0];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.lblDeviceNm.text=_deviceNm;
    
    cell.lblDeviceStatus.text=@"Syncing...";
    
    cell.imgVw.image=_deviceImg;
    cell.imgVw.contentMode = UIViewContentModeScaleAspectFit;
    
    cell.imgVw.layer.borderColor=[[UIColor colorWithRed:194/255.0 green:194/255.0 blue:194/255.0 alpha:1.0] CGColor];
    cell.imgVw.layer.borderWidth=1;
    
    cell.lblDeviceStatus.text=@"Synced";
  
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"ButtonIndex -- %ld",(long)buttonIndex);
    switch (buttonIndex) {
        case 0:
        {
            //-------For Camera--------
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                _camerapicker = [[UIImagePickerController alloc] init] ;
                _camerapicker.delegate = self;
                _camerapicker.allowsEditing = YES;
                _camerapicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                _camerapicker.showsCameraControls = YES;
                //[camerapicker parentViewController];
                [self presentViewController:_camerapicker animated:YES completion:^{
                }];
            }
            else
            {
                [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"No Camera Available in the Device" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
            }
        }
            break;
        case 1:
        {
            //---------For Gallery----------
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init] ;
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            }
            else if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
            {
                [imagePicker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
            }
            imagePicker.delegate = self;
            imagePicker.allowsEditing = NO;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Image Picker Delegates
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image,*image1;
    
    if([picker sourceType] == UIImagePickerControllerSourceTypePhotoLibrary){
        image = [info valueForKey:UIImagePickerControllerOriginalImage];
        
        image=[Utility imageWithImage:image scaledToWidth:200];
        //  [image resizedImage:CGSizeMake(250, 200) interpolationQuality:kCGInterpolationHigh];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    else if ([picker sourceType] == UIImagePickerControllerSourceTypeCamera){
        image = [info valueForKey:UIImagePickerControllerOriginalImage];
        NSLog(@"--height=%f,width=%f",image.size.height,image.size.width);
        image=[Utility imageWithImage:image scaledToWidth:200];
        NSLog(@"--height=%f,width=%f",image1.size.height,image1.size.width);
        //[image resizedImage:CGSizeMake(250, 200) interpolationQuality:kCGInterpolationHigh];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    //    _imgVwFile.image=image1;
    //    _imgVwFile.contentMode = UIViewContentModeScaleAspectFit;
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnActionselectProfileImg:(id)sender
{
//    sheetImages = [[UIActionSheet alloc] initWithTitle:@"Choose Profile Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From Camera",@"From Gallery", nil];
//    [sheetImages showInView:self.view];
    
}

#pragma mark - "Get Started" Button Action
- (IBAction)btnActionNewUser:(id)sender
{
    mAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (self.navigationController == mAppDelegate.homeNavigation) {
        if (self.navigationController.viewControllers.count> 0) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    else
        [mAppDelegate.tabBarController performSegueWithIdentifier:@"homenavigation" sender:[mAppDelegate.tabBarController.buttons objectAtIndex:0]];
}

#pragma mark - UINavigation Button Action
-(void)showLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)showRight
{
    SettingsViewController *mVerificationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    mVerificationViewController.navClass=@"settings";
    [self.navigationController pushViewController:mVerificationViewController animated:YES];
}

#pragma mark - getImage Method
- (UIImage*)getImage
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *ImageNm=[NSString stringWithFormat:@"savedImage_%@.png",selectedUserProfileID];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:ImageNm];
    UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
    return img;
}

@end
