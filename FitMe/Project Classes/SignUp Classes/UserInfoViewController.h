//
//  UserInfoViewController.h
//  FitMe
//
//  Created by Debasish on 27/07/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ServerConnection.h"
#import "RadioButtonViewController.h"
#import "UserProfile.h"
@interface UserInfoViewController : BaseViewController<UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,ServerConnectionDelegate,radioButtondelegate>
{
    UIActionSheet *SHEET;
    int selectedIndex;
    UIActionSheet *sheetImages;
}
@property(nonatomic,assign)BOOL isEditProfile;
@property (nonatomic ,strong)UIImagePickerController *camerapicker;

@property (strong, nonatomic) IBOutlet UIButton *btnProfileImg;
@property (strong, nonatomic) IBOutlet UIImageView *imgVwProfile;

@property(strong,nonatomic) UIPickerView *pickItem;
@property(strong,nonatomic) UIDatePicker *pickDate;
@property (retain, nonatomic)  UIView *vwpicker;

@property(strong,nonatomic) UIView *maskView;
@property(strong,nonatomic)UIToolbar *toolBar;

@property(nonatomic,strong) NSString *birthDay_str;
@property(nonatomic,strong) NSString *unitHeightID_str,*unitWeightID_str,*actLevel_str,*inchVal_str,*ftVal_str,*dailyCalIntakeVal_str,*genderVal,*weightVal_str;
@property (strong, nonatomic) IBOutlet UITableView *tblVw;
- (IBAction)btnActionselectProfileImg:(id)sender;
- (IBAction)btnActionCancel:(id)sender;
- (IBAction)btnActionSave:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtFldUserNm;
@property (strong, nonatomic) IBOutlet UITextField *txtFldUserFirstNm;
@property (strong, nonatomic) IBOutlet UITextField *txtFldUserLastNm;

@property (strong, nonatomic)  UITextField *txtFldHeight_Ft;
@property (strong, nonatomic)  UITextField *txtFldHeight_Inch;
@property(strong,nonatomic)NSDate *selectedDate;

@property(nonatomic,strong)NSString *connectType;
@end
