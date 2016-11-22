//
//  DeviceSynchFinalViewController.h
//  FitMe
//
//  Created by Debasish on 10/08/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "UserProfileDetails.h"
@interface DeviceSynchFinalViewController: BaseViewController<UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>
{
    UIActionSheet *SHEET;
    int selectedIndex;
    UIActionSheet *sheetImages;
}
@property(nonatomic,strong)UserProfileDetails *userProfileObj;
@property (nonatomic ,strong)UIImagePickerController *camerapicker;

@property (strong, nonatomic) IBOutlet UITableView *tblVw;
- (IBAction)btnActionselectProfileImg:(id)sender;
- (IBAction)btnActionNewUser:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtFldUserNm;
@property(nonatomic,strong)NSString *deviceNm;
@property(nonatomic,strong)UIImage *deviceImg;
@end
