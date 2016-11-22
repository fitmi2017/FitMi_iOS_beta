//
//  DeviceSynchViewController.m
//  FitMe
//
//  Created by Debasish on 10/08/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import "DeviceSynchViewController.h"
#import "ProfileTableViewCell.h"
#import "User.h"
#import "Utility.h"
#import "DeviceSynchFinalViewController.h"
#import "SettingsViewController.h"
#import "Constant.h"
#import "ExerciseLog.h"
#import "WeightLog.h"
#import "BPLog.h"
#import "FoodLog.h"
#import "DeviceLog.h"
#import "AppDelegate.h"
@interface DeviceSynchViewController ()
{
    AppDelegate *mAppDelegate;
    NSMutableArray *deviceArr;
     User *mUser;
    __weak IBOutlet UIButton *btnUserProfileImg;
    __weak IBOutlet UILabel *lblUserNm;
 NSString *selectedUserProfileID;
    NSUserDefaults *user_defaults;
    NSArray *enableScanDeviceTypes;
    ExerciseLog *exerciseLogObj;
    WeightLog *WeightLogObj;
    BPLog *BPLogObj;
    FoodLog *FoodLogObj;
    BOOL isNavigate;
    DeviceLog *DeviceLogObj;
}
@property(nonatomic,strong)NSMutableArray *scanResultsArray;
@property(nonatomic,strong)NSMutableArray *weightDataList;
@property(nonatomic,strong)NSMutableArray *fatDataList;
@property(nonatomic,strong)NSMutableArray *bloodPressureDataList;
@property(nonatomic,strong)NSMutableArray *heightDataList;
@property(nonatomic,strong)NSMutableArray *kitchenDataList;
@property(nonatomic,strong)NSString *deviceStatus;
@end

@implementation DeviceSynchViewController

@synthesize device_status;

#pragma mark - UIView LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mAppDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if([device_status isEqualToString:@"1"])
       _deviceStatus=@"Synced";
    else
        _deviceStatus=@"Preparing for Sync...";
    
    user_defaults = User_Defaults;
    
    selectedUserProfileID=[user_defaults valueForKey:@"selectedUserProfileID"];

    DeviceLogObj=[[DeviceLog alloc]init];
    
   // self.BleManager=[LSBLEDeviceManager defaultLsBleManager];
    self.scanResultsArray = [NSMutableArray new];
    
    self.weightDataList=[[NSMutableArray alloc] init];
    self.fatDataList=[[NSMutableArray alloc] init];
    self.bloodPressureDataList=[[NSMutableArray alloc] init];
    self.heightDataList=[[NSMutableArray alloc] init];
    self.kitchenDataList=[[NSMutableArray alloc] init];
 
    lblUserNm.text=_userProfileObj.full_name;
    UIImage *userImg=[self getImage];
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

    deviceArr = [[NSMutableArray alloc] initWithObjects:@"BloodPressure Monitor",@"Kitchen Scale",nil];
    
    
 /*
    else if([_deviceNm isEqualToString:[deviceArr objectAtIndex:2]])
        enableScanDeviceTypes= @[@8]; //For BloodPressure Monitor*/

    enableScanDeviceTypes=[self getEnableScanDeviceTypes];
   // mUser = [[Utility sharedManager] retriveUserDetailsFromDefault];
    //_txtFldUserNm.text=mUser.userName;

    [self createNavigationView:@"Devices"];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
 //   [self performSelector:@selector(callNextVC) withObject:nil afterDelay:10.0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
     FoodLogObj=[[FoodLog alloc] init];
    APP_CTRL.CurrentControllerObj = self;
    if (APP_CTRL.BleManagerGlobal == NULL) {
        self.BleManager=[LSBLEDeviceManager defaultLsBleManager];
        APP_CTRL.BleManagerGlobal = self.BleManager;
    }else {
        self.BleManager = APP_CTRL.BleManagerGlobal;
    }
    
    isNavigate=NO;
    WeightLogObj=[[WeightLog alloc] init];
    exerciseLogObj=[[ExerciseLog alloc] init];
    BPLogObj=[[BPLog alloc] init];
    [self addNotification];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [self StopSearchDevice];
    
    /* [[NSNotificationCenter defaultCenter] removeObserver:self  name:@"BloodPressure" object:nil];[[NSNotificationCenter defaultCenter] removeObserver:self  name:@"KitchenScale" object:nil];*/
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - addNotification Method
-(void)addNotification
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:@"BloodPressure" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:@"KitchenScale" object:nil];
    

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getBloodPressureData:)
                                                 name:@"BloodPressure"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getKitchenScaleData:)
                                                 name:@"KitchenScale"
                                               object:nil];
  
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
    cell.lblDeviceStatus.text=_deviceStatus;
  
    cell.imgVw.image=_deviceImg;
    cell.imgVw.contentMode = UIViewContentModeScaleAspectFit;
    
    cell.imgVw.layer.borderColor=[[UIColor colorWithRed:194/255.0 green:194/255.0 blue:194/255.0 alpha:1.0] CGColor];
    cell.imgVw.layer.borderWidth=1;
    
    cell.btnArrow.hidden=YES;
    
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

#pragma mark - Image Picker Delegate
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

#pragma mark - "Back" Button Action
- (IBAction)btnActionBack:(id)sender
{
    NSLog(@"%@",self.navigationController.viewControllers);
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - "Scan" Button Action
- (IBAction)btnActionScan:(id)sender
{
     _deviceStatus=@"Syncing...";
    self.currentWorkingStatus=WorkingStatusSearchDevice;
      [self searchBluetoothDevice];
    [_tblVw reloadData];
  }

#pragma mark : Stop Search Device Method
- (void) StopSearchDevice {
    [self.BleManager stopSearch];
}

#pragma mark - Search Bluetooth Device Method
-(void)searchBluetoothDevice
{
    [self.BleManager stopDataReceiveService];
    [self.scanResultsArray removeAllObjects];
    
    NSString *str=@"Scanning Device....";
    NSLog(@"%@",str);
   // _lblDeviceStatus.text = @"Scanning Device....";
    NSLog(@"%@",self.BleManager);
    BroadcastType enableScanBroadcast= BROADCAST_TYPE_ALL;
    [self.BleManager searchLsBleDevice:enableScanDeviceTypes ofBroadcastType:enableScanBroadcast searchCompletion:^(LSDeviceInfo *lsDevice)
     {
         NSLog(@"searchLsBleDevice");
        // _lblResultStatus.text = lsDevice.deviceName;
         self.deviceID = lsDevice.deviceName;
         if(lsDevice)
         {
             NSLog(@"%u",lsDevice.deviceType);
             NSLog(@"searchLsBleDevice==lsDevice");
             if(![self.scanResultsArray containsObject:lsDevice])
             {
                // _lblDeviceStatus.text = @"Pairing Device....";
                 NSString *str=@"Pairing Device....";
                 NSLog(@"%@",str);
                  [self.scanResultsArray addObject:lsDevice];
                [self StopSearchDevice];
                 
                 if(lsDevice.deviceType==LS_KITCHEN_SCALE)
                 {
                 [self.BleManager addMeasureDevice:lsDevice];
                 [self.BleManager startDataReceiveService:self];
                 }
                 else
                 {
                 [self.BleManager pairWithLsDeviceInfo:lsDevice pairedDelegate:self];
                 self.currentWorkingStatus=WorkingStatusPairDevice;
                 }
             }
         }
     }];
}

#pragma mark - getEnableScanDeviceTypes Method
-(NSArray *)getEnableScanDeviceTypes
{
    NSMutableArray *enableTypes=[[NSMutableArray alloc] init];
    
    [enableTypes addObject:@(LS_SPHYGMOMETER)];

    [enableTypes addObject:@(LS_HEIGHT_MIRIAM)];
    [enableTypes addObject:@(LS_KITCHEN_SCALE)];


    //LS_SPHYGMOMETER=8, LS_FAT_SCALE=2, LS_HEIGHT_MIRIAM=3, LS_KITCHEN_SCALE=9
    
      NSLog(@"enable scan device type %@",enableTypes);
    return enableTypes;
}

#pragma mark - LSBlePairing Delegate
-(void)bleManagerDidDiscoverUserList:(NSDictionary *)userlist
{
    NSLog(@"=====bleManagerDidDiscoverUserList=====");

    //_lblResultStatus.text = [NSString stringWithFormat:@"UserList : %@",userlist];
    NSString *str=[NSString stringWithFormat:@"UserList : %@",userlist];
    NSLog(@"%@",str);
    
    NSUInteger maxUserNumber=[userlist count];
    NSString *userName=nil;
    NSString *title=nil;
    NSString *key=nil;

    for(int i=1;i<=maxUserNumber;i++)
    {
        key=[NSString stringWithFormat:@"%@",@(i)];
        userName=[userlist objectForKey:@(i)];
        title=[NSString stringWithFormat:@"P%@ : %@",key,userName];
        NSLog(@"key=%@,userName=%@,title=%@",key,userName,title);
        if(userName.length==0)
        {
            userName=@"unknown";
        }
    }

    if(self.currentWorkingStatus==WorkingStatusPairDevice)
    {
        NSLog(@"=====bindingDeviceUsers=====%ld",maxUserNumber);
        NSLog(@"userName=%@,maxUserNumber=%ld",userName,maxUserNumber);
        [self.BleManager bindingDeviceUsers:maxUserNumber userName:userName];
    }
}

-(void)bleManagerDidPairedResults:(LSDeviceInfo *)lsDevice pairStatus:(int)pairStatus
{
//    NSLog(@"%u",lsDevice.deviceType);
//    NSLog(@"%d",pairStatus);
    if(lsDevice && pairStatus==1)
    {
        self.isPairedSuccess=true;
       // _lblResultStatus.text =  [NSString stringWithFormat:@"!!!! SUCCESSFULLY PAIRED With Device : %@!!!!",lsDevice.deviceName];
        NSString *str= [NSString stringWithFormat:@"!!!! SUCCESSFULLY PAIRED With Device : %@!!!!",lsDevice.deviceName];
        NSLog(@"%@",str);
        [self.BleManager addMeasureDevice:lsDevice];
        [self.BleManager startDataReceiveService:self];
    }
    else
    {
        self.isPairedSuccess=false;
       // _lblResultStatus.text = @"!!!! FAILED TO PAIRED !!!!";
        NSString *str=@"!!!! FAILED TO PAIRED !!!!";
        NSLog(@"%@",str);
 
      }
}

#pragma mark - LSBleDatareceive Delegate
-(void)bleManagerDidConnectStateChange:(DeviceConnectState)connectState deviceName:(NSString *)deviceName
{
   // _lblResultStatus.text =[NSString stringWithFormat:@"UI device connect state change %d",connectState];
    NSString *str=[NSString stringWithFormat:@"UI device connect state change %d",connectState];
    NSLog(@"%@",str);
}

-(void)bleManagerDidDiscoveredDeviceInfo:(LSDeviceInfo *)deviceInfo
{
    if(!deviceInfo)
    {
        return ;
    }
   
   // NSLog(@"%@",str);
}




-(void)bleManagerDidReceiveSphygmometerMeasuredData:(LSSphygmometerData *)data
{
    NSLog(@"=====bleManagerDidReceiveSphygmometerMeasuredData=====");
    if (data)
    {
        [self.bloodPressureDataList addObject:data];
        NSLog(@"Sys : %ld",(long)data.systolic);
        NSLog(@"Dia : %ld",(long)data.diastolic);
        NSLog(@"Pulse : %ld",(long)data.pluseRate);
        
        NSMutableDictionary * dict =[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)data.systolic], @"systolic", [NSString stringWithFormat:@"%ld",(long)data.diastolic], @"diastolic",[NSString stringWithFormat:@"%ld",(long)data.pluseRate], @"pluseRate", nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BloodPressure" object:self userInfo:dict];

    }
}

-(void)bleManagerDidReceiveKitchenScaleMeasuredData:(LSKitchenScaleData *)kitchenData
{
    NSLog(@"--------------bleManagerDidReceiveKitchenScaleMeasuredData");
   // NSLog(@"--------------bleManagerDidReceiveKitchenScaleMeasuredData===%f====%ld===%ld====%@===%ld====%@====%@",kitchenData.weight,(long)kitchenData.sectionWeight,(long)kitchenData.time,kitchenData.unit,(long)kitchenData.battery,kitchenData.deviceName,kitchenData.deviceId);
    if(kitchenData)
    {
        NSString *value=nil;
        
        if([kitchenData.unit isEqualToString:@"LB OZ"])
        {
            float LBVal=kitchenData.sectionWeight;
            float OZVal=kitchenData.weight;
            float TotalValOZ=(LBVal*16)+OZVal;
            NSLog(@"LBVal=%f,OZVal=%f",LBVal,OZVal);
            float TotalVal=(TotalValOZ*28.3495);
        //   value=[NSString stringWithFormat:@"%ld:%f",(long)kitchenData.sectionWeight,kitchenData.weight];
            value=[NSString stringWithFormat:@"%.1f",TotalVal];
        }
        else
        {
            value=[NSString stringWithFormat:@"%.1f",kitchenData.weight];
        }
        NSLog(@"KITCHENSCALE=%@",value);
        
      //  if(kitchenData.weight!=0.000000){
            NSMutableDictionary * dict =[NSMutableDictionary dictionaryWithObjectsAndKeys:value, @"foodWeight",nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"KitchenScale" object:self userInfo:dict];
        // }
    }
    else
    {
        NSLog(@"Error,failed to get kitchen scale measured data");
    }
}

- (void)getBloodPressureData:(NSNotification *) notification
{
     [DeviceLogObj updateDeviceData:[deviceArr objectAtIndex:2] withStatusVal:@"1" withLogDate:@"" withUserProfileID:selectedUserProfileID];
    
    NSString *systolicVal=[[notification userInfo] valueForKey:@"systolic"];
    NSString *diastolicVal=[[notification userInfo] valueForKey:@"diastolic"];
    NSString *pluseRateVal=[[notification userInfo] valueForKey:@"pluseRate"];
    NSLog(@"systolicVal=%@,\ndiastolicVal=%@,\npluseRateVal=%@",systolicVal,diastolicVal,pluseRateVal);
    
    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
    NSString *logTimeStr= [dateFormatter2 stringFromDate:[NSDate date]];

    UserProfile *userProfileObj=[[UserProfile alloc]init];
    NSMutableArray *user_profile_Arr=[NSMutableArray new];
    user_profile_Arr=[userProfileObj getAllProfileID];
    
    if([user_profile_Arr count] >0){
        
        BPLogObj=[[BPLog alloc] init];
        BPLogObj.log_user_id=[user_defaults objectForKey:@"user_id"];
        BPLogObj.log_user_profile_id=selectedUserProfileID;
        BPLogObj.sysVal=systolicVal;
        BPLogObj.diaVal=diastolicVal;
        BPLogObj.pulseVal=pluseRateVal;
        BPLogObj.log_date_added=[self getCurrentDateTime];
        BPLogObj.log_log_time=[NSString stringWithFormat:@"%@ %@",logTimeStr,[self getCurrentTime]];
        NSLog(@"exerciseLogObj.log_log_time%@",BPLogObj.log_log_time);
        [BPLogObj saveUserBPDataLog];
    }
    if(!isNavigate)
    {
        _deviceStatus=@"Synced";
        [_tblVw reloadData];

        isNavigate=YES;
      [self performSelector:@selector(callNextVC) withObject:nil afterDelay:1.0];
    }

}

- (void)getKitchenScaleData:(NSNotification *) notification
{
    NSLog(@"mAppDelegate.selectedFoodDict==%@",mAppDelegate.selectedFoodDict);
    
    NSString *foodWeightVal=[[notification userInfo] valueForKey:@"foodWeight"];
    NSLog(@"foodWeightVal=%@",foodWeightVal);
    NSLog(@"TOTALWEIGHT==%@",mAppDelegate.prevTotWeight);
      if(![foodWeightVal isEqualToString:@"0.0"])
    {
        NSLog(@"if");
        float finalCal=0.0;
        float finalWeight=0.0;
        if([[mAppDelegate.selectedFoodDict objectForKey:@"item_weight"] isEqualToString:@"0"])
        {
            finalCal=[[mAppDelegate.selectedFoodDict objectForKey:@"cals"] floatValue];
            finalWeight=[foodWeightVal floatValue];
            if(finalWeight!=0.0)
            {
            // finalCal=[foodWeightVal floatValue]*[[mAppDelegate.selectedFoodDict objectForKey:@"gm_cal"] floatValue];
            //  finalCal=[[mAppDelegate.selectedFoodDict objectForKey:@"cals"] floatValue]+finalCal;
             /*   if([mAppDelegate.prevTotWeight floatValue]<[foodWeightVal floatValue])
                {
                    finalWeight=[foodWeightVal floatValue]-[mAppDelegate.prevTotWeight floatValue];
                }
                else
                {
                    finalWeight=[[mAppDelegate.selectedFoodDict objectForKey:@"item_weight"] floatValue]+[foodWeightVal floatValue];
                    //changed on 22 Feb,2016
                    finalWeight=[foodWeightVal floatValue];
                }*/
                
                 finalWeight=[foodWeightVal floatValue]-[mAppDelegate.prevTotWeight floatValue];
                if(finalWeight<0.0 || finalWeight==1.0 || finalWeight==2.0)
                    finalWeight=0.0;
                
                if ([[mAppDelegate.selectedFoodDict  allKeys] containsObject:@"gm_cal"])
                {
                finalCal=finalWeight*[[mAppDelegate.selectedFoodDict objectForKey:@"gm_cal"] floatValue];
                }
               else if ([[mAppDelegate.selectedFoodDict  allKeys] containsObject:@"gm_calorie"])
                {
                finalCal=finalWeight*[[mAppDelegate.selectedFoodDict objectForKey:@"gm_calorie"] floatValue];
                }

               // finalCal=[[mAppDelegate.selectedFoodDict objectForKey:@"cals"] floatValue]+finalCal;
                
            }
            NSLog(@"finalCal0=%f---finalWeight0=%f",finalCal,finalWeight);
        }
        else
        {
           // float clpergm=[[mAppDelegate.selectedFoodDict objectForKey:@"cals"] floatValue]/[[mAppDelegate.selectedFoodDict objectForKey:@"item_weight"] floatValue];
           
           /* if([mAppDelegate.prevTotWeight floatValue]<[foodWeightVal floatValue])
            {
                finalWeight=[foodWeightVal floatValue]-[mAppDelegate.prevTotWeight floatValue];
            }
            else
            {
                finalWeight=[[mAppDelegate.selectedFoodDict objectForKey:@"item_weight"] floatValue]+[foodWeightVal floatValue];
                //changed on 22 Feb,2016
                finalWeight=[foodWeightVal floatValue];
            }*/
            
            finalWeight=[foodWeightVal floatValue]-[mAppDelegate.prevTotWeight floatValue];
            if(finalWeight<0.0 || finalWeight==1.0 || finalWeight==2.0)
                finalWeight=0.0;

            if ([[mAppDelegate.selectedFoodDict  allKeys] containsObject:@"gm_cal"])
            {
                finalCal=finalWeight*[[mAppDelegate.selectedFoodDict objectForKey:@"gm_cal"] floatValue];
            }
            else if ([[mAppDelegate.selectedFoodDict  allKeys] containsObject:@"gm_calorie"])
            {
                finalCal=finalWeight*[[mAppDelegate.selectedFoodDict objectForKey:@"gm_calorie"] floatValue];
            }

           // finalCal=[[mAppDelegate.selectedFoodDict objectForKey:@"cals"] floatValue]+finalCal;
            NSLog(@"finalCal1=%f===finalWeight1=%f",finalCal,finalWeight);
         }
        
       NSString *finalCalStr=[NSString stringWithFormat:@"%.1f",finalCal];
       
       NSString *finalWeightStr=[NSString stringWithFormat:@"%.1f",finalWeight];
        
        NSLog(@"finalCalStr==%@---finalWeightStr=%@",finalCalStr,finalWeightStr);
        
        /*NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
        NSString *logTimeStr= [dateFormatter2 stringFromDate:[NSDate date]];
        
        UserProfile *userProfileObj=[[UserProfile alloc]init];
        NSMutableArray *user_profile_Arr=[NSMutableArray new];
        user_profile_Arr=[userProfileObj getAllProfileID];*/
        
        NSLog(@"mAppDelegate.selectedFoodDict=%@",mAppDelegate.selectedFoodDict);
       // if([user_profile_Arr count] >0)
       // {
        
        //@synchronized(self)
       // {
          [FoodLogObj updateGramLog:finalCalStr withWeight:finalWeightStr withDate:@"" foodID:[mAppDelegate.selectedFoodDict  objectForKey:@"id"] withUserProfileID:selectedUserProfileID];
      //  }
            NSMutableDictionary * dict =[NSMutableDictionary dictionaryWithObjectsAndKeys:foodWeightVal, @"foodWeight",nil];

       [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateFoodScale" object:self userInfo:dict];
     //  }
    }
    else
    {
        NSLog(@"else0");
        //@synchronized(self)
        //{

        [FoodLogObj updateGramLog:@"0" withWeight:@"0" withDate:@"" foodID:[mAppDelegate.selectedFoodDict  objectForKey:@"id"] withUserProfileID:selectedUserProfileID];
       // }
        NSMutableDictionary * dict =[NSMutableDictionary dictionaryWithObjectsAndKeys:foodWeightVal, @"foodWeight",nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateFoodScale" object:self userInfo:dict];

    }
    
    if(!isNavigate)
    {
        if([_deviceNm isEqualToString:@"Kitchen Scale"])
        {
            [DeviceLogObj updateDeviceData:[deviceArr objectAtIndex:3] withStatusVal:@"1" withLogDate:@"" withUserProfileID:selectedUserProfileID];

        _deviceStatus=@"Synced";
        [_tblVw reloadData];

        isNavigate=YES;
       [self performSelector:@selector(callNextVC) withObject:nil afterDelay:1.0];
        }
    }

}

#pragma mark - callNextVC Method
-(void)callNextVC
{
    DeviceSynchFinalViewController *mVerificationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DeviceSynchFinalViewController"];
    mVerificationViewController.userProfileObj=_userProfileObj;
    mVerificationViewController.deviceNm=_deviceNm;
    mVerificationViewController.deviceImg=_deviceImg;
    [self.navigationController pushViewController:mVerificationViewController animated:YES];
}

@end
