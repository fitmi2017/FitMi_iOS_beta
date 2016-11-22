//
//  DeviceSynchViewController.h
//  FitMe
//
//  Created by Debasish on 10/08/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "UserProfileDetails.h"
#import <LifesenseBluetooth/LSBLEDeviceManager.h>
#import <objc/runtime.h>

typedef enum
{
    MessageSearchingPrompts,
    MessagePairingPrompts,
}MessageType;


typedef enum {
    WorkingStatusFree,
    WorkingStatusSearchDevice,
    WorkingStatusPairDevice,
    WorkingStatusSaveDevice,
}WorkingStatus;

static NSString *kBroadcastAll=@"All";
static NSString *kBroadcastNormal=@"Normal";
static NSString *kBroadcastPair=@"Pair";
static NSString *kSearchingTitle=@"Searching,please wait.";
static NSString *kPairingTitle=@"Pairing,please wait.";
static NSString *KSearchingTips=@"Searching.";

@interface DeviceSynchViewController : BaseViewController<UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,LSBlePairingDelegate,LSBleDataReceiveDelegate>
{
    UIActionSheet *SHEET;
    int selectedIndex;
    UIActionSheet *sheetImages;
}
@property(nonatomic,strong)UserProfileDetails *userProfileObj;
@property (nonatomic ,strong)UIImagePickerController *camerapicker;

@property (strong, nonatomic) IBOutlet UITableView *tblVw;
- (IBAction)btnActionselectProfileImg:(id)sender;
- (IBAction)btnActionBack:(id)sender;
- (IBAction)btnActionScan:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtFldUserNm;
@property(nonatomic,strong)NSString *deviceNm;
@property(nonatomic,strong)UIImage *deviceImg;

@property (nonatomic,strong) LSBLEDeviceManager *BleManager;
@property(nonatomic) WorkingStatus currentWorkingStatus;
@property(nonatomic)BOOL isPairedSuccess;
@property (nonatomic,strong) NSString *deviceID;
@property(nonatomic,strong)NSString *device_status;
@end
