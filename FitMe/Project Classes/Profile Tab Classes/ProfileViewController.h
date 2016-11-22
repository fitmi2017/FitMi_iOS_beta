//
//  ProfileViewController.h
//  FitMe
//
//  Created by Debasish on 27/07/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ServerConnection.h"
#import "UserProfileDetails.h"
@interface ProfileViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,ServerConnectionDelegate>
{
    UIActionSheet *SHEET;
    int selectedIndex;
    UIActionSheet *sheetImages;
}
@property(nonatomic,strong) UserProfileDetails *userProfileDetails;
@property (nonatomic ,strong)UIImagePickerController *camerapicker;
@property (weak, nonatomic) IBOutlet UITableView *deviceTblVw;
//@property (weak, nonatomic) IBOutlet UITableView *userProfileTblVw;

@property (strong, nonatomic) IBOutlet UIButton *btnProfileImg;
@property (strong, nonatomic) IBOutlet UIImageView *imgVwProfile;

- (IBAction)btnActionselectProfileImg:(id)sender;
- (IBAction)btnActionLogOut:(id)sender;
- (IBAction)btnActionEditProfile:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblUserNm;

@end
