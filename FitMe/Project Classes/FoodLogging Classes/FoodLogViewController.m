//
//  FoodLogViewController.m
//  FitMe
//
//  Created by Debasish on 12/08/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import "FoodLogViewController.h"
#import "FoodLogTableViewCell.h"
#import "DateUpperCustomView.h"
#import "NIDropDown.h"
#import "QuartzCore/QuartzCore.h"
#import "ExerciseLog.h"
#import "SettingsViewController.h"
#import "MasterFood.h"
#import "UserCalDetails.h"
#import <AVFoundation/AVFoundation.h>
#import "CalorieIntakeViewController.h"
#import "UnitsLog.h"
#import "AppDelegate.h"
#import "headerViewFoodlog.h"
#import "FavFoodMealTableViewCell.h"
#import "FavMealLog.h"
#import "FavFoodLog.h"
#import "DeviceLog.h"
#import "ProfileViewController.h"

#define SEARCH_TABLE_TAG 101
#define RECENT_TABLE_TAG 200
#define MYMEAL_TABLE_TAG 501
#define MEALSUBCATEGORY_TABLE_TAG 2
#define FAV_MEALSUBCAT_TABLE_TAG 3
#define FAV_MEALDROPDOWN_TABLE_TAG 301
#define SCREEN_WEIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)-60
#define KEYBOARD_TRIGGER_VELOCITY SCREEN_HEIGHT

@interface FoodLogViewController ()
{
    int FavFoodVCount,RecentFavFoodVCount;
    __weak IBOutlet UIImageView *arrowImageView;
    
    AppDelegate *mAppDelegate;
    NSString *selectedFoodWeight,*selectedFoodScaleWeightUnit;
    __weak IBOutlet UITableView *myMealTable;
    
    NSString *selectedRecentFav,*navTitle;
    NSString *selectedId;
    UIButton *btnDropDown;
    
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;
    
    UIView *_highlightView;
    int selectedTableTag,selectedButton;
    
    Devicefamily family;
    int  totalCalToShow;
    __weak IBOutlet NSLayoutConstraint *totalViewBottomConstant;
    __weak IBOutlet UICollectionView *sessionCollectionView;
    __weak IBOutlet UIView *myMealLbl;
    NSMutableArray *selectedRecentFoodArray;
    __weak IBOutlet UITableView *recentFoodTableView;
    FoodLog *foodLogObject;
    FavFoodLog *favFoodLogObj;
    FavMealLog *favMealLogObj;
    
    MealType *mealTypeObj;
    DeviceLog *DeviceLogObj;
    
    NSInteger selectedItemRecent,selectedItemFav,selectedItem;
    BOOL selectedRecentFood,saveRecentFood;
    
    __weak IBOutlet UIButton *_btnBarCode;
    
    __weak IBOutlet UIButton *btn_recentFood;
    __weak IBOutlet UIButton *btn_recentMeal;
    
    __weak IBOutlet UIView *buttonView;
    __weak IBOutlet NSLayoutConstraint *sessionCollectionViewHeight;
    
    __weak IBOutlet NSLayoutConstraint *recentMealViewTopConstant;
    __weak IBOutlet UITextField *autoCompleteTextField;
    DateUpperCustomView* mDateUpperCustomView;
    NSMutableArray *arrDropDownTopTxt,*arrDropDownTxtFood,*arrDropDownTypeActivity,*arrDropDownImgFood,*arrDropDownImgActivity,*arrFoodVa,*arrDropDownTxtActivity;
    
    NSInteger selectedIndexPathNormal,selectedIndexPathNormalPrev,selectedIndexPathRecent,selectedIndexPathRecentPrev,selectedIndexPathSearch,selectedIndexPathFav,selectedIndexPathFavPrev,selectedIndexPathDropDownMealPrev,selectedIndexPathDropDownMeal;
    
    FoodLogPopUPViewController *foodPopupcontroller;
    
    BOOL popupShown,goBack;
    __weak IBOutlet UITableView *autoCompleteTableView;
    __weak IBOutlet UISearchBar *autoCompleteSearchbar;
    
    __weak IBOutlet UILabel *sessionName;
    int totalCal;
    
    __weak IBOutlet UIView *logView;
    __weak IBOutlet NSLayoutConstraint *logViewBottomConstant;
    
    
    NSString *strVal,*breakfastId,*lunchId,*dinnerId,*snackId,*selectedDropdown;
    BOOL searching;
    NSMutableArray *allFoodLogArr;
    NSMutableArray *myMealArr,*myMealSecTitleArr,*myMealCalTotalArr;
    NSMutableArray *favMealArr,*favMealSecTitleArr,*favMealTitleArr;
    NSString *favMealTitleStr;
    
    NSUserDefaults *defaults;
    NSString *selectedUserProfileID;
    __weak IBOutlet NSLayoutConstraint *logViewHeight;
    
    __weak IBOutlet UIButton *logBtn;
    NSString *foodIdToEdit;
    NSMutableArray *primarySelectedArray;
    BOOL isDelete;
    __weak IBOutlet UIView *recentFoodView;
    UISwipeGestureRecognizer *swipeFood,*swipeMeal;
    UITapGestureRecognizer *tapFood,*tapMeal;
    
    NSString *weightliftId,*boxingId,*jumpingId,*swimmingId,*walkingId,*gymnasticsId;
    BOOL isConnection;
    ExerciseLog *exerciseLogObj;
    
    __weak IBOutlet UIView *sessionView;
    NSMutableArray *arrAllExercise;
    
    __weak IBOutlet UIView *snackImg;
    __weak IBOutlet UIView *breakfastImg;
    __weak IBOutlet UIView *lunchImg;
    __weak IBOutlet UIView *dinnerImg;
    NSString *selectedFavMealTypeId,*sessionNm,*selectedMyMealType;
    
    MasterFood *masterFoodObj;
    NSMutableArray *deviceStatusArr;
    int totalCalMealSub;
}
@property(nonatomic,strong)NSMutableArray *_selectedFoodArr;
@property(nonatomic,assign)int myMealTotalCal;
@property(nonatomic,strong)NSString *logTimeStr;
@property (nonatomic,assign) BOOL isDeviceOn;
@property (nonatomic,strong) NSTimer *timerDeviceStatusCheck;
@property(nonatomic,strong)NSMutableAttributedString *LightAttrStringOZ,*LightAttrStringGM,*LightAttrStringCAL;
@property(nonatomic,strong)NSDictionary *attributedTotDict;
@end

@implementation FoodLogViewController
@synthesize sessionArray=sessionArray;
@synthesize _selectedFoodArr=_selectedFoodArr;
@synthesize logTimeStr=logTimeStr;

#pragma mark - UIView LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    selectedIndexPathNormal=-100000;
    UIFont *LightFont = [UIFont fontWithName:@"SinkinSans-300Light" size:15];
    NSDictionary *LightDict = [NSDictionary dictionaryWithObject:LightFont forKey:NSFontAttributeName];
    _LightAttrStringOZ = [[NSMutableAttributedString alloc]initWithString:@" oz"  attributes:LightDict];
    _LightAttrStringGM = [[NSMutableAttributedString alloc]initWithString:@" g"  attributes:LightDict];
    _LightAttrStringCAL = [[NSMutableAttributedString alloc]initWithString:@" cal"  attributes:LightDict];
    
    UIFont *mediumFont = [UIFont fontWithName:@"SinkinSans-400regular" size:30];
    _attributedTotDict = [NSDictionary dictionaryWithObject: mediumFont forKey:NSFontAttributeName];

    _isBarCodeScanOpen=NO;
    _isSelectedFoodScaleItem=NO;
    sessionArray=[[NSMutableArray alloc] initWithObjects:@"Food",@"Meal",@"img", nil];
    [_btnMTotal.layer setBorderColor:[[UIColor colorWithRed:157.0/255.0f green:172.0/255.0f blue:189.0/255.0f alpha:1.0f] CGColor]];
    [[_btnMTotal layer] setBorderWidth:1.0f];
    
    [_btnTTotal.layer setBorderColor:[[UIColor colorWithRed:157.0/255.0f green:172.0/255.0f blue:189.0/255.0f alpha:1.0f] CGColor]];
    [[_btnTTotal layer] setBorderWidth:1.0f];
    
    [self getTotalWeight];
    
    mAppDelegate=App_Delegate_Instance;
    
    dropdown_imgBtnWidth_Constant.constant=[UIScreen mainScreen].bounds.size.width/3;
    breakfastImg.layer.cornerRadius =breakfastImg.bounds.size.width/2;
    breakfastImg.layer.masksToBounds=YES;
    lunchImg.layer.masksToBounds=YES;
    dinnerImg.layer.masksToBounds=YES;
    snackImg.layer.masksToBounds=YES;
    lunchImg.layer.cornerRadius =breakfastImg.bounds.size.width/2;
    dinnerImg.layer.cornerRadius =breakfastImg.bounds.size.width/2;
    snackImg.layer.cornerRadius =breakfastImg.bounds.size.width/2;
    
    UITapGestureRecognizer *recognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [recognizer1 setNumberOfTapsRequired:1];
    [sessionView addGestureRecognizer:recognizer1];
    
    totalCalToShow=0;
    _recentFoodArray=[NSMutableArray array];
    foodLogObject=[[FoodLog alloc] init];
    mealTypeObj=[[MealType alloc]init];
    goBack=0;
    
    isDelete=0;
    
    //goBack=1;
    [self updateSelectedIndexPath];
    
    exerciseLogObj=[[ExerciseLog alloc]init];
    
    masterFoodObj=[[MasterFood alloc]init];
    
    favFoodLogObj=[[FavFoodLog alloc]init];
    favMealLogObj=[[FavMealLog alloc]init];
    DeviceLogObj=[[DeviceLog alloc]init];
    
    defaults=[NSUserDefaults standardUserDefaults];
    selectedUserProfileID=[defaults valueForKey:@"selectedUserProfileID"];
    
    if([self.logTime isEqualToString:@" " ] || self.logTime ==nil || self.logTime.length==0)
    {
        //logTimeStr = [[Utility sharedManager] getSelectedDateFormat];
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        formatter1.dateFormat = @"EEEE, MMMM dd, yyyy";
        NSDate *dateFromString = [formatter1 dateFromString:[[Utility sharedManager] getSelectedDate]];
        NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
        logTimeStr= [dateFormatter2 stringFromDate:dateFromString];
    }
    else
        logTimeStr=self.logTime;
    
    if([self.previous_activity isEqualToString:@"FromPlanner"])
    {
        [mDateUpperCustomView.btnDate_Home setTitle:logTimeStr forState:UIControlStateNormal];
        if(logTimeStr)
            mDateUpperCustomView.logTimeStr=logTimeStr;
    }
    
    else if ([self.previous_activity isEqualToString:@"NotificationTapped"]){
        
        NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
        NSDate *dateFromString = [dateFormatter2 dateFromString:self.logTime];
        
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        formatter1.dateFormat = @"EEEE, MMMM dd, yyyy";
        
        logTimeStr= [formatter1 stringFromDate:dateFromString];
        [mDateUpperCustomView.btnDate_Home setTitle:logTimeStr forState:UIControlStateNormal];
        if(logTimeStr)
            mDateUpperCustomView.logTimeStr=logTimeStr;
        
    }
    ///////////////// 10-2-16 /////////////////////////////
    _selectedFoodArr=[NSMutableArray new];
    // _recentSelectedFoodArr=[NSMutableArray new];
    
    CGFloat f1;
    if([self.previous_activity isEqualToString:@"FromPlanner"]||[self.previous_activity isEqualToString:@"newPlanner"])
    {
        if(family==iPad){
            f1=[[UIScreen mainScreen] bounds].size.height-260;
            //f1=700;
            totalViewBottomConstant.constant=0;
        }
        else{
            f1=[[UIScreen mainScreen] bounds].size.height-(204-28);
            totalViewBottomConstant.constant=15;
        }
        [self.view bringSubviewToFront:logView ];
    }
    else{
        
        if(family==iPad){
            f1=[[UIScreen mainScreen] bounds].size.height-260;
            totalViewBottomConstant.constant=0;
        }
        else{
            f1=[[UIScreen mainScreen] bounds].size.height-140;
            totalViewBottomConstant.constant=18;
        }
    }
    /*   recentMealViewTopConstant.constant=f1;
     UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHideRecentfoodView:)];
     [recognizer setNumberOfTapsRequired:1];
     
     [myMealLbl addGestureRecognizer:recognizer];
     
     //add gesture on all table view to detect tap.
     UITapGestureRecognizer *taprecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetect:)];
     [taprecognizer setNumberOfTapsRequired:1];
     [self.tblVw addGestureRecognizer:taprecognizer];
     
     UITapGestureRecognizer *taprecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetect:)];
     [taprecognizer1 setNumberOfTapsRequired:1];
     [autoCompleteTableView addGestureRecognizer:taprecognizer1];
     
     UITapGestureRecognizer *taprecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetect:)];
     [taprecognizer2 setNumberOfTapsRequired:1];
     [recentFoodTableView addGestureRecognizer:taprecognizer2];
     
     //ADD Swipe Gesture on RecentFood & Recent Meal Button
     swipeFood= [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(RecentSwipe:)];
     [swipeFood setDirection: UISwipeGestureRecognizerDirectionUp];
     //[btn_recentFood addGestureRecognizer:swipeFood];
     [recentFoodView addGestureRecognizer:swipeFood];
     [swipeFood delaysTouchesEnded];*/
    
    //Code added on 31 Dec
    recentFoodView.translatesAutoresizingMaskIntoConstraints=YES;
    // recentMealViewTopConstant.constant=f1;
    recentFoodView.frame=CGRectMake(0, f1+52, SCREEN_WEIDTH, SCREEN_HEIGHT-(140));
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHideRecentfoodView:)];
    [recognizer setNumberOfTapsRequired:1];
    
    [myMealLbl addGestureRecognizer:recognizer];
    
    //add gesture on all table view to detect tap.
    UITapGestureRecognizer *taprecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetect:)];
    [taprecognizer setNumberOfTapsRequired:1];
    [self.tblVw addGestureRecognizer:taprecognizer];
    
    UITapGestureRecognizer *taprecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetect:)];
    [taprecognizer1 setNumberOfTapsRequired:1];
    [autoCompleteTableView addGestureRecognizer:taprecognizer1];
    
    UITapGestureRecognizer *taprecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetect:)];
    [taprecognizer2 setNumberOfTapsRequired:1];
    [recentFoodTableView addGestureRecognizer:taprecognizer2];
    
    //ADD Swipe Gesture on RecentFood & Recent Meal Button
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(RecentSwipe:)];
    [recentFoodView addGestureRecognizer:pan];
    //Code added on 31 Dec
    
    //swipeMeal = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(MealSwipe:)];
    // [swipeMeal setDirection:UISwipeGestureRecognizerDirectionUp];
    // [btn_recentMeal addGestureRecognizer:swipeMeal];
    //[swipeMeal delaysTouchesEnded];
    
    _selectedFoodDictArr=[NSMutableArray array];
    
    _connectType=@"";
    
    UITapGestureRecognizer *taprecognizerKeyBoard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetectKeyBoard:)];
    [taprecognizerKeyBoard setNumberOfTapsRequired:1];

}

//---SUDIPTA----
- (void)SetDiviceStatusOFF{
    _isDeviceOn = FALSE;
     _isKitchenScaleSync=NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
     selectedIndexPathNormal=-100000;
    mAppDelegate=App_Delegate_Instance;
    mAppDelegate.prevTotWeight=@"0";
    mAppDelegate.prevTotWeight=[self calculateTotalWeightVal];
    _isKitchenScaleSync=NO;
    selectedMyMealType=@"";
    selectedRecentFav=@"Recent";
    FavFoodVCount=0;
    //----SUDIPTA-------
_timerDeviceStatusCheck = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(SetDiviceStatusOFF) userInfo:nil repeats:YES];

    selectedItemRecent=0,selectedItemFav=0,selectedItem=0;
    
    if (APP_CTRL.BleManagerGlobal == NULL)
    {
        [DeviceLogObj updateDeviceData:@"Kitchen Scale" withStatusVal:@"0" withLogDate:@"" withUserProfileID:selectedUserProfileID];
    }
    
    deviceStatusArr=[DeviceLogObj getAllDeviceDataLog:@"" withUserProfileID:selectedUserProfileID];
    NSLog(@"deviceStatusArr=%@",deviceStatusArr);
    
   if(APP_CTRL.isShowDevice)
   {
    if(APP_CTRL.isFirstLaunch==FALSE)
    {
        APP_CTRL.isFirstLaunch=TRUE;
    if(deviceStatusArr.count>0)
    {
        if([[[deviceStatusArr objectAtIndex:2 ]objectForKey:@"device_status"] isEqualToString:@"0"])
        {
          UIAlertView  *myAlert = [[UIAlertView alloc]initWithTitle:@"Measupro"
                                                message:@"Kindly Sync the Kitchen Scale Device"
                                               delegate:self
                                      cancelButtonTitle:@"Later"
                                      otherButtonTitles:@"Sync Now",nil];
            myAlert.delegate=self;
            myAlert.tag=10;
            [myAlert show];

        }
    }
    else
    {
        UIAlertView  *myAlert = [[UIAlertView alloc]initWithTitle:@"Measupro"
                                                          message:@"Kindly Sync the Kitchen Scale Device"
                                                         delegate:self
                                                cancelButtonTitle:@"Later"
                                                otherButtonTitles:@"Sync Now",nil];
        myAlert.delegate=self;
        myAlert.tag=10;
        [myAlert show];
 
    }
    }
   }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateFoodScaleData:)
                                                 name:@"UpdateFoodScale"
                                               object:nil];
    
    if(!_isBarCodeScanOpen)
    {
        UnitsLog *unitsLogObj;
        unitsLogObj=[[UnitsLog alloc]init];
        
        NSMutableArray *arrUnitsLog=[unitsLogObj getAllUnitDataLog:[defaults valueForKey:@"selectedUserProfileID"]];
        
        if(arrUnitsLog.count>0)
        {
            for(int i=0;i<arrUnitsLog.count;i++)
            {
                NSDictionary *dict=[arrUnitsLog objectAtIndex:i];
                if([[dict objectForKey:@"type"] isEqualToString:@"food_weight"])
                {
                    selectedFoodWeight=[unitsLogObj getUnitType:[dict objectForKey:@"unit_id"] withUnitCategory:@"food_weight"];
                    selectedFoodScaleWeightUnit=selectedFoodWeight;
                }
            }
        }
        else
        {
            selectedFoodWeight=@"gm";
            selectedFoodScaleWeightUnit=selectedFoodWeight;
        }
        
        logBtn.userInteractionEnabled=false;
        defaults=[NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:@"isFoodNavigate"];
        [defaults synchronize];
        
        selectedDropdown=@"";
        // [self createNavigationView:@"Food Logging"];
        
        primarySelectedArray=[NSMutableArray new];
        arrAllExercise=[[NSMutableArray alloc]init];
        
        if(self.selected_session != nil )
        {
            sessionNm=[NSString stringWithFormat:@"My %@",self.selected_session ];
            sessionName.text=[NSString stringWithFormat:@"My %@",self.selected_session ];
            [self createNavigationView:self.selected_session];
            navTitle=self.selected_session;
        }
        else
        {
            sessionNm=@"My Meal";
            sessionName.text=@"My Meal";
            [self createNavigationView:@"My Meal"];
            navTitle=@"My Meal";
        }
        
        
        if([self.previous_activity isEqualToString:@"FromPlanner"] || [self.previous_activity isEqualToString:@"newPlanner"])
        {
            if(family==iPad){
                logViewHeight.constant=60;
                [self.view bringSubviewToFront:logView];
                
            }
            else
                logViewHeight.constant=39;
            
            logBtn.hidden=NO;
            _bottomRecentTblVwConst.constant=40;
        }
        else
        {
            logViewHeight.constant=0;
            logBtn.hidden=YES;
            _bottomRecentTblVwConst.constant=0;
            
        }
        
        totalCal=0;
        NSArray * allTheViewsInMyNIB = [[NSBundle mainBundle] loadNibNamed:@"DateUpperCustomView" owner:self options:nil];
        mDateUpperCustomView = allTheViewsInMyNIB[0];
        mDateUpperCustomView.frame = CGRectMake(0,0,self.view.frame.size.width,184);
        [self.view addSubview:mDateUpperCustomView];
        mDateUpperCustomView.delegate=self;
        [mDateUpperCustomView.btnDate_Home setSelected:YES];
        [mDateUpperCustomView click_dateButton:nil];
        
        
        if([self.logTime isEqualToString:@" " ] || self.logTime ==nil || self.logTime.length==0)
        {
            //logTimeStr = [[Utility sharedManager] getSelectedDateFormat];
            NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
            formatter1.dateFormat = @"EEEE, MMMM dd, yyyy";
            NSDate *dateFromString = [formatter1 dateFromString:[[Utility sharedManager] getSelectedDate]];
            NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc] init];
            [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
            logTimeStr= [dateFormatter2 stringFromDate:dateFromString];
        }
        else
            logTimeStr=self.logTime;
        
        if([self.previous_activity isEqualToString:@"FromPlanner"])
        {
            
            [mDateUpperCustomView.btnDate_Home setTitle:logTimeStr forState:UIControlStateNormal];
            if(logTimeStr)
                mDateUpperCustomView.logTimeStr=logTimeStr;
        }
        
        if([_selectedFoodArr count]==0)
            [_tblVw setHidden:YES];
        else
        {
            mymealView.hidden=YES;
            FavFoodVCount=0;
            _tblVw.tag=MEALSUBCATEGORY_TABLE_TAG;
            _tblVw.delegate=self;
            _tblVw.dataSource=self;
            _tblVw.hidden=NO;
            [_tblVw reloadData];
            
            //[self performSelector:@selector(selfCalculateTotalSubCategoryMeal) withObject:nil afterDelay:3.0];
            
        }
        
        if([self.previous_activity isEqualToString:@"newPlanner"])
        {
            /* [mymealView setHidden:NO];
             [self createMyMealArr];
             NSLog(@"myMealArr==%@",myMealArr);
             NSLog(@"myMealSecTitleArr==%@",myMealSecTitleArr);
             
             myMealTable.delegate=self;
             myMealTable.dataSource=self;
             myMealTable.hidden=NO;
             [myMealTable reloadData];*/
            
            mymealView.hidden=YES;
            [self getTotalCal];
            
            [self createNavigationView:@"Planner"];
            navTitle=@"Planner";
            
        }
        else if([self.previous_activity isEqualToString:@"RadialTapp"] || [self.previous_activity isEqualToString:@"FromPlanner"] || [self.previous_activity isEqualToString:@"NotificationTapped"])
        {
            mymealView.hidden=YES;
            NSMutableArray *allMealArr=[NSMutableArray array];
            allMealArr=[mealTypeObj findAllMealType];
            for(NSDictionary *dict in allMealArr)
            {
                if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"breakfast"])
                    breakfastId=[dict objectForKey:@"meal_type_id"];
                
                else if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"lunch"])
                    lunchId=[dict objectForKey:@"meal_type_id"];
                
                else if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"dinner"])
                    dinnerId=[dict objectForKey:@"meal_type_id"];
                
                else if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"snack"])
                    snackId=[dict objectForKey:@"meal_type_id"];
            }
            
            if([self.selected_session isEqualToString:@"Breakfast"])
                self.selectedMealTypeId=breakfastId;
            else if([self.selected_session isEqualToString:@"Lunch"])
                self.selectedMealTypeId=lunchId;
            else if([self.selected_session isEqualToString:@"Dinner"])
                self.selectedMealTypeId=dinnerId;
            else if([self.selected_session isEqualToString:@"Snack"])
                self.selectedMealTypeId=snackId;
            
            
            selectedMyMealType= self.selectedMealTypeId;
            _selectedFoodArr=[NSMutableArray array];
            
            _selectedFoodArr= _recentFoodArray=[foodLogObject getAllLunchLog:self.selectedMealTypeId withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
            
            if([_selectedFoodArr count]>0)
                goBack=0;
            NSMutableArray *yourArray;
            if(APP_CTRL.carryDataDict !=NULL)
            {
                yourArray=[[NSMutableArray alloc] init];
                [yourArray addObject:APP_CTRL.carryDataDict];
            }
            NSLog(@"yourArray=====%@",yourArray);
            
            if([_selectedFoodArr count]>0)
            {
                if([yourArray count]>0)
                    [ _selectedFoodArr addObject:APP_CTRL.carryDataDict];
                mymealView.hidden=YES;
                FavFoodVCount=0;
                _tblVw.tag=MEALSUBCATEGORY_TABLE_TAG;
                _tblVw.delegate=self;
                _tblVw.dataSource=self;
                _tblVw.hidden=NO;
                [_tblVw reloadData];
                
                //[self performSelector:@selector(selfCalculateTotalSubCategoryMeal) withObject:nil afterDelay:3.0];
            }
            else{
                if([yourArray count]>0)
                {
                    [_selectedFoodArr addObject:APP_CTRL.carryDataDict];
                    mymealView.hidden=YES;
                    FavFoodVCount=0;
                    _tblVw.tag=MEALSUBCATEGORY_TABLE_TAG;
                    _tblVw.delegate=self;
                    _tblVw.dataSource=self;
                    _tblVw.hidden=NO;
                    [_tblVw reloadData];
                    
                    //[self performSelector:@selector(selfCalculateTotalSubCategoryMeal) withObject:nil afterDelay:3.0];
                }
                else
                    _tblVw.hidden=YES;
                
            }
            
        }
        
        else
        {
            [mymealView setHidden:NO];
            [self createMyMealArr];
            NSLog(@"myMealArr==%@",myMealArr);
            NSLog(@"myMealSecTitleArr==%@",myMealSecTitleArr);
            
            myMealTable.delegate=self;
            myMealTable.dataSource=self;
            myMealTable.hidden=NO;
            [myMealTable reloadData];
            
        }
        [self getTotalCal];
        
        //For Other Food Notification
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOtherSelectedFood) name:@"updateOtherSelectedFood" object:nil];
        
        //For Recent Food Notification
        // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRecentFood) name:@"updateRecentFood" object:nil];
        
        if([self.previous_activity isEqualToString:@"fromActivity"])
        {
            if(self.carryFromActivityArr)
            {
                NSMutableArray *allMealArr=[NSMutableArray array];
                allMealArr=[mealTypeObj findAllMealType];
                for(NSDictionary *dict in allMealArr){
                    if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"breakfast"])
                        breakfastId=[dict objectForKey:@"meal_type_id"];
                    
                    else if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"lunch"])
                        lunchId=[dict objectForKey:@"meal_type_id"];
                    
                    else if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"dinner"])
                        dinnerId=[dict objectForKey:@"meal_type_id"];
                    
                    else if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"snack"])
                        snackId=[dict objectForKey:@"meal_type_id"];
                }
                
                if([self.carryMealTypeActivity isEqualToString:@"1"])
                {
                    self.selectedMealTypeId=breakfastId;
                    [self createNavigationView:@"Breakfast"];
                    navTitle=@"Breakfast";
                }
                else  if([self.carryMealTypeActivity isEqualToString:@"2"])
                {
                    self.selectedMealTypeId=lunchId;
                    [self createNavigationView:@"Lunch"];
                    navTitle=@"Lunch";
                }
                
                else if([self.carryMealTypeActivity isEqualToString:@"3"])
                {
                    self.selectedMealTypeId=dinnerId;
                    [self createNavigationView:@"Dinner"];
                    navTitle=@"Dinner";
                }
                
                else
                {
                    self.selectedMealTypeId=snackId;
                    [self createNavigationView:@"Snack"];
                    navTitle=@"Snack";
                }
                
                _selectedFoodArr= _recentFoodArray=self.carryFromActivityArr;
                if([_selectedFoodArr count]>0)
                {
                    
                    mymealView.hidden=YES;
                    autoCompleteTableView.hidden=YES;
                    recentFoodTableView.hidden=YES;
                    FavFoodVCount=0;
                    _tblVw.tag=MEALSUBCATEGORY_TABLE_TAG;
                    _tblVw.delegate=self;
                    _tblVw.dataSource=self;
                    _tblVw.hidden=NO;
                    [_tblVw reloadData];
                    
                    //[self performSelector:@selector(selfCalculateTotalSubCategoryMeal) withObject:nil afterDelay:3.0];
                    
                }
                else
                {
                    mymealView.hidden=YES;
                    FavFoodVCount=0;
                    _tblVw.tag=MEALSUBCATEGORY_TABLE_TAG;
                    _tblVw.delegate=self;
                    _tblVw.dataSource=self;
                    _tblVw.hidden=YES;
                    [_tblVw reloadData];
                    
                    //[self performSelector:@selector(selfCalculateTotalSubCategoryMeal) withObject:nil afterDelay:3.0];
                }
                
            }
            
            else
            {
                [self createMyMealArr];
                NSLog(@"myMealArr==%@",myMealArr);
                NSLog(@"myMealSecTitleArr==%@",myMealSecTitleArr);
                
                [mymealView setHidden:NO];
                
                myMealTable.delegate=self;
                myMealTable.dataSource=self;
                myMealTable.hidden=NO;
                [myMealTable reloadData];
                
                sessionName.text=@"My Meal";
                sessionNm=@"My Meal";
                [self createNavigationView:@"My Meal"];
                navTitle=@"My Meal";
                
            }
            
            [self getTotalCal];
            
        }
        
        [self refreshViewDropdownView];
    }
    
    if([_selectedFoodArr count]>0)
    {
        for(int i=0;i<_selectedFoodArr.count;i++)
        {
            if([[[_selectedFoodArr objectAtIndex:i] objectForKey:@"isFavMeal"] isEqualToString:@"1"])
            {
                FavFoodVCount++;
            }
        }
    }
    
    if([_selectedFoodArr count]>0)
    {
        if(FavFoodVCount==_selectedFoodArr.count)
        {
            [_btnTotalFav setImage:[UIImage imageNamed:@"green-star@3x.png"] forState:UIControlStateNormal];
        }
        else
        {
            [_btnTotalFav setImage:[UIImage imageNamed:@"green-star@3x_outline.png"] forState:UIControlStateNormal];
        }
    }
    else
    {
        [_btnTotalFav setImage:[UIImage imageNamed:@"green-star@3x_outline.png"] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [defaults setBool:NO forKey:@"isFoodNavigate"];
    [defaults synchronize];
    
  //  [self syncUpdateFoodLogTable];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:@"UpdateFoodScale" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:@"updateOtherSelectedFood" object:nil];
    // [_recentSelectedFoodArr removeAllObjects];
    autoCompleteTextField.text=@"";
    _lblBottomTotalCal.text=@"";
    totalCal=0;
    //APP_CTRL.carryDataDict=nil;
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"primarySelectedArray"];
    
    [autoCompleteTableView setEditing:NO];
    [recentFoodTableView setEditing:NO];
    [_tblVw setEditing:NO];
}

-(void)tapDetectKeyBoard:(UIGestureRecognizer*) recognizer
{
    [self.view endEditing:YES];
    
}

-(void)syncUpdateFoodLogTable
{
    NSMutableArray *arrFood=[foodLogObject getAllFoodLogForSync:selectedUserProfileID];
    NSLog(@"%@",arrFood);
}
#pragma mark - Recent Swipe Gesture Method
/*-(void)RecentSwipe:(UISwipeGestureRecognizer *)sender
 {
 arrowImageView.image=[UIImage imageNamed:@"kee_arrow"];
 UITableViewCell *cell = (UITableViewCell*)[myMealTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
 UIButton *plusBtn=(UIButton *)[cell viewWithTag:1];
 [plusBtn setUserInteractionEnabled:NO];
 [btn1 setUserInteractionEnabled:NO];
 [btn2 setUserInteractionEnabled:NO];
 [btn3 setUserInteractionEnabled:NO];
 [btn4 setUserInteractionEnabled:NO];
 
 if (sender.direction == UISwipeGestureRecognizerDirectionUp)
 {
 NSLog(@"Swipe Up");
 
 [swipeFood setDirection: UISwipeGestureRecognizerDirectionDown];
 
 [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
 if(family==iPad)
 recentMealViewTopConstant.constant=300;
 else
 recentMealViewTopConstant.constant=142;//150;
 [self.view layoutIfNeeded];
 } completion:^(BOOL finished){
 
 }];
 
 id sender;
 [self btnActionRecentFood:sender];
 }
 else if (sender.direction == UISwipeGestureRecognizerDirectionDown)
 {
 NSLog(@"Swipe Down");
 id sender2;
 [self showHideRecentfoodView:sender2];
 }
 }*/
-(void)MealSwipe:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionUp)
    {
        NSLog(@"Swipe Up");
        id sender1;
        [self btnActionRecentMeal:sender1];
        
    }
    else if (sender.direction == UISwipeGestureRecognizerDirectionDown)
    {
        NSLog(@"Swipe Down");
        id sender2;
        [self showHideRecentfoodView:sender2];
        
    }
}

#pragma mark - Gesture on TableView Method
-(void)tapDetect:(UIGestureRecognizer*) recognizer
{
    [dropDown hideDropDown:btnDropDown];
    [self rel];
    
    UITableView *tblView=(UITableView *)[recognizer view];
    CGPoint tapLocation = [recognizer locationInView:tblView];
    if ([tblView isKindOfClass:[UITableView class]])
    {
        NSIndexPath *indexPath = [tblView indexPathForRowAtPoint:tapLocation];
        if (indexPath)
        {
            recognizer.cancelsTouchesInView = NO;
        }
        else
        {
        }
    }
}

#pragma mark - create MyMeal Array Method
-(void)createMyMealArr
{
    NSMutableArray *allMealArr=[NSMutableArray array];
    myMealCalTotalArr=[NSMutableArray array];
    _myMealTotalCal=0;
    
    allMealArr=[mealTypeObj findAllMealType];
    for(NSDictionary *dict in allMealArr)
    {
        if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"breakfast"])
            breakfastId=[dict objectForKey:@"meal_type_id"];
        
        else if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"lunch"])
            lunchId=[dict objectForKey:@"meal_type_id"];
        
        else if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"dinner"])
            dinnerId=[dict objectForKey:@"meal_type_id"];
        
        else if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"snack"])
            snackId=[dict objectForKey:@"meal_type_id"];
    }
    
    myMealArr=[NSMutableArray array];
    myMealSecTitleArr=[NSMutableArray array];
    
    int breakfastCal=0;
    NSMutableArray *breakfastMealArr=[foodLogObject getAllLunchLog:breakfastId withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
    if(breakfastMealArr.count>0)
    {
        for(int j=0;j<breakfastMealArr.count;j++)
        {
            int breakfastTempCal=0;
            if([[[breakfastMealArr objectAtIndex:j]objectForKey:@"item_weight"]intValue]==0)
            {
                 breakfastCal=0+breakfastCal;
            }
            else
            {
                breakfastTempCal=[[[breakfastMealArr objectAtIndex:j]objectForKey:@"cals"]intValue];
                breakfastCal=breakfastTempCal+breakfastCal;
            }
        }
        [myMealCalTotalArr addObject:[NSString stringWithFormat:@"%d",breakfastCal]];

        [myMealArr addObject:breakfastMealArr];
        [myMealSecTitleArr addObject:@"Breakfast"];
    }
    
     int lunchCal=0;
    NSMutableArray *lunchMealArr=[foodLogObject getAllLunchLog:lunchId withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
    if(lunchMealArr.count>0)
    {
        for(int j=0;j<lunchMealArr.count;j++)
        {
            int lunchTempCal=0;
            if([[[lunchMealArr objectAtIndex:j]objectForKey:@"item_weight"]intValue]==0)
            {
                lunchCal=0+lunchCal;
            }
            else
            {
             lunchTempCal=[[[lunchMealArr objectAtIndex:j]objectForKey:@"cals"]intValue];
            lunchCal=lunchTempCal+lunchCal;
            }
        }

        [myMealCalTotalArr addObject:[NSString stringWithFormat:@"%d",lunchCal]];

        [myMealArr addObject:lunchMealArr];
        [myMealSecTitleArr addObject:@"Lunch"];
    }
    
    int dinnerCal=0;
    NSMutableArray *dinnerMealArr=[foodLogObject getAllLunchLog:dinnerId withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
    if(dinnerMealArr.count>0)
    {
        for(int j=0;j<dinnerMealArr.count;j++)
        {
            int dinnerTempCal=0;
            if([[[dinnerMealArr objectAtIndex:j]objectForKey:@"item_weight"]intValue]==0)
            {
            dinnerCal=0+dinnerCal;
            }
            else
            {
             dinnerTempCal=[[[dinnerMealArr objectAtIndex:j]objectForKey:@"cals"]intValue];
            dinnerCal=dinnerTempCal+dinnerCal;
            }
        }
        [myMealCalTotalArr addObject:[NSString stringWithFormat:@"%d",dinnerCal]];

        [myMealArr addObject:dinnerMealArr];
        [myMealSecTitleArr addObject:@"Dinner"];
    }
    
    int snacksCal=0;
      NSMutableArray *snacksMealArr=[foodLogObject getAllLunchLog:snackId withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
    if(snacksMealArr.count>0)
    {
        for(int j=0;j<snacksMealArr.count;j++)
        {
            int snacksTempCal=0;
            if([[[snacksMealArr objectAtIndex:j]objectForKey:@"item_weight"]intValue]==0)
            {
                snacksCal=0+snacksCal;
            }
            else
            {
             snacksTempCal=[[[snacksMealArr objectAtIndex:j]objectForKey:@"cals"]intValue];
            snacksCal=snacksTempCal+snacksCal;
            }
        }
        [myMealCalTotalArr addObject:[NSString stringWithFormat:@"%d",snacksCal]];

        [myMealArr addObject:snacksMealArr];
        [myMealSecTitleArr addObject:@"Snack"];
    }
    
    
    _myMealTotalCal=breakfastCal+lunchCal+dinnerCal+snacksCal;
}

#pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView
 willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //  [cell setBackgroundColor:[UIColor clearColor]];
    NSLog(@"selectedIndexPathRecentDisplay==%ld",(long)selectedIndexPathRecent);
    NSLog(@"selectedIndexPathFavDisplay==%ld",(long)selectedIndexPathFav);
    NSLog(@"selectedIndexPathNormalDisplay==%ld",(long)selectedIndexPathNormal);
    if (tableView.tag==RECENT_TABLE_TAG)
    {
        //For Else "MyMeal" Section
        if(![selectedMyMealType isEqualToString:@""])
        {
            if([selectedRecentFav isEqualToString:@"Recent"] || [selectedRecentFav isEqualToString:@"Favorites"])
            {
                if(selectedIndexPathRecent==indexPath.row)
                {
                    [cell.contentView setBackgroundColor:[UIColor colorWithRed:84.0/255.0f green:167.0/255.0f blue:115.0/255.0f alpha:1.0f]];
                    //cell.backgroundView=  customColorView;
                }
                else
                {
                    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
                    // cell.backgroundView=  customClearView;
                }
            }
        }
    }
    else if (tableView.tag==MEALSUBCATEGORY_TABLE_TAG)
    {
        if(selectedIndexPathNormal==indexPath.row)
        {
            [cell.contentView setBackgroundColor:[UIColor colorWithRed:84.0/255.0f green:167.0/255.0f blue:115.0/255.0f alpha:1.0f]];
            //cell.backgroundView=  customColorView;
        }
        else
        {
            [cell.contentView setBackgroundColor:[UIColor whiteColor]];
            // cell.backgroundView=  customClearView;
        }
        
    }
    else if (tableView.tag==FAV_MEALSUBCAT_TABLE_TAG)
    {
        //For Else "MyMeal" Section
        if(![selectedMyMealType isEqualToString:@""])
        {
            if([selectedRecentFav isEqualToString:@"Recent"] || [selectedRecentFav isEqualToString:@"Favorites"])
            {
                int selectedIndexPathFavPrevRow=selectedIndexPathFavPrev%10000;
                int selectedIndexPathFavPrevSec=selectedIndexPathFavPrev/10000;
                //For Deselect
                if(selectedIndexPathFavPrevRow==indexPath.row && selectedIndexPathFavPrevSec==indexPath.section)
                {
                    [cell.contentView setBackgroundColor:[UIColor colorWithRed:84.0/255.0f green:167.0/255.0f blue:115.0/255.0f alpha:1.0f]];
                    //cell.backgroundView=  customColorView;
                }
                else
                {
                    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
                    // cell.backgroundView=  customClearView;
                }
            }
        }
    }
    else if (tableView.tag==FAV_MEALDROPDOWN_TABLE_TAG)
    {
        //For Else "MyMeal" Section
        if(![selectedMyMealType isEqualToString:@""])
        {
            if([selectedRecentFav isEqualToString:@"Recent"] || [selectedRecentFav isEqualToString:@"Favorites"])
            {
                //For Deselect
                if(selectedIndexPathDropDownMeal==indexPath.row)
                {
                    [cell.contentView setBackgroundColor:[UIColor colorWithRed:84.0/255.0f green:167.0/255.0f blue:115.0/255.0f alpha:1.0f]];
                    //cell.backgroundView=  customColorView;
                }
                else
                {
                    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
                    // cell.backgroundView=  customClearView;
                }
            }
        }
        
    }
    else
        [cell setBackgroundColor:[UIColor clearColor]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag==SEARCH_TABLE_TAG)
        if(section==0)
            return [self.allSearchedFoodArr count];
        else
            return 1;
    
        else if (tableView.tag==RECENT_TABLE_TAG)
        {
            return [_recentFoodArray count];
        }
        else if (tableView.tag==FAV_MEALSUBCAT_TABLE_TAG)
        {
            if(favMealArr.count>0)
            {
                if([selectedRecentFav isEqualToString:@"Recent"])
                {
                    return [[favMealArr objectAtIndex:section] count];
                }
                else
                {
                    return [[favMealArr objectAtIndex:section] count];
                }
            }
        }
        else if (tableView.tag==FAV_MEALDROPDOWN_TABLE_TAG)
        {
            if(favMealArr.count>0)
            {
                if([selectedRecentFav isEqualToString:@"Recent"])
                {
                    return [[favMealArr objectAtIndex:section] count];
                }
                else
                {
                    return [[favMealArr objectAtIndex:section] count];
                    //return 1;
                }
            }
        }
        else if (tableView.tag==MEALSUBCATEGORY_TABLE_TAG)
        {
            return _selectedFoodArr.count;
        }
        else if (tableView.tag==MYMEAL_TABLE_TAG)
        {
            if(section==0)
                return 1;
            else if([myMealArr count]>0)
            {
                return [[myMealArr objectAtIndex:section-1] count];
            }
        }
        else
        {
            if([myMealArr count]>0)
            {
            return [[myMealArr objectAtIndex:section] count];
            }
        }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    cell=(UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"recentFoodCell"];
    
    if(tableView.tag==SEARCH_TABLE_TAG)
        return 68;
    else if(tableView.tag==MYMEAL_TABLE_TAG){
        if(indexPath.section==0)
            return 71;
        else
            return 60;
    }
    else if (tableView.tag==FAV_MEALDROPDOWN_TABLE_TAG)
    {
        CGRect titleLabelSize=[self getLabelSizeForFavMeal:[[favMealTitleArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row ] :[UIScreen mainScreen].bounds.size.width-69];
        NSLog(@"Label height=======%f",titleLabelSize.size.height);
        return (titleLabelSize.size.height)>40 ?(titleLabelSize.size.height+50):60;
        
    }
    else if (tableView.tag==FAV_MEALSUBCAT_TABLE_TAG)
    {
        if([selectedRecentFav isEqualToString:@"Recent"])
        {
            CGRect titleLabelSize=[self getLabelSizeForFavMeal:[[favMealTitleArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row ] :[UIScreen mainScreen].bounds.size.width-69];
            NSLog(@"Label height=======%f",titleLabelSize.size.height);
            return (titleLabelSize.size.height)>40 ?(titleLabelSize.size.height+20):60;
        }
        else{
            /* CGRect titleLabelSize=[self getLabelSizeForFavMeal:[favMealTitleArr objectAtIndex:indexPath.section] :[UIScreen mainScreen].bounds.size.width-40];
             NSLog(@"Label height=======%f",titleLabelSize.size.height);
             return (titleLabelSize.size.height)>40 ?(titleLabelSize.size.height+20):60;*/
            CGRect titleLabelSize=[self getLabelSizeForFavMeal:[[favMealTitleArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row ] :[UIScreen mainScreen].bounds.size.width-69];
            NSLog(@"Label height=======%f",titleLabelSize.size.height);
            return (titleLabelSize.size.height)>40 ?(titleLabelSize.size.height+20):60;
            
        }
    }
    else if(tableView.tag !=RECENT_TABLE_TAG)
    {
        CGRect descLabelSize;
        UILabel *descLabel=(UILabel*)[cell viewWithTag:3];
        
        if(_selectedFoodArr.count>0)
        {
        if(![[self chkNullInputinitWithString:[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_desc"]] isEqualToString:@""])
        {
            if([NSString stringWithFormat:@"%@",[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_desc"]].length>30)
                descLabelSize=[self getLabelSize:[[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_desc"] substringToIndex:30] :[UIScreen mainScreen].bounds.size.width-122];
            else
                descLabelSize=[self getLabelSize:[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_desc"]:[UIScreen mainScreen].bounds.size.width-122];
        }
            return (descLabelSize.size.height)>68 ?(descLabelSize.size.height+80-descLabel.frame.size.height)+10:68 ;
            //return 90;
        }
    }
    else
    {
        NSString *str=@"";
        
        if(_recentFoodArray.count>0)
        {
            if([[[_recentFoodArray objectAtIndex:indexPath.row] allKeys] containsObject:@"item_title"]){
                str=[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"item_title"];
                
            }
            else if([[[_recentFoodArray objectAtIndex:indexPath.row] allKeys] containsObject:@"food_name"]){
                str=[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"food_name"];
                
            }
        }
        
        CGRect titleLabelSize=[self getLabelSizeForFavMeal:str :[UIScreen mainScreen].bounds.size.width-25];
        NSLog(@"Label height=======%f",titleLabelSize.size.height);
        return (titleLabelSize.size.height)>40 ?(titleLabelSize.size.height+20):68;
    }
    return 68;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    UIView *customColorView = [[UIView alloc] initWithFrame:cell.frame];
    customColorView.backgroundColor = [UIColor colorWithRed:84.0/255.0f green:167.0/255.0f blue:115.0/255.0f alpha:1.0f];
    
    UIView *customClearView = [[UIView alloc] initWithFrame:cell.frame];
    customClearView.backgroundColor = [UIColor clearColor];
    
    //For Search Table
    if(tableView.tag==SEARCH_TABLE_TAG)
    {
        if(indexPath.section==0)
        {
            static NSString *simpleTableIdentifier = @"autoCompleteCell";
            
            cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            }
            UILabel *foodLabel=(UILabel*)[cell viewWithTag:10];
            UILabel *descLabel=(UILabel*)[cell viewWithTag:11];
            descLabel.text=@"";
            UILabel *calpergmLabel=(UILabel*)[cell viewWithTag:12];
            UILabel *calLabel=(UILabel*)[cell viewWithTag:13];
            if(![[self chkNullInputinitWithString:[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_title"]]isEqualToString:@""]){
                
               // foodLabel.text=[NSString stringWithFormat:@"%@(%@)",[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_title"],[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"serving_size"]];
                 foodLabel.text=[NSString stringWithFormat:@"%@",[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_title"]];
            }
            
            if(![[self chkNullInputinitWithString:[NSString stringWithFormat:@"%@",[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"cals"]]] isEqualToString:@""])
            {
                calLabel.text=[NSString stringWithFormat:@"%@ cal",[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"cals"]];
            }
            
            if(![[self chkNullInputinitWithString:[NSString stringWithFormat:@"%@",[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_desc"]]] isEqualToString:@""])
            {
                descLabel.text=[NSString stringWithFormat:@"%@",[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_desc"]];
            }
            
            if(![[self chkNullInputinitWithString:[NSString stringWithFormat:@"%@",[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_weight"]]] isEqualToString:@""] && [[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_weight"] intValue]!=0)
            {
                NSLog(@"wwwww===%@",[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_weight"]);
                
                if([selectedFoodWeight isEqualToString:@"gm"])
                {
                    calpergmLabel.text=[NSString stringWithFormat:@"%@ g",[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_weight"]];
                }
                else
                {
                    calpergmLabel.text=[NSString stringWithFormat:@"%@ oz",[self gmToOz:[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_weight"]]];
                }
            }
            else
            {
                if([selectedFoodWeight isEqualToString:@"gm"])
                {
                    calpergmLabel.text=[NSString stringWithFormat:@"0 g"];
                }
                else
                {
                    calpergmLabel.text=[NSString stringWithFormat:@"0 oz"];
                }
            }
            
            [cell.contentView.layer setBorderColor:[[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:.5] CGColor]];
            [cell.contentView.layer setBorderWidth:.3f];
            cell.selectedBackgroundView =  customColorView;
            if(selectedIndexPathSearch==indexPath.row)
            {
                //                [cell setBackgroundColor:[UIColor colorWithRed:84.0/255.0f green:167.0/255.0f blue:115.0/255.0f alpha:1.0f]];
            }
            else{
                // [cell setBackgroundColor:[UIColor clearColor]];
            }
            
        }
        
        else
        {
            static NSString *simpleTableIdentifier = @"otherCell";
            
            cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            }
            UIButton *otherBtn=(UIButton*)[cell viewWithTag:10];
            [otherBtn addTarget:self action:@selector(OtherButtonTapped) forControlEvents:UIControlEventTouchUpInside];
            
        }
        [cell.contentView.layer setBorderColor:[[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:.5] CGColor]];
        [cell.contentView.layer setBorderWidth:.3f];
        cell.selectedBackgroundView =  customColorView;
        
        return cell;
        
    }
    
    //For Favorite/Recent DropDown Category Meal Table
    else if (tableView.tag==FAV_MEALDROPDOWN_TABLE_TAG)
    {
        FavFoodMealTableViewCell *cell1=nil;
        NSArray *nib=nil;
        nib=[[ NSBundle  mainBundle]loadNibNamed:@"FavRecentMealTableViewCell" owner:self options:nil];
        cell1=(FavFoodMealTableViewCell*)[nib objectAtIndex:0];
        
        cell1.selectionStyle=UITableViewCellSelectionStyleNone;
        
        //cell1.lblTitle.text=[NSString stringWithFormat:@"%@",[favMealTitleArr objectAtIndex:indexPath.section]];
        ////////////////
        NSMutableParagraphStyle *style=[NSMutableParagraphStyle new];
        style.lineSpacing=6;
        NSMutableAttributedString *str ;
        str = [[NSMutableAttributedString alloc] initWithString:[[favMealTitleArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]];
        cell1.lblSepararor.hidden=NO;
        [str addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
        cell1.lblTitle.attributedText= str;
        
        RecentFavFoodVCount=0;
        if([selectedRecentFav isEqualToString:@"Recent"])
        {
            NSLog(@"%@",[[favMealArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]);
            if([[[favMealArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] count]>0){
                
                for(int i=0;i<[[[favMealArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] count];i++)
                {
                    if([[[[[favMealArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectAtIndex:i] objectForKey:@"isFavMeal"] isEqualToString:@"1"])
                    {
                        RecentFavFoodVCount++;
                    }
                }
            }
            
            if(RecentFavFoodVCount==[[[favMealArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] count])
            {
                [cell1.btnFav setImage:[UIImage imageNamed:@"green-star@3x.png"] forState:UIControlStateNormal];
                [cell1.btnFav addTarget:self action:@selector(UnFavouriteDropDownRecentMeal:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                [cell1.btnFav setImage:[UIImage imageNamed:@"green-star@3x_outline.png"] forState:UIControlStateNormal];
                
                [cell1.btnFav addTarget:self action:@selector(AddFavouriteDropDownRecentMeal:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        else{
            
            [cell1.btnFav addTarget:self action:@selector(unFavDropDownMeal:) forControlEvents:UIControlEventTouchUpInside];
            [cell1.btnFav setImage:[UIImage imageNamed:@"green-star@3x.png"] forState:UIControlStateNormal];
        }
        cell1.btnFav.tag=indexPath.section*100000+indexPath.row;
        
        return cell1;
        
    }
    //For Favorite/Recent Meal Table
    else if (tableView.tag==FAV_MEALSUBCAT_TABLE_TAG)
    {
        FavFoodMealTableViewCell *cell1=nil;
        NSArray *nib=nil;
        if([selectedRecentFav isEqualToString:@"Recent"])
        {
            nib=[[ NSBundle  mainBundle]loadNibNamed:@"FavRecentMealTableViewCell" owner:self options:nil];
        }
        else
        {
            nib=[[ NSBundle  mainBundle]loadNibNamed:@"FavRecentMealTableViewCell" owner:self options:nil];
            // nib=[[ NSBundle  mainBundle]loadNibNamed:@"FavFoodMealTableViewCell" owner:self options:nil];
        }
        cell1=(FavFoodMealTableViewCell*)[nib objectAtIndex:0];
        
        cell1.selectionStyle=UITableViewCellSelectionStyleNone;
        
        //cell1.lblTitle.text=[NSString stringWithFormat:@"%@",[favMealTitleArr objectAtIndex:indexPath.section]];
        ////////////////
        NSMutableParagraphStyle *style=[NSMutableParagraphStyle new];
        style.lineSpacing=6;
        NSMutableAttributedString *str ;
        
        if([selectedRecentFav isEqualToString:@"Recent"])
        {
            str = [[NSMutableAttributedString alloc] initWithString:[[favMealTitleArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]];
            cell1.lblSepararor.hidden=NO;
        }
        else{
            //           str = [[NSMutableAttributedString alloc] initWithString:[favMealTitleArr objectAtIndex:indexPath.section]];
            //            cell1.lblSepararor.hidden=YES;
            str = [[NSMutableAttributedString alloc] initWithString:[[favMealTitleArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]];
            cell1.lblSepararor.hidden=NO;
            
        }
        [str addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
        cell1.lblTitle.attributedText= str;
        
        //  cell1.btnFav.accessibilityHint=[NSString stringWithFormat: @"%ld", (long)section];
        RecentFavFoodVCount=0;
        if([selectedRecentFav isEqualToString:@"Recent"])
        {
            NSLog(@"%@",[[favMealArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]);
            if([[[favMealArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] count]>0){
                
                for(int i=0;i<[[[favMealArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] count];i++)
                {
                    if([[[[[favMealArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectAtIndex:i] objectForKey:@"isFavMeal"] isEqualToString:@"1"])
                    {
                        RecentFavFoodVCount++;
                    }
                }
            }
            
            if(RecentFavFoodVCount==[[[favMealArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] count])
            {
                [cell1.btnFav setImage:[UIImage imageNamed:@"green-star@3x.png"] forState:UIControlStateNormal];
                [cell1.btnFav addTarget:self action:@selector(UnFavouriteRecentMeal:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                [cell1.btnFav setImage:[UIImage imageNamed:@"green-star@3x_outline.png"] forState:UIControlStateNormal];
                
                [cell1.btnFav addTarget:self action:@selector(AddFavouriteRecentMeal:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        else{
            
            [cell1.btnFav addTarget:self action:@selector(unFavMeal:) forControlEvents:UIControlEventTouchUpInside];
            [cell1.btnFav setImage:[UIImage imageNamed:@"green-star@3x.png"] forState:UIControlStateNormal];
        }
        
        cell1.btnFav.tag=indexPath.section*100000+indexPath.row;
        
        return cell1;
        /*static NSString *simpleTableIdentifier = @"recentCell";
         
         UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
         if (cell == nil) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
         }
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         
         UILabel *foodNmLabel=(UILabel*)[cell viewWithTag:11];
         UILabel *descLabel=(UILabel*)[cell viewWithTag:12];
         UILabel *calLabel=(UILabel*)[cell viewWithTag:14];
         UILabel *calpergmLabel=(UILabel*)[cell viewWithTag:13];
         foodNmLabel.text=descLabel.text=@"";
         
         UIButton *editBtn=(UIButton *)[cell viewWithTag:2];
         editBtn.userInteractionEnabled=YES;
         [editBtn addTarget:self action:@selector(AddFavouriteRecent:) forControlEvents:UIControlEventTouchUpInside];
         editBtn.accessibilityHint=[NSString stringWithFormat:@"%@#%@",[[[favMealArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectForKey:@"isFavorite"],[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"id"]];
         
         if([[[[favMealArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectForKey:@"isFavorite"] isEqualToString:@"1"])
         [editBtn setImage:[UIImage imageNamed:@"green-star@3x.png"] forState:UIControlStateNormal];
         else
         [editBtn setImage:[UIImage imageNamed:@"green-star@3x_outline.png"] forState:UIControlStateNormal];
         
         if([[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] allKeys] containsObject:@"food_name"])
         {
         if(![[self chkNullInputinitWithString:[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"food_name"]]isEqualToString:@""] &&[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"food_name"]!=[NSNull null])
         {
         foodNmLabel.text=[NSString stringWithFormat:@"%@",[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"food_name"]];
         }
         }
         
         else if([[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] allKeys] containsObject:@"item_title"])
         {
         if(![[self chkNullInputinitWithString:[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"item_title"]]isEqualToString:@""] &&[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"item_title"]!=[NSNull null])
         {
         foodNmLabel.text=[NSString stringWithFormat:@"%@",[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"item_title"]];
         }
         }
         
         if(![[self chkNullInputinitWithString:[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"item_desc"]] isEqualToString:@""] )
         {
         if([NSString stringWithFormat:@"%@",[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"item_desc"]].length>30)
         descLabel.text=[NSString stringWithFormat:@"%@",[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"item_desc"]substringToIndex:30]];
         else
         descLabel.text=[NSString stringWithFormat:@"%@",[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"item_desc"] ];
         
         }
         else if([[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] allKeys] containsObject:@"description"])
         {
         if(![[self chkNullInputinitWithString:[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"description"]]isEqualToString:@""] &&[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"description"]!=[NSNull null])
         {
         foodNmLabel.text=[NSString stringWithFormat:@"%@",[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"description"]];
         }
         }
         
         if([[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"cals"]!=nil && [[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"cals"]!=[NSNull null])
         {
         calLabel.text=[NSString stringWithFormat:@"%@ cal",[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"cals"]];
         }
         
         if(![[self chkNullInputinitWithString:[NSString stringWithFormat:@"%@",[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"item_weight"]]] isEqualToString:@""] && [[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"item_weight"] intValue]!=0)
         {
         if([selectedFoodWeight isEqualToString:@"gm"])
         {
         calpergmLabel.text=[NSString stringWithFormat:@"%@ g",[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"item_weight"]];
         }
         else
         {
         calpergmLabel.text=[NSString stringWithFormat:@"%@ oz",[self gmToOz:[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"item_weight"]]];
         }
         }
         
         [cell.contentView.layer setBorderColor:[[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:.5] CGColor]];
         [cell.contentView.layer setBorderWidth:.3f];
         
         //   cell.selectedBackgroundView =  customClearView;
         
         return cell;*/
    }
    //For Recent & Favorite Table
    else if (tableView.tag==RECENT_TABLE_TAG)
    {
        static NSString *simpleTableIdentifier = @"recentCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *foodNmLabel=(UILabel*)[cell viewWithTag:11];
        UILabel *descLabel=(UILabel*)[cell viewWithTag:12];
        UILabel *calLabel=(UILabel*)[cell viewWithTag:14];
        UILabel *calpergmLabel=(UILabel*)[cell viewWithTag:13];
        foodNmLabel.text=descLabel.text=@"";
        
        UIButton *editBtn=(UIButton *)[cell viewWithTag:2];
        editBtn.userInteractionEnabled=YES;
        [editBtn addTarget:self action:@selector(AddFavouriteRecent:) forControlEvents:UIControlEventTouchUpInside];
        
        if(_recentFoodArray.count>0)
        {
        editBtn.accessibilityHint=[NSString stringWithFormat:@"%@#%@#%@#%ld",[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"isFavorite"],[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"id"],[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"item"],indexPath.row];
        
            //For Recent Table
            if([selectedRecentFav isEqualToString:@"Recent"])
            {
                if([[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"isFavorite"] isEqualToString:@"1"])
                {
                    [editBtn setImage:[UIImage imageNamed:@"green-star@3x.png"] forState:UIControlStateNormal];
                }
                else
                {
                    [editBtn setImage:[UIImage imageNamed:@"green-star@3x_outline.png"] forState:UIControlStateNormal];
                }
            }
             //For Favorite Table
            else
            {
                [editBtn setImage:[UIImage imageNamed:@"green-star@3x.png"] forState:UIControlStateNormal];

            }
            
        if([[[_recentFoodArray objectAtIndex:indexPath.row] allKeys] containsObject:@"food_name"])
        {
            if(![[self chkNullInputinitWithString:[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"food_name"]]isEqualToString:@""] &&[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"food_name"]!=[NSNull null])
            {
                NSMutableParagraphStyle *style=[NSMutableParagraphStyle new];
                style.lineSpacing=6;
                NSMutableAttributedString *str ;
                str = [[NSMutableAttributedString alloc] initWithString:[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"food_name"]];
                
                [str addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
                
                
                foodNmLabel.attributedText=str;
            }
        }
        
        else if([[[_recentFoodArray objectAtIndex:indexPath.row] allKeys] containsObject:@"item_title"])
        {
            if(![[self chkNullInputinitWithString:[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"item_title"]]isEqualToString:@""] &&[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"item_title"]!=[NSNull null])
            {
                NSMutableParagraphStyle *style=[NSMutableParagraphStyle new];
                style.lineSpacing=6;
                NSMutableAttributedString *str ;
                str = [[NSMutableAttributedString alloc] initWithString:[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"item_title"]];
                
                [str addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
                
                
                foodNmLabel.attributedText=str;
            }
        }
        
        if(![[self chkNullInputinitWithString:[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"item_desc"]] isEqualToString:@""] )
        {
            if([NSString stringWithFormat:@"%@",[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"item_desc"]].length>30)
                descLabel.text=[NSString stringWithFormat:@"%@",[[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"item_desc"]substringToIndex:30]];
            else
                descLabel.text=[NSString stringWithFormat:@"%@",[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"item_desc"] ];
            
        }
        else if([[[_recentFoodArray objectAtIndex:indexPath.row] allKeys] containsObject:@"description"])
        {
            if(![[self chkNullInputinitWithString:[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"description"]]isEqualToString:@""] &&[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"description"]!=[NSNull null])
            {
                foodNmLabel.text=[NSString stringWithFormat:@"%@",[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"description"]];
            }
        }
        
        if([[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"cals"]!=nil && [[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"cals"]!=[NSNull null])
        {
            calLabel.text=[NSString stringWithFormat:@"%@ cal",[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"cals"]];
        }
        
        if(![[self chkNullInputinitWithString:[NSString stringWithFormat:@"%@",[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"item_weight"]]] isEqualToString:@""] && [[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"item_weight"] intValue]!=0)
        {
            if([selectedFoodWeight isEqualToString:@"gm"])
            {
                calpergmLabel.text=[NSString stringWithFormat:@"%@ g",[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"item_weight"]];
            }
            else
            {
                calpergmLabel.text=[NSString stringWithFormat:@"%@ oz",[self gmToOz:[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"item_weight"]]];
            }
        }
        else
        {
            if([selectedFoodWeight isEqualToString:@"gm"])
            {
                calpergmLabel.text=[NSString stringWithFormat:@"0 g"];
            }
            else
            {
                calpergmLabel.text=[NSString stringWithFormat:@"0 oz"];
            }
        }
    }
        
        [cell.contentView.layer setBorderColor:[[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:.5] CGColor]];
        [cell.contentView.layer setBorderWidth:.3f];
        
        //  cell.selectedBackgroundView =  customColorView;
        
        return cell;
    }
    //For My Meal Table
    else if (tableView.tag==MYMEAL_TABLE_TAG)
    {
        static NSString *simpleTableIdentifier;
        if(indexPath.section==0)
            simpleTableIdentifier=@"totalCell";
        else
            simpleTableIdentifier = @"resultCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if(indexPath.section!=0)
        {
            if([myMealArr count]>0)
            {
                UIView *greySeparator=(UILabel*)[cell viewWithTag:777];
                if(myMealSecTitleArr.count+1>2)
                {
                    if([[myMealArr objectAtIndex:indexPath.section-1] count]-1==indexPath.row){
                        greySeparator.hidden=YES;
                    }
                    else
                    {
                        greySeparator.hidden=NO;
                    }
                }
                UILabel *foodNmLabel=(UILabel*)[cell viewWithTag:6];
                UILabel *descLabel=(UILabel*)[cell viewWithTag:8];
                UILabel *calLabel=(UILabel*)[cell viewWithTag:7];
                UILabel *wtLabel=(UILabel*)[cell viewWithTag:9];
                
                if([[[[myMealArr objectAtIndex:indexPath.section-1]objectAtIndex:indexPath.row] allKeys] containsObject:@"food_name"])
                {
                    if(![[self chkNullInputinitWithString:[[[myMealArr objectAtIndex:indexPath.section-1]objectAtIndex:indexPath.row] objectForKey:@"food_name"]] isEqualToString:@""]){
                        
                        foodNmLabel.text=[NSString stringWithFormat:@"%@",[[[myMealArr objectAtIndex:indexPath.section-1]objectAtIndex:indexPath.row] objectForKey:@"food_name"]];
                    }
                }
                else if([[[[myMealArr objectAtIndex:indexPath.section-1]objectAtIndex:indexPath.row] allKeys] containsObject:@"item_title"])
                {
                    if(![[self chkNullInputinitWithString:[[[myMealArr objectAtIndex:indexPath.section-1]objectAtIndex:indexPath.row] objectForKey:@"item_title"]] isEqualToString:@""])
                        foodNmLabel.text=[NSString stringWithFormat:@"%@",[[[myMealArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectForKey:@"item_title"]];
                }
                
                if(![[self chkNullInputinitWithString:[[[myMealArr objectAtIndex:indexPath.section-1]objectAtIndex:indexPath.row] objectForKey:@"item_desc"]] isEqualToString:@""] &&[[[myMealArr objectAtIndex:indexPath.section-1]objectAtIndex:indexPath.row] objectForKey:@"item_desc"]!=nil && [[[myMealArr objectAtIndex:indexPath.section-1]objectAtIndex:indexPath.row] objectForKey:@"item_desc"]!=[NSNull null])
                {
                    if([NSString stringWithFormat:@"%@",[[[myMealArr objectAtIndex:indexPath.section-1]objectAtIndex:indexPath.row] objectForKey:@"item_desc"]].length>30)
                        descLabel.text=[NSString stringWithFormat:@"%@",[[[[myMealArr objectAtIndex:indexPath.section-1]objectAtIndex:indexPath.row] objectForKey:@"item_desc"]substringToIndex:30]];
                    else
                        descLabel.text=[NSString stringWithFormat:@"%@",[[[myMealArr objectAtIndex:indexPath.section-1]objectAtIndex:indexPath.row] objectForKey:@"item_desc"] ];
                }
                
                if([[[myMealArr objectAtIndex:indexPath.section-1]objectAtIndex:indexPath.row] objectForKey:@"cals"]!=nil && [[[myMealArr objectAtIndex:indexPath.section-1]objectAtIndex:indexPath.row] objectForKey:@"cals"]!=[NSNull null])
                {
                  if(  [[[[myMealArr objectAtIndex:indexPath.section-1]objectAtIndex:indexPath.row] objectForKey:@"item_weight"] isEqualToString:@"0"])
                  {
                      calLabel.text=[NSString stringWithFormat:@"%@ cal",@"0"];
   
                  }
                    else
                    {
                        calLabel.text=[NSString stringWithFormat:@"%@ cal",[[[myMealArr objectAtIndex:indexPath.section-1]objectAtIndex:indexPath.row] objectForKey:@"cals"]];
                     }
                }
                
                if(![[self chkNullInputinitWithString:[[[myMealArr objectAtIndex:indexPath.section-1]objectAtIndex:indexPath.row] objectForKey:@"item_weight"]] isEqualToString:@""] &&[[[myMealArr objectAtIndex:indexPath.section-1]objectAtIndex:indexPath.row] objectForKey:@"item_weight"]!=nil && [[[myMealArr objectAtIndex:indexPath.section-1]objectAtIndex:indexPath.row] objectForKey:@"item_weight"]!=[NSNull null])
                {
                    
                    if([selectedFoodWeight isEqualToString:@"gm"])
                    {
                        wtLabel.text=[NSString stringWithFormat:@"%@ g",[[[myMealArr objectAtIndex:indexPath.section-1]objectAtIndex:indexPath.row] objectForKey:@"item_weight"]];
                    }
                    else
                    {
                        wtLabel.text=[NSString stringWithFormat:@"%@ oz",[self gmToOz:[[[myMealArr objectAtIndex:indexPath.section-1]objectAtIndex:indexPath.row] objectForKey:@"item_weight"]]];
                    }
                    
                }
                
            }
        }
        else
        {
            UIView *separatorView=(UIView*)[cell viewWithTag:555];
            if([myMealArr count]>0)
                separatorView.hidden=YES;
            else
                separatorView.hidden=NO;
            UIButton *editBtn=(UIButton*)[cell viewWithTag:1];
            [editBtn addTarget:self action:@selector(showSessionView) forControlEvents:UIControlEventTouchUpInside];
            UILabel *totalcalLabel=(UILabel*)[cell viewWithTag:2];
            totalcalLabel.adjustsFontSizeToFitWidth=YES;
            if([self.previous_activity isEqualToString:@"newPlanner"])
            {
                totalCal=0;
                NSMutableArray *allMealArr=[foodLogObject getAllLunchLog:@"" withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
                if(allMealArr.count>0)
                {
                    for(int j=0;j<allMealArr.count;j++)
                    {
                        int individualTempCal=[[[allMealArr objectAtIndex:j]objectForKey:@"cals"]intValue];
                        totalCal=individualTempCal+totalCal;
                    }
                }

                //totalCal=[foodLogObject getFoodSumIndividualCalorie:@"" withUserProfileID:selectedUserProfileID withDate:logTimeStr];
                
                totalcalLabel.text=[NSString stringWithFormat:@"%d",_myMealTotalCal];
            }
            else
               // totalcalLabel.text=[NSString stringWithFormat:@"%d",[self getTotalCal] ];
                totalcalLabel.text=[NSString stringWithFormat:@"%d",_myMealTotalCal];

        }
        return cell;
    }
    //For Meal SubCategory Table
    else if (tableView.tag==MEALSUBCATEGORY_TABLE_TAG)
    {
        static NSString *simpleTableIdentifier = @"recentFoodCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if(indexPath.row==0)
            totalCalMealSub=0;
        
        UILabel *foodNmLabel=(UILabel*)[cell viewWithTag:1];
        //foodNmLabel.userInteractionEnabled=YES;
        UILabel *descLabel=(UILabel*)[cell viewWithTag:3];
        UILabel *calLabel=(UILabel*)[cell viewWithTag:4];
        UIButton *editBtn=(UIButton *)[cell viewWithTag:2];
        UILabel *wtLabel=(UILabel*)[cell viewWithTag:5];
        foodNmLabel.text=calLabel.text=@"";
        descLabel.text=calLabel.text=@"";
        
        //make them touchable
          UILongPressGestureRecognizer *longRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapAction:)];
        longRecognizer.minimumPressDuration = 3;
        [cell.contentView addGestureRecognizer:longRecognizer];
        
        [cell.contentView.layer setBorderColor:[[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:.5] CGColor]];
        [cell.contentView.layer setBorderWidth:.3f];
        if([self.previous_activity isEqualToString:@"RadialTapp"])
        {
            
            if([[[_selectedFoodArr objectAtIndex:indexPath.row] allKeys] containsObject:@"food_name"])
            {
                if(![[self chkNullInputinitWithString:[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"food_name"]]isEqualToString:@""] &&[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"food_name"]!=[NSNull null])
                {
                    foodNmLabel.text=[NSString stringWithFormat:@"%@",[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"food_name"]];
                }
            }
            else  if([[[_selectedFoodArr objectAtIndex:indexPath.row] allKeys] containsObject:@"item_title"])
            {
                if(![[self chkNullInputinitWithString:[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_title"]]isEqualToString:@""] &&[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_title"]!=[NSNull null])
                {
                    foodNmLabel.text=[NSString stringWithFormat:@"%@",[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_title"]];
                }
            }
            
        }
        else
        {
            
            if([[[_selectedFoodArr objectAtIndex:indexPath.row] allKeys] containsObject:@"food_name"])
            {
                if(![[self chkNullInputinitWithString:[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"food_name"]] isEqualToString:@""])
                {
                    foodNmLabel.text=[NSString stringWithFormat:@"%@",[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"food_name"]];
                }
            }
            else if([[[_selectedFoodArr objectAtIndex:indexPath.row] allKeys] containsObject:@"item_title"])
            {
                if(![[self chkNullInputinitWithString:[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_title"]] isEqualToString:@""])
                    foodNmLabel.text=[NSString stringWithFormat:@"%@",[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_title"]];
            }
        }
        
        if(![[self chkNullInputinitWithString:[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_desc"]] isEqualToString:@""] &&[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_desc"]!=nil && [[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_desc"]!=[NSNull null])
        {
            if([NSString stringWithFormat:@"%@",[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_desc"]].length>30)
                descLabel.text=[NSString stringWithFormat:@"%@",[[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_desc"]substringToIndex:30]];
            else
                descLabel.text=[NSString stringWithFormat:@"%@",[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_desc"] ];
            
        }
        
        if([[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"cals"]!=nil && [[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"cals"]!=[NSNull null])
        {
            if(_isKitchenScaleSync)
            {
            if(_isSelectedFoodScaleItem)
            {
                //Selected Item with Kitchen Scale
                if(selectedIndexPathNormal==indexPath.row)
                {
             //       float resultCal=[[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"gm_cal"]floatValue]*
                    calLabel.text=[NSString stringWithFormat:@"%@ cal",@"0"];
                    totalCalMealSub=totalCalMealSub+0;
                }
                else
                {
                    if([[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_weight"] isEqualToString:@"0"])
                    {
                        calLabel.text=[NSString stringWithFormat:@"%@ cal",@"0"];
                        totalCalMealSub=totalCalMealSub+0;
                    }
                    else
                    {
                        calLabel.text=[NSString stringWithFormat:@"%@ cal",[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"cals"]];
                        totalCalMealSub=totalCalMealSub+[[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"cals"]intValue];
                    }
                }
            }
            else
            {
                if([[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_weight"] isEqualToString:@"0"])
                {
                    calLabel.text=[NSString stringWithFormat:@"%@ cal",@"0"];
                    totalCalMealSub=totalCalMealSub+0;
                }
                else
                {
            calLabel.text=[NSString stringWithFormat:@"%@ cal",[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"cals"]];
                totalCalMealSub=totalCalMealSub+[[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"cals"]intValue];
                }
            }
            }
            else
            {
                if([[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_weight"] isEqualToString:@"0"])
                {
                    calLabel.text=[NSString stringWithFormat:@"%@ cal",@"0"];
                    totalCalMealSub=totalCalMealSub+0;
                }
                else
                {
                    //Selected Item without Kitchen Scale
                    if(selectedIndexPathNormal==indexPath.row)
                    {
                        calLabel.text=[NSString stringWithFormat:@"%@ cal",@"0"];
                        totalCalMealSub=totalCalMealSub+0;
                    }
                    else
                    {
                        calLabel.text=[NSString stringWithFormat:@"%@ cal",[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"cals"]];
                        totalCalMealSub=totalCalMealSub+[[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"cals"]intValue];

                    }
                }
            }

        }
        
        /*NSString *totalcalMealSub=[NSString stringWithFormat:@"%d",totalCalMealSub];
        
        NSMutableAttributedString *mediumAttrString = [[NSMutableAttributedString alloc] initWithString:totalcalMealSub attributes: _attributedTotDict];
        [mediumAttrString appendAttributedString:_LightAttrStringCAL];
        _lblBottomTotalCal.attributedText=mediumAttrString;*/

        if([self.previous_activity isEqualToString:@"NotificationTapped"])
        {
            if(![[self chkNullInputinitWithString:[NSString stringWithFormat:@"%@",[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_weight"]]] isEqualToString:@""] || [[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"cals"] intValue]!=0)
            {
                if([selectedFoodWeight isEqualToString:@"gm"])
                {
                    wtLabel.text=[NSString stringWithFormat:@"%@ g",[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_weight"]];
                }
                else
                {
                    wtLabel.text=[NSString stringWithFormat:@"%@ oz",[self gmToOz:[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_weight"]]];
                }

            }
        }
        else
        {
            NSLog(@"_isKitchenScaleSync====%d,_isSelectedFoodScaleItem===%d",_isKitchenScaleSync,_isSelectedFoodScaleItem);
        if(![[self chkNullInputinitWithString:[NSString stringWithFormat:@"%@",[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_weight"]]] isEqualToString:@""] || [[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"cals"] intValue]!=0)
        {
            if([selectedFoodWeight isEqualToString:@"gm"])
            {
                if(_isKitchenScaleSync)
                {
                if(_isSelectedFoodScaleItem)
                {
                    //Selected Item with Kitchen Scale
                    if(selectedIndexPathNormal==indexPath.row)
                    {
                        //wtLabel.text=[NSString stringWithFormat:@"%@ g",@"0"];
                        wtLabel.text=[NSString stringWithFormat:@"%@ g",[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_weight"]];
                    }
                    else
                    {
                          wtLabel.text=[NSString stringWithFormat:@"%@ g",[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_weight"]];
                    }
                }
                else
                {
                         wtLabel.text=[NSString stringWithFormat:@"%@ g",[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_weight"]];
                }
                }
                else
                {
                    if([[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_weight"] isEqualToString:@"0"])
                    {
                     wtLabel.text=[NSString stringWithFormat:@"%@ g",@"0"];
                    }
                    //Selected Item without Kitchen Scale
                    else
                    {
                        if(selectedIndexPathNormal==indexPath.row)
                        {
                            wtLabel.text=[NSString stringWithFormat:@"%@ g",@"0"];
                        }
                        else
                        {
                          wtLabel.text=[NSString stringWithFormat:@"%@ g",[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_weight"]];
                        }
                    }
                }
            }
            else
            {
                if(_isKitchenScaleSync)
                {
                if(_isSelectedFoodScaleItem)
                {
                    //Selected Item with Kitchen Scale
                    if(selectedIndexPathNormal==indexPath.row)
                    {
                        wtLabel.text=[NSString stringWithFormat:@"%@ oz",@"0"];
                    }
                    else
                    {
                        wtLabel.text=[NSString stringWithFormat:@"%@ oz",[self gmToOz:[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_weight"]]];
                    }
                }
                else
                {
                       wtLabel.text=[NSString stringWithFormat:@"%@ oz",[self gmToOz:[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_weight"]]];
                }
                }
                else
                {
                    if([[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_weight"] isEqualToString:@"0"])
                    {
                        wtLabel.text=[NSString stringWithFormat:@"%@ oz",@"0"];
                    }
                    //Selected Item without Kitchen Scale
                    else
                    {
                        if(selectedIndexPathNormal==indexPath.row)
                        {
                           wtLabel.text=[NSString stringWithFormat:@"%@ oz",@"0"];
                        }
                        else
                        {
                           wtLabel.text=[NSString stringWithFormat:@"%@ oz",[self gmToOz:[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_weight"]]];
                        }
                        
                    }
                }
            }
            
        }
        else
        {
            if([selectedFoodWeight isEqualToString:@"gm"])
            {
                wtLabel.text=[NSString stringWithFormat:@"%@ g",@"0"];
            }
            else
            {
                wtLabel.text=[NSString stringWithFormat:@"%@ oz",@"0"];
            }
        }
        
        }
        
        if([[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"isFavorite"] isEqualToString:@"1"])
        {
            [editBtn setImage:[UIImage imageNamed:@"green-star@3x.png"] forState:UIControlStateNormal];
            //FavFoodVCount++;
        }
        else
        {
            [editBtn setImage:[UIImage imageNamed:@"green-star@3x_outline.png"] forState:UIControlStateNormal];
        }
        
        [editBtn addTarget:self action:@selector(AddFavourite:) forControlEvents:UIControlEventTouchUpInside];
        editBtn.accessibilityHint=[NSString stringWithFormat:@"%@#%@#%@#%ld#%@",[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"isFavMeal"],[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"isFavorite"],[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"id"],indexPath.row,[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item"]];
        
        [cell.contentView.layer setBorderColor:[[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:.5] CGColor]];
        [cell.contentView.layer setBorderWidth:.3f];
        
        // cell.selectedBackgroundView =  customColorView;
        return cell;
        
    }
    
    else
    {
        static NSString *simpleTableIdentifier = @"recentFoodCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        UILabel *foodNmLabel=(UILabel*)[cell viewWithTag:1];
        UILabel *descLabel=(UILabel*)[cell viewWithTag:3];
        UILabel *calLabel=(UILabel*)[cell viewWithTag:4];
        UIButton *editBtn=(UIButton *)[cell viewWithTag:2];
        foodNmLabel.text=calLabel.text=@"";
        descLabel.text=calLabel.text=@"";
        
        [cell.contentView.layer setBorderColor:[[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:.5] CGColor]];
        [cell.contentView.layer setBorderWidth:.3f];
        
        if([[[[myMealArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] allKeys] containsObject:@"food_name"])
        {
            if(![[self chkNullInputinitWithString:[[[myMealArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectForKey:@"food_name"]] isEqualToString:@""]){
                
                foodNmLabel.text=[NSString stringWithFormat:@"%@",[[[myMealArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectForKey:@"food_name"]];
            }
        }
        else if([[[[myMealArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] allKeys] containsObject:@"item_title"])
        {
            if(![[self chkNullInputinitWithString:[[[myMealArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectForKey:@"item_title"]] isEqualToString:@""])
                foodNmLabel.text=[NSString stringWithFormat:@"%@",[[[myMealArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectForKey:@"item_title"]];
        }
        
        
        if(![[self chkNullInputinitWithString:[[[myMealArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectForKey:@"item_desc"]] isEqualToString:@""] &&[[[myMealArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectForKey:@"item_desc"]!=nil && [[[myMealArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectForKey:@"item_desc"]!=[NSNull null])
        {
            if([NSString stringWithFormat:@"%@",[[[myMealArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectForKey:@"item_desc"]].length>30)
                descLabel.text=[NSString stringWithFormat:@"%@",[[[[myMealArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectForKey:@"item_desc"]substringToIndex:30]];
            else
                descLabel.text=[NSString stringWithFormat:@"%@",[[[myMealArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectForKey:@"item_desc"] ];
            
        }
        if([[[myMealArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectForKey:@"cals"]!=nil && [[[myMealArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectForKey:@"cals"]!=[NSNull null])
        {
            calLabel.text=[NSString stringWithFormat:@"%@ cal",[[[myMealArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectForKey:@"cals"]];
        }
        
        // editBtn.hidden=YES;
        
        if(selectedIndexPathNormal==indexPath.row)
        {
            //  [cell setBackgroundColor:[UIColor colorWithRed:84.0/255.0f green:167.0/255.0f blue:115.0/255.0f alpha:1.0f]];
        }
        else{
            //  [cell setBackgroundColor:[UIColor clearColor]];
        }
        
        [cell.contentView.layer setBorderColor:[[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:.5] CGColor]];
        [cell.contentView.layer setBorderWidth:.3f];
        cell.selectedBackgroundView =  customColorView;
        
        return cell;
    }
    return  nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self.view endEditing:YES];
    //For Search Table
    if(tableView.tag==SEARCH_TABLE_TAG)
    {
        
        NSLog(@"%@",[self.allSearchedFoodArr objectAtIndex:indexPath.row]);
        [autoCompleteTableView setHidden:YES];
        autoCompleteTextField.text=[NSString stringWithFormat:@"%@",[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_title"]];
        //APP_CTRL.searchStart=1;
        
        if([self.previous_activity isEqualToString:@"FromPlanner"])
            goBack=1;
        
        NSMutableArray *allFoodID=[NSMutableArray array];
        allFoodID=[masterFoodObj findDuplicateFood];
        
        
        if([[[self.allSearchedFoodArr objectAtIndex:indexPath.row] allKeys] containsObject:@"item_title"])
        {
            if(![[self chkNullInputinitWithString:[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_title"]] isEqualToString:@""])
                masterFoodObj.item_title=[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_title"];
        }
        else if ([[[self.allSearchedFoodArr objectAtIndex:indexPath.row] allKeys] containsObject:@"food_name"])
        {
            if(![[self chkNullInputinitWithString:[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"food_name"]] isEqualToString:@""])
                masterFoodObj.item_title=[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"food_name"];
        }
        
        if(![[self chkNullInputinitWithString:[NSString stringWithFormat:@"%@",[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"cals"]]] isEqualToString:@""])
        {
            masterFoodObj.cals=[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"cals"];
        }
        else
        {
            masterFoodObj.cals=@"0";
        }
        
        if(![[self chkNullInputinitWithString:[NSString stringWithFormat:@"%@",[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_weight"]]] isEqualToString:@""] && [[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_weight"] intValue]!=0)
        {
            masterFoodObj.item_weight=[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_weight"];
        }
        else
        {
            masterFoodObj.item_weight=@"0";
        }
        
           if(![[self chkNullInputinitWithString:[NSString stringWithFormat:@"%@",[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_weight"]]] isEqualToString:@""] && [[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_weight"] intValue]!=0)
        {
            float gm_cal=[[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"cals"]floatValue]/[[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_weight"]floatValue];
            masterFoodObj.item_gm_cal=[NSString stringWithFormat:@"%.1f",gm_cal];
        }
        else
        {
            masterFoodObj.item_gm_cal=[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"cals"];
        }
        masterFoodObj.item_desc=[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_desc"];
        masterFoodObj.serving_size=[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"serving_size"];
        masterFoodObj.livestrong_id=[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item"];
        
        NSString *selectedID=[NSString stringWithFormat:@"%@",[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item"]];
        
        if(![allFoodID containsObject:selectedID])
        {
            [masterFoodObj saveUserFoodData];
        }
        
        _selectedFoodDict=[[NSMutableDictionary alloc]init];
        int selectedFoodID=[foodLogObject getMaxFoodID:selectedUserProfileID];
        NSLog(@"selectedFoodID==%d",selectedFoodID);
   
        selectedFoodID=selectedFoodID+1;
        NSString *strID=[NSString stringWithFormat:@"%d",selectedFoodID];
        
        [_selectedFoodDict setObject:strID forKey:@"id"];
        
        if(![[self chkNullInputinitWithString:self.selectedMealTypeId] isEqualToString:@""])
        {
            [_selectedFoodDict setObject:self.selectedMealTypeId forKey:@"meal_id"];
        }
        else
        {
            [_selectedFoodDict setObject:@"" forKey:@"meal_id"];
        }
        
        [_selectedFoodDict setObject:[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_title"] forKey:@"item_title"];
        [_selectedFoodDict setObject:[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_desc"] forKey:@"item_desc"];
        [_selectedFoodDict setObject:[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"serving_size"] forKey:@"serving_size"];
        [_selectedFoodDict setObject:[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item"] forKey:@"item"];
        
        if(![[self chkNullInputinitWithString:[NSString stringWithFormat:@"%@",[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"cals"]]] isEqualToString:@""])
        {
            [_selectedFoodDict setObject:[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"cals"] forKey:@"cals"];
        }
        else
        {
            [_selectedFoodDict setObject:@"0" forKey:@"cals"];
        }
        
        if(![[self chkNullInputinitWithString:[NSString stringWithFormat:@"%@",[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_weight"]]] isEqualToString:@""] && [[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_weight"] intValue]!=0)
        {
            //  [_selectedFoodDict setObject:[NSString stringWithFormat:@"%@",[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_weight"]] forKey:@"item_weight"];
            [_selectedFoodDict setObject:@"0" forKey:@"item_weight"];
        }
        else
        {
            [_selectedFoodDict setObject:@"0" forKey:@"item_weight"];
        }
        
        if(![[self chkNullInputinitWithString:[NSString stringWithFormat:@"%@",[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_weight"]]] isEqualToString:@""] && [[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_weight"] intValue]!=0)
        {
            float gm_cal=[[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"cals"]floatValue]/[[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_weight"]floatValue];
            [_selectedFoodDict setObject:[NSString stringWithFormat:@"%.1f",gm_cal] forKey:@"gm_cal"];
            }
        else
        {
            [_selectedFoodDict setObject:[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"cals"] forKey:@"gm_cal"];
        }

        
        [_selectedFoodDict setObject:[[self.allSearchedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item"] forKey:@"reference_food_id"];
        
        [_selectedFoodDict setObject:@"0" forKey:@"isFavorite"];
        [_selectedFoodDict setObject:@"0" forKey:@"isFavMeal"];

        if(![self.previous_activity isEqualToString:@"FromPlanner"] && ![self.previous_activity isEqualToString:@"newPlanner"])
        {
            
            totalCalToShow=totalCalToShow+[[_selectedFoodDict objectForKey:@"cals"] intValue];
            
            NSString *totalcal=[NSString stringWithFormat:@"%d",totalCalToShow];
            
            UIFont *mediumFont = [UIFont fontWithName:@"SinkinSans-400regular" size:30];
            NSDictionary *mediumDict = [NSDictionary dictionaryWithObject: mediumFont forKey:NSFontAttributeName];
            NSMutableAttributedString *mediumAttrString = [[NSMutableAttributedString alloc] initWithString:totalcal attributes: mediumDict];
            
            UIFont *LightFont = [UIFont fontWithName:@"SinkinSans-300Light" size:15];
            NSDictionary *LightDict = [NSDictionary dictionaryWithObject:LightFont forKey:NSFontAttributeName];
            NSMutableAttributedString *LightAttrString = [[NSMutableAttributedString alloc]initWithString:@" cal"  attributes:LightDict];
            
            [mediumAttrString appendAttributedString:LightAttrString];
            _lblBottomTotalCal.attributedText=mediumAttrString;
            
        }
        
        [_selectedFoodDictArr addObject:_selectedFoodDict];
        NSLog(@"_selectedFoodDictArr====%@",_selectedFoodDictArr);
        
        NSString *all_log=[[NSUserDefaults standardUserDefaults]objectForKey:@"For_Alldate"];
        
        foodLogObject.log_user_id=[defaults objectForKey:@"user_id"];
        foodLogObject.log_user_profile_id=selectedUserProfileID;
        
        foodLogObject.log_meal_id=self.selectedMealTypeId;
        
        [_selectedFoodArr addObject:_selectedFoodDict];
        
        if([_selectedFoodArr count]>0)
        {
            NSLog(@"_selectedFoodArr==%@",_selectedFoodArr);
            mAppDelegate.selectedFoodDict=nil;
            mAppDelegate.selectedFoodDict=[NSMutableDictionary dictionary];
            mAppDelegate.selectedFoodDict=[_selectedFoodArr lastObject];
            
            NSLog(@"selectedIndexPathNormal==%ld",(long)selectedIndexPathNormal);
            //if(selectedIndexPathNormal<0)
            //{
            _isSelectedFoodScaleItem=YES;
            selectedIndexPathNormal=_selectedFoodArr.count-1;
            selectedIndexPathNormalPrev=selectedIndexPathNormal;
            //}
            
            goBack=1;
            FavFoodVCount=0;
            _tblVw.tag=MEALSUBCATEGORY_TABLE_TAG;
            _tblVw.delegate=self;
            _tblVw.dataSource=self;
            [_tblVw reloadData];
            [_tblVw setHidden:NO];
            
            //[self performSelector:@selector(selfCalculateTotalSubCategoryMeal) withObject:nil afterDelay:3.0];
        }
        
        
        if([all_log isEqualToString:@"1"])
        {
            NSMutableArray *allDates=[[Utility sharedManager]getAllDates];
            
            for(int j=0;j<[allDates count];j++)
            {
                for(int i=0;i<[_selectedFoodArr count];i++)
                {
                    
                    foodLogObject.log_item_title=[[[_selectedFoodArr objectAtIndex:i] objectForKey:@"item_title"]stringByReplacingOccurrencesOfString:@"'" withString:@""];
                    foodLogObject.log_item_desc=[[_selectedFoodArr objectAtIndex:i] objectForKey:@"item_desc"];
                    foodLogObject.log_cals=@"0";//[[_selectedFoodArr objectAtIndex:i] objectForKey:@"cals"];
                    foodLogObject.log_serving_size=[[_selectedFoodArr objectAtIndex:i] objectForKey:@"serving_size"];
                    foodLogObject.log_reference_food_id=[[_selectedFoodArr objectAtIndex:i] objectForKey:@"reference_food_id"];
                    foodLogObject.log_date_added=[self getCurrentDateTime];
                    foodLogObject.log_item_weight=@"0";//[[_selectedFoodArr objectAtIndex:i] objectForKey:@"item_weight"];
                     foodLogObject.log_gm_cal=[[_selectedFoodArr objectAtIndex:i] objectForKey:@"gm_cal"];
                    
                    foodLogObject.log_log_time=[NSString stringWithFormat:@"%@ %@",[allDates objectAtIndex:j],[self getCurrentTime]];
                   // [foodLogObject saveUserFoodDataLog];
                    
                    ////////////////////////////////--CodeAdded7/1/16--/////////////////////////////////////////////////////////////////////////
                    NSMutableArray *arrRefID=[foodLogObject getAllRefID:@"" withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
                    int originalCalVal=0,originalWeightVal=0;
                    NSMutableArray * arrAllFoodLog=[masterFoodObj getAllFoodLog];
                    for(int i=0;i<arrAllFoodLog.count;i++)
                    {
                        if([[[arrAllFoodLog objectAtIndex:i]objectForKey:@"searchID"] isEqualToString:[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item"]])
                        {
                            originalCalVal=[[[arrAllFoodLog objectAtIndex:i]objectForKey:@"cals"] intValue];
                            originalWeightVal=[[[arrAllFoodLog objectAtIndex:i]objectForKey:@"item_weight"] intValue];
                        }
                    }
                    int calVal=[[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"cals"] intValue]+originalCalVal;
                    int weightVal=[[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item_weight"] intValue]+originalWeightVal;
                    NSString *strCalVal=[NSString stringWithFormat:@"%d",calVal];
                    NSString *strWeightVal=[NSString stringWithFormat:@"%d",weightVal];
                    
                    if(![self.previous_activity isEqualToString:@"FromPlanner"] && ![self.previous_activity isEqualToString:@"newPlanner"])
                    {
                    //Check Duplicate Data
                    if([logTimeStr isEqualToString:[[[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"log_time"] componentsSeparatedByString:@" "]objectAtIndex:0]])
                    {
                        NSLog(@"SameDate");
                        if([self.selectedMealTypeId isEqualToString:[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"meal_id"]])
                        {
                            NSLog(@"SameDate & Same MealID");
                            if ([arrRefID containsObject:[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item"]])
                            {
                                NSLog(@"SameDate & Same MealID & Same ID");
                                [foodLogObject updateGramLog:strCalVal withWeight:strWeightVal withDate:foodLogObject.log_log_time foodID:[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"id"] withUserProfileID:selectedUserProfileID];
                            }
                            else
                            {
                                NSLog(@"SameDate & Same MealID & Different ID");
                                [foodLogObject saveUserFoodDataLog];
                            }
                            
                        }
                        else
                        {
                            NSLog(@"SameDate & Different MealID");
                            [foodLogObject saveUserFoodDataLog];
                        }
                        
                    }
                    else
                    {
                        NSLog(@"DifferentDate");
                        [foodLogObject saveUserFoodDataLog];
                        
                    }
                  
                    // APP_CTRL.searchStart=0;
                    }
                }
            }
        }
        
        else
        {
            
            // goBack=0;
            if([self.previous_activity isEqualToString:@"RadialTapp"]  )
            {
                [self notifyEvent:@"YES"];
                
                /*foodPopupcontroller =[self.storyboard instantiateViewControllerWithIdentifier:@"FoodLogPopUp"];
                 CGRect frame = foodPopupcontroller.view.frame;
                 frame.size.height = self.view.frame.size.height;
                 frame.origin.y=self.view.frame.origin.y;
                 foodPopupcontroller.view.frame = frame;
                 [foodPopupcontroller willMoveToParentViewController:self];
                 foodPopupcontroller.delegate=self;
                 foodPopupcontroller.navigateVal=@"food";
                 [self.view addSubview:foodPopupcontroller.view];
                 [self addChildViewController:foodPopupcontroller];
                 [self.view bringSubviewToFront:foodPopupcontroller.view];*/
                //popupShown=1;
                // goBack=0;
            }
            
            else
            {
                if(_selectedFoodArr.count>0)
                {
                    foodLogObject.log_item_title=[[[_selectedFoodArr lastObject] objectForKey:@"item_title"]stringByReplacingOccurrencesOfString:@"'" withString:@""];
                    foodLogObject.log_item_desc=[[_selectedFoodArr lastObject] objectForKey:@"item_desc"];
                    foodLogObject.log_cals=@"0";//[[_selectedFoodArr lastObject] objectForKey:@"cals"];
                    foodLogObject.log_serving_size=[[_selectedFoodArr lastObject] objectForKey:@"serving_size"];
                    foodLogObject.log_reference_food_id=[[_selectedFoodArr lastObject] objectForKey:@"reference_food_id"];
                    foodLogObject.log_date_added=[self getCurrentDateTime];
                    foodLogObject.log_item_weight=@"0";//[[_selectedFoodArr lastObject] objectForKey:@"item_weight"];
                    foodLogObject.log_gm_cal=[[_selectedFoodArr lastObject] objectForKey:@"gm_cal"];

                    foodLogObject.log_log_time=[NSString stringWithFormat:@"%@ %@",logTimeStr,[self getCurrentTime]];
                    if(![self.previous_activity isEqualToString:@"FromPlanner"] && ![self.previous_activity isEqualToString:@"newPlanner"])
                    {
                    [foodLogObject saveUserFoodDataLog];
                    }
                    ////////////////////////////////--CodeAdded7/1/16--/////////////////////////////////////////////////////////////////////////
                   /* NSMutableArray *arrRefID=[foodLogObject getAllRefID:@"" withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
                    int originalCalVal=0,originalWeightVal=0;
                    NSMutableArray * arrAllFoodLog=[masterFoodObj getAllFoodLog];
                    for(int i=0;i<arrAllFoodLog.count;i++)
                    {
                        if([[[arrAllFoodLog objectAtIndex:i]objectForKey:@"searchID"] isEqualToString:[[_selectedFoodArr lastObject] objectForKey:@"item"]])
                        {
                            originalCalVal=[[[arrAllFoodLog objectAtIndex:i]objectForKey:@"cals"] intValue];
                            originalWeightVal=[[[arrAllFoodLog objectAtIndex:i]objectForKey:@"item_weight"] intValue];
                        }
                    }
                    int calVal=[[[_selectedFoodArr lastObject] objectForKey:@"cals"] intValue]+originalCalVal;
                    int weightVal=[[[_selectedFoodArr lastObject] objectForKey:@"item_weight"] intValue]+originalWeightVal;
                    NSString *strCalVal=[NSString stringWithFormat:@"%d",calVal];
                    NSString *strWeightVal=[NSString stringWithFormat:@"%d",weightVal];
                    
                      //Check Duplicate Data
                    if([logTimeStr isEqualToString:[[[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"log_time"] componentsSeparatedByString:@" "]objectAtIndex:0]])
                    {
                        NSLog(@"SameDate");
                        if([self.selectedMealTypeId isEqualToString:[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"meal_id"]])
                        {
                            NSLog(@"SameDate & Same MealID");
                            if ([arrRefID containsObject:[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"item"]])
                            {
                                NSLog(@"SameDate & Same MealID & Same ID");
                                [foodLogObject updateGramLog:strCalVal withWeight:strWeightVal withDate:foodLogObject.log_log_time foodID:[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"id"] withUserProfileID:selectedUserProfileID];
                            }
                            else
                            {
                                NSLog(@"SameDate & Same MealID & Different ID");
                                [foodLogObject saveUserFoodDataLog];
                            }
                            
                        }
                        else
                        {
                            NSLog(@"SameDate & Different MealID");
                            [foodLogObject saveUserFoodDataLog];
                        }
                        
                    }
                    else
                    {
                        NSLog(@"DifferentDate");
                        [foodLogObject saveUserFoodDataLog];
                        
                    }*/
                    
                }
            }
        }
        
        [self.view endEditing:YES];
        autoCompleteTextField.text=@"";
        selectedIndexPathSearch=indexPath.row;
        //APP_CTRL.searchStart=0;
        
        for(int i=0;i<_selectedFoodArr.count;i++)
        {
            if([[[_selectedFoodArr objectAtIndex:i] objectForKey:@"isFavMeal"] isEqualToString:@"1"])
            {
                FavFoodVCount++;
            }
        }
        
        if([_selectedFoodArr count]>0)
        {
            if(FavFoodVCount==_selectedFoodArr.count)
            {
                [_btnTotalFav setImage:[UIImage imageNamed:@"green-star@3x.png"] forState:UIControlStateNormal];
            }
            else
            {
                [_btnTotalFav setImage:[UIImage imageNamed:@"green-star@3x_outline.png"] forState:UIControlStateNormal];
            }
        }
        else
        {
            [_btnTotalFav setImage:[UIImage imageNamed:@"green-star@3x_outline.png"] forState:UIControlStateNormal];
        }
        
        int selectedFoodIDNew=[foodLogObject getMaxFoodID:selectedUserProfileID];
        NSLog(@"selectedFoodIDNew==%d",selectedFoodIDNew);
        NSString *strselectedFoodIDNew=[NSString stringWithFormat:@"%d",selectedFoodIDNew];
        
    if(mAppDelegate.selectedFoodDict)
            [mAppDelegate.selectedFoodDict  setValue:strselectedFoodIDNew forKey:@"id"];
        
         mAppDelegate.prevTotWeight=[self calculateTotalWeightVal];
    }
    //For Recent & Favorite Table
    else if (tableView.tag==RECENT_TABLE_TAG)
    {
        //For Else "MyMeal" Section
        if(![selectedMyMealType isEqualToString:@""])
        {
            if([selectedRecentFav isEqualToString:@"Recent"] || [selectedRecentFav isEqualToString:@"Favorites"])
            {
                if([_recentFoodArray count]>0){
                    
                    mAppDelegate.selectedFoodDict=nil;
                    mAppDelegate.selectedFoodDict=[NSMutableDictionary dictionary];
                    mAppDelegate.selectedFoodDict=[_recentFoodArray objectAtIndex:indexPath.row];
                    
                    //APP_CTRL.searchStart=0;
                    
                    NSLog(@"selectedIndexPathRecent==%ld",(long)selectedIndexPathRecent);
                    if(selectedIndexPathRecent<0)
                    {
                        selectedIndexPathRecent=indexPath.row;
                        selectedIndexPathRecentPrev=selectedIndexPathRecent;
                        
                        //            dispatch_queue_t queue = dispatch_get_global_queue(
                        //                                                               DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                        //            dispatch_async(queue, ^{
                        
                        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
                        formatter1.dateFormat = @"EEEE, MMMM dd, yyyy";
                        NSDate *dateFromString = [formatter1 dateFromString:[[Utility sharedManager] getSelectedDate]];
                        //  NSDate *dateFromString = [formatter1 dateFromString:dateStr];
                        NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc] init];
                        [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
                        logTimeStr= [dateFormatter2 stringFromDate:dateFromString];
                        
                        foodLogObject.log_user_id=[defaults objectForKey:@"user_id"];
                        foodLogObject.log_user_profile_id=selectedUserProfileID;
                        
                        NSMutableArray *arrRefID=[foodLogObject getAllRefID:@"" withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
                        
                        if(self.selectedMealTypeId)
                        {
                            foodLogObject.log_meal_id=self.selectedMealTypeId;
                        }
                        else
                        {
                            foodLogObject.log_meal_id=[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"meal_id"];
                        }
                        
                        if([[[_recentFoodArray objectAtIndex:indexPath.row] allKeys] containsObject:@"item_title"])
                        {
                            foodLogObject.log_item_title=[[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"item_title"]stringByReplacingOccurrencesOfString:@"'" withString:@""];
                        }
                        else  if([[[_recentFoodArray objectAtIndex:indexPath.row] allKeys] containsObject:@"food_name"])
                        {
                            foodLogObject.log_item_title=[[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"food_name"]stringByReplacingOccurrencesOfString:@"'" withString:@""];
                        }
                        [_selectedFoodDict setObject:[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"item_desc"] forKey:@"item_desc"];
                        
                        foodLogObject.log_item_desc=[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"item_desc"];
                        foodLogObject.log_cals=[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"cals"];
                        foodLogObject.log_serving_size=[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"serving_size"];
                        foodLogObject.log_reference_food_id=[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"item"];
                        foodLogObject.log_date_added=[self getCurrentDateTime];
                        foodLogObject.log_item_weight=[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"item_weight"];
                        foodLogObject.log_gm_cal=[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"gm_calorie"];
                        
                        foodLogObject.log_log_time=[NSString stringWithFormat:@"%@ %@",logTimeStr,[self getCurrentTime]];
                        
                        int originalCalVal=0,originalWeightVal=0;
                        NSMutableArray * arrAllFoodLog=[masterFoodObj getAllFoodLog];
                        for(int i=0;i<arrAllFoodLog.count;i++)
                        {
                            if([[[arrAllFoodLog objectAtIndex:i]objectForKey:@"searchID"] isEqualToString:[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"item"]])
                            {
                                originalCalVal=[[[arrAllFoodLog objectAtIndex:i]objectForKey:@"cals"] intValue];
                                originalWeightVal=[[[arrAllFoodLog objectAtIndex:i]objectForKey:@"item_weight"] intValue];
                            }
                        }
                        int calVal=[[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"cals"] intValue]+originalCalVal;
                        int weightVal=[[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"item_weight"] intValue]+originalWeightVal;
                        NSString *strCalVal=[NSString stringWithFormat:@"%d",calVal];
                        NSString *strWeightVal=[NSString stringWithFormat:@"%d",weightVal];
                        
                        //Check Duplicate Data
                        if([logTimeStr isEqualToString:[[[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"log_time"] componentsSeparatedByString:@" "]objectAtIndex:0]])
                        {
                            NSLog(@"SameDate");
                            if([self.selectedMealTypeId isEqualToString:[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"meal_id"]])
                            {
                                NSLog(@"SameDate & Same MealID");
                                if ([arrRefID containsObject:[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"item"]])
                                {
                                    NSLog(@"SameDate & Same MealID & Same ID");
                                    [foodLogObject updateGramLog:strCalVal withWeight:strWeightVal withDate:foodLogObject.log_log_time foodID:[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"id"] withUserProfileID:selectedUserProfileID];
                                }
                                else
                                {
                                    NSLog(@"SameDate & Same MealID & Different ID");
                                /*    if([selectedRecentFav isEqualToString:@"Favorites"])
                                    {
                                        [foodLogObject saveUserFavFoodDataLog];
                                    }
                                    else
                                    {*/
                                    [foodLogObject saveUserFoodDataLog];
                                    //}
                                }
                                
                            }
                            else
                            {
                                NSLog(@"SameDate & Different MealID");
                               /* if([selectedRecentFav isEqualToString:@"Favorites"])
                                {
                                    [foodLogObject saveUserFavFoodDataLog];
                                }
                                else
                                {*/
                                    [foodLogObject saveUserFoodDataLog];
                                //}

                            }
                            
                        }
                        else
                        {
                            NSLog(@"DifferentDate");
                           /* if([selectedRecentFav isEqualToString:@"Favorites"])
                            {
                                [foodLogObject saveUserFavFoodDataLog];
                            }
                            else
                            {*/
                                [foodLogObject saveUserFoodDataLog];
                           // }
                        }
                        
                        //                dispatch_async(dispatch_get_main_queue(), ^{
                        //                    NSLog(@"Complete Save Recent Table");
                        //                   });
                        //        });
                        
                    }
                    else
                    {
                        //For Deselect
                        if(selectedIndexPathRecentPrev==indexPath.row)
                        {
                            mAppDelegate.selectedFoodDict=nil;
                            mAppDelegate.selectedFoodDict=[NSMutableDictionary dictionary];
                            selectedIndexPathRecent=-100000;
                            selectedIndexPathRecentPrev=selectedIndexPathRecent;
                        }
                        else
                        {
                            selectedIndexPathRecent=indexPath.row;
                            selectedIndexPathRecentPrev=selectedIndexPathRecent;
                            
                            //            dispatch_queue_t queue = dispatch_get_global_queue(
                            //                                                               DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                            //            dispatch_async(queue, ^{
                            
                            NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
                            formatter1.dateFormat = @"EEEE, MMMM dd, yyyy";
                            NSDate *dateFromString = [formatter1 dateFromString:[[Utility sharedManager] getSelectedDate]];
                            //  NSDate *dateFromString = [formatter1 dateFromString:dateStr];
                            NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc] init];
                            [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
                            logTimeStr= [dateFormatter2 stringFromDate:dateFromString];
                            
                            foodLogObject.log_user_id=[defaults objectForKey:@"user_id"];
                            foodLogObject.log_user_profile_id=selectedUserProfileID;
                            
                            NSMutableArray *arrRefID=[foodLogObject getAllRefID:@"" withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
                            
                            if(self.selectedMealTypeId)
                            {
                                foodLogObject.log_meal_id=self.selectedMealTypeId;
                            }
                            else
                            {
                                foodLogObject.log_meal_id=[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"meal_id"];
                            }
                            
                            if([[[_recentFoodArray objectAtIndex:indexPath.row] allKeys] containsObject:@"item_title"])
                            {
                                foodLogObject.log_item_title=[[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"item_title"]stringByReplacingOccurrencesOfString:@"'" withString:@""];
                            }
                            else  if([[[_recentFoodArray objectAtIndex:indexPath.row] allKeys] containsObject:@"food_name"])
                            {
                                foodLogObject.log_item_title=[[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"food_name"]stringByReplacingOccurrencesOfString:@"'" withString:@""];
                            }
                            [_selectedFoodDict setObject:[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"item_desc"] forKey:@"item_desc"];
                            
                            foodLogObject.log_item_desc=[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"item_desc"];
                            foodLogObject.log_cals=[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"cals"];
                            foodLogObject.log_serving_size=[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"serving_size"];
                            foodLogObject.log_reference_food_id=[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"item"];
                            foodLogObject.log_date_added=[self getCurrentDateTime];
                            foodLogObject.log_item_weight=[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"item_weight"];
                             foodLogObject.log_gm_cal=[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"gm_calorie"];
                            foodLogObject.log_log_time=[NSString stringWithFormat:@"%@ %@",logTimeStr,[self getCurrentTime]];
                            
                            int originalCalVal=0,originalWeightVal=0;
                            NSMutableArray * arrAllFoodLog=[masterFoodObj getAllFoodLog];
                            for(int i=0;i<arrAllFoodLog.count;i++)
                            {
                                if([[[arrAllFoodLog objectAtIndex:i]objectForKey:@"searchID"] isEqualToString:[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"item"]])
                                {
                                    originalCalVal=[[[arrAllFoodLog objectAtIndex:i]objectForKey:@"cals"] intValue];
                                    originalWeightVal=[[[arrAllFoodLog objectAtIndex:i]objectForKey:@"item_weight"] intValue];
                                }
                            }
                            int calVal=[[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"cals"] intValue]+originalCalVal;
                            int weightVal=[[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"item_weight"] intValue]+originalWeightVal;
                            NSString *strCalVal=[NSString stringWithFormat:@"%d",calVal];
                            NSString *strWeightVal=[NSString stringWithFormat:@"%d",weightVal];
                            
                            
                            //Check Duplicate Data
                            if([logTimeStr isEqualToString:[[[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"log_time"] componentsSeparatedByString:@" "]objectAtIndex:0]])
                            {
                                NSLog(@"SameDate");
                                if([self.selectedMealTypeId isEqualToString:[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"meal_id"]])
                                {
                                    NSLog(@"SameDate & Same MealID");
                                    if ([arrRefID containsObject:[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"item"]])
                                    {
                                        NSLog(@"SameDate & Same MealID & Same ID");
                                        [foodLogObject updateGramLog:strCalVal withWeight:strWeightVal withDate:foodLogObject.log_log_time foodID:[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"id"] withUserProfileID:selectedUserProfileID];
                                    }
                                    else
                                    {
                                        NSLog(@"SameDate & Same MealID & Different ID");
                                        [foodLogObject saveUserFoodDataLog];
                                    }
                                    
                                }
                                else
                                {
                                    NSLog(@"SameDate & Different MealID");
                                    [foodLogObject saveUserFoodDataLog];
                                }
                                
                            }
                            else
                            {
                                NSLog(@"DifferentDate");
                                [foodLogObject saveUserFoodDataLog];
                                
                            }
  
                                         
                            //                dispatch_async(dispatch_get_main_queue(), ^{
                            //                    NSLog(@"Complete Save Recent Table");
                            //                   });
                            //        });
                            
                        }
                    }
                    
                    NSLog(@"selectedMealTypeId====%@",self.selectedMealTypeId);
                    
                    if([selectedRecentFav isEqualToString:@"Recent"])
                        _recentFoodArray=[foodLogObject getAllFoodLog:selectedUserProfileID ];
                    else if([selectedRecentFav isEqualToString:@"Favorites"])
                    {
                      /*  if(![[self chkNullInputinitWithString:self.selectedMealTypeId] isEqualToString:@""])
                        {
                            _recentFoodArray=[foodLogObject getAllFavoriteFoodLog:self.selectedMealTypeId withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
                        }
                        else
                        {*/
                           // _recentFoodArray=[foodLogObject getAllFavoriteFoodLog:@"" withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
                        _recentFoodArray=[favFoodLogObj getAllFavoriteFoodLog:@"" withSelectedDate:logTimeStr withUserId:selectedUserProfileID];

                        //}
                    }
                    
                    [tableView reloadData];
                    [self refreshViewDropdownView];
                    
                    if([self.previous_activity isEqualToString:@"RadialTapp"]||![selectedMyMealType isEqualToString:@""] )
                    {
                        _selectedFoodArr=[foodLogObject getAllLunchLog:self.selectedMealTypeId  withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
                        
                        FavFoodVCount=0;
                        if([_selectedFoodArr count]>0)
                        {
                            for(int i=0;i<_selectedFoodArr.count;i++)
                            {
                                if([[[_selectedFoodArr objectAtIndex:i] objectForKey:@"isFavMeal"] isEqualToString:@"1"])
                                {
                                    FavFoodVCount++;
                                }
                            }
                            if(FavFoodVCount==_selectedFoodArr.count)
                            {
                                [_btnTotalFav setImage:[UIImage imageNamed:@"green-star@3x.png"] forState:UIControlStateNormal];
                            }
                            else
                            {
                                [_btnTotalFav setImage:[UIImage imageNamed:@"green-star@3x_outline.png"] forState:UIControlStateNormal];
                            }
                            
                            _tblVw.tag=MEALSUBCATEGORY_TABLE_TAG;
                            _tblVw.hidden=NO;
                            _tblVw.delegate=self;
                            _tblVw.dataSource=self;
                            [_tblVw reloadData];
                            
                            //[self performSelector:@selector(selfCalculateTotalSubCategoryMeal) withObject:nil afterDelay:3.0];
                        }
                        else
                        {
                            FavFoodVCount=0;
                            [_btnTotalFav setImage:[UIImage imageNamed:@"green-star@3x_outline.png"] forState:UIControlStateNormal];
                            _tblVw.hidden=YES;
                        }
                        
                        goBack=1;
                        selectedRecentFood=1;
                        
                        /*   if(![self.previous_activity isEqualToString:@"FromPlanner"] && ![self.previous_activity isEqualToString:@"newPlanner"])
                         {
                         [self notifyEvent:@"YES"];
                         }*/
                        /* foodPopupcontroller =[self.storyboard instantiateViewControllerWithIdentifier:@"FoodLogPopUp"];
                         CGRect frame = foodPopupcontroller.view.frame;
                         frame.size.height = self.view.frame.size.height;
                         frame.origin.y=self.view.frame.origin.y;
                         foodPopupcontroller.view.frame = frame;
                         [foodPopupcontroller willMoveToParentViewController:self];
                         foodPopupcontroller.delegate=self;
                         foodPopupcontroller.navigateVal=@"food";
                         [self.view addSubview:foodPopupcontroller.view];
                         [self addChildViewController:foodPopupcontroller];
                         [self.view bringSubviewToFront:foodPopupcontroller.view];*/
                        // popupShown=1;
                        // goBack=0;
                    }
                    else
                    {
                        if([_recentFoodArray count ]>0 ){
                            _selectedFoodDict=[[NSMutableDictionary alloc]init];
                            
                            if([[[_recentFoodArray objectAtIndex:indexPath.row] allKeys] containsObject:@"item_title"])
                            {
                                [_selectedFoodDict setObject:[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"item_title"] forKey:@"item_title"];
                            }
                            else  if([[[_recentFoodArray objectAtIndex:indexPath.row] allKeys] containsObject:@"food_name"])
                            {
                                [_selectedFoodDict setObject:[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"food_name"] forKey:@"food_name"];
                            }
                            
                            [_selectedFoodDict setObject:[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"item_desc"] forKey:@"item_desc"];
                            [_selectedFoodDict setObject:[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"serving_size"] forKey:@"serving_size"];
                            [_selectedFoodDict setObject:[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"cals"] forKey:@"cals"];
                            
                            if([[[_recentFoodArray objectAtIndex:indexPath.row] allKeys] containsObject:@"item"])
                            {
                                [_selectedFoodDict setObject:[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"item"] forKey:@"item"];
                            }
                            
                            if([[[_recentFoodArray objectAtIndex:indexPath.row] allKeys] containsObject:@"reference_food_id"])
                            {
                                [_selectedFoodDict setObject:[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"item"] forKey:@"reference_food_id"];
                            }
                            
                            if(![[self chkNullInputinitWithString:[NSString stringWithFormat:@"%@",[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"item_weight"]]] isEqualToString:@""] && [[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"item_weight"] intValue]!=0)
                            {
                                [_selectedFoodDict setObject:[NSString stringWithFormat:@"%@",[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"item_weight"]] forKey:@"item_weight"];
                            }
                            else
                            {
                                [_selectedFoodDict setObject:@"0" forKey:@"item_weight"];
                            }
                              [_selectedFoodDict setObject:[NSString stringWithFormat:@"%@",[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"gm_calorie"]] forKey:@"gm_calorie"];
                          
                            [_selectedFoodDictArr addObject:_selectedFoodDict];
                        }
                        [mymealView setHidden:NO];
                        saveRecentFood=1;
                        FavFoodVCount=0;
                        _tblVw.tag=MEALSUBCATEGORY_TABLE_TAG;
                        _tblVw.hidden=NO;
                        //                _tblVw.delegate=self;
                        //                _tblVw.dataSource=self;
                        [_tblVw reloadData];
                        
                        goBack=0;
                        logBtn.userInteractionEnabled=YES;
                        selectedRecentFood=1;
                        
                        //[self performSelector:@selector(selfCalculateTotalSubCategoryMeal) withObject:nil afterDelay:3.0];
                        /*if(![self.previous_activity isEqualToString:@"FromPlanner"] && ![self.previous_activity isEqualToString:@"newPlanner"])
                         {
                         [self notifyEvent:@"YES"];
                         }
                         
                         UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"Measupro"
                         message:@"Would you like to log this meal?"
                         delegate:self
                         cancelButtonTitle:@"No"
                         
                         otherButtonTitles:@"Yes", nil];
                         myAlert.delegate=self;
                         myAlert.tag=999;
                         [myAlert show];*/
                        
                    }
                }
            }
        }
        
    }
    //For Meal SubCategory Table
    else if (tableView.tag==MEALSUBCATEGORY_TABLE_TAG)
    {
        
        mAppDelegate.selectedFoodDict=nil;
        mAppDelegate.selectedFoodDict=[NSMutableDictionary dictionary];
        mAppDelegate.selectedFoodDict=[_selectedFoodArr objectAtIndex:indexPath.row];
        
        NSLog(@"selectedIndexPathNormal==%ld",(long)selectedIndexPathNormal);
        if(selectedIndexPathNormal<0)
        {
            _isSelectedFoodScaleItem=YES;
            selectedIndexPathNormal=indexPath.row;
            selectedIndexPathNormalPrev=selectedIndexPathNormal;
        }
        else
        {
            //For Deselect
            if(selectedIndexPathNormalPrev==indexPath.row)
            {
                _isSelectedFoodScaleItem=NO;
                mAppDelegate.selectedFoodDict=nil;
                mAppDelegate.selectedFoodDict=[NSMutableDictionary dictionary];
                selectedIndexPathNormal=-100000;
                selectedIndexPathNormalPrev=selectedIndexPathNormal;
            }
            else
            {
                _isSelectedFoodScaleItem=YES;
                selectedIndexPathNormal=indexPath.row;
                selectedIndexPathNormalPrev=selectedIndexPathNormal;
            }
        }
 
        //mAppDelegate.prevTotWeight=[self calculateTotalWeightVal];
       [tableView reloadData];
        
        if([self.allSearchedFoodArr count]>0 && self.selected_session == nil)
        {
            if(![self.previous_activity isEqualToString:@"RadialTapp"] && ![self.previous_activity isEqualToString:@"FromPlanner"] && ![self.previous_activity isEqualToString:@"newPlanner"])
            {
                [self notifyEvent:@"YES"];
            }
        }
        
        mAppDelegate.prevTotWeight=[self calculateTotalWeightVal];
      /*   int breakfastCal=0;
        for (int k=0;k<_selectedFoodArr.count;k++)
        {
            int breakfastTempCal=[[[_selectedFoodArr objectAtIndex:k]objectForKey:@"cals"]intValue];
            breakfastCal=breakfastTempCal+breakfastCal;
        }
        NSLog(@"calculating cal=%d",breakfastCal);*/
    }
    //For Recent &Favorite Meal Table
    else if (tableView.tag==FAV_MEALSUBCAT_TABLE_TAG)
    {
        //        dispatch_queue_t queue = dispatch_get_global_queue(
        //                                                           DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //        dispatch_async(queue, ^{
        
        
        
        //            dispatch_async(dispatch_get_main_queue(), ^{
        //                NSLog(@"Complete Save Fav Sub Table");
        //            });
        //        });
        //For Else "MyMeal" Section
        if(![selectedMyMealType isEqualToString:@""])
        {
            if([selectedRecentFav isEqualToString:@"Recent"] || [selectedRecentFav isEqualToString:@"Favorites"])
            {
                
                APP_CTRL.searchStart=0;
                
                if(selectedIndexPathFav<0)
                {
                    
                    selectedIndexPathFav=indexPath.section*10000+indexPath.row;
                    selectedIndexPathFavPrev=selectedIndexPathFav;
                    
                    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
                    formatter1.dateFormat = @"EEEE, MMMM dd, yyyy";
                    NSDate *dateFromString = [formatter1 dateFromString:[[Utility sharedManager] getSelectedDate]];
                    //  NSDate *dateFromString = [formatter1 dateFromString:dateStr];
                    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc] init];
                    [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
                    logTimeStr= [dateFormatter2 stringFromDate:dateFromString];
                    
                    NSMutableArray *arrRefID=[foodLogObject getAllRefID:@"" withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
                    
                    NSLog(@"===%@",[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]);
                    
                    for(int i=0;i<[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]count];i++)
                    {
                        foodLogObject.log_user_id=[defaults objectForKey:@"user_id"];
                        foodLogObject.log_user_profile_id=selectedUserProfileID;
                        
                        if(self.selectedMealTypeId)
                        {
                            foodLogObject.log_meal_id=self.selectedMealTypeId;
                        }
                        else
                        {
                            foodLogObject.log_meal_id=[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"meal_id"];
                        }
                        
                        if([[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] allKeys] containsObject:@"item_title"])
                        {
                            foodLogObject.log_item_title=[[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"item_title"]stringByReplacingOccurrencesOfString:@"'" withString:@""];
                        }
                        else  if([[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] allKeys] containsObject:@"food_name"])
                        {
                            foodLogObject.log_item_title=[[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"food_name"]stringByReplacingOccurrencesOfString:@"'" withString:@""];
                        }
                        
                        foodLogObject.log_item_desc=[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"item_desc"];
                        foodLogObject.log_cals=[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i]objectForKey:@"cals"];
                        foodLogObject.log_serving_size=[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"serving_size"];
                        foodLogObject.log_reference_food_id=[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"item"];
                        foodLogObject.log_date_added=[self getCurrentDateTime];
                        foodLogObject.log_item_weight=[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i]objectForKey:@"item_weight"];
                        foodLogObject.log_item_weight=[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i]objectForKey:@"item_weight"];
                        foodLogObject.log_gm_cal=[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i]objectForKey:@"gm_calorie"];
                        foodLogObject.log_log_time=[NSString stringWithFormat:@"%@ %@",logTimeStr,[self getCurrentTime]];
                        
                        
                        int originalCalVal=0,originalWeightVal=0;
                        NSMutableArray * arrAllFoodLog=[masterFoodObj getAllFoodLog];
                        for(int j=0;j<arrAllFoodLog.count;j++)
                        {
                            if([[[arrAllFoodLog objectAtIndex:j]objectForKey:@"searchID"] isEqualToString:[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"item"]])
                            {
                                originalCalVal=[[[arrAllFoodLog objectAtIndex:j]objectForKey:@"cals"] intValue];
                                originalWeightVal=[[[arrAllFoodLog objectAtIndex:j]objectForKey:@"item_weight"] intValue];
                            }
                        }
                        int calVal=[[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"cals"] intValue]+originalCalVal;
                        int weightVal=[[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i]objectForKey:@"item_weight"] intValue]+originalWeightVal;
                        NSString *strCalVal=[NSString stringWithFormat:@"%d",calVal];
                        NSString *strWeightVal=[NSString stringWithFormat:@"%d",weightVal];
                        
                        //Check Duplicate Data
                        if([logTimeStr isEqualToString:[[[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"log_time"] componentsSeparatedByString:@" "]objectAtIndex:0]])
                        {
                            NSLog(@"SameDate");
                            if([self.selectedMealTypeId isEqualToString:[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"meal_id"]])
                            {
                                NSLog(@"SameDate & Same MealID");
                                if ([arrRefID containsObject:[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"item"]])
                                {
                                    NSLog(@"SameDate & Same MealID & Same ID");
                                    [foodLogObject updateGramLog:strCalVal withWeight:strWeightVal withDate:foodLogObject.log_log_time foodID:[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"id"] withUserProfileID:selectedUserProfileID];
                                }
                                else
                                {
                                    NSLog(@"SameDate & Same MealID & Different ID");
                                    [foodLogObject saveUserFoodDataLog];
                                }
                                
                            }
                            else
                            {
                                NSLog(@"SameDate & Different MealID");
                                [foodLogObject saveUserFoodDataLog];
                            }
                            
                        }
                        else
                        {
                            NSLog(@"DifferentDate");
                            [foodLogObject saveUserFoodDataLog];
                            
                        }
                    }
                }
                else
                {
                    int selectedIndexPathFavPrevRow=selectedIndexPathFavPrev%10000;
                    int selectedIndexPathFavPrevSec=selectedIndexPathFavPrev/10000;
                    //For Deselect
                    if(selectedIndexPathFavPrevRow==indexPath.row && selectedIndexPathFavPrevSec==indexPath.section)
                    {
                        //                mAppDelegate.selectedFoodDict=nil;
                        //                mAppDelegate.selectedFoodDict=[NSMutableDictionary dictionary];
                        selectedIndexPathFav=-100000;
                        selectedIndexPathFavPrev=selectedIndexPathFav;
                    }
                    else
                    {
                        selectedIndexPathFav=indexPath.section*10000+indexPath.row;
                        selectedIndexPathFavPrev=selectedIndexPathFav;
                        
                        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
                        formatter1.dateFormat = @"EEEE, MMMM dd, yyyy";
                        NSDate *dateFromString = [formatter1 dateFromString:[[Utility sharedManager] getSelectedDate]];
                        //  NSDate *dateFromString = [formatter1 dateFromString:dateStr];
                        NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc] init];
                        [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
                        logTimeStr= [dateFormatter2 stringFromDate:dateFromString];
                        
                        NSMutableArray *arrRefID=[foodLogObject getAllRefID:@"" withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
                        for(int i=0;i<[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]count];i++)
                        {
                            
                            foodLogObject.log_user_id=[defaults objectForKey:@"user_id"];
                            foodLogObject.log_user_profile_id=selectedUserProfileID;
                            
                            if(self.selectedMealTypeId)
                            {
                                foodLogObject.log_meal_id=self.selectedMealTypeId;
                            }
                            else
                            {
                                foodLogObject.log_meal_id=[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"meal_id"];
                            }
                            
                            if([[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] allKeys] containsObject:@"item_title"])
                            {
                                foodLogObject.log_item_title=[[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"item_title"]stringByReplacingOccurrencesOfString:@"'" withString:@""];
                            }
                            else  if([[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] allKeys] containsObject:@"food_name"])
                            {
                                foodLogObject.log_item_title=[[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"food_name"]stringByReplacingOccurrencesOfString:@"'" withString:@""];
                            }
                            
                            foodLogObject.log_item_desc=[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"item_desc"];
                            foodLogObject.log_cals=[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"cals"];
                            foodLogObject.log_serving_size=[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"serving_size"];
                            foodLogObject.log_reference_food_id=[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"item"];
                            foodLogObject.log_date_added=[self getCurrentDateTime];
                            foodLogObject.log_item_weight=[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"item_weight"];
                            foodLogObject.log_gm_cal=[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i]objectForKey:@"gm_calorie"];

                            foodLogObject.log_log_time=[NSString stringWithFormat:@"%@ %@",logTimeStr,[self getCurrentTime]];
                            
                            
                            int originalCalVal=0,originalWeightVal=0;
                            NSMutableArray * arrAllFoodLog=[masterFoodObj getAllFoodLog];
                            for(int k=0;k<arrAllFoodLog.count;k++)
                            {
                                if([[[arrAllFoodLog objectAtIndex:k]objectForKey:@"searchID"] isEqualToString:[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"item"]])
                                {
                                    originalCalVal=[[[arrAllFoodLog objectAtIndex:k]objectForKey:@"cals"] intValue];
                                    originalWeightVal=[[[arrAllFoodLog objectAtIndex:k]objectForKey:@"item_weight"] intValue];
                                }
                            }
                            int calVal=[[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"cals"] intValue]+originalCalVal;
                            int weightVal=[[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"item_weight"] intValue]+originalWeightVal;
                            NSString *strCalVal=[NSString stringWithFormat:@"%d",calVal];
                            NSString *strWeightVal=[NSString stringWithFormat:@"%d",weightVal];
                            
                            //Check Duplicate Data
                            if([logTimeStr isEqualToString:[[[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"log_time"] componentsSeparatedByString:@" "]objectAtIndex:0]])
                            {
                                NSLog(@"SameDate");
                                if([self.selectedMealTypeId isEqualToString:[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"meal_id"]])
                                {
                                    NSLog(@"SameDate & Same MealID");
                                    if ([arrRefID containsObject:[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"item"]])
                                    {
                                        NSLog(@"SameDate & Same MealID & Same ID");
                                        [foodLogObject updateGramLog:strCalVal withWeight:strWeightVal withDate:foodLogObject.log_log_time foodID:[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"id"] withUserProfileID:selectedUserProfileID];
                                    }
                                    else
                                    {
                                        NSLog(@"SameDate & Same MealID & Different ID");
                                        [foodLogObject saveUserFoodDataLog];
                                    }
                                    
                                }
                                else
                                {
                                    NSLog(@"SameDate & Different MealID");
                                    [foodLogObject saveUserFoodDataLog];
                                }
                                
                            }
                            else
                            {
                                NSLog(@"DifferentDate");
                                [foodLogObject saveUserFoodDataLog];
                                
                            }
                            
                        }
                    }
                }
                
                if([selectedRecentFav isEqualToString:@"Recent"])
                {
                    [self createRecentMealArr];
                }
                else if([selectedRecentFav isEqualToString:@"Favorites"])
                {
                    [self createFavMealArr];
                }
                
                [tableView reloadData];
                [self refreshViewDropdownView];
            }
        }
    }
    else if (tableView.tag==FAV_MEALDROPDOWN_TABLE_TAG)
    {
        //For Else "MyMeal" Section
        if(![selectedMyMealType isEqualToString:@""])
        {
            if([selectedRecentFav isEqualToString:@"Recent"] || [selectedRecentFav isEqualToString:@"Favorites"])
            {
                
                APP_CTRL.searchStart=0;
                
                if(selectedIndexPathDropDownMeal<0)
                {
                    selectedIndexPathDropDownMeal=indexPath.row;
                    selectedIndexPathDropDownMealPrev=selectedIndexPathDropDownMeal;
                    
                    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
                    formatter1.dateFormat = @"EEEE, MMMM dd, yyyy";
                    NSDate *dateFromString = [formatter1 dateFromString:[[Utility sharedManager] getSelectedDate]];
                    //  NSDate *dateFromString = [formatter1 dateFromString:dateStr];
                    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc] init];
                    [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
                    logTimeStr= [dateFormatter2 stringFromDate:dateFromString];
                    
                    NSMutableArray *arrRefID=[foodLogObject getAllRefID:@"" withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
                    
                    NSLog(@"===%@",[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]);
                    
                    for(int i=0;i<[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]count];i++)
                    {
                        foodLogObject.log_user_id=[defaults objectForKey:@"user_id"];
                        foodLogObject.log_user_profile_id=selectedUserProfileID;
                        
                        if(self.selectedMealTypeId)
                        {
                            foodLogObject.log_meal_id=self.selectedMealTypeId;
                        }
                        else
                        {
                            foodLogObject.log_meal_id=[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"meal_id"];
                        }
                        
                        if([[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] allKeys] containsObject:@"item_title"])
                        {
                            foodLogObject.log_item_title=[[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"item_title"]stringByReplacingOccurrencesOfString:@"'" withString:@""];
                        }
                        else  if([[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] allKeys] containsObject:@"food_name"])
                        {
                            foodLogObject.log_item_title=[[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"food_name"]stringByReplacingOccurrencesOfString:@"'" withString:@""];
                        }
                        
                        foodLogObject.log_item_desc=[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"item_desc"];
                        foodLogObject.log_cals=[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i]objectForKey:@"cals"];
                        foodLogObject.log_serving_size=[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"serving_size"];
                        foodLogObject.log_reference_food_id=[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"item"];
                        foodLogObject.log_date_added=[self getCurrentDateTime];
                        foodLogObject.log_item_weight=[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i]objectForKey:@"item_weight"];
                        foodLogObject.log_gm_cal=[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i]objectForKey:@"gm_calorie"];

                        foodLogObject.log_log_time=[NSString stringWithFormat:@"%@ %@",logTimeStr,[self getCurrentTime]];
                        
                        
                        int originalCalVal=0,originalWeightVal=0;
                        NSMutableArray * arrAllFoodLog=[masterFoodObj getAllFoodLog];
                        for(int j=0;j<arrAllFoodLog.count;j++)
                        {
                            if([[[arrAllFoodLog objectAtIndex:j]objectForKey:@"searchID"] isEqualToString:[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"item"]])
                            {
                                originalCalVal=[[[arrAllFoodLog objectAtIndex:j]objectForKey:@"cals"] intValue];
                                originalWeightVal=[[[arrAllFoodLog objectAtIndex:j]objectForKey:@"item_weight"] intValue];
                            }
                        }
                        int calVal=[[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"cals"] intValue]+originalCalVal;
                        int weightVal=[[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i]objectForKey:@"item_weight"] intValue]+originalWeightVal;
                        NSString *strCalVal=[NSString stringWithFormat:@"%d",calVal];
                        NSString *strWeightVal=[NSString stringWithFormat:@"%d",weightVal];
                        
                        //Check Duplicate Data
                        if([logTimeStr isEqualToString:[[[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"log_time"] componentsSeparatedByString:@" "]objectAtIndex:0]])
                        {
                            NSLog(@"SameDate");
                            if([self.selectedMealTypeId isEqualToString:[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"meal_id"]])
                            {
                                NSLog(@"SameDate & Same MealID");
                                if ([arrRefID containsObject:[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"item"]])
                                {
                                    NSLog(@"SameDate & Same MealID & Same ID");
                                    [foodLogObject updateGramLog:strCalVal withWeight:strWeightVal withDate:foodLogObject.log_log_time foodID:[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"id"] withUserProfileID:selectedUserProfileID];
                                }
                                else
                                {
                                    NSLog(@"SameDate & Same MealID & Different ID");
                                    [foodLogObject saveUserFoodDataLog];
                                }
                                
                            }
                            else
                            {
                                NSLog(@"SameDate & Different MealID");
                                [foodLogObject saveUserFoodDataLog];
                            }
                            
                        }
                        else
                        {
                            NSLog(@"DifferentDate");
                            [foodLogObject saveUserFoodDataLog];
                            
                        }
                    }
                }
                else
                {
                    //For Deselect
                    if(selectedIndexPathDropDownMealPrev==indexPath.row)
                    {
                        //                mAppDelegate.selectedFoodDict=nil;
                        //                mAppDelegate.selectedFoodDict=[NSMutableDictionary dictionary];
                        selectedIndexPathDropDownMeal=-100000;
                        selectedIndexPathDropDownMealPrev=selectedIndexPathDropDownMeal;
                    }
                    else
                    {
                        selectedIndexPathDropDownMeal=indexPath.row;
                        selectedIndexPathDropDownMealPrev=selectedIndexPathDropDownMeal;
                        
                        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
                        formatter1.dateFormat = @"EEEE, MMMM dd, yyyy";
                        NSDate *dateFromString = [formatter1 dateFromString:[[Utility sharedManager] getSelectedDate]];
                        //  NSDate *dateFromString = [formatter1 dateFromString:dateStr];
                        NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc] init];
                        [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
                        logTimeStr= [dateFormatter2 stringFromDate:dateFromString];
                        
                        NSMutableArray *arrRefID=[foodLogObject getAllRefID:@"" withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
                        for(int i=0;i<[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]count];i++)
                        {
                            foodLogObject.log_user_id=[defaults objectForKey:@"user_id"];
                            foodLogObject.log_user_profile_id=selectedUserProfileID;
                            
                            if(self.selectedMealTypeId)
                            {
                                foodLogObject.log_meal_id=self.selectedMealTypeId;
                            }
                            else
                            {
                                foodLogObject.log_meal_id=[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"meal_id"];
                            }
                            
                            if([[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] allKeys] containsObject:@"item_title"])
                            {
                                foodLogObject.log_item_title=[[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"item_title"]stringByReplacingOccurrencesOfString:@"'" withString:@""];
                            }
                            else  if([[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] allKeys] containsObject:@"food_name"])
                            {
                                foodLogObject.log_item_title=[[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"food_name"]stringByReplacingOccurrencesOfString:@"'" withString:@""];
                            }
                            
                            foodLogObject.log_item_desc=[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"item_desc"];
                            foodLogObject.log_cals=[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"cals"];
                            foodLogObject.log_serving_size=[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"serving_size"];
                            foodLogObject.log_reference_food_id=[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"item"];
                            foodLogObject.log_date_added=[self getCurrentDateTime];
                            foodLogObject.log_item_weight=[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"item_weight"];
                            foodLogObject.log_gm_cal=[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i]objectForKey:@"gm_calorie"];
                            foodLogObject.log_log_time=[NSString stringWithFormat:@"%@ %@",logTimeStr,[self getCurrentTime]];
                            
                            int originalCalVal=0,originalWeightVal=0;
                            NSMutableArray * arrAllFoodLog=[masterFoodObj getAllFoodLog];
                            for(int k=0;k<arrAllFoodLog.count;k++)
                            {
                                if([[[arrAllFoodLog objectAtIndex:k]objectForKey:@"searchID"] isEqualToString:[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"item"]])
                                {
                                    originalCalVal=[[[arrAllFoodLog objectAtIndex:k]objectForKey:@"cals"] intValue];
                                    originalWeightVal=[[[arrAllFoodLog objectAtIndex:k]objectForKey:@"item_weight"] intValue];
                                }
                            }
                            int calVal=[[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"cals"] intValue]+originalCalVal;
                            int weightVal=[[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"item_weight"] intValue]+originalWeightVal;
                            NSString *strCalVal=[NSString stringWithFormat:@"%d",calVal];
                            NSString *strWeightVal=[NSString stringWithFormat:@"%d",weightVal];
                            
                            //Check Duplicate Data
                            if([logTimeStr isEqualToString:[[[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"log_time"] componentsSeparatedByString:@" "]objectAtIndex:0]])
                            {
                                NSLog(@"SameDate");
                                if([self.selectedMealTypeId isEqualToString:[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"meal_id"]])
                                {
                                    NSLog(@"SameDate & Same MealID");
                                    if ([arrRefID containsObject:[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"item"]])
                                    {
                                        NSLog(@"SameDate & Same MealID & Same ID");
                                        [foodLogObject updateGramLog:strCalVal withWeight:strWeightVal withDate:foodLogObject.log_log_time foodID:[[[[favMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectAtIndex:i] objectForKey:@"id"] withUserProfileID:selectedUserProfileID];
                                    }
                                    else
                                    {
                                        NSLog(@"SameDate & Same MealID & Different ID");
                                        [foodLogObject saveUserFoodDataLog];
                                    }
                                    
                                }
                                else
                                {
                                    NSLog(@"SameDate & Different MealID");
                                    [foodLogObject saveUserFoodDataLog];
                                }
                                
                            }
                            else
                            {
                                NSLog(@"DifferentDate");
                                [foodLogObject saveUserFoodDataLog];
                                
                            }
                            
                        }
                    }
                }
                
                ////////////////////////////////////////////////////////////////////////////////////////////////
                
                if([selectedRecentFav isEqualToString:@"Recent"])
                {
                    favMealArr=[NSMutableArray array];
                    favMealTitleArr=[NSMutableArray array];
                    favMealTitleStr=@"";
                    
                    NSMutableArray *arrRecentDate=[foodLogObject getUniqueRecentDate:selectedUserProfileID withMealID:self.selectedMealTypeId];
                    NSLog(@"arrRecentDate==%@",arrRecentDate);
                    
                    NSMutableArray *breakfastTitleFinalArr =[NSMutableArray array];
                    NSMutableArray *breakfastMealFinalArr =[NSMutableArray array];
                    for(int i=0;i<arrRecentDate.count;i++)
                    {
                        NSMutableArray *breakfastMealArr=[foodLogObject getRecentMealFoodLog:self.selectedMealTypeId withSelectedDate:[arrRecentDate objectAtIndex:i] withUserId:selectedUserProfileID];
                        
                        if(breakfastMealArr.count>0)
                        {
                            NSMutableArray *breakfastTitleArr =[NSMutableArray array];
                            
                            NSString *breakfastTitleStr=@"";
                            for(int i=0;i<breakfastMealArr.count;i++)
                            {
                                [breakfastTitleArr addObject:[[breakfastMealArr objectAtIndex:i]objectForKey:@"food_name"]];
                            }
                            breakfastTitleStr = [breakfastTitleArr componentsJoinedByString:@" , "];
                            [breakfastTitleFinalArr addObject:breakfastTitleStr];
                            
                            [breakfastMealFinalArr addObject:breakfastMealArr];
                        }
                        
                    }
                    
                    if(breakfastMealFinalArr.count>0)
                    {
                        [favMealTitleArr addObject:breakfastTitleFinalArr];
                        [favMealArr addObject:breakfastMealFinalArr];
                    }
                    
                }
                else if([selectedRecentFav isEqualToString:@"Favorites"])
                {
                    favMealArr=[NSMutableArray array];
                    favMealTitleArr=[NSMutableArray array];
                    favMealTitleStr=@"";
                    
                    //NSMutableArray *arrFavDate=[foodLogObject getUniqueFavDate:selectedUserProfileID withMealID:self.selectedMealTypeId];
                    NSMutableArray *arrFavDate=[favMealLogObj getUniqueFavDate:selectedUserProfileID withMealID:self.selectedMealTypeId];
                    NSLog(@"arrFavDate==%@",arrFavDate);
                    
                    NSMutableArray *breakfastTitleFinalArr =[NSMutableArray array];
                    NSMutableArray *breakfastMealFinalArr =[NSMutableArray array];
                    
                    for(int i=0;i<arrFavDate.count;i++)
                    {
                       // NSMutableArray *breakfastMealArr=[foodLogObject getFavMealFoodLog:self.selectedMealTypeId withSelectedDate:[arrFavDate objectAtIndex:i] withUserId:selectedUserProfileID];
                        NSMutableArray *breakfastMealArr=[favMealLogObj getFavMealFoodLog:self.selectedMealTypeId withSelectedDate:[arrFavDate objectAtIndex:i] withUserId:selectedUserProfileID];
                        if(breakfastMealArr.count>0)
                        {
                            NSMutableArray *breakfastTitleArr =[NSMutableArray array];
                            
                            NSString *breakfastTitleStr=@"";
                            for(int i=0;i<breakfastMealArr.count;i++)
                            {
                                [breakfastTitleArr addObject:[[breakfastMealArr objectAtIndex:i]objectForKey:@"food_name"]];
                            }
                            breakfastTitleStr = [breakfastTitleArr componentsJoinedByString:@" , "];
                            [breakfastTitleFinalArr addObject:breakfastTitleStr];
                            
                            [breakfastMealFinalArr addObject:breakfastMealArr];
                        }
                        
                    }
                    
                    if(breakfastMealFinalArr.count>0)
                    {
                        [favMealTitleArr addObject:breakfastTitleFinalArr];
                        [favMealArr addObject:breakfastMealFinalArr];
                    }
                    
                }
                
                
                [tableView reloadData];
                [self refreshViewDropdownView];
            }
        }
    }
    else
    {
        
        if([self.allSearchedFoodArr count]>0 && self.selected_session == nil)
        {
            if(![self.previous_activity isEqualToString:@"RadialTapp"] && ![self.previous_activity isEqualToString:@"FromPlanner"] && ![self.previous_activity isEqualToString:@"newPlanner"])
            {
                [self notifyEvent:@"YES"];
                /* foodPopupcontroller =[self.storyboard instantiateViewControllerWithIdentifier:@"FoodLogPopUp"];
                 CGRect frame = foodPopupcontroller.view.frame;
                 frame.size.height = self.view.frame.size.height;
                 frame.origin.y=self.view.frame.origin.y;
                 foodPopupcontroller.view.frame = frame;
                 [foodPopupcontroller willMoveToParentViewController:self];
                 foodPopupcontroller.delegate=self;
                 foodPopupcontroller.navigateVal=@"food";
                 [self.view addSubview:foodPopupcontroller.view];
                 [self addChildViewController:foodPopupcontroller];
                 [self.view bringSubviewToFront:foodPopupcontroller.view];*/
                //popupShown=1;
                goBack=1;
                
            }
        }
        //[tableView reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView.tag==SEARCH_TABLE_TAG)
        return 2;
    else if(tableView.tag==MYMEAL_TABLE_TAG)
        return myMealSecTitleArr.count+1;
    else if (tableView.tag==RECENT_TABLE_TAG)
        return 1;
    else if (tableView.tag==MEALSUBCATEGORY_TABLE_TAG)
        return 1;
    else if (tableView.tag==FAV_MEALDROPDOWN_TABLE_TAG)
        return 1;
    else if (tableView.tag==FAV_MEALSUBCAT_TABLE_TAG)
        return favMealSecTitleArr.count;
    else
        return myMealSecTitleArr.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView.tag==MYMEAL_TABLE_TAG)
    {
        if(section!=0)
        {
            int cal;
            /* UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sessionCell"];
             cell.backgroundView = nil;
             cell.backgroundColor = [UIColor whiteColor];*/
            
            headerViewFoodlog *headerViewM=[[[NSBundle mainBundle] loadNibNamed:@                                                                       "headerViewFoodlog"owner:self options:nil] objectAtIndex:0];
            headerViewM.frame=CGRectMake(0, 0, SCREEN_WEIDTH, 60);
            NSString *strMealType=[myMealSecTitleArr objectAtIndex:section-1];
            
            UILabel *CalLbl = (UILabel *)[headerViewM viewWithTag:4];
            UILabel *headerLbl = (UILabel *)[headerViewM viewWithTag:3];
            [headerLbl setText:strMealType];
            
            /*if([strMealType isEqualToString:@"Breakfast"])
            {
                cal=[foodLogObject getFoodSumIndividualCalorie:@"1" withUserProfileID:selectedUserProfileID withDate:logTimeStr];
            }
            else if ([strMealType isEqualToString:@"Lunch"])
            {
                cal=[foodLogObject getFoodSumIndividualCalorie:@"2" withUserProfileID:selectedUserProfileID withDate:logTimeStr];
            }
            else if ([strMealType isEqualToString:@"Dinner"])
            {
                cal=[foodLogObject getFoodSumIndividualCalorie:@"3" withUserProfileID:selectedUserProfileID withDate:logTimeStr];
            }
            else
            {
                cal=[foodLogObject getFoodSumIndividualCalorie:@"4" withUserProfileID:selectedUserProfileID withDate:logTimeStr];
            }
            
            CalLbl.text=[NSString stringWithFormat:@"%d",cal];*/
            if(myMealCalTotalArr.count>0)
               CalLbl.text=[myMealCalTotalArr objectAtIndex:section-1];
            else
                CalLbl.text=@"0";
            
            UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMealCategory:)];
            
            if([strMealType isEqualToString:@"Breakfast"])
                headerViewM.tag = 0;
            else if([strMealType isEqualToString:@"Lunch"])
                headerViewM.tag = 1;
            else if([strMealType isEqualToString:@"Dinner"])
                headerViewM.tag = 2;
            else if([strMealType isEqualToString:@"Snack"])
                headerViewM.tag = 3;
            
            doubleTap.numberOfTapsRequired = 2;
            [headerViewM addGestureRecognizer: doubleTap];
            
            return headerViewM;
            
        }
        
    }
    else if (tableView.tag==FAV_MEALSUBCAT_TABLE_TAG)
    {
        UIView *view = [[UIView alloc] init ];
        if(thisDeviceFamily()==iPad)
            view.frame=CGRectMake(0, 0, self.view.bounds.size.width, 40.0f);
        else
            view.frame=CGRectMake(0, 0, self.view.bounds.size.width, 40.0f);
        
        //        view.layer.borderColor =[UIColor colorWithRed:0.0/255.0f green:145.0/255.0f blue:77.0/255.0f alpha:1.0f].CGColor;
        //        view.layer.borderWidth = 1.0f;
        
        [view setBackgroundColor:[UIColor whiteColor]];
        
        UILabel *lbl = [[UILabel alloc] init];
        if(thisDeviceFamily()==iPad)
        {
            lbl.frame=CGRectMake(20, 10, self.view.bounds.size.width-66, 20);
            lbl.font=[UIFont fontWithName:@"SinkinSans-600SemiBold" size:18.0f];
        }
        else
        {
            lbl.frame=CGRectMake(20, 10, self.view.bounds.size.width-66,20);
            lbl.font=[UIFont fontWithName:@"SinkinSans-600SemiBold" size:15.0f];
        }
        [lbl setTextColor:[UIColor blackColor]];
        [view addSubview:lbl];
        
        NSString *strTitle=[favMealSecTitleArr objectAtIndex:section];
        [lbl setText:strTitle];
        
        /*  if(![selectedRecentFav isEqualToString:@"Recent"])
         {
         UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
         button.accessibilityHint=[NSString stringWithFormat: @"%ld", (long)section];
         RecentFavFoodVCount=0;
         [button addTarget:self action:@selector(unFavMeal:) forControlEvents:UIControlEventTouchUpInside];
         [button setImage:[UIImage imageNamed:@"green-star@3x.png"] forState:UIControlStateNormal];
         button.frame = CGRectMake(self.view.bounds.size.width-56, 2.0, 36.0, 36.0);
         button.tag=section;
         [view addSubview:button];
         }*/
        
        /*  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
         button.accessibilityHint=[NSString stringWithFormat: @"%ld", (long)section];
         RecentFavFoodVCount=0;
         if([selectedRecentFav isEqualToString:@"Recent"])
         {
         NSLog(@"%@",[favMealArr objectAtIndex:section]);
         if([[favMealArr objectAtIndex:section] count]>0){
         
         for(int i=0;i<[[favMealArr objectAtIndex:section] count];i++)
         {
         if([[[[favMealArr objectAtIndex:section] objectAtIndex:i] objectForKey:@"isFavorite"] isEqualToString:@"1"])
         {
         RecentFavFoodVCount++;
         }
         }
         }
         
         if(RecentFavFoodVCount==[[favMealArr objectAtIndex:section] count])
         {
         [button setImage:[UIImage imageNamed:@"green-star@3x.png"] forState:UIControlStateNormal];
         [button addTarget:self action:@selector(UnFavouriteRecentMeal:) forControlEvents:UIControlEventTouchUpInside];
         }
         else
         {
         [button setImage:[UIImage imageNamed:@"green-star@3x_outline.png"] forState:UIControlStateNormal];
         
         [button addTarget:self action:@selector(AddFavouriteRecentMeal:) forControlEvents:UIControlEventTouchUpInside];
         }
         
         
         
         }
         else{
         
         [button addTarget:self action:@selector(unFavMeal:) forControlEvents:UIControlEventTouchUpInside];
         [button setImage:[UIImage imageNamed:@"green-star@3x.png"] forState:UIControlStateNormal];
         }
         button.frame = CGRectMake(self.view.bounds.size.width-56, 2.0, 36.0, 36.0);
         button.tag=section;
         [view addSubview:button];*/
        
        UIView *lineView = [[UIView alloc] init ];
        if(thisDeviceFamily()==iPad)
            lineView.frame=CGRectMake(0, 39.0, self.view.bounds.size.width, 1.0f);
        else
            lineView.frame=CGRectMake(0, 39.0, self.view.bounds.size.width, 1.0f);
        [lineView setBackgroundColor:[UIColor colorWithRed:0.0/255.0f green:145.0/255.0f blue:77.0/255.0f alpha:1.0f]];
        [view addSubview:lineView];
        
        
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView.tag==MYMEAL_TABLE_TAG)
    {
        if(section==0)
            return 0;
        else
            return 60;
    }
    else if (tableView.tag==FAV_MEALSUBCAT_TABLE_TAG)
        return 40;
    return 0;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES if you want the specified item to be editable.
    if(tableView.tag==MEALSUBCATEGORY_TABLE_TAG)
    {
        if (_isDeviceOn == TRUE && selectedIndexPathNormal>=0) {
            return NO;
        }
        else
        {
        return YES;
        }
    }
    else if(tableView.tag==RECENT_TABLE_TAG)
    {
        if([selectedRecentFav isEqualToString:@"Recent"])
            return YES;
        else if([selectedRecentFav isEqualToString:@"Favorites"])
            return NO;
    }
    else if(tableView.tag==MYMEAL_TABLE_TAG)
    {
        if(indexPath.section==0)
            return NO;
        else
            return YES;
    }
    return NO;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                    {
                                        NSLog(@"DELETE");
                                        NSString *selected_FoodID,*selected_Ref_food_ID;
                                        NSString *selectedProfileUsrID=[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedUserProfileID"];
                                        if(!isDelete)
                                        {
                                            isDelete=1;
                                            
                                            NSString *selectedDate=[[Utility sharedManager]getSelectedDateFormat];
                                            if(tableView.tag==MEALSUBCATEGORY_TABLE_TAG)
                                            {
                                                selected_FoodID=[[_selectedFoodArr objectAtIndex:indexPath.row]objectForKey:@"id"];
                                                
                                                if([self.previous_activity isEqualToString:@"FromPlanner"] || [self.previous_activity isEqualToString:@"newPlanner"])
                                                {
                                                    if(_selectedFoodArr.count>0)
                                                    {
                                                        /*[_selectedFoodArr removeObjectAtIndex:indexPath.row];
                                                         [self performSelector:@selector(callReload) withObject:nil afterDelay:0.1];*/
                                                        BOOL isSuccess=[foodLogObject deleteRowFoodData:selected_FoodID withSelectedDate:selectedDate withUserId:selectedProfileUsrID];
                                                        
                                                        if(isSuccess)
                                                        {
                                                            _selectedFoodArr= [foodLogObject getAllLunchLog:self.selectedMealTypeId withSelectedDate:logTimeStr  withUserId:selectedUserProfileID];
                                                            [self performSelector:@selector(callReload) withObject:nil afterDelay:0.1];
                                                            
                                                        }
                                                        
                                                        
                                                    }
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateFromPlanner" object:nil];
                                                    
                                                }
                                                else
                                                {
                                                    BOOL isSuccess=[foodLogObject deleteRowFoodData:selected_FoodID withSelectedDate:selectedDate withUserId:selectedProfileUsrID];
                                                    
                                                    if(isSuccess)
                                                    {
                                                        _selectedFoodArr= [foodLogObject getAllLunchLog:self.selectedMealTypeId withSelectedDate:logTimeStr  withUserId:selectedUserProfileID];
                                                        [self performSelector:@selector(callReload) withObject:nil afterDelay:0.1];
                                                        
                                                    }
                                                }
                                            }
                                            else if(tableView.tag==MYMEAL_TABLE_TAG)
                                            {
                                                selected_FoodID=[[[myMealArr objectAtIndex:indexPath.section-1]objectAtIndex:indexPath.row] objectForKey:@"id"];
                                                selected_Ref_food_ID=[[[myMealArr objectAtIndex:indexPath.section-1]objectAtIndex:indexPath.row] objectForKey:@"item"];
                                                BOOL isSuccess=[foodLogObject deleteRowFoodData:selected_FoodID withSelectedDate:selectedDate withUserId:selectedProfileUsrID];
                                                
                                                if(isSuccess)
                                                {
                                                    [mymealView setHidden:NO];
                                                    [self createMyMealArr];
                                                    NSLog(@"myMealArr==%@",myMealArr);
                                                    NSLog(@"myMealSecTitleArr==%@",myMealSecTitleArr);
                                                    
                                                    myMealTable.delegate=self;
                                                    myMealTable.dataSource=self;
                                                    myMealTable.hidden=NO;
                                                    [myMealTable reloadData];
                                                    isDelete=NO;
                                                    
                                                }
                                                
                                            }
                                            
                                            else if(tableView.tag==RECENT_TABLE_TAG)
                                            {
                                                selected_FoodID=[[_recentFoodArray objectAtIndex:indexPath.row]objectForKey:@"id"];
                                                selected_Ref_food_ID=[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"item"];
                                                if([selectedRecentFav isEqualToString:@"Recent"])
                                                {
                                                    BOOL isSuccess=[foodLogObject deleteRowFoodData:selected_FoodID withSelectedDate:selectedDate withUserId:selectedProfileUsrID];
                                                    
                                                    if(isSuccess)
                                                    {
                                                        if(selectedButton==1)
                                                            _recentFoodArray=[foodLogObject getAllFoodLog:selectedUserProfileID ];
                                                        else if (selectedButton==2){
                                                            _recentFoodArray=[foodLogObject getAllLunchLog:selectedId withSelectedDate:@""  withUserId:selectedUserProfileID];
                                                        }
                                                        [self performSelector:@selector(callReload) withObject:nil afterDelay:0.1];
                                                        
                                                    }
                                                    
                                                }
                                                
                                                else if([selectedRecentFav isEqualToString:@"Favorites"])
                                                {
                                                    [foodLogObject updateFavoriteStatus:@"0" foodID:selected_FoodID  withUserProfileID:selectedUserProfileID withFoodRefID:selected_Ref_food_ID];
                                                    [favFoodLogObj deleteFavFoodData:selected_FoodID withUserId:selectedUserProfileID];
                                                    [self performSelector:@selector(callReloadFav) withObject:nil afterDelay:0.1];
                                                }
                                            }
                                            
                                            [self getTotalCal];
                                            [self refreshViewDropdownView];
                                            
                                        }
                                        
                                    }];
    delete.backgroundColor = [UIColor redColor];
    
    if(tableView.tag==MEALSUBCATEGORY_TABLE_TAG || tableView.tag==RECENT_TABLE_TAG)
    {
        UITableViewRowAction *more = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@" Edit " handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                      {
                                          NSLog(@"Edit");
                                          if(tableView.tag==MEALSUBCATEGORY_TABLE_TAG)
                                          {
                                              self.selectedRow=[NSString stringWithFormat:@"%ld#%@",(long)indexPath.row,[[_selectedFoodArr objectAtIndex:indexPath.row] objectForKey:@"id"]];
                                              selectedTableTag=MEALSUBCATEGORY_TABLE_TAG;
                                              
                                              
                                              EditWeightViewController *editWeightController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditWeight"];
                                              CGRect frame = editWeightController.view.frame;
                                              frame.size.height = self.view.frame.size.height;
                                              frame.origin.y=self.view.frame.origin.y;
                                              editWeightController.view.frame = frame;
                                              [editWeightController willMoveToParentViewController:self];
                                              editWeightController.delegate=self;
                                              [self.view addSubview:editWeightController.view];
                                              [self addChildViewController:editWeightController];
                                              [self.view bringSubviewToFront:editWeightController.view];
                                              
                                              
                                          }
                                          else if (tableView.tag==RECENT_TABLE_TAG)
                                          {
                                              self.selectedRow=[NSString stringWithFormat:@"%ld#%@",(long)indexPath.row,[[_recentFoodArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
                                              selectedTableTag=RECENT_TABLE_TAG;
                                              
                                              EditCalViewController *editViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditCal"];
                                              CGRect frame = editViewController.view.frame;
                                              frame.size.height = self.view.frame.size.height;
                                              frame.origin.y=self.view.frame.origin.y;
                                              editViewController.view.frame = frame;
                                              [editViewController willMoveToParentViewController:self];
                                              editViewController.delegate=self;
                                              [self.view addSubview:editViewController.view];
                                              [self addChildViewController:editViewController];
                                              [self.view bringSubviewToFront:editViewController.view];
                                              
                                              
                                          }
                                          //popupShown=1;
                                          
                                      }];
        more.backgroundColor = [UIColor colorWithRed:0.188 green:0.514 blue:0.984 alpha:1];
        return @[delete, more];
    }
    else{
        return @[delete];
        
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // if(tableView.tag !=RECENT_TABLE_TAG){
    /*  if(tableView.tag==MEALSUBCATEGORY_TABLE_TAG)
     {
     NSString *selected_FoodID;
     NSString *selectedProfileUsrID=[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedUserProfileID"];
     if(!isDelete){
     isDelete=1;
     if (editingStyle == UITableViewCellEditingStyleDelete) {
     
     NSString *selectedDate=[[Utility sharedManager]getSelectedDateFormat];
     selected_FoodID=[[_selectedFoodArr objectAtIndex:indexPath.row]objectForKey:@"id"];
     BOOL isSuccess=[foodLogObject deleteRowFoodData:selected_FoodID withSelectedDate:selectedDate withUserId:selectedProfileUsrID];
     
     if(isSuccess)
     {
     //                    _selectedFoodArr= _recentFoodArray=[foodLogObject getAllLunchLog:self.selectedMealTypeId withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
     _selectedFoodArr= _recentFoodArray=[foodLogObject getAllLunchLog:self.selectedMealTypeId withSelectedDate:logTimeStr  withUserId:selectedUserProfileID];
     
     [self performSelector:@selector(callReload) withObject:nil afterDelay:1.0];
     
     }
     
     }
     }
     }*/
}

-(void)longTapAction:(UILongPressGestureRecognizer *)sender
{
    NSLog(@"%@",sender.view);
    UITableViewCell *cell = (UITableViewCell *)sender.view.superview;
    
    NSIndexPath *index=[_tblVw indexPathForCell:cell];
    NSLog(@"Tap%ld",(long)index.row);
    
    NSLog(@"%@",[[_lblBottomTotalGram.text componentsSeparatedByString:@" " ]objectAtIndex:0]);
    NSLog(@"%@",[_selectedFoodArr objectAtIndex:index.row]);
    
float  finalWeight=[[[_selectedFoodArr objectAtIndex:index.row] objectForKey:@"item_weight"] floatValue]+[[[_lblBottomTotalGram.text componentsSeparatedByString:@" " ]objectAtIndex:0] floatValue];
  
float finalCal=finalWeight*[[[_selectedFoodArr objectAtIndex:index.row] objectForKey:@"gm_calorie"] floatValue];

    
    NSString *finalCalStr=[NSString stringWithFormat:@"%.1f",finalCal];
    
    NSString *finalWeightStr=[NSString stringWithFormat:@"%.1f",finalWeight];

   [foodLogObject updateGramLog:finalCalStr withWeight:finalWeightStr withDate:@"" foodID:[[_selectedFoodArr objectAtIndex:index.row]  objectForKey:@"id"] withUserProfileID:selectedUserProfileID];

    _selectedFoodArr= _recentFoodArray=[foodLogObject getAllLunchLog:self.selectedMealTypeId withSelectedDate:logTimeStr withUserId:selectedUserProfileID];

    [ _tblVw reloadData];
}

-(NSString *)calculateTotalWeightVal
{
    NSLog(@"selectedIndexPathNormal==%ld",(long)selectedIndexPathNormal);
    int finalweight=0;
    if(_selectedFoodArr.count>0)
    {
        for(int i=0;i<_selectedFoodArr.count;i++)
        {
            if(i!=selectedIndexPathNormal)
            {
                int tempWeight=[[[_selectedFoodArr objectAtIndex:i]objectForKey:@"item_weight"]intValue];
                finalweight=finalweight+tempWeight;
            }
        }
     }
    return [NSString stringWithFormat:@"%d",finalweight];
}
#pragma mark - UnFavorite Meal Method
-(void)unFavDropDownMeal:(UIButton* )sender
{
    NSLog(@"ButtonTag=%ld",sender.tag);
    int section=sender.tag/100000;
    int row=sender.tag%100000;
    NSMutableArray *tempArr=[[favMealArr objectAtIndex:section]objectAtIndex:row];
    
    for(int i=0;i<[tempArr count];i++)
    {
        NSString *foodIdToAddFav=[NSString stringWithFormat:@"%@",[[tempArr objectAtIndex:i] objectForKey:@"id"]];
        NSString *refFoodIdToAddFav=[NSString stringWithFormat:@"%@",[[tempArr objectAtIndex:i] objectForKey:@"item"]];

        [foodLogObject updateMealFavoriteStatus:@"0" foodID:foodIdToAddFav withUserProfileID:selectedUserProfileID withMealFavStatus:@"0" withFoodRefID:refFoodIdToAddFav];
        [favMealLogObj deleteFavMealData:foodIdToAddFav withUserId:selectedUserProfileID];
    }
    
    /* NSLog(@"%@",[favMealArr objectAtIndex:sender.tag]);
     
     for(int i=0;i<[[favMealArr objectAtIndex:sender.tag] count];i++)
     {
     [foodLogObject updateFavoriteStatus:@"0" foodID:[[[favMealArr objectAtIndex:sender.tag] objectAtIndex:i]objectForKey:@"id" ]  withUserProfileID:selectedUserProfileID];
     }*/
    favMealArr=[NSMutableArray array];
    favMealTitleArr=[NSMutableArray array];
    favMealTitleStr=@"";
    
    //NSMutableArray *arrFavDate=[foodLogObject getUniqueFavDate:selectedUserProfileID withMealID:self.selectedMealTypeId];
    NSMutableArray *arrFavDate=[favMealLogObj getUniqueFavDate:selectedUserProfileID withMealID:self.selectedMealTypeId];

    NSLog(@"arrFavDate==%@",arrFavDate);
    
    NSMutableArray *breakfastTitleFinalArr =[NSMutableArray array];
    NSMutableArray *breakfastMealFinalArr =[NSMutableArray array];
    
    for(int i=0;i<arrFavDate.count;i++)
    {
      //  NSMutableArray *breakfastMealArr=[foodLogObject getFavMealFoodLog:self.selectedMealTypeId withSelectedDate:[arrFavDate objectAtIndex:i] withUserId:selectedUserProfileID];
        NSMutableArray *breakfastMealArr=[favMealLogObj getFavMealFoodLog:self.selectedMealTypeId withSelectedDate:[arrFavDate objectAtIndex:i] withUserId:selectedUserProfileID];
        if(breakfastMealArr.count>0)
        {
            NSMutableArray *breakfastTitleArr =[NSMutableArray array];
            
            NSString *breakfastTitleStr=@"";
            for(int i=0;i<breakfastMealArr.count;i++)
            {
                [breakfastTitleArr addObject:[[breakfastMealArr objectAtIndex:i]objectForKey:@"food_name"]];
            }
            breakfastTitleStr = [breakfastTitleArr componentsJoinedByString:@" , "];
            [breakfastTitleFinalArr addObject:breakfastTitleStr];
            
            [breakfastMealFinalArr addObject:breakfastMealArr];
        }
        
    }
    
    if(breakfastMealFinalArr.count>0)
    {
        [favMealTitleArr addObject:breakfastTitleFinalArr];
        [favMealArr addObject:breakfastMealFinalArr];
        [self reloadDropDownFoodTable];
        
    }
    else
    {
        recentFoodTableView.hidden=YES;
    }
    
}

-(void)unFavMeal:(UIButton* )sender
{
    NSLog(@"ButtonTag=%ld",sender.tag);
    int section=sender.tag/100000;
    int row=sender.tag%100000;
    NSMutableArray *tempArr=[[favMealArr objectAtIndex:section]objectAtIndex:row];
    
    for(int i=0;i<[tempArr count];i++){
        NSString *foodIdToAddFav=[NSString stringWithFormat:@"%@",[[tempArr objectAtIndex:i] objectForKey:@"id"]];
        NSString *refFoodIdToAddFav=[NSString stringWithFormat:@"%@",[[tempArr objectAtIndex:i] objectForKey:@"item"]];

        [foodLogObject updateMealFavoriteStatus:@"0" foodID:foodIdToAddFav withUserProfileID:selectedUserProfileID withMealFavStatus:@"0" withFoodRefID:refFoodIdToAddFav];
       [favMealLogObj deleteFavMealData:foodIdToAddFav withUserId:selectedUserProfileID];
    }
    
    /* NSLog(@"%@",[favMealArr objectAtIndex:sender.tag]);
     
     for(int i=0;i<[[favMealArr objectAtIndex:sender.tag] count];i++)
     {
     [foodLogObject updateFavoriteStatus:@"0" foodID:[[[favMealArr objectAtIndex:sender.tag] objectAtIndex:i]objectForKey:@"id" ]  withUserProfileID:selectedUserProfileID];
     }*/
    [self createFavMealArr];
    
    if([favMealArr count]>0)
    {
        recentFoodTableView.hidden=NO;
        
        recentFoodTableView.tag=FAV_MEALSUBCAT_TABLE_TAG;
        recentFoodTableView.delegate=self;
        recentFoodTableView.dataSource=self;
        [recentFoodTableView reloadData];
        
        recentFoodTableView.hidden=NO;
    }
    else
    {
        recentFoodTableView.hidden=YES;
    }
    
}

#pragma mark - callReloadFav Method
-(void)callReloadFav
{
    if([[self chkNullInputinitWithString:selectedFavMealTypeId] isEqualToString:@""])
    {
        selectedFavMealTypeId=@"";
    }
    //_recentFoodArray=[foodLogObject getAllFavoriteFoodLog:selectedFavMealTypeId withSelectedDate:@""  withUserId:selectedUserProfileID];
    _recentFoodArray=[favFoodLogObj getAllFavoriteFoodLog:selectedFavMealTypeId withSelectedDate:@"" withUserId:selectedUserProfileID];

    NSLog(@"%@",_recentFoodArray);
    
    recentFoodTableView.tag=RECENT_TABLE_TAG;
    recentFoodTableView.delegate=self;
    recentFoodTableView.dataSource=self;
    [recentFoodTableView reloadData];
    
    isDelete=NO;
    
}

#pragma mark - MealCategory DoubleTap Gesture Method
-(void)clickMealCategory:(UITapGestureRecognizer *)btnClick
{
    NSLog(@"btnClick==%ld",(long)btnClick.view.tag);
    
    [self updateSelectedIndexPath];
    
    //  selectedDropdown=@"dropdown";
    NSMutableArray *allMealArr=[NSMutableArray array];
    allMealArr=[mealTypeObj findAllMealType];
    for(NSDictionary *dict in allMealArr)
    {
        if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"breakfast"])
            breakfastId=[dict objectForKey:@"meal_type_id"];
        
        else if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"lunch"])
            lunchId=[dict objectForKey:@"meal_type_id"];
        
        else if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"dinner"])
            dinnerId=[dict objectForKey:@"meal_type_id"];
        
        else if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"snack"])
            snackId=[dict objectForKey:@"meal_type_id"];
    }
    
    if(btnClick.view.tag==0)
    {
        self.selectedMealTypeId=breakfastId;
        selectedMyMealType=@"1";
        sessionName.text=[NSString stringWithFormat:@"My %@",@"Breakfast"];
        sessionNm=[NSString stringWithFormat:@"My %@",@"Breakfast"];
        [self createNavigationView:@"Breakfast"];
        navTitle=@"Breakfast";
    }
    else if(btnClick.view.tag==1)
    {
        self.selectedMealTypeId=lunchId;
        selectedMyMealType=@"2";
        sessionName.text=[NSString stringWithFormat:@"My %@",@"Lunch"];
        sessionNm=[NSString stringWithFormat:@"My %@",@"Lunch"];
        [self createNavigationView:@"Lunch"];
        navTitle=@"Lunch";
    }
    else if(btnClick.view.tag==2)
    {
        self.selectedMealTypeId=dinnerId;
        selectedMyMealType=@"3";
        sessionName.text=[NSString stringWithFormat:@"My %@",@"Dinner"];
        sessionNm=[NSString stringWithFormat:@"My %@",@"Dinner"];
        [self createNavigationView:@"Dinner"];
        navTitle=@"Dinner";
    }
    else if(btnClick.view.tag==3)
    {
        self.selectedMealTypeId=snackId;
        selectedMyMealType=@"4";
        sessionName.text=[NSString stringWithFormat:@"My %@",@"Snack"];
        sessionNm=[NSString stringWithFormat:@"My %@",@"Snack"];
        [self createNavigationView:@"Snack"];
        navTitle=@"Snack";
    }
    
    _selectedFoodArr=[NSMutableArray array];
    FavFoodVCount=0;
    
    _selectedFoodArr= _recentFoodArray=[foodLogObject getAllLunchLog:self.selectedMealTypeId withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
    if([_selectedFoodArr count]>0){
        
        for(int i=0;i<_selectedFoodArr.count;i++)
        {
            if([[[_selectedFoodArr objectAtIndex:i] objectForKey:@"isFavMeal"] isEqualToString:@"1"])
            {
                FavFoodVCount++;
            }
        }
        mymealView.hidden=YES;
        autoCompleteTableView.hidden=YES;
        recentFoodTableView.hidden=YES;
        _tblVw.tag=MEALSUBCATEGORY_TABLE_TAG;
        _tblVw.delegate=self;
        _tblVw.dataSource=self;
        _tblVw.hidden=NO;
        [_tblVw reloadData];
        
        //[self performSelector:@selector(selfCalculateTotalSubCategoryMeal) withObject:nil afterDelay:3.0];
    }
    else
    {
        mymealView.hidden=YES;
        FavFoodVCount=0;
        _tblVw.tag=MEALSUBCATEGORY_TABLE_TAG;
        _tblVw.delegate=self;
        _tblVw.dataSource=self;
        _tblVw.hidden=YES;
        [_tblVw reloadData];
        //[self performSelector:@selector(selfCalculateTotalSubCategoryMeal) withObject:nil afterDelay:3.0];
    }
    
    if(FavFoodVCount==_selectedFoodArr.count)
    {
        [_btnTotalFav setImage:[UIImage imageNamed:@"green-star@3x.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_btnTotalFav setImage:[UIImage imageNamed:@"green-star@3x_outline.png"] forState:UIControlStateNormal];
    }
    
    totalCal=0;
    NSMutableArray *individualMealArr=[foodLogObject getAllLunchLog:self.selectedMealTypeId withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
    if(individualMealArr.count>0)
    {
        for(int j=0;j<individualMealArr.count;j++)
        {
            int individualTempCal=[[[individualMealArr objectAtIndex:j]objectForKey:@"cals"]intValue];
       
            if([[[individualMealArr objectAtIndex:j] objectForKey:@"item_weight"] isEqualToString:@"0"])
                  totalCal=0+totalCal;
            else
                  totalCal=individualTempCal+totalCal;
            }
    }

    //totalCal=[foodLogObject getFoodSumIndividualCalorie:self.selectedMealTypeId withUserProfileID:selectedUserProfileID withDate:logTimeStr];
    NSString *totalcal=[NSString stringWithFormat:@"%d",totalCal];
    
    NSMutableAttributedString *mediumAttrString = [[NSMutableAttributedString alloc] initWithString:totalcal attributes: _attributedTotDict];
    
    [mediumAttrString appendAttributedString:_LightAttrStringCAL];
    _lblBottomTotalCal.attributedText=mediumAttrString;

 }

#pragma mark - callReload Method
-(void)callReload
{
    // TotalCalBurned=[self getTotalBurnedCalorieCalculation];
    //  _lblBottomTotalCal.text=[NSString stringWithFormat:@"%d Cal",TotalCalBurned];
    _tblVw.tag=MEALSUBCATEGORY_TABLE_TAG;
    
    if([_selectedFoodArr count] > 0){
        FavFoodVCount=0;
        _tblVw.hidden=NO;
        _tblVw.delegate=self;
        _tblVw.dataSource=self;
        [_tblVw reloadData];
        
        //[self performSelector:@selector(selfCalculateTotalSubCategoryMeal) withObject:nil afterDelay:3.0];
    }
    else{
        _tblVw.hidden=YES;
    }
    if([_recentFoodArray count]>0)
    {
        recentFoodTableView.tag=RECENT_TABLE_TAG;
        recentFoodTableView.delegate=self;
        recentFoodTableView.dataSource=self;
        [recentFoodTableView reloadData];
        
        [recentFoodTableView setHidden:NO];
    }
    else{
        [recentFoodTableView setHidden:YES];
        
    }
    autoCompleteTableView.hidden=YES;
    isDelete=0;
    [self refreshViewDropdownView];
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    [dropDown hideDropDown:btnDropDown];
    [self rel];
}

#pragma mark - UINavigation Button Action
-(void)showLeft
{
    [dropDown hideDropDown:nil];
    [self.view endEditing:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    /*  if([self.previous_activity isEqualToString:@"FromPlanner"])
     [self.navigationController popViewControllerAnimated:YES];
     
     if(!goBack)
     {
     if(APP_CTRL.searchStart)
     {
     UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"Measupro"
     message:@"Are you about to leave the page?"
     delegate:self
     cancelButtonTitle:@"No"
     
     otherButtonTitles:@"Yes", nil];
     myAlert.delegate=self;
     myAlert.tag=1000;
     //[myAlert show];
     }
     else
     [self.navigationController popViewControllerAnimated:YES];
     }
     
     else
     {
     if(![self.previous_activity isEqualToString:@"RadialTapp"] && ![self.previous_activity isEqualToString:@"FromPlanner"] && ![self.previous_activity isEqualToString:@"newPlanner"])
     {
     if(APP_CTRL.searchStart)
     {
     UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"Measupro"
     message:@"Are you about to leave the page?"
     delegate:self
     cancelButtonTitle:@"No"
     
     otherButtonTitles:@"Yes", nil];
     myAlert.delegate=self;
     myAlert.tag=1000;
     // [myAlert show];
     }
     else
     {
     UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"Measupro"
     message:@"Are you about to leave the page?"
     delegate:self
     cancelButtonTitle:@"No"
     
     otherButtonTitles:@"Yes", nil];
     myAlert.delegate=self;
     myAlert.tag=1000;
     //[myAlert show];
     
     // [self.navigationController popViewControllerAnimated:YES];
     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
     //                foodPopupcontroller =[self.storyboard instantiateViewControllerWithIdentifier:@"FoodLogPopUp"];
     //                 CGRect frame = foodPopupcontroller.view.frame;
     //                 frame.size.height = self.view.frame.size.height;
     //                 frame.origin.y=self.view.frame.origin.y;
     //                 foodPopupcontroller.view.frame = frame;
     //                 [foodPopupcontroller willMoveToParentViewController:self];
     //                 foodPopupcontroller.delegate=self;
     //                 foodPopupcontroller.navigateVal=@"food";
     //                 [self.view addSubview:foodPopupcontroller.view];
     //                 [self addChildViewController:foodPopupcontroller];
     //                 [self.view bringSubviewToFront:foodPopupcontroller.view];
     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
     //popupShown=1;
     //goBack=1;
     //}
     }
     else
     {
     goBack=1;
     //popupShown=0;
     if([self.previous_activity isEqualToString:@"RadialTapp"]||[self.previous_activity isEqualToString:@"newPlanner"])
     {
     if(APP_CTRL.searchStart)
     {
     UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"Measupro"
     message:@"Are you about to leave the page?"
     delegate:self
     cancelButtonTitle:@"No"
     
     otherButtonTitles:@"Yes", nil];
     myAlert.delegate=self;
     myAlert.tag=1000;
     //[myAlert show];
     }
     else
     {
     [self.navigationController popViewControllerAnimated:YES];
     //}
     }
     else{
     // [self.navigationController popViewControllerAnimated:YES];
     }
     }
     }*/
}

-(void)showRight
{
    NSLog(@"APP_CTRL.searchStart====%d",APP_CTRL.searchStart);
    // if(!APP_CTRL.searchStart)
    // {
    SettingsViewController *mVerificationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    mVerificationViewController.navClass=@"settings";
    [self.navigationController pushViewController:mVerificationViewController animated:YES];
    
    // }
    // else
    // {
    /* UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"Measupro" message:@"Are you about to leave the page?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
     myAlert.tag=1002;
     [myAlert show];*/
    //}
}

-(void)notifyEvent:(NSString*)msg
{
    @try {
        [autoCompleteTableView setHidden:YES];
        //goBack=0;
        if([msg isEqualToString:@"YES"])
        {
            if([self.previous_activity isEqualToString:@"RadialTapp"]||[self.previous_activity isEqualToString:@"FromPlanner"])
            {
                foodLogObject.log_user_id=[defaults objectForKey:@"user_id"];
                foodLogObject.log_user_profile_id=selectedUserProfileID;
                
                foodLogObject.log_meal_id=self.selectedMealTypeId;
                //            if([self.action_selected isEqualToString:@"replace"]){
                //                [foodLogObject deleteUserFoodDataLog:self.selectedMealTypeId withSelectedDate:logTimeStr];
                //
                //            }
                
                if([_selectedFoodArr count]>0){
                    for(int i=0;i<[_selectedFoodArr count];i++){
                        if([[[_selectedFoodArr objectAtIndex:i] allKeys] containsObject:@"item_title"]){
                            if(![[self chkNullInputinitWithString:[[_selectedFoodArr objectAtIndex:i] objectForKey:@"item_title"]] isEqualToString:@""])
                                foodLogObject.log_item_title=[[[_selectedFoodArr objectAtIndex:i] objectForKey:@"item_title"]stringByReplacingOccurrencesOfString:@"'" withString:@""];
                        }
                        else if([[[_selectedFoodArr objectAtIndex:i] allKeys] containsObject:@"food_name"]){
                            
                            if(![[self chkNullInputinitWithString:[[_selectedFoodArr objectAtIndex:i] objectForKey:@"food_name"]] isEqualToString:@""])
                                
                                foodLogObject.log_item_title=[[[_selectedFoodArr objectAtIndex:i] objectForKey:@"food_name"]stringByReplacingOccurrencesOfString:@"'" withString:@""];
                        }
                        
                        foodLogObject.log_item_desc=[[_selectedFoodArr objectAtIndex:i] objectForKey:@"item_desc"];
                        foodLogObject.log_cals=[[_selectedFoodArr objectAtIndex:i] objectForKey:@"cals"];//@"0";
                        foodLogObject.log_serving_size=[[_selectedFoodArr objectAtIndex:i] objectForKey:@"serving_size"];
                        foodLogObject.log_reference_food_id=[[_selectedFoodArr objectAtIndex:i] objectForKey:@"reference_food_id"];
                        foodLogObject.log_date_added=[self getCurrentDateTime];
                        
                        foodLogObject.log_item_weight=[[_selectedFoodArr objectAtIndex:i] objectForKey:@"item_weight"];//@"0";
                        foodLogObject.log_gm_cal=[[_selectedFoodArr objectAtIndex:i] objectForKey:@"gm_cal"];
                        foodLogObject.log_log_time=[NSString stringWithFormat:@"%@ %@",logTimeStr,[self getCurrentTime]];
                        
                        BOOL idFound;
                        if([[[_selectedFoodArr objectAtIndex:i] allKeys] containsObject:@"item"])
                            idFound=[foodLogObject findID:[[_selectedFoodArr objectAtIndex:i] objectForKey:@"item"] withUserProfileID:selectedUserProfileID withmeal_id:self.selectedMealTypeId withSelectedDate:logTimeStr];
                        
                        if(!idFound){
                            [foodLogObject saveUserFoodDataLog];
                            //APP_CTRL.searchStart=0;
                        }
                    }
                    
                }
                else{
                    
                    for(int i=0;i<[_selectedFoodArr count];i++){
                        if([[[_selectedFoodArr objectAtIndex:i] allKeys] containsObject:@"item_title"])
                            foodLogObject.log_item_title=[[[_selectedFoodArr objectAtIndex:i] objectForKey:@"item_title"]stringByReplacingOccurrencesOfString:@"'" withString:@""];
                        else if ([[[_selectedFoodArr objectAtIndex:i] allKeys]containsObject:@"food_name"])
                            foodLogObject.log_item_title=[[[_selectedFoodArr objectAtIndex:i] objectForKey:@"food_name"]stringByReplacingOccurrencesOfString:@"'" withString:@""];
                        
                        foodLogObject.log_item_desc=[[_selectedFoodArr objectAtIndex:i] objectForKey:@"item_desc"];
                        foodLogObject.log_cals=@"0";//[[_selectedFoodArr objectAtIndex:i] objectForKey:@"cals"];
                        foodLogObject.log_serving_size=[[_selectedFoodArr objectAtIndex:i] objectForKey:@"serving_size"];
                        foodLogObject.log_reference_food_id=[[_selectedFoodArr objectAtIndex:i] objectForKey:@"livestrong_id"];
                        foodLogObject.log_date_added=[self getCurrentDateTime];
                        
                        foodLogObject.log_log_time=[NSString stringWithFormat:@"%@ %@",logTimeStr,[self getCurrentTime]];
                        foodLogObject.log_item_weight=@"0";//[[_selectedFoodArr objectAtIndex:i] objectForKey:@"item_weight"];
                          foodLogObject.log_gm_cal=[[_selectedFoodArr objectAtIndex:i] objectForKey:@"gm_cal"];
                        
                        if(selectedRecentFood){
                            BOOL idFound;
                            if([[[_selectedFoodArr objectAtIndex:i] allKeys] containsObject:@"item"])
                                idFound=[foodLogObject findID:[[_selectedFoodArr objectAtIndex:i] objectForKey:@"item"] withUserProfileID:selectedUserProfileID withmeal_id:self.selectedMealTypeId withSelectedDate:logTimeStr];
                            
                            if(idFound){
                                // [foodLogObj updateCalLog:<#(NSString *)#> foodID:[[_selectedFoodArr objectAtIndex:i] objectForKey:@"id"] withUserProfileID:selectedUserProfileID];
                            }
                            else{
                                [foodLogObject saveUserFoodDataLog];
                                //APP_CTRL.searchStart=0;
                            }
                        }
                        else{
                            [foodLogObject saveUserFoodDataLog];
                            //APP_CTRL.searchStart=0;
                        }
                    }
                }
                [self getTotalCal];
                [self refreshViewDropdownView];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateFromPlanner" object:nil];
                if([self.previous_activity isEqualToString:@"FromPlanner"])
                    [self.navigationController popViewControllerAnimated:YES];
                
            }
            else{
                
                [self btnActionSavePlanner];
                
                //popupShown=1;
            }
            
        }
        else if ([msg isEqualToString:@"NO"]){
           // [self.navigationController popViewControllerAnimated:YES];
            //popupShown=0;
        }
        else{
            
            [foodPopupcontroller willMoveToParentViewController:nil];
            [foodPopupcontroller.view removeFromSuperview];
            [foodPopupcontroller removeFromParentViewController];
            foodPopupcontroller=nil;
            // popupShown=0;
            
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"Exception : %@",exception);
    }
    @finally {
        
    }
    //   return msg;
    
}

- (void)btnActionSavePlanner
{
    NSString *mealTypeNm=@"";
    /*   mealTypeObj=[[MealType alloc]init];
     NSMutableArray *allMealArr=[NSMutableArray array];
     allMealArr=[mealTypeObj findAllMealType];
     for(NSDictionary *dict in allMealArr){
     if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"breakfast"])
     breakfastId=[dict objectForKey:@"meal_type_id"];
     
     else if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"lunch"])
     lunchId=[dict objectForKey:@"meal_type_id"];
     
     else if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"dinner"])
     dinnerId=[dict objectForKey:@"meal_type_id"];
     else if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"snack"])
     snackId=[dict objectForKey:@"meal_type_id"];
     }
     
     if(self.selectedMealTypeId==breakfastId)
     mealTypeNm=[NSString stringWithFormat:@" Breakfast_%@",[[NSUserDefaults standardUserDefaults]valueForKey:LATEST_SELECTED_DATE]];
     else if(self.selectedMealTypeId==lunchId)
     mealTypeNm=[NSString stringWithFormat:@" Lunch_%@",[[NSUserDefaults standardUserDefaults]valueForKey:LATEST_SELECTED_DATE]];
     else if(self.selectedMealTypeId==dinnerId)
     mealTypeNm=[NSString stringWithFormat:@" Dinner_%@",[[NSUserDefaults standardUserDefaults]valueForKey:LATEST_SELECTED_DATE]];
     else if(self.selectedMealTypeId==snackId)
     mealTypeNm=[NSString stringWithFormat:@" Snack_%@",[[NSUserDefaults standardUserDefaults]valueForKey:LATEST_SELECTED_DATE]];*/
    
    if([self.previous_activity isEqualToString:@"rowTapped"]){
    }
   else  if(![self.previous_activity isEqualToString:@"Planner"]){
        APP_CTRL.carryPlannerDataDataDict=[NSMutableDictionary dictionary];
        UserProfile *userProfileObj=[[UserProfile alloc]init];
        NSMutableArray *user_profile_Arr=[NSMutableArray new];
        user_profile_Arr=[userProfileObj getAllProfileID];
        if([user_profile_Arr count] >0){
            //NSString *userProfileID=[[user_profile_Arr objectAtIndex:0] objectForKey:@"id"];
            FoodLog *foodLogObj=[[FoodLog alloc] init];
            foodLogObj.log_user_id=[defaults objectForKey:@"user_id"];
            foodLogObj.log_user_profile_id=selectedUserProfileID;
            
            if(self.selectedMealTypeId!=nil && ![self.selectedMealTypeId isEqualToString:@" "])
                foodLogObj.log_meal_id=self.selectedMealTypeId;
            else{
                mealTypeObj.meal_type_name=mealTypeNm;
                int customMealID= [mealTypeObj saveCustomMeal];
                self.selectedMealTypeId=[NSString stringWithFormat:@"%d",customMealID];
                foodLogObj.log_meal_id=self.selectedMealTypeId;
            }
            
            
            for(int i=0;i<[_selectedFoodArr count];i++){
                
                if([[[_selectedFoodArr objectAtIndex:i]allKeys] containsObject:@"item_title"]){
                    foodLogObj.log_item_title=[[_selectedFoodArr objectAtIndex:i] objectForKey:@"item_title"];
                }
                else if([[[_selectedFoodArr objectAtIndex:i]allKeys] containsObject:@"food_name"]){
                    foodLogObj.log_item_title=[[_selectedFoodArr objectAtIndex:i] objectForKey:@"food_name"];
                }
                foodLogObj.log_reference_food_id=[[_selectedFoodArr objectAtIndex:i] objectForKey:@"reference_food_id"];
                foodLogObj.log_item_desc=[[_selectedFoodArr objectAtIndex:i] objectForKey:@"item_desc"];
                foodLogObj.log_cals=[[_selectedFoodArr objectAtIndex:i] objectForKey:@"cals"];
                foodLogObj.log_serving_size=[[_selectedFoodArr objectAtIndex:i] objectForKey:@"serving_size"];
                foodLogObj.log_reference_food_id=[[_selectedFoodArr objectAtIndex:i] objectForKey:@"item"];
                foodLogObj.log_date_added=[self getCurrentDateTime];
                foodLogObj.log_log_time=[NSString stringWithFormat:@"%@ %@",[[NSUserDefaults standardUserDefaults]valueForKey:LATEST_SELECTED_DATE],[self getCurrentTime]];
                foodLogObj.log_item_weight=[[_selectedFoodArr objectAtIndex:i] objectForKey:@"item_weight"];
                foodLogObject.log_gm_cal=[[_selectedFoodArr objectAtIndex:i] objectForKey:@"gm_cal"];
                
                if([self.previous_activity isEqualToString:@"newPlanner"]){
                    [APP_CTRL.carryPlannerDataDataDict setValue:@"food" forKey:@"type"];
                    [APP_CTRL.carryPlannerDataDataDict setValue:foodLogObj.log_user_id forKey:@"user_id"];
                    [APP_CTRL.carryPlannerDataDataDict setValue:selectedUserProfileID forKey:@"user_profile_id"];
                    
                    [APP_CTRL.carryPlannerDataDataDict setValue:self.selectedMealTypeId forKey:@"meal_id"];
                    [APP_CTRL.carryPlannerDataDataDict setValue:foodLogObj.log_item_title forKey:@"item_title"];
                    [APP_CTRL.carryPlannerDataDataDict setValue:foodLogObj.log_item_desc forKey:@"item_desc"];
                    [APP_CTRL.carryPlannerDataDataDict setValue:foodLogObj.log_cals forKey:@"cals"];
                    [APP_CTRL.carryPlannerDataDataDict setValue:foodLogObj.log_serving_size forKey:@"serving_size"];
                    [APP_CTRL.carryPlannerDataDataDict setValue:foodLogObj.log_reference_food_id forKey:@"item"];
                    [APP_CTRL.carryPlannerDataDataDict setValue:foodLogObj.log_log_time forKey:@"log_time"];
                    [APP_CTRL.carryPlannerDataDataDict setValue:foodLogObj.log_item_weight forKey:@"item_weight"];
                    [APP_CTRL.carryPlannerDataDataDict setValue:foodLogObj.log_gm_cal forKey:@"gm_cal"];

                    [APP_CTRL.carryPlannerDataDataDict setValue:[[NSUserDefaults standardUserDefaults]valueForKey:LATEST_SELECTED_DATE] forKey:@"selectedDate"];
                    
                    [APP_CTRL.carryDataDict setValue:foodLogObj.log_item_weight forKey:@"item_weight"];
                    [APP_CTRL.carryDataDict setValue:[[_selectedFoodArr objectAtIndex:i] objectForKey:@"isFavorite"] forKey:@"isFavorite"];
                    [APP_CTRL.carryDataDict setValue:[[_selectedFoodArr objectAtIndex:i] objectForKey:@"isFavMeal"] forKey:@"isFavMeal"];

                }
                else
                    [foodLogObj saveUserFoodDataLog];
                // APP_CTRL.searchStart=0;
                
            }
        }
        [defaults setObject:self.selectedMealTypeId forKey:@"selected_food_id"];
       [self notifyEventLog:@"BACK"];
        NSLog(@"SAVE carrydict%@",APP_CTRL.carryPlannerDataDataDict);
        
    }
    else{
        
        APP_CTRL.carryPlannerDataDataDict=[NSMutableDictionary dictionary];
        UserProfile *userProfileObj=[[UserProfile alloc]init];
        NSMutableArray *user_profile_Arr=[NSMutableArray new];
        user_profile_Arr=[userProfileObj getAllProfileID];
        if([user_profile_Arr count] >0){
            //NSString *userProfileID=[[user_profile_Arr objectAtIndex:0] objectForKey:@"id"];
            FoodLog *foodLogObj=[[FoodLog alloc] init];
            foodLogObj.log_user_id=[defaults objectForKey:@"user_id"];
            foodLogObj.log_user_profile_id=selectedUserProfileID;
            
            if(self.selectedMealTypeId!=nil && ![self.selectedMealTypeId isEqualToString:@" "])
                foodLogObj.log_meal_id=self.selectedMealTypeId;
            else{
                mealTypeObj.meal_type_name=mealTypeNm;
                int customMealID= [mealTypeObj saveCustomMeal];
                self.selectedMealTypeId=[NSString stringWithFormat:@"%d",customMealID];
                foodLogObj.log_meal_id=self.selectedMealTypeId;
            }
            
            for(int i=0;i<[_selectedFoodArr count];i++){
                
                if([[[_selectedFoodArr objectAtIndex:i]allKeys] containsObject:@"item_title"]){
                    foodLogObj.log_item_title=[[_selectedFoodArr objectAtIndex:i] objectForKey:@"item_title"];
                }
                else if([[[_selectedFoodArr objectAtIndex:i]allKeys] containsObject:@"food_name"]){
                    foodLogObj.log_item_title=[[_selectedFoodArr objectAtIndex:i] objectForKey:@"food_name"];
                }
                foodLogObj.log_reference_food_id=[[_selectedFoodArr objectAtIndex:i] objectForKey:@"reference_food_id"];
                foodLogObj.log_item_desc=[[_selectedFoodArr objectAtIndex:i] objectForKey:@"item_desc"];
                foodLogObj.log_cals=[[_selectedFoodArr objectAtIndex:i] objectForKey:@"cals"];
                foodLogObj.log_serving_size=[[_selectedFoodArr objectAtIndex:i] objectForKey:@"serving_size"];
                foodLogObj.log_reference_food_id=[[_selectedFoodArr objectAtIndex:i] objectForKey:@"item"];
                foodLogObj.log_date_added=[self getCurrentDateTime];
                foodLogObj.log_log_time=[NSString stringWithFormat:@"%@ %@",[[NSUserDefaults standardUserDefaults]valueForKey:LATEST_SELECTED_DATE],[self getCurrentTime]];
                foodLogObj.log_item_weight=[[_selectedFoodArr objectAtIndex:i] objectForKey:@"item_weight"];
                foodLogObject.log_gm_cal=[[_selectedFoodArr objectAtIndex:i] objectForKey:@"gm_cal"];

                if([self.previous_activity isEqualToString:@"newPlanner"]){
                    [APP_CTRL.carryPlannerDataDataDict setValue:@"food" forKey:@"type"];
                    [APP_CTRL.carryPlannerDataDataDict setValue:foodLogObj.log_user_id forKey:@"user_id"];
                    [APP_CTRL.carryPlannerDataDataDict setValue:selectedUserProfileID forKey:@"user_profile_id"];
                    
                    [APP_CTRL.carryPlannerDataDataDict setValue:self.selectedMealTypeId forKey:@"meal_id"];
                    [APP_CTRL.carryPlannerDataDataDict setValue:foodLogObj.log_item_title forKey:@"item_title"];
                    [APP_CTRL.carryPlannerDataDataDict setValue:foodLogObj.log_item_desc forKey:@"item_desc"];
                    [APP_CTRL.carryPlannerDataDataDict setValue:foodLogObj.log_cals forKey:@"cals"];
                    [APP_CTRL.carryPlannerDataDataDict setValue:foodLogObj.log_serving_size forKey:@"serving_size"];
                    [APP_CTRL.carryPlannerDataDataDict setValue:foodLogObj.log_reference_food_id forKey:@"item"];
                    [APP_CTRL.carryPlannerDataDataDict setValue:foodLogObj.log_log_time forKey:@"log_time"];
                    [APP_CTRL.carryPlannerDataDataDict setValue:foodLogObj.log_item_weight forKey:@"item_weight"];
                    [APP_CTRL.carryPlannerDataDataDict setValue:foodLogObj.log_gm_cal forKey:@"gm_cal"];

                    [APP_CTRL.carryPlannerDataDataDict setValue:[[NSUserDefaults standardUserDefaults]valueForKey:LATEST_SELECTED_DATE] forKey:@"selectedDate"];
                    
                    [APP_CTRL.carryDataDict setValue:foodLogObj.log_item_weight forKey:@"item_weight"];
                    [APP_CTRL.carryDataDict setValue:[[_selectedFoodArr objectAtIndex:i] objectForKey:@"isFavorite"] forKey:@"isFavorite"];
                      [APP_CTRL.carryDataDict setValue:[[_selectedFoodArr objectAtIndex:i] objectForKey:@"isFavMeal"] forKey:@"isFavMeal"];
                }
                else
                    [foodLogObj saveUserFoodDataLog];
                // APP_CTRL.searchStart=0;
                
            }
        }
        [defaults setObject:self.selectedMealTypeId forKey:@"selected_food_id"];
        [self notifyEventLog:@"BACK"];
        NSLog(@"SAVE carrydict%@",APP_CTRL.carryPlannerDataDataDict);
        
    }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"savePerformed" object:nil];
    
}
-(NSString*)notifyEventLog:(NSString *)msg{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshViewDropdownView)
                                                 name:@"savePerformed"
                                               object:nil];
    // popupShown=0;
    goBack=0;
    [self.navigationController popViewControllerAnimated:YES];
    // [self getTotalCal];
    return nil;
    
}

#pragma mark - Refresh Dropdown Method
-(void)refreshViewDropdownView
{
    int TotalsumFoodLog=0;
    arrDropDownTopTxt=[[NSMutableArray alloc]init];
    arrDropDownTxtFood=[[NSMutableArray alloc]init];
    
    UserCalDetails *userCalObj=[[UserCalDetails alloc]init];
    NSMutableArray *usersCalArr=[userCalObj getUserCalorieDetails:selectedUserProfileID];
    NSLog(@"usersCalArr=%@",usersCalArr);
    if(usersCalArr.count>0)
    {
        userCalObj=[usersCalArr objectAtIndex:0];
        [defaults setObject:userCalObj.total_intake forKey:@"TotalIntake"];
        [defaults synchronize];
    }
    
    
    NSLog(@"TOTALINTAKE=%@",userCalObj.total_intake);
    
    int breakfastCal=0;
    NSMutableArray *breakfastMealArr=[foodLogObject getAllLunchLog:@"1" withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
    if(breakfastMealArr.count>0)
    {
        for(int j=0;j<breakfastMealArr.count;j++)
        {
            int breakfastTempCal=0;
            if([[[breakfastMealArr objectAtIndex:j]objectForKey:@"item_weight"]intValue]==0)
            {
                breakfastCal=0+breakfastCal;
            }
            else
            {
                breakfastTempCal=[[[breakfastMealArr objectAtIndex:j]objectForKey:@"cals"]intValue];
                breakfastCal=breakfastTempCal+breakfastCal;
            }
         }
    }
    
    int lunchCal=0;
    NSMutableArray *lunchMealArr=[foodLogObject getAllLunchLog:@"2" withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
    if(lunchMealArr.count>0)
    {
        for(int j=0;j<lunchMealArr.count;j++)
        {
            int lunchTempCal=0;
            if([[[lunchMealArr objectAtIndex:j]objectForKey:@"item_weight"]intValue]==0)
            {
                lunchCal=0+lunchCal;
            }
            else
            {
                lunchTempCal=[[[lunchMealArr objectAtIndex:j]objectForKey:@"cals"]intValue];
                lunchCal=lunchTempCal+lunchCal;
            }
        }
        
    }
    
    int dinnerCal=0;
    NSMutableArray *dinnerMealArr=[foodLogObject getAllLunchLog:@"3" withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
    if(dinnerMealArr.count>0)
    {
        for(int j=0;j<dinnerMealArr.count;j++)
        {
            int dinnerTempCal=0;
            if([[[dinnerMealArr objectAtIndex:j]objectForKey:@"item_weight"]intValue]==0)
            {
                dinnerCal=0+dinnerCal;
            }
            else
            {
                dinnerTempCal=[[[dinnerMealArr objectAtIndex:j]objectForKey:@"cals"]intValue];
                dinnerCal=dinnerTempCal+dinnerCal;
            }
        }
        
    }
    
    int snacksCal=0;
    NSMutableArray *snacksMealArr=[foodLogObject getAllLunchLog:@"4" withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
    if(snacksMealArr.count>0)
    {
        for(int j=0;j<snacksMealArr.count;j++)
        {
            int snacksTempCal=0;
            if([[[snacksMealArr objectAtIndex:j]objectForKey:@"item_weight"]intValue]==0)
            {
                snacksCal=0+snacksCal;
            }
            else
            {
                snacksTempCal=[[[snacksMealArr objectAtIndex:j]objectForKey:@"cals"]intValue];
                snacksCal=snacksTempCal+snacksCal;
            }
        }
        
    }
    
    int sumFood=0;
    sumFood=breakfastCal+lunchCal+dinnerCal+snacksCal;
    
   /* int sumFood=0;
    NSMutableArray *allMealArr=[foodLogObject getAllLunchLog:@"" withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
    if(allMealArr.count>0)
    {
        for(int j=0;j<allMealArr.count;j++)
        {
            int individualTempCal=[[[allMealArr objectAtIndex:j]objectForKey:@"cals"]intValue];
            sumFood=individualTempCal+sumFood;
        }
    }*/

   // int sumFood= [foodLogObject getFoodSumCalorie:logTimeStr todate:logTimeStr withUserProfileID:selectedUserProfileID];

    NSString *strSumFoodTotal=[NSString stringWithFormat:@"%d",sumFood];
    [arrDropDownTxtFood addObject:strSumFoodTotal];
    
    arrDropDownImgFood= [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"foodlog_new"],[UIImage imageNamed:@"breakfast_new"], [UIImage imageNamed:@"lunch_new"], [UIImage imageNamed:@"dinner_new"], [UIImage imageNamed:@"snack_new"],  nil];
    
    for(int i=0;i<4;i++)
    {
        NSString *mealID=[NSString stringWithFormat:@"%d",i+1];
        int sumFoodLog=0;
        NSMutableArray *individualMealArr=[foodLogObject getAllLunchLog:mealID withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
        if(individualMealArr.count>0)
        {
            for(int j=0;j<individualMealArr.count;j++)
            {
                int individualTempCal=0;
                if([[[individualMealArr objectAtIndex:j]objectForKey:@"item_weight"]intValue]==0)
                {
                    sumFoodLog=0+sumFoodLog;
                }
                else
                {
                    individualTempCal=[[[individualMealArr objectAtIndex:j]objectForKey:@"cals"]intValue];
                    sumFoodLog=individualTempCal+sumFoodLog;
                }
            }
        }

       // int sumFoodLog= [foodLogObject getFoodSumIndividualCalorie:mealID withUserProfileID:selectedUserProfileID withDate:logTimeStr];
        TotalsumFoodLog+=sumFoodLog;
        NSString *strSumFoodLog=[NSString stringWithFormat:@"%d",sumFoodLog];
        [arrDropDownTxtFood addObject:strSumFoodLog];
    }
    
    arrDropDownImgActivity= [[NSMutableArray alloc]init];
    arrDropDownTxtActivity=[[NSMutableArray alloc]init];
    
    int sumAllExerciseLog= [exerciseLogObj getFoodSumAllCalorie:@"" withUserProfileID:selectedUserProfileID withDate:logTimeStr];
    NSString *strSumActivityTotal=[NSString stringWithFormat:@"%d",sumAllExerciseLog];
    [arrDropDownTxtActivity addObject:strSumActivityTotal];
    
    NSMutableArray *subarrDropDownImgActivity= [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"Calories-Burned"],[UIImage imageNamed:@"Lifting-Weight.png"],[UIImage imageNamed:@"Boxing.png"],[UIImage imageNamed:@"Jumprope.png"], [UIImage imageNamed:@"Swimming.png"], [UIImage imageNamed:@"Treadmill.png"],[UIImage imageNamed:@"Chin-Ups.png"],nil];
    
    [arrDropDownImgActivity addObject:[subarrDropDownImgActivity objectAtIndex:0]];
    
    int TotalsumExerciseLog=0;
    for(int i=0;i<6;i++)
    {
        NSString *exerciseID=[NSString stringWithFormat:@"%d",i+1];
        int sumExerciseLog= [exerciseLogObj getFoodSumIndividualCalorie:exerciseID withUserProfileID:selectedUserProfileID withDate:logTimeStr];
        TotalsumExerciseLog+=sumExerciseLog;
        NSString *strSumExerciseLog=[NSString stringWithFormat:@"%d",sumExerciseLog];
        if(sumExerciseLog!=0)
        {
            [arrDropDownTxtActivity addObject:strSumExerciseLog];
            [arrDropDownImgActivity addObject:[subarrDropDownImgActivity objectAtIndex:i+1]];
        }
    }
    
    int netCalorie=[userCalObj.total_intake intValue]-sumFood;
    if(netCalorie<0)
        netCalorie= 0;
    
    int sumActivity= [exerciseLogObj getActivitySumBurned:logTimeStr todate:logTimeStr withUserProfileID:selectedUserProfileID];
    
    int TotalsumBurn=0;
    TotalsumBurn=sumFood-sumActivity;
    if(TotalsumBurn<0)
        TotalsumBurn= -TotalsumBurn;
    
    /* [arrDropDownTopTxt addObject:[NSString stringWithFormat:@"%d",netCalorie]];
     [arrDropDownTopTxt addObject:[NSString stringWithFormat:@"%d",TotalsumFoodLog]];
     [arrDropDownTopTxt addObject:[NSString stringWithFormat:@"%d",TotalsumExerciseLog]];
     [arrDropDownTopTxt addObject:[NSString stringWithFormat:@"%d",TotalsumBurn]];*/
    
    [arrDropDownTopTxt addObject:[NSString stringWithFormat:@"%@",[defaults objectForKey:@"TotalIntake"]]];
    [arrDropDownTopTxt addObject:strSumFoodTotal];
    [arrDropDownTopTxt addObject:[NSString stringWithFormat:@"%d",sumAllExerciseLog]];
    [arrDropDownTopTxt addObject:[NSString stringWithFormat:@"%d",netCalorie]];
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    family=thisDeviceFamily();
    if(family == iPad){
    }
    else{
        if([self isIphoneSixPlus])
        {
            _lblTop1.font=[UIFont fontWithName:@"SinkinSans-300Light" size:19.0f];
            _lblTop2.font=[UIFont fontWithName:@"SinkinSans-300Light" size:19.0f];
            _lblTop3.font=[UIFont fontWithName:@"SinkinSans-300Light" size:19.0f];
            _lblTop4.font=[UIFont fontWithName:@"SinkinSans-300Light" size:19.0f];
        }
    }
    
    _lblTop1.text=[arrDropDownTopTxt objectAtIndex:0];
    _lblTop2.text=[arrDropDownTopTxt objectAtIndex:1];
    _lblTop3.text=[arrDropDownTopTxt objectAtIndex:2];
    _lblTop4.text=[arrDropDownTopTxt objectAtIndex:3];
    _lblTop1.adjustsFontSizeToFitWidth=YES;
    _lblTop1.minimumScaleFactor=0.6;
    _lblTop4.adjustsFontSizeToFitWidth=YES;
    _lblTop4.minimumScaleFactor=0.6;
    
    _lblTop2.adjustsFontSizeToFitWidth=YES;
    _lblTop2.minimumScaleFactor=0.6;
    _lblTop3.adjustsFontSizeToFitWidth=YES;
    _lblTop3.minimumScaleFactor=0.6;
}

#pragma mark - getTotalWeight Method
-(void)getTotalWeight
{
    NSString *totalgm=[NSString stringWithFormat:@"%d",0];
    
    
    UIFont *mediumFont = [UIFont fontWithName:@"SinkinSans-400regular" size:30];
    NSDictionary *mediumDict = [NSDictionary dictionaryWithObject: mediumFont forKey:NSFontAttributeName];
    NSMutableAttributedString *mediumAttrString = [[NSMutableAttributedString alloc] initWithString:totalgm attributes: mediumDict];
    
    UIFont *LightFont = [UIFont fontWithName:@"SinkinSans-300Light" size:15];
    NSDictionary *LightDict = [NSDictionary dictionaryWithObject:LightFont forKey:NSFontAttributeName];
    NSMutableAttributedString *LightAttrString = [[NSMutableAttributedString alloc]initWithString:@" g"  attributes:LightDict];
    
    [mediumAttrString appendAttributedString:LightAttrString];
    
    _lblBottomTotalGram.attributedText=mediumAttrString;
}

#pragma mark - getTotalCalorie Method
-(int)getTotalCal
{
    totalCal=0;
    NSLog(@"self.selectedMealTypeId==%@",self.selectedMealTypeId);
    if([self.previous_activity isEqualToString:@"rowTapped"]){
        if([selectedDropdown isEqualToString:@"dropdown"])
        {
            NSMutableArray *individualMealArr=[foodLogObject getAllLunchLog:self.selectedMealTypeId withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
            if(individualMealArr.count>0)
            {
                for(int j=0;j<individualMealArr.count;j++)
                {
                    int individualTempCal=[[[individualMealArr objectAtIndex:j]objectForKey:@"cals"]intValue];
                    if([[[individualMealArr objectAtIndex:j] objectForKey:@"item_weight"] isEqualToString:@"0"])
                                totalCal=0+totalCal;
                            else
                                totalCal=individualTempCal+totalCal;
                }
            }
            
            
            //totalCal=[foodLogObject getFoodSumIndividualCalorie:self.selectedMealTypeId withUserProfileID:selectedUserProfileID withDate:logTimeStr];
        }
        else
        {
            NSMutableArray *allMealArr;
            if([self.selectedMealTypeId isEqualToString:@"1"])
                allMealArr=[foodLogObject getAllLunchLog:@"1" withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
            else if([self.selectedMealTypeId isEqualToString:@"2"])
                allMealArr=[foodLogObject getAllLunchLog:@"2" withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
            else if([self.selectedMealTypeId isEqualToString:@"3"])
                allMealArr=[foodLogObject getAllLunchLog:@"3" withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
            else if([self.selectedMealTypeId isEqualToString:@"4"])
                allMealArr=[foodLogObject getAllLunchLog:@"4" withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
            else
                allMealArr=[foodLogObject getAllLunchLog:@"" withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
            if(allMealArr.count>0)
            {
                for(int j=0;j<allMealArr.count;j++)
                {
                    int individualTempCal=[[[allMealArr objectAtIndex:j]objectForKey:@"cals"]intValue];
                             if([[[allMealArr objectAtIndex:j] objectForKey:@"item_weight"] isEqualToString:@"0"])
                        totalCal=0+totalCal;
                    else
                       totalCal=individualTempCal+totalCal;
                }
            }
            
            //totalCal=[foodLogObject getFoodSumIndividualCalorie:@"" withUserProfileID:selectedUserProfileID withDate:logTimeStr];
        }
    }
    else  if([self.previous_activity isEqualToString:@"newPlanner"])
    {
        
        //  totalCal=[foodLogObject getFoodSumIndividualCalorie:@"" withUserProfileID:selectedUserProfileID withDate:logTimeStr];
        totalCal=0;
    }
    else{
        if(![[self chkNullInputinitWithString:self.selectedMealTypeId] isEqualToString:@""])
        {
            NSMutableArray *individualMealArr=[foodLogObject getAllLunchLog:self.selectedMealTypeId withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
            if(individualMealArr.count>0)
            {
                for(int j=0;j<individualMealArr.count;j++)
                {
                    int individualTempCal=[[[individualMealArr objectAtIndex:j]objectForKey:@"cals"]intValue];
                       if([[[individualMealArr objectAtIndex:j] objectForKey:@"item_weight"] isEqualToString:@"0"])
                        totalCal=0+totalCal;
                    else
                        totalCal=individualTempCal+totalCal;
                  }
            }
            //totalCal=[foodLogObject getFoodSumIndividualCalorie:self.selectedMealTypeId withUserProfileID:selectedUserProfileID withDate:logTimeStr];
        }
        else
        {
            
            NSMutableArray *individualMealArr=[foodLogObject getAllLunchLog:[defaults objectForKey:@"selected_food_id"] withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
            if(individualMealArr.count>0)
            {
                for(int j=0;j<individualMealArr.count;j++)
                {
                    int individualTempCal=[[[individualMealArr objectAtIndex:j]objectForKey:@"cals"]intValue];
                          if([[[individualMealArr objectAtIndex:j] objectForKey:@"item_weight"] isEqualToString:@"0"])
                        totalCal=0+totalCal;
                    else
                        totalCal=individualTempCal+totalCal;
                  }
            }
            //totalCal=[foodLogObject getFoodSumIndividualCalorie:[defaults objectForKey:@"selected_food_id"]withUserProfileID:selectedUserProfileID withDate:logTimeStr];
            
        }
    }
    NSString *totalcal=[NSString stringWithFormat:@"%d",totalCal];
    
     NSMutableAttributedString *mediumAttrString = [[NSMutableAttributedString alloc] initWithString:totalcal attributes: _attributedTotDict];
    
    [mediumAttrString appendAttributedString:_LightAttrStringCAL];
    _lblBottomTotalCal.attributedText=mediumAttrString;
    
    selectedDropdown=@"";
    
    return totalCal;
}

#pragma mark - Summary Top Navigation DropDown Button Action
- (IBAction)btnAction1:(id)sender
{
    CalorieIntakeViewController *catloryIntake = [self.storyboard instantiateViewControllerWithIdentifier:@"CalorieIntakeViewController"];
    catloryIntake.previousNav=@"Food Logging";
    [self.navigationController pushViewController:catloryIntake animated:YES];
}

- (IBAction)btnAction2:(id)sender
{
    btnDropDown=sender;
    if(dropDown == nil) {
        CGFloat f = 250;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arrDropDownTxtFood :arrDropDownImgFood :@"down" :2];
        dropDown.delegate = self;
        mAppDelegate.dropDown=dropDown;
        mAppDelegate.btnDropDown=btnDropDown;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
    
}
- (IBAction)btnAction3:(id)sender
{
    btnDropDown=sender;
    if(dropDown == nil) {
        CGFloat f = 250;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arrDropDownTxtActivity :arrDropDownImgActivity :@"down" :3];
        dropDown.delegate = self;
        mAppDelegate.dropDown=dropDown;
        mAppDelegate.btnDropDown=btnDropDown;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
    
}
- (IBAction)btnAction4:(id)sender
{
}

#pragma mark - NIDropDown Delegate
- (void) niDropDownDelegateMethod: (NIDropDown *) sender SelectedText:(NSString *)selectedTextString selectedIndex:(NSInteger)selectedIndex tag:(NSInteger)Tag
{
    [self updateSelectedIndexPath];
    
    [self rel];
    NSLog(@"%ld,%ld",(long)Tag,(long)selectedIndex);
    if(Tag==2)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:selectedIndex forKey:@"selectedFoodLogMenu"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        selectedDropdown=@"dropdown";
        NSMutableArray *allMealArr=[NSMutableArray array];
        allMealArr=[mealTypeObj findAllMealType];
        for(NSDictionary *dict in allMealArr){
            if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"breakfast"])
                breakfastId=[dict objectForKey:@"meal_type_id"];
            
            else if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"lunch"])
                lunchId=[dict objectForKey:@"meal_type_id"];
            
            else if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"dinner"])
                dinnerId=[dict objectForKey:@"meal_type_id"];
            else if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"snack"])
                snackId=[dict objectForKey:@"meal_type_id"];
        }
        
        if(selectedIndex==0)
        {
            [self createMyMealArr];
            NSLog(@"myMealArr==%@",myMealArr);
            NSLog(@"myMealSecTitleArr==%@",myMealSecTitleArr);
            
            [mymealView setHidden:NO];
            
            myMealTable.delegate=self;
            myMealTable.dataSource=self;
            myMealTable.hidden=NO;
            [myMealTable reloadData];
            
            sessionName.text=@"My Meal";
            sessionNm=@"My Meal";
            [self createNavigationView:@"My Meal"];
            navTitle=@"My Meal";
            selectedMyMealType=@"";
        }
        else
        {
            if(selectedIndex==1)
            {
                selectedMyMealType=@"1";
                self.selectedMealTypeId=breakfastId;
                sessionName.text=[NSString stringWithFormat:@"My %@",@"Breakfast"];
                sessionNm=[NSString stringWithFormat:@"My %@",@"Breakfast"];
                [self createNavigationView:@"Breakfast"];
                navTitle=@"Breakfast";
            }
            else if(selectedIndex==2)
            {
                selectedMyMealType=@"2";
                self.selectedMealTypeId=lunchId;
                sessionName.text=[NSString stringWithFormat:@"My %@",@"Lunch"];
                sessionNm=[NSString stringWithFormat:@"My %@",@"Lunch"];
                [self createNavigationView:@"Lunch"];
                navTitle=@"Lunch";
            }
            else if(selectedIndex==3)
            {
                selectedMyMealType=@"3";
                self.selectedMealTypeId=dinnerId;
                sessionName.text=[NSString stringWithFormat:@"My %@",@"Dinner"];
                sessionNm=[NSString stringWithFormat:@"My %@",@"Dinner"];
                [self createNavigationView:@"Dinner"];
                navTitle=@"Dinner";
            }
            else if(selectedIndex==4)
            {
                selectedMyMealType=@"4";
                self.selectedMealTypeId=snackId;
                sessionName.text=[NSString stringWithFormat:@"My %@",@"Snack"];
                sessionNm=[NSString stringWithFormat:@"My %@",@"Snack"];
                [self createNavigationView:@"Snack"];
                navTitle=@"Snack";
            }
            
            _selectedFoodArr=[NSMutableArray array];
            
            _selectedFoodArr= _recentFoodArray=[foodLogObject getAllLunchLog:self.selectedMealTypeId withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
            if([_selectedFoodArr count]>0){
                mymealView.hidden=YES;
                autoCompleteTableView.hidden=YES;
                recentFoodTableView.hidden=YES;
                FavFoodVCount=0;
                _tblVw.tag=MEALSUBCATEGORY_TABLE_TAG;
                _tblVw.delegate=self;
                _tblVw.dataSource=self;
                _tblVw.hidden=NO;
                [_tblVw reloadData];
                
                //[self performSelector:@selector(selfCalculateTotalSubCategoryMeal) withObject:nil afterDelay:3.0];
            }
            else
            {
                mymealView.hidden=YES;
                FavFoodVCount=0;
                _tblVw.tag=MEALSUBCATEGORY_TABLE_TAG;
                _tblVw.delegate=self;
                _tblVw.dataSource=self;
                _tblVw.hidden=YES;
                [_tblVw reloadData];
                
                //[self performSelector:@selector(selfCalculateTotalSubCategoryMeal) withObject:nil afterDelay:3.0];
            }
        }
       // [self getTotalCal];
        
    }
    else  if(Tag==5)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:selectedIndex forKey:@"selectedFavLogMenu"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        selectedDropdown=@"dropdown";
        NSMutableArray *allMealArr=[NSMutableArray array];
        allMealArr=[mealTypeObj findAllMealType];
        for(NSDictionary *dict in allMealArr){
            if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"breakfast"])
                breakfastId=[dict objectForKey:@"meal_type_id"];
            
            else if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"lunch"])
                lunchId=[dict objectForKey:@"meal_type_id"];
            
            else if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"dinner"])
                dinnerId=[dict objectForKey:@"meal_type_id"];
            else if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"snack"])
                snackId=[dict objectForKey:@"meal_type_id"];
        }
        
        if(selectedIndex==0)
        {
            self.selectedMealTypeId=breakfastId;
            /* sessionName.text=[NSString stringWithFormat:@"My %@",@"Breakfast"];
             sessionNm=[NSString stringWithFormat:@"My %@",@"Breakfast"];
             [self createNavigationView:@"Breakfast"];
             navTitle=@"Breakfast";*/
        }
        else if(selectedIndex==1)
        {
            self.selectedMealTypeId=lunchId;
            /*  sessionName.text=[NSString stringWithFormat:@"My %@",@"Lunch"];
             sessionNm=[NSString stringWithFormat:@"My %@",@"Lunch"];
             [self createNavigationView:@"Lunch"];
             navTitle=@"Lunch";*/
        }
        else if(selectedIndex==2)
        {
            self.selectedMealTypeId=dinnerId;
            /*sessionName.text=[NSString stringWithFormat:@"My %@",@"Dinner"];
             sessionNm=[NSString stringWithFormat:@"My %@",@"Dinner"];
             [self createNavigationView:@"Dinner"];
             navTitle=@"Dinner";*/
        }
        else if(selectedIndex==3)
        {
            self.selectedMealTypeId=snackId;
            /*sessionName.text=[NSString stringWithFormat:@"My %@",@"Snack"];
             sessionNm=[NSString stringWithFormat:@"My %@",@"Snack"];
             [self createNavigationView:@"Snack"];
             navTitle=@"Snack";*/
        }
        selectedFavMealTypeId=self.selectedMealTypeId;
        _selectedFoodArr=[NSMutableArray array];
        /*  _recentFoodArray=[NSMutableArray array];
         
         _recentFoodArray=[foodLogObject getAllFavoriteFoodLog:self.selectedMealTypeId withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
         if([_recentFoodArray count]>0){
         [self reloadRecentFoodTable];
         recentFoodTableView.hidden=NO;
         }
         else{
         recentFoodTableView.hidden=YES;
         }*/
        
        ////////////////////////////////////////////////////////////////////////////////////////////////
        favMealArr=[NSMutableArray array];
        favMealTitleArr=[NSMutableArray array];
        favMealTitleStr=@"";
        
        //NSMutableArray *arrFavDate=[foodLogObject getUniqueFavDate:selectedUserProfileID withMealID:self.selectedMealTypeId];
        NSMutableArray *arrFavDate=[favMealLogObj getUniqueFavDate:selectedUserProfileID withMealID:self.selectedMealTypeId];

        NSLog(@"arrFavDate==%@",arrFavDate);
        
        NSMutableArray *breakfastTitleFinalArr =[NSMutableArray array];
        NSMutableArray *breakfastMealFinalArr =[NSMutableArray array];
        
        for(int i=0;i<arrFavDate.count;i++)
        {
            //NSMutableArray *breakfastMealArr=[foodLogObject getFavMealFoodLog:self.selectedMealTypeId withSelectedDate:[arrFavDate objectAtIndex:i] withUserId:selectedUserProfileID];
            NSMutableArray *breakfastMealArr=[favMealLogObj getFavMealFoodLog:self.selectedMealTypeId withSelectedDate:[arrFavDate objectAtIndex:i] withUserId:selectedUserProfileID];
            if(breakfastMealArr.count>0)
            {
                NSMutableArray *breakfastTitleArr =[NSMutableArray array];
                
                NSString *breakfastTitleStr=@"";
                for(int i=0;i<breakfastMealArr.count;i++)
                {
                    [breakfastTitleArr addObject:[[breakfastMealArr objectAtIndex:i]objectForKey:@"food_name"]];
                }
                breakfastTitleStr = [breakfastTitleArr componentsJoinedByString:@" , "];
                [breakfastTitleFinalArr addObject:breakfastTitleStr];
                
                [breakfastMealFinalArr addObject:breakfastMealArr];
            }
            
        }
        
        if(breakfastMealFinalArr.count>0)
        {
            [favMealTitleArr addObject:breakfastTitleFinalArr];
            [favMealArr addObject:breakfastMealFinalArr];
            [self reloadDropDownFoodTable];
            
        }
        else
        {
            recentFoodTableView.hidden=YES;
        }
        ////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        [self getTotalCal];
        
    }
    else  if(Tag==6)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:selectedIndex forKey:@"selectedFavLogMenu"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        selectedDropdown=@"dropdown";
        NSMutableArray *allMealArr=[NSMutableArray array];
        allMealArr=[mealTypeObj findAllMealType];
        for(NSDictionary *dict in allMealArr){
            if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"breakfast"])
                breakfastId=[dict objectForKey:@"meal_type_id"];
            
            else if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"lunch"])
                lunchId=[dict objectForKey:@"meal_type_id"];
            
            else if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"dinner"])
                dinnerId=[dict objectForKey:@"meal_type_id"];
            else if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"snack"])
                snackId=[dict objectForKey:@"meal_type_id"];
        }
        
        if(selectedIndex==0)
        {
            self.selectedMealTypeId=breakfastId;
            /* sessionName.text=[NSString stringWithFormat:@"My %@",@"Breakfast"];
             sessionNm=[NSString stringWithFormat:@"My %@",@"Breakfast"];
             [self createNavigationView:@"Breakfast"];
             navTitle=@"Breakfast";*/
        }
        else if(selectedIndex==1)
        {
            self.selectedMealTypeId=lunchId;
            /*  sessionName.text=[NSString stringWithFormat:@"My %@",@"Lunch"];
             sessionNm=[NSString stringWithFormat:@"My %@",@"Lunch"];
             [self createNavigationView:@"Lunch"];
             navTitle=@"Lunch";*/
        }
        else if(selectedIndex==2)
        {
            self.selectedMealTypeId=dinnerId;
            /*sessionName.text=[NSString stringWithFormat:@"My %@",@"Dinner"];
             sessionNm=[NSString stringWithFormat:@"My %@",@"Dinner"];
             [self createNavigationView:@"Dinner"];
             navTitle=@"Dinner";*/
        }
        else if(selectedIndex==3)
        {
            self.selectedMealTypeId=snackId;
            /*sessionName.text=[NSString stringWithFormat:@"My %@",@"Snack"];
             sessionNm=[NSString stringWithFormat:@"My %@",@"Snack"];
             [self createNavigationView:@"Snack"];
             navTitle=@"Snack";*/
        }
        selectedFavMealTypeId=self.selectedMealTypeId;
        _selectedFoodArr=[NSMutableArray array];
        /*  _recentFoodArray=[NSMutableArray array];
         
         _recentFoodArray=[foodLogObject getAllRecentFoodLog:self.selectedMealTypeId withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
         
         if([_recentFoodArray count]>0){
         [self reloadRecentFoodTable];
         recentFoodTableView.hidden=NO;
         }
         else{
         recentFoodTableView.hidden=YES;
         }*/
        
        
        
        ////////////////////////////////////////////////////////////////////////////////////////////////
        favMealArr=[NSMutableArray array];
        favMealTitleArr=[NSMutableArray array];
        favMealTitleStr=@"";
        
        NSMutableArray *arrRecentDate=[foodLogObject getUniqueRecentDate:selectedUserProfileID withMealID:self.selectedMealTypeId];
        NSLog(@"arrRecentDate==%@",arrRecentDate);
        
        NSMutableArray *breakfastTitleFinalArr =[NSMutableArray array];
        NSMutableArray *breakfastMealFinalArr =[NSMutableArray array];
        for(int i=0;i<arrRecentDate.count;i++)
        {
            NSMutableArray *breakfastMealArr=[foodLogObject getRecentMealFoodLog:self.selectedMealTypeId withSelectedDate:[arrRecentDate objectAtIndex:i] withUserId:selectedUserProfileID];
            
            if(breakfastMealArr.count>0)
            {
                NSMutableArray *breakfastTitleArr =[NSMutableArray array];
                
                NSString *breakfastTitleStr=@"";
                for(int i=0;i<breakfastMealArr.count;i++)
                {
                    [breakfastTitleArr addObject:[[breakfastMealArr objectAtIndex:i]objectForKey:@"food_name"]];
                }
                breakfastTitleStr = [breakfastTitleArr componentsJoinedByString:@" , "];
                [breakfastTitleFinalArr addObject:breakfastTitleStr];
                
                [breakfastMealFinalArr addObject:breakfastMealArr];
            }
            
        }
        
        
        if(breakfastMealFinalArr.count>0)
        {
            [favMealTitleArr addObject:breakfastTitleFinalArr];
            [favMealArr addObject:breakfastMealFinalArr];
            [self reloadDropDownFoodTable];
            
        }
        else
        {
            recentFoodTableView.hidden=YES;
        }
        
        ////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        [self getTotalCal];
        
    }
    
}

-(void)rel
{
    dropDown = nil;
}

#pragma mark - UITouch Delegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [dropDown hideDropDown:btnDropDown];
    [self rel];
    [self.view endEditing:YES];
    
    DSLCalendarView *calenderVw = (DSLCalendarView *)[mDateUpperCustomView viewWithTag:1001];
    calenderVw.hidden=YES;
    mDateUpperCustomView.frame = CGRectMake(0, 0, mDateUpperCustomView.frame.size.width, 110);
    
    UIButton *btn=(UIButton *)[mDateUpperCustomView viewWithTag:2001];
    if(btn.selected==NO)
    {
        [btn setSelected:YES];
    }
    else
    {
        [btn setSelected:NO];
    }
    [mDateUpperCustomView hideToday];
}

#pragma mark - Server Connection Delegate
-(void)requestDidFinished:(id)result
{
    self.view.userInteractionEnabled = YES;
    isConnection=NO;
    
    @try
    {
        //For Bar Search Connection
        if([_connectType isEqualToString:@"searchBar"])
        {
            if ([result isKindOfClass:[NSError class]])
            {
                NSError *error=(NSError *)result;
                [autoCompleteTableView setHidden:YES];
                  autoCompleteTextField.text =@"";
                //[self createAlertView:@"Mesupro" withAlertMessage:error.localizedDescription withAlertTag:0];
                return;
            }
            
            if ([result isKindOfClass:[NSDictionary class]])
            {
                NSLog(@"%@",result);
                  autoCompleteTextField.text =@"";
                self.allSearchedFoodArr=[NSMutableArray array];
                
                NSMutableDictionary *subdict=[NSMutableDictionary dictionary];
                
                if(![[self chkNullInputinitWithString:[result objectForKey:@"item_id"]] isEqualToString:@""])
                {
                    [subdict setObject:[result objectForKey:@"item_id"] forKey:@"item"];
                }
                else
                {
                    [subdict setObject:@"" forKey:@"item"];
                }
                
                if(![[self chkNullInputinitWithString:[result objectForKey:@"item_name"]] isEqualToString:@""])
                {
                    [subdict setObject:[result objectForKey:@"item_name"] forKey:@"item_title"];
                }
                else
                {
                    [subdict setObject:@"" forKey:@"item_title"];
                }
                
                if(![[self chkNullInputinitWithString:[result objectForKey:@"item_description"]] isEqualToString:@""])
                {
                    [subdict setObject:[result objectForKey:@"item_description"] forKey:@"item_desc"];
                }
                else
                {
                    [subdict setObject:@"" forKey:@"item_desc"];
                }
                
                if ([[result allKeys] containsObject:@"nf_serving_weight_grams"])
                {
                    [subdict setObject:[result objectForKey:@"nf_serving_weight_grams"] forKey:@"item_weight"];
                }
                else
                {
                    [subdict setObject:@"0" forKey:@"item_weight"];
                }
                
                if ([[result allKeys] containsObject:@"nf_serving_size_qty"])
                {
                    [subdict setObject:[result objectForKey:@"nf_serving_size_qty"] forKey:@"serving_size"];
                }
                else
                {
                    [subdict setObject:@"0" forKey:@"serving_size"];
                }
                
                if ([[result allKeys] containsObject:@"nf_calories"])
                {
                    [subdict setObject:[result objectForKey:@"nf_calories"] forKey:@"cals"];
                }
                else
                {
                    [subdict setObject:@"0" forKey:@"cals"];
                }
                
                if([[subdict objectForKey:@"item"] isEqualToString:@""] && [[subdict objectForKey:@"item_title"] isEqualToString:@""] && [[subdict objectForKey:@"item_desc"] isEqualToString:@""]  && [[subdict objectForKey:@"item_weight"] isEqualToString:@"0"]  && [[subdict objectForKey:@"serving_size"] isEqualToString:@"0"]  && [[subdict objectForKey:@"cals"] isEqualToString:@"0"]  )
                {
                }
                else
                {
                    [self.allSearchedFoodArr addObject:subdict];
                }
                
                NSLog(@"self.allSearchedFoodArr=======%@",self.allSearchedFoodArr);
                if([self.allSearchedFoodArr count]>0)
                {
                    selectedIndexPathSearch=2000000;
                    autoCompleteTableView.delegate=self;
                    autoCompleteTableView.dataSource=self;
                    [autoCompleteTableView reloadData ];
                    [autoCompleteTableView setHidden:NO];
                }
                else
                {
                    autoCompleteTableView.delegate=self;
                    autoCompleteTableView.dataSource=self;
                    [autoCompleteTableView reloadData ];
                    [autoCompleteTableView setHidden:YES];
                    // APP_CTRL.searchStart=0;
                }
            }
        }
        
        //For Text Search Connection
        else if([_connectType isEqualToString:@"searchText"])
        {
            if ([result isKindOfClass:[NSError class]])
            {
                NSError *error=(NSError *)result;
                [autoCompleteTableView setHidden:YES];
                //[self createAlertView:@"Mesupro" withAlertMessage:error.localizedDescription withAlertTag:0];
                return;
            }
            
            if ([result isKindOfClass:[NSDictionary class]])
            {
                NSMutableArray *hits=[NSMutableArray array];
                
                hits=[[result objectForKey:@"hits"] mutableCopy];
                
                if([hits count]>0)
                {
                    logBtn.userInteractionEnabled=true;
                    self.allSearchedFoodArr=[NSMutableArray array];
                    
                    for(int i=0;i<[hits count];i++)
                    {
                        NSLog(@"element is======%@",[hits objectAtIndex:i] );
                        NSMutableDictionary *subdict=[NSMutableDictionary dictionary];
                        
                        if(![[self chkNullInputinitWithString:[[hits objectAtIndex:i] objectForKey:@"_id"]] isEqualToString:@""])
                        {
                            [subdict setObject:[[hits objectAtIndex:i] objectForKey:@"_id"] forKey:@"item"];
                        }
                        else
                        {
                            [subdict setObject:@"" forKey:@"item"];
                        }
                        
                        if(![[self chkNullInputinitWithString:[[[hits objectAtIndex:i] objectForKey:@"fields"] objectForKey:@"item_name"]] isEqualToString:@""])
                        {
                            NSString *brandName=@"",*foodName=@"" ;
                            foodName=[NSString stringWithFormat:@"%@",[[[hits objectAtIndex:i] objectForKey:@"fields"] objectForKey:@"item_name"] ];
                            
                            if(![[self chkNullInputinitWithString:[[[hits objectAtIndex:i] objectForKey:@"fields"] objectForKey:@"brand_name"]] isEqualToString:@""])
                            {
                                brandName=[NSString stringWithFormat:@", %@",[[[hits objectAtIndex:i] objectForKey:@"fields"] objectForKey:@"brand_name"] ];
                            }
                            
                            
                            [subdict setObject:[NSString stringWithFormat:@"%@%@",foodName,brandName] forKey:@"item_title"];
                            
                        }
                        else
                        {
                            [subdict setObject:@"" forKey:@"item_title"];
                        }
                        
                        if(![[self chkNullInputinitWithString:[[[hits objectAtIndex:i] objectForKey:@"fields"] objectForKey:@"item_description"]] isEqualToString:@""])
                        {
                            [subdict setObject:[[[hits objectAtIndex:i] objectForKey:@"fields"] objectForKey:@"item_description"] forKey:@"item_desc"];
                        }
                        else
                        {
                            [subdict setObject:@"" forKey:@"item_desc"];
                        }
                        
                        [subdict setObject:[[[hits objectAtIndex:i] objectForKey:@"fields"] objectForKey:@"nf_serving_size_qty"] forKey:@"serving_size"];
                        
                        [subdict setObject:[[[hits objectAtIndex:i] objectForKey:@"fields"] objectForKey:@"nf_calories"] forKey:@"cals"];
                        
                        [subdict setObject:[[[hits objectAtIndex:i] objectForKey:@"fields"] objectForKey:@"nf_serving_weight_grams"] forKey:@"item_weight"];
                        
                        [self.allSearchedFoodArr addObject:subdict];
                    }
                    NSLog(@"self.allSearchedFoodArr=======%@",self.allSearchedFoodArr);
                    
                    if([self.allSearchedFoodArr count]>0)
                    {
                        selectedIndexPathSearch=2000000;
                        autoCompleteTableView.delegate=self;
                        autoCompleteTableView.dataSource=self;
                        [autoCompleteTableView reloadData ];
                        [autoCompleteTableView setHidden:NO];
                    }
                    else
                    {
                        autoCompleteTableView.delegate=self;
                        autoCompleteTableView.dataSource=self;
                        [autoCompleteTableView reloadData ];
                        [autoCompleteTableView setHidden:YES];
                        //APP_CTRL.searchStart=0;
                    }
                }
            }
        }
    }
    
    @catch (NSException *exception)
    {
        NSLog(@"exception==%@",exception);
    }
    @finally {
    }
    
}

#pragma mark - Calender Notification Method
-(void)notifyDate:(NSString *)dateStr
{
}

-(void)notifySelectedDate:(NSString *)dateStr
{
    // logTimeStr=dateStr;
    if([self.logTime isEqualToString:@" " ] || self.logTime ==nil || self.logTime.length==0)
    {
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        formatter1.dateFormat = @"EEEE, MMMM dd, yyyy";
        NSDate *dateFromString = [formatter1 dateFromString:[[Utility sharedManager] getSelectedDate]];
        //  NSDate *dateFromString = [formatter1 dateFromString:dateStr];
        NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
        logTimeStr= [dateFormatter2 stringFromDate:dateFromString];
    }
    else
    {
        //logTimeStr=self.logTime;
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        formatter1.dateFormat = @"EEEE, MMMM dd, yyyy";
        NSDate *dateFromString = [formatter1 dateFromString:dateStr];
        NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
        
        logTimeStr= [dateFormatter2 stringFromDate:dateFromString];
        
    }
    NSLog(@"logTimeStr===%@",logTimeStr);
    
    if([sessionNm isEqualToString:@"My Meal"])
    {
        [mymealView setHidden:NO];
        [self createMyMealArr];
        NSLog(@"myMealArr==%@",myMealArr);
        NSLog(@"myMealSecTitleArr==%@",myMealSecTitleArr);
        
        myMealTable.delegate=self;
        myMealTable.dataSource=self;
        myMealTable.hidden=NO;
        [myMealTable reloadData];
        
    }
    else
    {
        _selectedFoodArr=[foodLogObject getAllLunchLog:self.selectedMealTypeId  withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
        if([_selectedFoodArr count]>0)
        {
            FavFoodVCount=0;
            _tblVw.tag=MEALSUBCATEGORY_TABLE_TAG;
            _tblVw.hidden=NO;
            _tblVw.delegate=self;
            _tblVw.dataSource=self;
            [_tblVw reloadData];
            
            //[self performSelector:@selector(selfCalculateTotalSubCategoryMeal) withObject:nil afterDelay:3.0];
        }
        else
        {
            _tblVw.hidden=YES;
        }
    }
    
    
    @try {
        
        if([selectedRecentFav isEqualToString:@"Recent"])
        {
            selectedIndexPathRecent=-1000000;
            selectedIndexPathRecentPrev=selectedIndexPathRecent;
            
            selectedIndexPathSearch=-2000000;
            
            selectedIndexPathNormal=-1000000;
            selectedIndexPathNormalPrev=selectedIndexPathNormal;
            
            selectedIndexPathFav=-1000000;
            selectedIndexPathFavPrev=selectedIndexPathFav;
            
            selectedIndexPathDropDownMeal=-1000000;
            selectedIndexPathDropDownMealPrev=selectedIndexPathDropDownMeal;
            
            //selectedId=[[sessionArray objectAtIndex:indexPath.row] objectForKey:@"meal_type_id"];
            
            //For Recent Food Section
            if(selectedItemRecent==0)
            {
                _recentFoodArray=[NSMutableArray array];
                _recentFoodArray=[foodLogObject getAllFoodLog:selectedUserProfileID ];
                
                
                selectedFavMealTypeId=@"";
                if(dropDown != nil)
                {
                    [dropDown hideDropDown:btnDropDown];
                    [self rel];
                }
                
                //  [self createNavigationView:@"Favorites"];
                navTitle=@"Recent";
                
                if([_recentFoodArray count]>0)
                {
                    [self reloadRecentFoodTable];
                    recentFoodTableView.hidden=NO;
                }
                else{
                    recentFoodTableView.hidden=YES;
                }
                [sessionCollectionView reloadData];
            }
            
            //For Recent Meal Section
            else if(selectedItemRecent==1)
            {
                [self createRecentMealArr];
                //  [self createNavigationView:@"Favorites"];
                navTitle=@"Recent";
                
                if([favMealArr count]>0)
                {
                    recentFoodTableView.hidden=NO;
                    
                    recentFoodTableView.tag=FAV_MEALSUBCAT_TABLE_TAG;
                    recentFoodTableView.delegate=self;
                    recentFoodTableView.dataSource=self;
                    [recentFoodTableView reloadData];
                    
                    recentFoodTableView.hidden=NO;
                }
                else{
                    recentFoodTableView.hidden=YES;
                }
                [sessionCollectionView reloadData];
            }
            
            //For Recent Meal DropDown Section
            else
            {
                //  UICollectionViewCell *cell = (UICollectionViewCell*)[sessionCollectionView cellForItemAtIndexPath:indexPath];
                UIButton  *dropdownCellBtn=(UIButton*) [recentFoodView viewWithTag:999];//(UIButton *)[cell viewWithTag:999];
                
                NSMutableArray  *arrDropDownTxtFoodFav= [[NSMutableArray alloc]init];
                
                
                NSMutableArray  *arrDropDownImgFoodFav= [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"breakfast_new"], [UIImage imageNamed:@"lunch_new"], [UIImage imageNamed:@"dinner_new"], [UIImage imageNamed:@"snack_new"],  nil];
                /*for(int i=0;i<4;i++)
                 {
                 NSString *mealID=[NSString stringWithFormat:@"%d",i+1];
                 int sumFoodLog= [foodLogObject getFoodSumIndividualCalorieRecent:mealID withUserProfileID:selectedUserProfileID withDate:logTimeStr];
                 NSString *strSumFoodLog=[NSString stringWithFormat:@"%d",sumFoodLog];
                 [arrDropDownTxtFoodFav addObject:strSumFoodLog];
                 }*/
                [arrDropDownTxtFoodFav addObject:@"Breakfast"];
                [arrDropDownTxtFoodFav addObject:@"Lunch"];
                [arrDropDownTxtFoodFav addObject:@"Dinner"];
                [arrDropDownTxtFoodFav addObject:@"Snack"];
                /*     if(dropDown == nil) {
                 
                 CGFloat f = 250;
                 dropDown = [[NIDropDown alloc]showDropDown:dropdownCellBtn :&f :arrDropDownTxtFoodFav :arrDropDownImgFoodFav :@"down" :6];
                 dropDown.delegate = self;
                 dropdownCellBtn.alpha=0.5;
                 mAppDelegate.dropDown=dropDown;
                 mAppDelegate.btnDropDown=dropdownCellBtn;
                 }
                 else {
                 [dropDown hideDropDown:dropdownCellBtn];
                 dropdownCellBtn.alpha=1.0;
                 [self rel];
                 }*/
                
                [sessionCollectionView reloadData];
            }
            
            
            
        }
        else{
            selectedIndexPathRecent=-1000000;
            selectedIndexPathRecentPrev=selectedIndexPathRecent;
            
            selectedIndexPathSearch=-2000000;
            
            selectedIndexPathNormal=-1000000;
            selectedIndexPathNormalPrev=selectedIndexPathNormal;
            
            selectedIndexPathFav=-1000000;
            selectedIndexPathFavPrev=selectedIndexPathFav;
            
            selectedIndexPathDropDownMeal=-1000000;
            selectedIndexPathDropDownMealPrev=selectedIndexPathDropDownMeal;
            
            //selectedId=[[sessionArray objectAtIndex:indexPath.row] objectForKey:@"meal_type_id"];
            
            //For Favourite Food Section
            if(selectedItemFav==0)
            {
                _recentFoodArray=[NSMutableArray array];
               // _recentFoodArray=[foodLogObject getAllFavoriteFoodLog:@"" withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
                _recentFoodArray=[favFoodLogObj getAllFavoriteFoodLog:@"" withSelectedDate:logTimeStr withUserId:selectedUserProfileID];

                selectedFavMealTypeId=@"";
                if(dropDown != nil)
                {
                    [dropDown hideDropDown:btnDropDown];
                    [self rel];
                }
                
                //  [self createNavigationView:@"Favorites"];
                navTitle=@"Favorites";
                
                if([_recentFoodArray count]>0)
                {
                    [self reloadRecentFoodTable];
                    recentFoodTableView.hidden=NO;
                }
                else{
                    recentFoodTableView.hidden=YES;
                }
                [sessionCollectionView reloadData];
            }
            
            //For Favourite Meal Section
            else if(selectedItemFav==1)
            {
                [self createFavMealArr];
                //  [self createNavigationView:@"Favorites"];
                navTitle=@"Favorites";
                
                if([favMealArr count]>0)
                {
                    recentFoodTableView.hidden=NO;
                    
                    recentFoodTableView.tag=FAV_MEALSUBCAT_TABLE_TAG;
                    recentFoodTableView.delegate=self;
                    recentFoodTableView.dataSource=self;
                    [recentFoodTableView reloadData];
                    
                    recentFoodTableView.hidden=NO;
                }
                else{
                    recentFoodTableView.hidden=YES;
                }
                [sessionCollectionView reloadData];
            }
            
            //For Favourite Meal DropDown Section
            else
            {
                //  UICollectionViewCell *cell = (UICollectionViewCell*)[sessionCollectionView cellForItemAtIndexPath:indexPath];
                UIButton  *dropdownCellBtn=(UIButton*) [recentFoodView viewWithTag:999];//(UIButton *)[cell viewWithTag:999];
                
                NSMutableArray  *arrDropDownTxtFoodFav= [[NSMutableArray alloc]init];
                
                /*  int sumFood= [foodLogObject getFoodSumIndividualCalorieFav:@"" withUserProfileID:selectedUserProfileID withDate:logTimeStr];
                 NSString *strSumFoodTotal=[NSString stringWithFormat:@"%d",sumFood];
                 [arrDropDownTxtFoodFav addObject:strSumFoodTotal];*/
                
                // NSMutableArray  *arrDropDownImgFoodFav= [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"Breakfast.png"], [UIImage imageNamed:@"Lunch.png"], [UIImage imageNamed:@"Dinner.png"], [UIImage imageNamed:@"Snack.png"],  nil];
                NSMutableArray  *arrDropDownImgFoodFav= [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"breakfast_new"], [UIImage imageNamed:@"lunch_new"], [UIImage imageNamed:@"dinner_new"], [UIImage imageNamed:@"snack_new"],  nil];
                /*for(int i=0;i<4;i++)
                 {
                 NSString *mealID=[NSString stringWithFormat:@"%d",i+1];
                 int sumFoodLog= [foodLogObject getFoodSumIndividualCalorieFav:mealID withUserProfileID:selectedUserProfileID withDate:logTimeStr];
                 NSString *strSumFoodLog=[NSString stringWithFormat:@"%d",sumFoodLog];
                 [arrDropDownTxtFoodFav addObject:strSumFoodLog];
                 }*/
                [arrDropDownTxtFoodFav addObject:@"Breakfast"];
                [arrDropDownTxtFoodFav addObject:@"Lunch"];
                [arrDropDownTxtFoodFav addObject:@"Dinner"];
                [arrDropDownTxtFoodFav addObject:@"Snack"];
                /*  if(dropDown == nil) {
                 
                 CGFloat f = 250;
                 dropDown = [[NIDropDown alloc]showDropDown:dropdownCellBtn :&f :arrDropDownTxtFoodFav :arrDropDownImgFoodFav :@"down" :5];
                 dropDown.delegate = self;
                 dropdownCellBtn.alpha=0.5;
                 mAppDelegate.dropDown=dropDown;
                 mAppDelegate.btnDropDown=dropdownCellBtn;
                 }
                 else {
                 [dropDown hideDropDown:dropdownCellBtn];
                 dropdownCellBtn.alpha=1.0;
                 [self rel];
                 }*/
                
                [sessionCollectionView reloadData];
            }
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception : %@",exception);
    }
    @finally {
        
    }
    
    /*  if([navTitle isEqualToString:@"Recent"])
     {
     _recentFoodArray=[foodLogObject getAllFoodLog:selectedUserProfileID];
     selectedButton=1;
     [self reloadRecentFoodTable];
     }
     else if([navTitle isEqualToString:@"Favorites"])
     {
     _recentFoodArray=[foodLogObject getAllFavoriteFoodLog:@"" withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
     selectedButton=2;
     [self reloadRecentFoodTable];
     }*/
    
    [self refreshViewDropdownView];
    [self getTotalCal];
}

#pragma mark - "Recent" Button Action
- (IBAction)btnActionRecentFood:(id)sender
{
    [self updateSelectedIndexPath];
    
    if(dropDown != nil) {
        [dropDown hideDropDown:btnDropDown];
        [self rel];
    }
    selectedRecentFav=@"Recent";
    
    selectedItem=0;
    [swipeFood setDirection: UISwipeGestureRecognizerDirectionDown];
    [swipeMeal setDirection:UISwipeGestureRecognizerDirectionDown];
    
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if(family==iPad)
            recentMealViewTopConstant.constant=300;
        else
            recentMealViewTopConstant.constant=142;//150;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished){
        
    }];
    autoCompleteTextField.text=@"";
    autoCompleteTableView.hidden=YES;
    sessionCollectionViewHeight.constant=40;
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [self.view layoutIfNeeded];
        sessionCollectionView.delegate=self;
        sessionCollectionView.dataSource=self;
        [sessionCollectionView reloadData];
        
    } completion:^(BOOL finished){
        
        
    }];
    [btn_recentFood setBackgroundColor:[UIColor colorWithRed:183/255.0 green:32/255.0 blue:109/255.0 alpha:1]];
    
    [btn_recentMeal setBackgroundColor:[UIColor colorWithRed:189/255.0 green:119/255.0 blue:164/255.0 alpha:1]];
    
    selectedButton=1;
    
    //    _recentFoodArray=[foodLogObject getAllFoodLog:selectedUserProfileID ];
    //        [self reloadRecentFoodTable];
    
    //[self createNavigationView:@"Recent"];
    navTitle=@"Recent";
    
    
    @try {
        
        if([selectedRecentFav isEqualToString:@"Recent"])
        {
            selectedIndexPathRecent=-1000000;
            selectedIndexPathRecentPrev=selectedIndexPathRecent;
            
            selectedIndexPathSearch=-2000000;
            
            selectedIndexPathNormal=-1000000;
            selectedIndexPathNormalPrev=selectedIndexPathNormal;
            
            selectedIndexPathFav=-1000000;
            selectedIndexPathFavPrev=selectedIndexPathFav;
            
            selectedIndexPathDropDownMeal=-1000000;
            selectedIndexPathDropDownMealPrev=selectedIndexPathDropDownMeal;
            
            //selectedId=[[sessionArray objectAtIndex:indexPath.row] objectForKey:@"meal_type_id"];
            
            //For Recent Food Section
            if(selectedItemRecent==0)
            {
                _recentFoodArray=[NSMutableArray array];
                _recentFoodArray=[foodLogObject getAllFoodLog:selectedUserProfileID ];
                
                
                selectedFavMealTypeId=@"";
                if(dropDown != nil)
                {
                    [dropDown hideDropDown:btnDropDown];
                    [self rel];
                }
                
                //  [self createNavigationView:@"Favorites"];
                navTitle=@"Recent";
                
                if([_recentFoodArray count]>0)
                {
                    [self reloadRecentFoodTable];
                    recentFoodTableView.hidden=NO;
                }
                else{
                    recentFoodTableView.hidden=YES;
                }
                [sessionCollectionView reloadData];
            }
            
            //For Recent Meal Section
            else if(selectedItemRecent==1)
            {
                [self createRecentMealArr];
                //  [self createNavigationView:@"Favorites"];
                navTitle=@"Recent";
                
                if([favMealArr count]>0)
                {
                    recentFoodTableView.hidden=NO;
                    
                    recentFoodTableView.tag=FAV_MEALSUBCAT_TABLE_TAG;
                    recentFoodTableView.delegate=self;
                    recentFoodTableView.dataSource=self;
                    [recentFoodTableView reloadData];
                    
                    recentFoodTableView.hidden=NO;
                }
                else{
                    recentFoodTableView.hidden=YES;
                }
                [sessionCollectionView reloadData];
            }
            
            //For Recent Meal DropDown Section
            else
            {
                //  UICollectionViewCell *cell = (UICollectionViewCell*)[sessionCollectionView cellForItemAtIndexPath:indexPath];
                UIButton  *dropdownCellBtn=(UIButton*) [recentFoodView viewWithTag:999];//(UIButton *)[cell viewWithTag:999];
                
                NSMutableArray  *arrDropDownTxtFoodFav= [[NSMutableArray alloc]init];
                
                
                NSMutableArray  *arrDropDownImgFoodFav= [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"breakfast_new"], [UIImage imageNamed:@"lunch_new"], [UIImage imageNamed:@"dinner_new"], [UIImage imageNamed:@"snack_new"],  nil];
                /*for(int i=0;i<4;i++)
                 {
                 NSString *mealID=[NSString stringWithFormat:@"%d",i+1];
                 int sumFoodLog= [foodLogObject getFoodSumIndividualCalorieRecent:mealID withUserProfileID:selectedUserProfileID withDate:logTimeStr];
                 NSString *strSumFoodLog=[NSString stringWithFormat:@"%d",sumFoodLog];
                 [arrDropDownTxtFoodFav addObject:strSumFoodLog];
                 }*/
                [arrDropDownTxtFoodFav addObject:@"Breakfast"];
                [arrDropDownTxtFoodFav addObject:@"Lunch"];
                [arrDropDownTxtFoodFav addObject:@"Dinner"];
                [arrDropDownTxtFoodFav addObject:@"Snack"];
                /*     if(dropDown == nil) {
                 
                 CGFloat f = 250;
                 dropDown = [[NIDropDown alloc]showDropDown:dropdownCellBtn :&f :arrDropDownTxtFoodFav :arrDropDownImgFoodFav :@"down" :6];
                 dropDown.delegate = self;
                 dropdownCellBtn.alpha=0.5;
                 mAppDelegate.dropDown=dropDown;
                 mAppDelegate.btnDropDown=dropdownCellBtn;
                 }
                 else {
                 [dropDown hideDropDown:dropdownCellBtn];
                 dropdownCellBtn.alpha=1.0;
                 [self rel];
                 }*/
                
                [sessionCollectionView reloadData];
            }
            
            
            
        }
        else{
            selectedIndexPathRecent=-1000000;
            selectedIndexPathRecentPrev=selectedIndexPathRecent;
            
            selectedIndexPathSearch=-2000000;
            
            selectedIndexPathNormal=-1000000;
            selectedIndexPathNormalPrev=selectedIndexPathNormal;
            
            selectedIndexPathFav=-1000000;
            selectedIndexPathFavPrev=selectedIndexPathFav;
            
            selectedIndexPathDropDownMeal=-1000000;
            selectedIndexPathDropDownMealPrev=selectedIndexPathDropDownMeal;
            
            //selectedId=[[sessionArray objectAtIndex:indexPath.row] objectForKey:@"meal_type_id"];
            
            //For Favourite Food Section
            if(selectedItemFav==0)
            {
                _recentFoodArray=[NSMutableArray array];
              //  _recentFoodArray=[foodLogObject getAllFavoriteFoodLog:@"" withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
                _recentFoodArray=[favFoodLogObj getAllFavoriteFoodLog:@"" withSelectedDate:logTimeStr withUserId:selectedUserProfileID];

                selectedFavMealTypeId=@"";
                if(dropDown != nil)
                {
                    [dropDown hideDropDown:btnDropDown];
                    [self rel];
                }
                
                //  [self createNavigationView:@"Favorites"];
                navTitle=@"Favorites";
                
                if([_recentFoodArray count]>0)
                {
                    [self reloadRecentFoodTable];
                    recentFoodTableView.hidden=NO;
                }
                else{
                    recentFoodTableView.hidden=YES;
                }
                [sessionCollectionView reloadData];
            }
            
            //For Favourite Meal Section
            else if(selectedItemFav==1)
            {
                [self createFavMealArr];
                //  [self createNavigationView:@"Favorites"];
                navTitle=@"Favorites";
                
                if([favMealArr count]>0)
                {
                    recentFoodTableView.hidden=NO;
                    
                    recentFoodTableView.tag=FAV_MEALSUBCAT_TABLE_TAG;
                    recentFoodTableView.delegate=self;
                    recentFoodTableView.dataSource=self;
                    [recentFoodTableView reloadData];
                    
                    recentFoodTableView.hidden=NO;
                }
                else{
                    recentFoodTableView.hidden=YES;
                }
                [sessionCollectionView reloadData];
            }
            
            //For Favourite Meal DropDown Section
            else
            {
                //  UICollectionViewCell *cell = (UICollectionViewCell*)[sessionCollectionView cellForItemAtIndexPath:indexPath];
                UIButton  *dropdownCellBtn=(UIButton*) [recentFoodView viewWithTag:999];//(UIButton *)[cell viewWithTag:999];
                
                NSMutableArray  *arrDropDownTxtFoodFav= [[NSMutableArray alloc]init];
                
                /*  int sumFood= [foodLogObject getFoodSumIndividualCalorieFav:@"" withUserProfileID:selectedUserProfileID withDate:logTimeStr];
                 NSString *strSumFoodTotal=[NSString stringWithFormat:@"%d",sumFood];
                 [arrDropDownTxtFoodFav addObject:strSumFoodTotal];*/
                
                // NSMutableArray  *arrDropDownImgFoodFav= [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"Breakfast.png"], [UIImage imageNamed:@"Lunch.png"], [UIImage imageNamed:@"Dinner.png"], [UIImage imageNamed:@"Snack.png"],  nil];
                NSMutableArray  *arrDropDownImgFoodFav= [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"breakfast_new"], [UIImage imageNamed:@"lunch_new"], [UIImage imageNamed:@"dinner_new"], [UIImage imageNamed:@"snack_new"],  nil];
                /*for(int i=0;i<4;i++)
                 {
                 NSString *mealID=[NSString stringWithFormat:@"%d",i+1];
                 int sumFoodLog= [foodLogObject getFoodSumIndividualCalorieFav:mealID withUserProfileID:selectedUserProfileID withDate:logTimeStr];
                 NSString *strSumFoodLog=[NSString stringWithFormat:@"%d",sumFoodLog];
                 [arrDropDownTxtFoodFav addObject:strSumFoodLog];
                 }*/
                [arrDropDownTxtFoodFav addObject:@"Breakfast"];
                [arrDropDownTxtFoodFav addObject:@"Lunch"];
                [arrDropDownTxtFoodFav addObject:@"Dinner"];
                [arrDropDownTxtFoodFav addObject:@"Snack"];
                /*  if(dropDown == nil) {
                 
                 CGFloat f = 250;
                 dropDown = [[NIDropDown alloc]showDropDown:dropdownCellBtn :&f :arrDropDownTxtFoodFav :arrDropDownImgFoodFav :@"down" :5];
                 dropDown.delegate = self;
                 dropdownCellBtn.alpha=0.5;
                 mAppDelegate.dropDown=dropDown;
                 mAppDelegate.btnDropDown=dropdownCellBtn;
                 }
                 else {
                 [dropDown hideDropDown:dropdownCellBtn];
                 dropdownCellBtn.alpha=1.0;
                 [self rel];
                 }*/
                
                [sessionCollectionView reloadData];
            }
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception : %@",exception);
    }
    @finally {
        
    }
    
}

#pragma mark - "Favorites" Button Action
- (IBAction)btnActionRecentMeal:(id)sender
{
    [self updateSelectedIndexPath];
    
    if(dropDown != nil) {
        [dropDown hideDropDown:btnDropDown];
        [self rel];
    }
    
    selectedRecentFav=@"Favorites";
    selectedFavMealTypeId=@"";
    
    [swipeFood setDirection: UISwipeGestureRecognizerDirectionDown];
    [swipeMeal setDirection:UISwipeGestureRecognizerDirectionDown];
    
    // sessionArray=[mealTypeObj findAllMealType];
    selectedItem=0;
    
    if(family==iPad)
        recentMealViewTopConstant.constant=300;
    else
        recentMealViewTopConstant.constant=142;//150;
    
    if(family==iPad)
        sessionCollectionViewHeight.constant=60;
    else
        sessionCollectionViewHeight.constant=40;
    
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [self.view layoutIfNeeded];
        sessionCollectionView.delegate=self;
        sessionCollectionView.dataSource=self;
        [sessionCollectionView reloadData];
        
    } completion:^(BOOL finished){
        
        
    }];
    
    autoCompleteTextField.text=@"";
    autoCompleteTableView.hidden=YES;
    [btn_recentMeal setBackgroundColor:[UIColor colorWithRed:183/255.0 green:32/255.0 blue:109/255.0 alpha:1]];
    
    [btn_recentFood setBackgroundColor:[UIColor colorWithRed:189/255.0 green:119/255.0 blue:164/255.0 alpha:1]];
    
    selectedButton=2;
    
    //  [self createNavigationView:@"Favorites"];
    navTitle=@"Favorites";
    
    @try {
        
        if([selectedRecentFav isEqualToString:@"Recent"])
        {
            selectedIndexPathRecent=-1000000;
            selectedIndexPathRecentPrev=selectedIndexPathRecent;
            
            selectedIndexPathSearch=-2000000;
            
            selectedIndexPathNormal=-1000000;
            selectedIndexPathNormalPrev=selectedIndexPathNormal;
            
            selectedIndexPathFav=-1000000;
            selectedIndexPathFavPrev=selectedIndexPathFav;
            
            
            //selectedId=[[sessionArray objectAtIndex:indexPath.row] objectForKey:@"meal_type_id"];
            
            //For Recent Food Section
            if(selectedItemRecent==0)
            {
                _recentFoodArray=[NSMutableArray array];
                _recentFoodArray=[foodLogObject getAllFoodLog:selectedUserProfileID ];
                
                
                selectedFavMealTypeId=@"";
                if(dropDown != nil)
                {
                    [dropDown hideDropDown:btnDropDown];
                    [self rel];
                }
                
                //  [self createNavigationView:@"Favorites"];
                navTitle=@"Recent";
                
                if([_recentFoodArray count]>0)
                {
                    [self reloadRecentFoodTable];
                    recentFoodTableView.hidden=NO;
                }
                else{
                    recentFoodTableView.hidden=YES;
                }
                [sessionCollectionView reloadData];
            }
            
            //For Recent Meal Section
            else if(selectedItemRecent==1)
            {
                [self createRecentMealArr];
                //  [self createNavigationView:@"Favorites"];
                navTitle=@"Recent";
                
                if([favMealArr count]>0)
                {
                    recentFoodTableView.hidden=NO;
                    
                    recentFoodTableView.tag=FAV_MEALSUBCAT_TABLE_TAG;
                    recentFoodTableView.delegate=self;
                    recentFoodTableView.dataSource=self;
                    [recentFoodTableView reloadData];
                    
                    recentFoodTableView.hidden=NO;
                }
                else{
                    recentFoodTableView.hidden=YES;
                }
                [sessionCollectionView reloadData];
            }
            
            //For Recent Meal DropDown Section
            else
            {
                //  UICollectionViewCell *cell = (UICollectionViewCell*)[sessionCollectionView cellForItemAtIndexPath:indexPath];
                UIButton  *dropdownCellBtn=(UIButton*) [recentFoodView viewWithTag:999];//(UIButton *)[cell viewWithTag:999];
                
                NSMutableArray  *arrDropDownTxtFoodFav= [[NSMutableArray alloc]init];
                
                
                NSMutableArray  *arrDropDownImgFoodFav= [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"breakfast_new"], [UIImage imageNamed:@"lunch_new"], [UIImage imageNamed:@"dinner_new"], [UIImage imageNamed:@"snack_new"],  nil];
                /* for(int i=0;i<4;i++)
                 {
                 NSString *mealID=[NSString stringWithFormat:@"%d",i+1];
                 int sumFoodLog= [foodLogObject getFoodSumIndividualCalorieRecent:mealID withUserProfileID:selectedUserProfileID withDate:logTimeStr];
                 NSString *strSumFoodLog=[NSString stringWithFormat:@"%d",sumFoodLog];
                 [arrDropDownTxtFoodFav addObject:strSumFoodLog];
                 }*/
                [arrDropDownTxtFoodFav addObject:@"Breakfast"];
                [arrDropDownTxtFoodFav addObject:@"Lunch"];
                [arrDropDownTxtFoodFav addObject:@"Dinner"];
                [arrDropDownTxtFoodFav addObject:@"Snack"];
                /*  if(dropDown == nil) {
                 
                 CGFloat f = 250;
                 dropDown = [[NIDropDown alloc]showDropDown:dropdownCellBtn :&f :arrDropDownTxtFoodFav :arrDropDownImgFoodFav :@"down" :6];
                 dropDown.delegate = self;
                 dropdownCellBtn.alpha=0.5;
                 mAppDelegate.dropDown=dropDown;
                 mAppDelegate.btnDropDown=dropdownCellBtn;
                 }
                 else {
                 [dropDown hideDropDown:dropdownCellBtn];
                 dropdownCellBtn.alpha=1.0;
                 [self rel];
                 }*/
                
                [sessionCollectionView reloadData];
            }
            
            
            
        }
        else{
            selectedIndexPathRecent=-1000000;
            selectedIndexPathRecentPrev=selectedIndexPathRecent;
            
            selectedIndexPathSearch=-2000000;
            
            selectedIndexPathNormal=-1000000;
            selectedIndexPathNormalPrev=selectedIndexPathNormal;
            
            selectedIndexPathFav=-1000000;
            selectedIndexPathFavPrev=selectedIndexPathFav;
            
            
            //selectedId=[[sessionArray objectAtIndex:indexPath.row] objectForKey:@"meal_type_id"];
            
            //For Favourite Food Section
            if(selectedItemFav==0)
            {
                _recentFoodArray=[NSMutableArray array];
               // _recentFoodArray=[foodLogObject getAllFavoriteFoodLog:@"" withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
                _recentFoodArray=[favFoodLogObj getAllFavoriteFoodLog:@"" withSelectedDate:logTimeStr withUserId:selectedUserProfileID];

                selectedFavMealTypeId=@"";
                if(dropDown != nil)
                {
                    [dropDown hideDropDown:btnDropDown];
                    [self rel];
                }
                
                //  [self createNavigationView:@"Favorites"];
                navTitle=@"Favorites";
                
                if([_recentFoodArray count]>0)
                {
                    [self reloadRecentFoodTable];
                    recentFoodTableView.hidden=NO;
                }
                else{
                    recentFoodTableView.hidden=YES;
                }
                [sessionCollectionView reloadData];
            }
            
            //For Favourite Meal Section
            else if(selectedItemFav==1)
            {
                [self createFavMealArr];
                //  [self createNavigationView:@"Favorites"];
                navTitle=@"Favorites";
                
                if([favMealArr count]>0)
                {
                    recentFoodTableView.hidden=NO;
                    
                    recentFoodTableView.tag=FAV_MEALSUBCAT_TABLE_TAG;
                    recentFoodTableView.delegate=self;
                    recentFoodTableView.dataSource=self;
                    [recentFoodTableView reloadData];
                    
                    recentFoodTableView.hidden=NO;
                }
                else{
                    recentFoodTableView.hidden=YES;
                }
                [sessionCollectionView reloadData];
            }
            
            //For Favourite Meal DropDown Section
            else
            {
                //  UICollectionViewCell *cell = (UICollectionViewCell*)[sessionCollectionView cellForItemAtIndexPath:indexPath];
                UIButton  *dropdownCellBtn=(UIButton*) [recentFoodView viewWithTag:999];//(UIButton *)[cell viewWithTag:999];
                
                NSMutableArray  *arrDropDownTxtFoodFav= [[NSMutableArray alloc]init];
                
                /*  int sumFood= [foodLogObject getFoodSumIndividualCalorieFav:@"" withUserProfileID:selectedUserProfileID withDate:logTimeStr];
                 NSString *strSumFoodTotal=[NSString stringWithFormat:@"%d",sumFood];
                 [arrDropDownTxtFoodFav addObject:strSumFoodTotal];*/
                
                // NSMutableArray  *arrDropDownImgFoodFav= [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"Breakfast.png"], [UIImage imageNamed:@"Lunch.png"], [UIImage imageNamed:@"Dinner.png"], [UIImage imageNamed:@"Snack.png"],  nil];
                NSMutableArray  *arrDropDownImgFoodFav= [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"breakfast_new"], [UIImage imageNamed:@"lunch_new"], [UIImage imageNamed:@"dinner_new"], [UIImage imageNamed:@"snack_new"],  nil];
                /* for(int i=0;i<4;i++)
                 {
                 NSString *mealID=[NSString stringWithFormat:@"%d",i+1];
                 int sumFoodLog= [foodLogObject getFoodSumIndividualCalorieFav:mealID withUserProfileID:selectedUserProfileID withDate:logTimeStr];
                 NSString *strSumFoodLog=[NSString stringWithFormat:@"%d",sumFoodLog];
                 [arrDropDownTxtFoodFav addObject:strSumFoodLog];
                 }*/
                [arrDropDownTxtFoodFav addObject:@"Breakfast"];
                [arrDropDownTxtFoodFav addObject:@"Lunch"];
                [arrDropDownTxtFoodFav addObject:@"Dinner"];
                [arrDropDownTxtFoodFav addObject:@"Snack"];
                /* if(dropDown == nil) {
                 CGFloat f = 250;
                 dropDown = [[NIDropDown alloc]showDropDown:dropdownCellBtn :&f :arrDropDownTxtFoodFav :arrDropDownImgFoodFav :@"down" :5];
                 dropDown.delegate = self;
                 dropdownCellBtn.alpha=0.5;
                 mAppDelegate.dropDown=dropDown;
                 mAppDelegate.btnDropDown=dropdownCellBtn;
                 }
                 else {
                 [dropDown hideDropDown:dropdownCellBtn];
                 dropdownCellBtn.alpha=1.0;
                 [self rel];
                 }*/
                
                [sessionCollectionView reloadData];
            }
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception : %@",exception);
    }
    @finally {
        
    }
    
}

-(void)reloadDropDownFoodTable
{
    recentFoodTableView.hidden=NO;
    
    recentFoodTableView.tag=FAV_MEALDROPDOWN_TABLE_TAG;
    recentFoodTableView.delegate=self;
    recentFoodTableView.dataSource=self;
    [recentFoodTableView reloadData];
}

#pragma mark - Reload RecentFoodTable Method
-(void)reloadRecentFoodTable
{
    recentFoodTableView.hidden=NO;
    
    recentFoodTableView.tag=RECENT_TABLE_TAG;
    recentFoodTableView.delegate=self;
    recentFoodTableView.dataSource=self;
    [recentFoodTableView reloadData];
}

-(void)notifyRecentFoodSearch:(NSMutableArray *)searchedFoodArr{
    
    //    _recentSelectedFoodArr=[searchedFoodArr mutableCopy];
    //    popupShown=0;
    //    goBack=0;
    //
    //    if([self.previous_activity isEqualToString:@"FromPlanner"])
    //        goBack=1;
    
}
- (IBAction)btnActionRecentMeals:(id)sender
{
}

#pragma mark - Private Method
-(NSString*)getCurrentDateTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"Y-M-dd HH:mm:ss";
    NSString *string = [formatter stringFromDate:[NSDate date]];
    return string;
}

-(NSString*)getCurrentDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"Y-M-dd HH:mm:ss";
    NSString *string = [formatter stringFromDate:[NSDate date]];
    return string;
}
-(NSString *)getCurrentTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm:ss";
    NSString *string = [formatter stringFromDate:[NSDate date]];
    return string;
}
#pragma mark - getLabelSize Method
-(CGRect)getLabelSizeForFavMeal:(NSString *)str :(CGFloat)width
{
    NSLog(@"string=====%@ and width=== %f",str,width);
    CGSize maxSize = CGSizeZero;
    maxSize = CGSizeMake(width, MAXFLOAT);
    __unused float rowHeight=0.0;
    float fontSize = 0.0;
    if (thisDeviceFamily() == iPad)
    {
        fontSize = 20.0;
    }
    else
    {
        fontSize = 15.0;
    }
    
    NSMutableParagraphStyle *style=[NSMutableParagraphStyle new];
    style.lineSpacing=6;
    
    UIFont *font=[UIFont fontWithName:@"SinkinSans-300Light" size:fontSize];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: font}];
    
    [attributedText addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
    
    
    maxSize = CGSizeMake(width, MAXFLOAT);
    
    CGRect labelRect = [attributedText boundingRectWithSize:maxSize
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                    context:nil];
    return labelRect;
    
}
-(CGRect)getLabelSize:(NSString *)str :(CGFloat)width
{
    NSMutableParagraphStyle *style=[NSMutableParagraphStyle new];
    style.lineSpacing=6;
    
    UIFont *font=[UIFont fontWithName:@"SinkinSans-300Light" size:15];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: font}];
    
    [attributedText addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
    
    CGSize maxSize = CGSizeZero;
    // maxSize = CGSizeMake(width-space, MAXFLOAT);
    maxSize = CGSizeMake(width, MAXFLOAT);
    __unused float rowHeight=0.0;
    
    //CGRect labelRect = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{                                                                NSFontAttributeName : font                                                                                                                                                                                                                                                                        }      context:nil];
    
    
    CGRect labelRect = [attributedText boundingRectWithSize:maxSize
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                    context:nil];
    return labelRect;
}
#pragma mark - Change Favorite Status in Meal SubCategory Table
-(void)AddFavourite:(UIButton* )sender
{
    NSString *selectedRowIndex=[NSString stringWithFormat:@"%@",sender.accessibilityHint ];
    
    NSArray *itemArr=[[NSString stringWithFormat:@"%@",selectedRowIndex]componentsSeparatedByString:@"#"];
    NSLog(@"selected row is===%@",itemArr );
    NSString *foodIdToAddFav=[itemArr objectAtIndex:2];
    
    NSString *foodStatusToAddFav=[itemArr objectAtIndex:1];
    
    NSString *mealStatusToAddFav=[itemArr objectAtIndex:0];
    
    NSString *refFoodIDToAddFav=[itemArr objectAtIndex:4];
    
    if([self.previous_activity isEqualToString:@"FromPlanner"]||[self.previous_activity isEqualToString:@"newPlanner"])
    {
        if(_selectedFoodDictArr.count>0)
        {
                NSString *foodStatusToAddFav=[[_selectedFoodDictArr objectAtIndex:[[itemArr objectAtIndex:3]integerValue]]objectForKey:@"isFavorite"];
                if([foodStatusToAddFav isEqualToString:@"1"])
                {
                    NSMutableDictionary *oldDict =[_selectedFoodDictArr objectAtIndex:[[itemArr objectAtIndex:3]integerValue]];
                    [oldDict  setValue:@"0" forKey:@"isFavorite"];
                    [_selectedFoodDictArr replaceObjectAtIndex:[[itemArr objectAtIndex:3]integerValue] withObject:oldDict];
                }
                else
                {
                    NSMutableDictionary *oldDict =[_selectedFoodDictArr objectAtIndex:[[itemArr objectAtIndex:3]integerValue]];
                    [oldDict  setValue:@"1" forKey:@"isFavorite"];
                    [_selectedFoodDictArr replaceObjectAtIndex:[[itemArr objectAtIndex:3]integerValue] withObject:oldDict];
                    
                }
                
                _selectedFoodArr=[_selectedFoodDictArr mutableCopy];
        }
    }
    else
    {
         if([foodStatusToAddFav isEqualToString:@"1"])
        {
            [foodLogObject updateFavoriteStatus:@"0" foodID:foodIdToAddFav  withUserProfileID:selectedUserProfileID withFoodRefID:refFoodIDToAddFav];
             [favFoodLogObj deleteFavFoodData:foodIdToAddFav withUserId:selectedUserProfileID];
        }
        else
        {
            NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
            formatter1.dateFormat = @"EEEE, MMMM dd, yyyy";
            NSDate *dateFromString = [formatter1 dateFromString:[[Utility sharedManager] getSelectedDate]];
            //  NSDate *dateFromString = [formatter1 dateFromString:dateStr];
            NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc] init];
            [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
            logTimeStr= [dateFormatter2 stringFromDate:dateFromString];
          
            favFoodLogObj.log_date_added=[self getCurrentDateTime];
            favFoodLogObj.log_log_time=[NSString stringWithFormat:@"%@ %@",logTimeStr,[self getCurrentTime]];

            favFoodLogObj.log_meal_id=[[_selectedFoodArr objectAtIndex:[[itemArr objectAtIndex:3]integerValue]] objectForKey:@"meal_id"];
            
            if([[[_selectedFoodArr objectAtIndex:[[itemArr objectAtIndex:3]integerValue]] allKeys] containsObject:@"item_title"])
            {
                favFoodLogObj.log_item_title=[[_selectedFoodArr objectAtIndex:[[itemArr objectAtIndex:3]integerValue]] objectForKey:@"item_title"];
            }
            else  if([[[_selectedFoodArr objectAtIndex:[[itemArr objectAtIndex:3]integerValue]] allKeys] containsObject:@"food_name"])
            {
                favFoodLogObj.log_item_title=[[_selectedFoodArr objectAtIndex:[[itemArr objectAtIndex:3]integerValue]]objectForKey:@"food_name"];
            }
            
            favFoodLogObj.log_item_desc=[[_selectedFoodArr objectAtIndex:[[itemArr objectAtIndex:3]integerValue]] objectForKey:@"item_desc"];
            favFoodLogObj.log_cals=[[_selectedFoodArr objectAtIndex:[[itemArr objectAtIndex:3]integerValue]] objectForKey:@"cals"];
            favFoodLogObj.log_serving_size=[[_selectedFoodArr objectAtIndex:[[itemArr objectAtIndex:3]integerValue]] objectForKey:@"serving_size"];
            favFoodLogObj.log_reference_food_id=[[_selectedFoodArr objectAtIndex:[[itemArr objectAtIndex:3]integerValue]] objectForKey:@"item"];
            favFoodLogObj.log_item_weight=[[_selectedFoodArr objectAtIndex:[[itemArr objectAtIndex:3]integerValue]]objectForKey:@"item_weight"];

            [foodLogObject updateFavoriteStatus:@"1" foodID:foodIdToAddFav  withUserProfileID:selectedUserProfileID withFoodRefID:refFoodIDToAddFav];
            [favFoodLogObj saveFavFoodDataLog:[_selectedFoodArr objectAtIndex:[[itemArr objectAtIndex:3]integerValue]] withFoodID:foodIdToAddFav withLogUserID:[defaults objectForKey:@"user_id"] withUserProfileID:selectedUserProfileID ];
        }
        _selectedFoodArr= _recentFoodArray=[foodLogObject getAllLunchLog:self.selectedMealTypeId withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
    }
    
    FavFoodVCount=0;
    
    for(int i=0;i<_selectedFoodArr.count;i++)
    {
        if([[[_selectedFoodArr objectAtIndex:i] objectForKey:@"isFavMeal"] isEqualToString:@"1"])
        {
            FavFoodVCount++;
        }
    }
    
    if(FavFoodVCount==_selectedFoodArr.count)
    {
       [_btnTotalFav setImage:[UIImage imageNamed:@"green-star@3x.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_btnTotalFav setImage:[UIImage imageNamed:@"green-star@3x_outline.png"] forState:UIControlStateNormal];
    }
    
    [_tblVw reloadData];
}

#pragma mark - Change Favorite Status in Recent/Favorite Table
-(void)AddFavouriteRecentMeal:(UIButton* )sender
{
    //NSString *foodIdToAddFav=[NSString stringWithFormat:@"%@",sender.accessibilityHint];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    formatter1.dateFormat = @"EEEE, MMMM dd, yyyy";
    NSDate *dateFromString = [formatter1 dateFromString:[[Utility sharedManager] getSelectedDate]];
    //  NSDate *dateFromString = [formatter1 dateFromString:dateStr];
    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
    logTimeStr= [dateFormatter2 stringFromDate:dateFromString];
    
    favMealLogObj.log_date_added=[self getCurrentDateTime];
    favMealLogObj.log_log_time=[NSString stringWithFormat:@"%@ %@",logTimeStr,[self getCurrentTime]];

    int section=sender.tag/100000;
    int row=sender.tag%100000;
    NSMutableArray *tempArr=[[favMealArr objectAtIndex:section]objectAtIndex:row];
    /*  NSLog(@"favMealArr=====%@",[favMealArr objectAtIndex:[sender.accessibilityHint integerValue]]);
     NSMutableArray *tempArr=[[favMealArr objectAtIndex:[sender.accessibilityHint integerValue]] mutableCopy];*/
    for(int i=0;i<[tempArr count];i++)
    {
        NSString *foodIdToAddFav=[NSString stringWithFormat:@"%@",[[tempArr objectAtIndex:i] objectForKey:@"id"]];
        NSString *refFoodIdToAddFav=[NSString stringWithFormat:@"%@",[[tempArr objectAtIndex:i] objectForKey:@"item"]];
        
        favMealLogObj.log_meal_id=[[tempArr objectAtIndex:i] objectForKey:@"meal_id"];
        
        if([[[tempArr objectAtIndex:i]  allKeys] containsObject:@"item_title"])
        {
            favMealLogObj.log_item_title=[[tempArr objectAtIndex:i]  objectForKey:@"item_title"];
        }
        else  if([[[tempArr objectAtIndex:i]  allKeys] containsObject:@"food_name"])
        {
            favMealLogObj.log_item_title=[[tempArr objectAtIndex:i] objectForKey:@"food_name"];
        }
        
        favMealLogObj.log_item_desc=[[tempArr objectAtIndex:i]  objectForKey:@"item_desc"];
        favMealLogObj.log_cals=[[tempArr objectAtIndex:i]  objectForKey:@"cals"];
        favMealLogObj.log_serving_size=[[tempArr objectAtIndex:i]  objectForKey:@"serving_size"];
        favMealLogObj.log_reference_food_id=[[tempArr objectAtIndex:i]  objectForKey:@"item"];
        favMealLogObj.log_item_weight=[[tempArr objectAtIndex:i] objectForKey:@"item_weight"];
        
        [foodLogObject updateMealFavoriteStatus:@"1" foodID:foodIdToAddFav withUserProfileID:selectedUserProfileID withMealFavStatus:@"1" withFoodRefID:refFoodIdToAddFav];
       [favMealLogObj saveFavMealDataLog:[tempArr objectAtIndex:i] withFoodID:foodIdToAddFav withLogUserID:[defaults objectForKey:@"user_id"] withUserProfileID:selectedUserProfileID];
    }
    
    [self createRecentMealArr];
    //  [self createNavigationView:@"Favorites"];
    navTitle=@"Recent";
    
    if([favMealArr count]>0)
    {
        recentFoodTableView.tag=FAV_MEALSUBCAT_TABLE_TAG;
        [recentFoodTableView reloadData];
    }
    [sender setImage:[UIImage imageNamed:@"green-star@3x.png"] forState:UIControlStateNormal];
    
}
-(void)AddFavouriteDropDownRecentMeal:(UIButton* )sender
{
    //NSString *foodIdToAddFav=[NSString stringWithFormat:@"%@",sender.accessibilityHint];
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    formatter1.dateFormat = @"EEEE, MMMM dd, yyyy";
    NSDate *dateFromString = [formatter1 dateFromString:[[Utility sharedManager] getSelectedDate]];
    //  NSDate *dateFromString = [formatter1 dateFromString:dateStr];
    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
    logTimeStr= [dateFormatter2 stringFromDate:dateFromString];
    
    favMealLogObj.log_date_added=[self getCurrentDateTime];
    favMealLogObj.log_log_time=[NSString stringWithFormat:@"%@ %@",logTimeStr,[self getCurrentTime]];
  
    int section=sender.tag/100000;
    int row=sender.tag%100000;
    NSMutableArray *tempArr=[[favMealArr objectAtIndex:section]objectAtIndex:row];
    /*  NSLog(@"favMealArr=====%@",[favMealArr objectAtIndex:[sender.accessibilityHint integerValue]]);
     NSMutableArray *tempArr=[[favMealArr objectAtIndex:[sender.accessibilityHint integerValue]] mutableCopy];*/
    for(int i=0;i<[tempArr count];i++){
        NSString *foodIdToAddFav=[NSString stringWithFormat:@"%@",[[tempArr objectAtIndex:i] objectForKey:@"id"]];
        NSString *refFoodIdToAddFav=[NSString stringWithFormat:@"%@",[[tempArr objectAtIndex:i] objectForKey:@"item"]];

        favMealLogObj.log_meal_id=[[tempArr objectAtIndex:i] objectForKey:@"meal_id"];
        
        if([[[tempArr objectAtIndex:i]  allKeys] containsObject:@"item_title"])
        {
            favMealLogObj.log_item_title=[[tempArr objectAtIndex:i]  objectForKey:@"item_title"];
        }
        else  if([[[tempArr objectAtIndex:i]  allKeys] containsObject:@"food_name"])
        {
            favMealLogObj.log_item_title=[[tempArr objectAtIndex:i] objectForKey:@"food_name"];
        }
        
        favMealLogObj.log_item_desc=[[tempArr objectAtIndex:i]  objectForKey:@"item_desc"];
        favMealLogObj.log_cals=[[tempArr objectAtIndex:i]  objectForKey:@"cals"];
        favMealLogObj.log_serving_size=[[tempArr objectAtIndex:i]  objectForKey:@"serving_size"];
        favMealLogObj.log_reference_food_id=[[tempArr objectAtIndex:i]  objectForKey:@"item"];
        favMealLogObj.log_item_weight=[[tempArr objectAtIndex:i] objectForKey:@"item_weight"];

        [foodLogObject updateMealFavoriteStatus:@"1" foodID:foodIdToAddFav withUserProfileID:selectedUserProfileID withMealFavStatus:@"1" withFoodRefID:refFoodIdToAddFav];
        [favMealLogObj saveFavMealDataLog:[tempArr objectAtIndex:i] withFoodID:foodIdToAddFav withLogUserID:[defaults objectForKey:@"user_id"] withUserProfileID:selectedUserProfileID];
    }
    
    favMealArr=[NSMutableArray array];
    favMealTitleArr=[NSMutableArray array];
    favMealTitleStr=@"";
    
    NSMutableArray *arrRecentDate=[foodLogObject getUniqueRecentDate:selectedUserProfileID withMealID:self.selectedMealTypeId];
    NSLog(@"arrRecentDate==%@",arrRecentDate);
    
    NSMutableArray *breakfastTitleFinalArr =[NSMutableArray array];
    NSMutableArray *breakfastMealFinalArr =[NSMutableArray array];
    for(int i=0;i<arrRecentDate.count;i++)
    {
        NSMutableArray *breakfastMealArr=[foodLogObject getRecentMealFoodLog:self.selectedMealTypeId withSelectedDate:[arrRecentDate objectAtIndex:i] withUserId:selectedUserProfileID];
        
        if(breakfastMealArr.count>0)
        {
            NSMutableArray *breakfastTitleArr =[NSMutableArray array];
            
            NSString *breakfastTitleStr=@"";
            for(int i=0;i<breakfastMealArr.count;i++)
            {
                [breakfastTitleArr addObject:[[breakfastMealArr objectAtIndex:i]objectForKey:@"food_name"]];
            }
            breakfastTitleStr = [breakfastTitleArr componentsJoinedByString:@" , "];
            [breakfastTitleFinalArr addObject:breakfastTitleStr];
            
            [breakfastMealFinalArr addObject:breakfastMealArr];
        }
        
    }
    
    
    if(breakfastMealFinalArr.count>0)
    {
        [favMealTitleArr addObject:breakfastTitleFinalArr];
        [favMealArr addObject:breakfastMealFinalArr];
        [self reloadDropDownFoodTable];
        
    }
    
    //  [self createNavigationView:@"Favorites"];
    navTitle=@"Recent";
    
    [sender setImage:[UIImage imageNamed:@"green-star@3x.png"] forState:UIControlStateNormal];
    
}


-(void)UnFavouriteDropDownRecentMeal:(UIButton* )sender
{
    int section=sender.tag/100000;
    int row=sender.tag%100000;
    NSMutableArray *tempArr=[[favMealArr objectAtIndex:section]objectAtIndex:row];
    /*NSLog(@"favMealArr=====%@",[favMealArr objectAtIndex:[sender.accessibilityHint integerValue]]);
     NSMutableArray *tempArr=[[favMealArr objectAtIndex:[sender.accessibilityHint integerValue]] mutableCopy];*/
    
    for(int i=0;i<[tempArr count];i++){
        NSString *foodIdToAddFav=[NSString stringWithFormat:@"%@",[[tempArr objectAtIndex:i] objectForKey:@"id"]];
        NSString *refFoodIdToAddFav=[NSString stringWithFormat:@"%@",[[tempArr objectAtIndex:i] objectForKey:@"item"]];

        [foodLogObject updateMealFavoriteStatus:@"0" foodID:foodIdToAddFav withUserProfileID:selectedUserProfileID withMealFavStatus:@"0" withFoodRefID:refFoodIdToAddFav];
       [favMealLogObj deleteFavMealData:foodIdToAddFav withUserId:selectedUserProfileID];
    }
    
    [sender setImage:[UIImage imageNamed:@"green-star@3x_outline.png"] forState:UIControlStateNormal];
    //  [self createNavigationView:@"Favorites"];
    navTitle=@"Recent";
    
    favMealArr=[NSMutableArray array];
    favMealTitleArr=[NSMutableArray array];
    favMealTitleStr=@"";
    
    NSMutableArray *arrRecentDate=[foodLogObject getUniqueRecentDate:selectedUserProfileID withMealID:self.selectedMealTypeId];
    NSLog(@"arrRecentDate==%@",arrRecentDate);
    
    NSMutableArray *breakfastTitleFinalArr =[NSMutableArray array];
    NSMutableArray *breakfastMealFinalArr =[NSMutableArray array];
    for(int i=0;i<arrRecentDate.count;i++)
    {
        NSMutableArray *breakfastMealArr=[foodLogObject getRecentMealFoodLog:self.selectedMealTypeId withSelectedDate:[arrRecentDate objectAtIndex:i] withUserId:selectedUserProfileID];
        
        if(breakfastMealArr.count>0)
        {
            NSMutableArray *breakfastTitleArr =[NSMutableArray array];
            
            NSString *breakfastTitleStr=@"";
            for(int i=0;i<breakfastMealArr.count;i++)
            {
                [breakfastTitleArr addObject:[[breakfastMealArr objectAtIndex:i]objectForKey:@"food_name"]];
            }
            breakfastTitleStr = [breakfastTitleArr componentsJoinedByString:@" , "];
            [breakfastTitleFinalArr addObject:breakfastTitleStr];
            
            [breakfastMealFinalArr addObject:breakfastMealArr];
        }
        
    }
    
    
    if(breakfastMealFinalArr.count>0)
    {
        [favMealTitleArr addObject:breakfastTitleFinalArr];
        [favMealArr addObject:breakfastMealFinalArr];
        [self reloadDropDownFoodTable];
        
    }
    
}


-(void)UnFavouriteRecentMeal:(UIButton* )sender
{
    int section=sender.tag/100000;
    int row=sender.tag%100000;
    NSMutableArray *tempArr=[[favMealArr objectAtIndex:section]objectAtIndex:row];
    /*NSLog(@"favMealArr=====%@",[favMealArr objectAtIndex:[sender.accessibilityHint integerValue]]);
     NSMutableArray *tempArr=[[favMealArr objectAtIndex:[sender.accessibilityHint integerValue]] mutableCopy];*/
    
    for(int i=0;i<[tempArr count];i++){
        NSString *foodIdToAddFav=[NSString stringWithFormat:@"%@",[[tempArr objectAtIndex:i] objectForKey:@"id"]];
        NSString *refFoodIdToAddFav=[NSString stringWithFormat:@"%@",[[tempArr objectAtIndex:i] objectForKey:@"item"]];

        [foodLogObject updateMealFavoriteStatus:@"0" foodID:foodIdToAddFav withUserProfileID:selectedUserProfileID withMealFavStatus:@"0" withFoodRefID:refFoodIdToAddFav];
        [favMealLogObj deleteFavMealData:foodIdToAddFav withUserId:selectedUserProfileID];
    }
    
    [sender setImage:[UIImage imageNamed:@"green-star@3x_outline.png"] forState:UIControlStateNormal];
    [self createRecentMealArr];
    //  [self createNavigationView:@"Favorites"];
    navTitle=@"Recent";
    
    if([favMealArr count]>0)
    {
        recentFoodTableView.tag=FAV_MEALSUBCAT_TABLE_TAG;
        [recentFoodTableView reloadData];
    }
    
}



-(void)AddFavouriteRecent:(UIButton* )sender
{
    
    NSString *selectedRowIndex=[NSString stringWithFormat:@"%@",sender.accessibilityHint ];
    
    NSArray *itemArr=[[NSString stringWithFormat:@"%@",selectedRowIndex]componentsSeparatedByString:@"#"];
    NSLog(@"selected row is===%@",itemArr );
    NSLog(@"recentFood==%@",[_recentFoodArray objectAtIndex:[[itemArr objectAtIndex:3]integerValue]]);

    NSString *foodIdToAddFav=[itemArr objectAtIndex:1];
    
    NSString *tableViewTag=[itemArr objectAtIndex:0];
    NSString *foodStatusToAddFav=[itemArr objectAtIndex:0];
    
    NSString *refFoodIDToAddFav=[itemArr objectAtIndex:2];

    //For Favourite Food Section
    if([tableViewTag isEqualToString:@"3"])
    {
        if([foodStatusToAddFav isEqualToString:@"0"])
        {
            NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
            formatter1.dateFormat = @"EEEE, MMMM dd, yyyy";
            NSDate *dateFromString = [formatter1 dateFromString:[[Utility sharedManager] getSelectedDate]];
            //  NSDate *dateFromString = [formatter1 dateFromString:dateStr];
            NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc] init];
            [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
            logTimeStr= [dateFormatter2 stringFromDate:dateFromString];
            
            favFoodLogObj.log_date_added=[self getCurrentDateTime];
            favFoodLogObj.log_log_time=[NSString stringWithFormat:@"%@ %@",logTimeStr,[self getCurrentTime]];
            
            favFoodLogObj.log_meal_id=[[_recentFoodArray objectAtIndex:[[itemArr objectAtIndex:3]integerValue]] objectForKey:@"meal_id"];
            
            if([[[_recentFoodArray objectAtIndex:[[itemArr objectAtIndex:3]integerValue]] allKeys] containsObject:@"item_title"])
            {
                favFoodLogObj.log_item_title=[[_recentFoodArray objectAtIndex:[[itemArr objectAtIndex:3]integerValue]] objectForKey:@"item_title"];
            }
            else  if([[[_recentFoodArray objectAtIndex:[[itemArr objectAtIndex:3]integerValue]] allKeys] containsObject:@"food_name"])
            {
                favFoodLogObj.log_item_title=[[_recentFoodArray objectAtIndex:[[itemArr objectAtIndex:3]integerValue]]objectForKey:@"food_name"];
            }
            
            favFoodLogObj.log_item_desc=[[_recentFoodArray objectAtIndex:[[itemArr objectAtIndex:3]integerValue]] objectForKey:@"item_desc"];
            favFoodLogObj.log_cals=[[_recentFoodArray objectAtIndex:[[itemArr objectAtIndex:3]integerValue]] objectForKey:@"cals"];
            favFoodLogObj.log_serving_size=[[_recentFoodArray objectAtIndex:[[itemArr objectAtIndex:3]integerValue]] objectForKey:@"serving_size"];
            favFoodLogObj.log_reference_food_id=[[_recentFoodArray objectAtIndex:[[itemArr objectAtIndex:3]integerValue]] objectForKey:@"item"];
            favFoodLogObj.log_item_weight=[[_recentFoodArray objectAtIndex:[[itemArr objectAtIndex:3]integerValue]]objectForKey:@"item_weight"];

           [foodLogObject updateFavoriteStatus:@"1" foodID:foodIdToAddFav  withUserProfileID:selectedUserProfileID withFoodRefID:refFoodIDToAddFav];
           [favFoodLogObj saveFavFoodDataLog:[_recentFoodArray objectAtIndex:[[itemArr objectAtIndex:3]integerValue]] withFoodID:foodIdToAddFav withLogUserID:[defaults objectForKey:@"user_id"] withUserProfileID:selectedUserProfileID];
        }
        else if([foodStatusToAddFav isEqualToString:@"1"])
        {
            [foodLogObject updateFavoriteStatus:@"0" foodID:foodIdToAddFav  withUserProfileID:selectedUserProfileID withFoodRefID:refFoodIDToAddFav];
             [favFoodLogObj deleteFavFoodData:foodIdToAddFav withUserId:selectedUserProfileID];
        }
        
        NSMutableArray *allMealArr=[NSMutableArray array];
        allMealArr=[mealTypeObj findAllMealType];
        for(NSDictionary *dict in allMealArr)
        {
            if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"breakfast"])
                breakfastId=[dict objectForKey:@"meal_type_id"];
            
            else if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"lunch"])
                lunchId=[dict objectForKey:@"meal_type_id"];
            
            else if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"dinner"])
                dinnerId=[dict objectForKey:@"meal_type_id"];
            
            else if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"snack"])
                snackId=[dict objectForKey:@"meal_type_id"];
        }
        
        favMealArr=[NSMutableArray array];
        favMealSecTitleArr=[NSMutableArray array];
        
       // NSMutableArray *breakfastMealArr=[foodLogObject getAllFavoriteFoodLog:breakfastId withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
        NSMutableArray *breakfastMealArr=[favFoodLogObj getAllFavoriteFoodLog:breakfastId withSelectedDate:logTimeStr withUserId:selectedUserProfileID];

        if(breakfastMealArr.count>0)
        {
            [favMealArr addObject:breakfastMealArr];
            [favMealSecTitleArr addObject:@"Breakfast"];
        }
        
        //NSMutableArray *lunchMealArr=[foodLogObject getAllFavoriteFoodLog:lunchId withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
        NSMutableArray *lunchMealArr=[favFoodLogObj getAllFavoriteFoodLog:lunchId withSelectedDate:logTimeStr withUserId:selectedUserProfileID];

        if(lunchMealArr.count>0)
        {
            [favMealArr addObject:lunchMealArr];
            [favMealSecTitleArr addObject:@"Lunch"];
        }
        
        //NSMutableArray *dinnerMealArr=[foodLogObject getAllFavoriteFoodLog:dinnerId withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
          NSMutableArray *dinnerMealArr=[favFoodLogObj getAllFavoriteFoodLog:dinnerId withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
        if(dinnerMealArr.count>0)
        {
            [favMealArr addObject:dinnerMealArr];
            [favMealSecTitleArr addObject:@"Dinner"];
        }
        
        //NSMutableArray *snacksMealArr=[foodLogObject getAllFavoriteFoodLog:snackId withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
        NSMutableArray *snacksMealArr=[favFoodLogObj getAllFavoriteFoodLog:snackId withSelectedDate:logTimeStr withUserId:selectedUserProfileID];

        if(snacksMealArr.count>0)
        {
            [favMealArr addObject:snacksMealArr];
            [favMealSecTitleArr addObject:@"Snack"];
        }
        
        if([favMealArr count]>0)
        {
            recentFoodTableView.hidden=NO;
            
            recentFoodTableView.tag=FAV_MEALSUBCAT_TABLE_TAG;
            recentFoodTableView.delegate=self;
            recentFoodTableView.dataSource=self;
            [recentFoodTableView reloadData];
            
            recentFoodTableView.hidden=NO;
        }
        else{
            recentFoodTableView.hidden=YES;
        }
        
    }
    else
    {
        //For Recent Section
        if([selectedRecentFav isEqualToString:@"Recent"])
        {
            if([foodStatusToAddFav isEqualToString:@"0"])
            {
                NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
                formatter1.dateFormat = @"EEEE, MMMM dd, yyyy";
                NSDate *dateFromString = [formatter1 dateFromString:[[Utility sharedManager] getSelectedDate]];
                //  NSDate *dateFromString = [formatter1 dateFromString:dateStr];
                NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc] init];
                [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
                logTimeStr= [dateFormatter2 stringFromDate:dateFromString];
                
                favFoodLogObj.log_date_added=[self getCurrentDateTime];
                favFoodLogObj.log_log_time=[NSString stringWithFormat:@"%@ %@",logTimeStr,[self getCurrentTime]];
  
                favFoodLogObj.log_meal_id=[[_recentFoodArray objectAtIndex:[[itemArr objectAtIndex:3]integerValue]] objectForKey:@"meal_id"];
                
                if([[[_recentFoodArray objectAtIndex:[[itemArr objectAtIndex:3]integerValue]] allKeys] containsObject:@"item_title"])
                {
                    favFoodLogObj.log_item_title=[[_recentFoodArray objectAtIndex:[[itemArr objectAtIndex:3]integerValue]] objectForKey:@"item_title"];
                }
                else  if([[[_recentFoodArray objectAtIndex:[[itemArr objectAtIndex:3]integerValue]] allKeys] containsObject:@"food_name"])
                {
                    favFoodLogObj.log_item_title=[[_recentFoodArray objectAtIndex:[[itemArr objectAtIndex:3]integerValue]]objectForKey:@"food_name"];
                }
                
                favFoodLogObj.log_item_desc=[[_recentFoodArray objectAtIndex:[[itemArr objectAtIndex:3]integerValue]] objectForKey:@"item_desc"];
                favFoodLogObj.log_cals=[[_recentFoodArray objectAtIndex:[[itemArr objectAtIndex:3]integerValue]] objectForKey:@"cals"];
                favFoodLogObj.log_serving_size=[[_recentFoodArray objectAtIndex:[[itemArr objectAtIndex:3]integerValue]] objectForKey:@"serving_size"];
                favFoodLogObj.log_reference_food_id=[[_recentFoodArray objectAtIndex:[[itemArr objectAtIndex:3]integerValue]] objectForKey:@"item"];
                favFoodLogObj.log_item_weight=[[_recentFoodArray objectAtIndex:[[itemArr objectAtIndex:3]integerValue]]objectForKey:@"item_weight"];

                [foodLogObject updateFavoriteStatus:@"1" foodID:foodIdToAddFav  withUserProfileID:selectedUserProfileID withFoodRefID:refFoodIDToAddFav];
                [favFoodLogObj saveFavFoodDataLog:[_recentFoodArray objectAtIndex:[[itemArr objectAtIndex:3]integerValue]] withFoodID:foodIdToAddFav withLogUserID:[defaults objectForKey:@"user_id"] withUserProfileID:selectedUserProfileID];
            }
            else if([foodStatusToAddFav isEqualToString:@"1"])
            {
                [foodLogObject updateFavoriteStatus:@"0" foodID:foodIdToAddFav  withUserProfileID:selectedUserProfileID withFoodRefID:refFoodIDToAddFav];
                 [favFoodLogObj deleteFavFoodData:foodIdToAddFav withUserId:selectedUserProfileID];
            }
            
            _recentFoodArray=[foodLogObject getAllFoodLog:selectedUserProfileID ];
            
            recentFoodTableView.tag=RECENT_TABLE_TAG;
            recentFoodTableView.delegate=self;
            recentFoodTableView.dataSource=self;
            [recentFoodTableView reloadData];
        }
        //For Favorite Section
        else if([selectedRecentFav isEqualToString:@"Favorites"])
        {
            [foodLogObject updateFavoriteStatus:@"0" foodID:foodIdToAddFav  withUserProfileID:selectedUserProfileID withFoodRefID:refFoodIDToAddFav];
            [favFoodLogObj deleteFavFoodData:foodIdToAddFav withUserId:selectedUserProfileID];
            
            if([foodStatusToAddFav isEqualToString:@"0"])
            {
                NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
                formatter1.dateFormat = @"EEEE, MMMM dd, yyyy";
                NSDate *dateFromString = [formatter1 dateFromString:[[Utility sharedManager] getSelectedDate]];
                //  NSDate *dateFromString = [formatter1 dateFromString:dateStr];
                NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc] init];
                [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
                logTimeStr= [dateFormatter2 stringFromDate:dateFromString];
                
                favFoodLogObj.log_date_added=[self getCurrentDateTime];
                favFoodLogObj.log_log_time=[NSString stringWithFormat:@"%@ %@",logTimeStr,[self getCurrentTime]];

                favFoodLogObj.log_meal_id=[[_recentFoodArray objectAtIndex:[[itemArr objectAtIndex:3]integerValue]] objectForKey:@"meal_id"];
                
                if([[[_recentFoodArray objectAtIndex:[[itemArr objectAtIndex:3]integerValue]] allKeys] containsObject:@"item_title"])
                {
                    favFoodLogObj.log_item_title=[[_recentFoodArray objectAtIndex:[[itemArr objectAtIndex:3]integerValue]] objectForKey:@"item_title"];
                }
                else  if([[[_recentFoodArray objectAtIndex:[[itemArr objectAtIndex:3]integerValue]] allKeys] containsObject:@"food_name"])
                {
                    favFoodLogObj.log_item_title=[[_recentFoodArray objectAtIndex:[[itemArr objectAtIndex:3]integerValue]]objectForKey:@"food_name"];
                }
                
                favFoodLogObj.log_item_desc=[[_recentFoodArray objectAtIndex:[[itemArr objectAtIndex:3]integerValue]] objectForKey:@"item_desc"];
                favFoodLogObj.log_cals=[[_recentFoodArray objectAtIndex:[[itemArr objectAtIndex:3]integerValue]] objectForKey:@"cals"];
                favFoodLogObj.log_serving_size=[[_recentFoodArray objectAtIndex:[[itemArr objectAtIndex:3]integerValue]] objectForKey:@"serving_size"];
                favFoodLogObj.log_reference_food_id=[[_recentFoodArray objectAtIndex:[[itemArr objectAtIndex:3]integerValue]] objectForKey:@"item"];
                favFoodLogObj.log_item_weight=[[_recentFoodArray objectAtIndex:[[itemArr objectAtIndex:3]integerValue]]objectForKey:@"item_weight"];

                [foodLogObject updateFavoriteStatus:@"1" foodID:foodIdToAddFav  withUserProfileID:selectedUserProfileID withFoodRefID:refFoodIDToAddFav];
                [favFoodLogObj saveFavFoodDataLog:[_recentFoodArray objectAtIndex:[[itemArr objectAtIndex:3]integerValue]] withFoodID:foodIdToAddFav withLogUserID:[defaults objectForKey:@"user_id"] withUserProfileID:selectedUserProfileID];
            }
            else if([foodStatusToAddFav isEqualToString:@"1"])
            {
                [foodLogObject updateFavoriteStatus:@"0" foodID:foodIdToAddFav  withUserProfileID:selectedUserProfileID withFoodRefID:refFoodIDToAddFav];
                 [favFoodLogObj deleteFavFoodData:foodIdToAddFav withUserId:selectedUserProfileID];
            }
            
            [self performSelector:@selector(callReloadFav) withObject:nil afterDelay:0.0];
            
            [self getTotalCal];
            [self refreshViewDropdownView];
            
        }
    }
}

#pragma mark - Edit Calorie Delegate Method
-(void)notifyCalorieLog:(NSString*)str
{
    NSArray *itemArr=[[NSString stringWithFormat:@"%@",self.selectedRow ]componentsSeparatedByString:@"#"];
    NSLog(@"selected row is===%@",itemArr );
    foodIdToEdit=[itemArr objectAtIndex:1];
    if([[self chkNullInputinitWithString:foodIdToEdit] isEqualToString:@""]){
        FoodLog *obj=[FoodLog new];
        int row=[obj getMaxFoodID:selectedUserProfileID];
        foodIdToEdit=[NSString stringWithFormat:@"%d",row];
    }
    
    if(selectedTableTag==MEALSUBCATEGORY_TABLE_TAG){
        if ([[_selectedFoodArr objectAtIndex:[[itemArr objectAtIndex:0] intValue]] isKindOfClass:[NSDictionary class]]){
            
            NSMutableDictionary *oldDict = [[NSMutableDictionary alloc] initWithDictionary:[_selectedFoodArr objectAtIndex:[self.selectedRow integerValue]]];
            [oldDict  setValue:str forKey:@"cals"];
            
            NSMutableArray *arrTemp = [[NSMutableArray alloc] initWithArray:_selectedFoodArr];
            [arrTemp replaceObjectAtIndex:[self.selectedRow integerValue] withObject:oldDict];
            
            _selectedFoodArr = [[NSMutableArray alloc] initWithArray:arrTemp];
            [ _tblVw reloadData];
            
            if([self.previous_activity isEqualToString:@"RadialTapp"] || selectedButton==1 || selectedButton==2){
                NSLog(@"self.selectedMealTypeId==%@",self.selectedMealTypeId);
                
                [foodLogObject updateCalLog:str foodID:foodIdToEdit  withUserProfileID:selectedUserProfileID];
                
            }
            
        }
    }
    else if (selectedTableTag==RECENT_TABLE_TAG){
        if ([[_recentFoodArray objectAtIndex:[[itemArr objectAtIndex:0] intValue]] isKindOfClass:[NSDictionary class]]){
            
            NSMutableDictionary *oldDict = [[NSMutableDictionary alloc] initWithDictionary:[_recentFoodArray objectAtIndex:[self.selectedRow integerValue]]];
            [oldDict  setValue:str forKey:@"cals"];
            
            
            NSMutableArray *arrTemp = [[NSMutableArray alloc] initWithArray:_recentFoodArray];
            [arrTemp replaceObjectAtIndex:[self.selectedRow integerValue] withObject:oldDict];
            
            _recentFoodArray = [[NSMutableArray alloc] initWithArray:arrTemp];
            [ recentFoodTableView reloadData];
            
            if([self.previous_activity isEqualToString:@"RadialTapp"]){
                NSLog(@"self.selectedMealTypeId==%@",self.selectedMealTypeId);
               
                [foodLogObject updateCalLog:str foodID:foodIdToEdit  withUserProfileID:selectedUserProfileID];
                
            }
            
        }
        
    }
    [self refreshViewDropdownView];
    [self getTotalCal];
}

#pragma mark - "Log" Button Action
- (IBAction)logBtnTapped:(id)sender
{
    if( [self.previous_activity isEqualToString:@"FromPlanner"] && [_selectedFoodArr count]>0 )
    {
        if([self.action_selected isEqualToString:@"replace"])
        {
            [foodLogObject deleteUserFoodDataLog:self.selectedMealTypeId withSelectedDate:logTimeStr withSelecteduser_id:selectedUserProfileID];
            if([_selectedFoodArr count]>0){
                if ( _selectedFoodDict !=Nil )
                {
                    [_selectedFoodArr removeAllObjects];
                    for (int i=0; i<[_selectedFoodDictArr count]; i++) {
                        [_selectedFoodArr addObject:[_selectedFoodDictArr objectAtIndex:i]];
                    }
                    
                }
            }
            
        }
        [self notifyEvent:@"YES"];
        /*foodPopupcontroller =[self.storyboard instantiateViewControllerWithIdentifier:@"FoodLogPopUp"];
         CGRect frame = foodPopupcontroller.view.frame;
         frame.size.height = self.view.frame.size.height;
         frame.origin.y=self.view.frame.origin.y;
         foodPopupcontroller.view.frame = frame;
         [foodPopupcontroller willMoveToParentViewController:self];
         foodPopupcontroller.delegate=self;
         foodPopupcontroller.navigateVal=@"food";
         [self.view addSubview:foodPopupcontroller.view];
         [self addChildViewController:foodPopupcontroller];
         [self.view bringSubviewToFront:foodPopupcontroller.view];*/
        //popupShown=1;
        
    }
    else
    {
        [self notifyEvent:@"YES"];
        /*foodPopupcontroller =[self.storyboard instantiateViewControllerWithIdentifier:@"FoodLogPopUp"];
         CGRect frame = foodPopupcontroller.view.frame;
         frame.size.height = self.view.frame.size.height;
         frame.origin.y=self.view.frame.origin.y;
         foodPopupcontroller.view.frame = frame;
         [foodPopupcontroller willMoveToParentViewController:self];
         foodPopupcontroller.delegate=self;
         foodPopupcontroller.navigateVal=@"food";
         [self.view addSubview:foodPopupcontroller.view];
         [self addChildViewController:foodPopupcontroller];
         [self.view bringSubviewToFront:foodPopupcontroller.view];*/
        // popupShown=1;
        goBack=1;
        
    }
}

#pragma mark - "Other" Button Action
-(void)OtherButtonTapped
{
    [self.view endEditing:YES];
    
    autoCompleteTableView.hidden=YES;
    LogOtherFoodViewController *logMeal=[self.storyboard instantiateViewControllerWithIdentifier:@"LogOtherFood"];
    logMeal.previous_activity=self.previous_activity;
    logMeal.logTime=logTimeStr;
    logMeal.meal_id=self.selectedMealTypeId;
    CGRect frame = logMeal.view.frame;
    frame.size.height = self.view.frame.size.height;
    frame.origin.y=self.view.frame.origin.y;
    logMeal.view.frame = frame;
    [logMeal willMoveToParentViewController:self];
    
    [self.view addSubview:logMeal.view];
    [self addChildViewController:logMeal];
    //logMeal.delegate=self;
    [self.view bringSubviewToFront:logMeal.view];
}

#pragma mark - Textfield Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    selectedIndexPathRecent=-1000000;
    selectedIndexPathRecentPrev=selectedIndexPathRecent;
    [recentFoodTableView reloadData];
    
    selectedIndexPathNormal=-1000000;
    selectedIndexPathNormalPrev=selectedIndexPathNormal;
    
    selectedIndexPathFav=-1000000;
    selectedIndexPathFavPrev=selectedIndexPathFav;
    
    FavFoodVCount=0;
    [_tblVw reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if(textField.text!=nil && textField.text.length >0 && ![textField.text isEqualToString:@" "]){
        //[autoCompleteTableView setHidden:YES];
        if(textField.text.length>=2){
            NSString *trimmedString = [textField.text stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceCharacterSet]];
            [[ServerConnection sharedInstance] setDelegate:self];
            [[ServerConnection sharedInstance] searchFoodLog:trimmedString];
            _connectType=@"searchText";
        }
    }
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)text
{
    
    NSString *searchStr=[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(searchStr!=nil && searchStr.length >0 && ![searchStr isEqualToString:@" "]){
        NSString *searchString=[textField.text stringByReplacingCharactersInRange:range withString:text];
        
        //[autoCompleteTableView setHidden:YES];
        if(searchString.length>=2){
            NSString *trimmedString = [searchString stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceCharacterSet]];
            [[ServerConnection sharedInstance] setDelegate:self];
            [[ServerConnection sharedInstance] searchFoodLog:trimmedString];
             _connectType=@"searchText";
            // APP_CTRL.searchStart=1;
        }
        
    }
    else if(searchStr.length==0) {
       // [autoCompleteTableView setHidden:YES];i
        //APP_CTRL.searchStart=0;
    }
    
    return YES;
}

-(void)updateOtherSelectedFood
{
    NSLog(@"===================%@",[defaults objectForKey:@"OtherFood"]);
    [_selectedFoodArr addObject:[defaults objectForKey:@"OtherFood"]];
    if([_selectedFoodArr count]>0){
        FavFoodVCount=0;
        _tblVw.tag=MEALSUBCATEGORY_TABLE_TAG;
        _tblVw.delegate=self;
        _tblVw.dataSource=self;
        _tblVw.hidden=NO;
        [_tblVw reloadData];
        goBack=1;
        
        //[self performSelector:@selector(selfCalculateTotalSubCategoryMeal) withObject:nil afterDelay:3.0];
    }
}
-(void)updateRecentFood
{
    NSLog(@"updateRecentFood===================%@",[defaults objectForKey:@"primarySelectedArray"]);
    
    /*   [_selectedFoodArr addObject:[defaults objectForKey:@"primarySelectedArray"]];
     if([_selectedFoodArr count]>0){
     goBack=0;
     FavFoodVCount=0;
     _tblVw.delegate=self;
     _tblVw.dataSource=self;
     _tblVw.hidden=NO;
     [_tblVw reloadData];
     }*/
    
}

#pragma mark - Swipe Arrow Down Gesture Method
/*-(void)showHideRecentfoodView:(id)sender
 {
 arrowImageView.image=[UIImage imageNamed:@"kee_arrow_strate"];
 UITableViewCell *cell = (UITableViewCell*)[myMealTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
 UIButton *plusBtn=(UIButton *)[cell viewWithTag:1];
 [plusBtn setUserInteractionEnabled:YES];
 [btn1 setUserInteractionEnabled:YES];
 [btn2 setUserInteractionEnabled:YES];
 [btn3 setUserInteractionEnabled:YES];
 [btn4 setUserInteractionEnabled:YES];
 
 if([sessionNm isEqualToString:@"My Meal"])
 {
 [mymealView setHidden:NO];
 [self createMyMealArr];
 NSLog(@"myMealArr==%@",myMealArr);
 NSLog(@"myMealSecTitleArr==%@",myMealSecTitleArr);
 
 myMealTable.delegate=self;
 myMealTable.dataSource=self;
 myMealTable.hidden=NO;
 [myMealTable reloadData];
 
 }
 else
 {
 _selectedFoodArr=[foodLogObject getAllLunchLog:self.selectedMealTypeId  withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
 if([_selectedFoodArr count]>0)
 {
 FavFoodVCount=0;
 _tblVw.tag=MEALSUBCATEGORY_TABLE_TAG;
 _tblVw.hidden=NO;
 _tblVw.delegate=self;
 _tblVw.dataSource=self;
 [_tblVw reloadData];
 }
 else
 {
 _tblVw.hidden=YES;
 }
 }
 
 [swipeFood setDirection: UISwipeGestureRecognizerDirectionUp];
 // [swipeMeal setDirection:UISwipeGestureRecognizerDirectionUp];
 
 [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
 CGFloat f1;
 
 if([self.previous_activity isEqualToString:@"FromPlanner"]||[self.previous_activity isEqualToString:@"newPlanner"] ){
 f1=[[UIScreen mainScreen] bounds].size.height-(204-28);
 totalViewBottomConstant.constant=15;
 //[self.view bringSubviewToFront:logView ];
 }
 else
 {
 if(family==iPad)
 {
 f1=[[UIScreen mainScreen] bounds].size.height-260;
 //[self.view bringSubviewToFront:buttonView];
 sessionCollectionViewHeight.constant=0;
 }
 else
 {
 f1=[[UIScreen mainScreen] bounds].size.height-140;
 }
 totalViewBottomConstant.constant=18;
 }
 recentMealViewTopConstant.constant=f1;
 [self.view layoutIfNeeded];
 } completion:^(BOOL finished){
 
 }];
 }*/

#pragma mark - UICollectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
    
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
    
    UIButton  *dropdownCellBtn;
    if(indexPath.item==2){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sessionImgCell" forIndexPath:indexPath];
        dropdownCellBtn=(UIButton*) [recentFoodView viewWithTag:999];//(UIButton *)[cell viewWithTag:999];
        
    }
    else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sessionCell" forIndexPath:indexPath];
        
    }
    UIButton  *collectionCellBtn;
    if(indexPath.item!=2){
        collectionCellBtn= (UIButton *)[cell viewWithTag:5];
        [collectionCellBtn setTitle:[sessionArray objectAtIndex:indexPath.row]  forState:UIControlStateNormal];
    }
    
    
    if([selectedRecentFav isEqualToString:@"Recent"])
    {
        if (selectedItemRecent == indexPath.row) {
            [collectionCellBtn setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:145.0/255.0 blue:77.0/255.0 alpha:1]];
            [cell.contentView setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:145.0/255.0 blue:77.0/255.0 alpha:1]];
            //collectionCellBtn.alpha=0.5;
        }
        else
        {
            // collectionCellBtn.alpha=1.0;
            [collectionCellBtn setBackgroundColor:[UIColor colorWithRed:128.0/255.0 green:179.0/255.0 blue:141.0/255.0 alpha:1]];
            [cell.contentView setBackgroundColor:[UIColor colorWithRed:128.0/255.0 green:179.0/255.0 blue:141.0/255.0 alpha:1]];
        }
        
    }
    else
    {
        if (selectedItemFav == indexPath.row) {
            [collectionCellBtn setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:145.0/255.0 blue:77.0/255.0 alpha:1]];
            [cell.contentView setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:145.0/255.0 blue:77.0/255.0 alpha:1]];
            //collectionCellBtn.alpha=0.5;
        }
        else
        {
            // collectionCellBtn.alpha=1.0;
            [collectionCellBtn setBackgroundColor:[UIColor colorWithRed:128.0/255.0 green:179.0/255.0 blue:141.0/255.0 alpha:1]];
            [cell.contentView setBackgroundColor:[UIColor colorWithRed:128.0/255.0 green:179.0/255.0 blue:141.0/255.0 alpha:1]];
        }
        
    }
    
    return cell;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize mElementSize = CGSizeMake([UIScreen mainScreen].bounds.size.width/3 , 40);
    
    return mElementSize;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    @try {
        
        if([selectedRecentFav isEqualToString:@"Recent"])
        {
            selectedIndexPathRecent=-1000000;
            selectedIndexPathRecentPrev=selectedIndexPathRecent;
            
            selectedIndexPathSearch=-2000000;
            
            selectedIndexPathNormal=-1000000;
            selectedIndexPathNormalPrev=selectedIndexPathNormal;
            
            selectedIndexPathFav=-1000000;
            selectedIndexPathFavPrev=selectedIndexPathFav;
            
            selectedItem=indexPath.item;
            selectedItemRecent=indexPath.item;
            
            //selectedId=[[sessionArray objectAtIndex:indexPath.row] objectForKey:@"meal_type_id"];
            
            //For Recent Food Section
            if(selectedItem==0)
            {
                _recentFoodArray=[NSMutableArray array];
                _recentFoodArray=[foodLogObject getAllFoodLog:selectedUserProfileID ];
                
                //   _recentFoodArray = [[[NSSet setWithArray:[_recentFoodArray valueForKey:@"item"]] allObjects]mutableCopy];
                
                selectedFavMealTypeId=@"";
                if(dropDown != nil)
                {
                    [dropDown hideDropDown:btnDropDown];
                    [self rel];
                }
                
                //  [self createNavigationView:@"Favorites"];
                navTitle=@"Recent";
                
                if([_recentFoodArray count]>0)
                {
                    [self reloadRecentFoodTable];
                    recentFoodTableView.hidden=NO;
                }
                else{
                    recentFoodTableView.hidden=YES;
                }
                [sessionCollectionView reloadData];
            }
            
            //For Recent Meal Section
            else if(selectedItem==1)
            {
                [self createRecentMealArr];
                //  [self createNavigationView:@"Favorites"];
                navTitle=@"Recent";
                
                if([favMealArr count]>0)
                {
                    recentFoodTableView.hidden=NO;
                    
                    recentFoodTableView.tag=FAV_MEALSUBCAT_TABLE_TAG;
                    recentFoodTableView.delegate=self;
                    recentFoodTableView.dataSource=self;
                    [recentFoodTableView reloadData];
                    
                    recentFoodTableView.hidden=NO;
                }
                else{
                    recentFoodTableView.hidden=YES;
                }
                [sessionCollectionView reloadData];
            }
            
            //For Recent Meal DropDown Section
            else
            {
                //  UICollectionViewCell *cell = (UICollectionViewCell*)[sessionCollectionView cellForItemAtIndexPath:indexPath];
                UIButton  *dropdownCellBtn=(UIButton*) [recentFoodView viewWithTag:999];//(UIButton *)[cell viewWithTag:999];
                
                NSMutableArray  *arrDropDownTxtFoodFav= [[NSMutableArray alloc]init];
                
                
                NSMutableArray  *arrDropDownImgFoodFav= [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"breakfast_new"], [UIImage imageNamed:@"lunch_new"], [UIImage imageNamed:@"dinner_new"], [UIImage imageNamed:@"snack_new"],  nil];
                /* for(int i=0;i<4;i++)
                 {
                 NSString *mealID=[NSString stringWithFormat:@"%d",i+1];
                 int sumFoodLog= [foodLogObject getFoodSumIndividualCalorieRecent:mealID withUserProfileID:selectedUserProfileID withDate:logTimeStr];
                 NSString *strSumFoodLog=[NSString stringWithFormat:@"%d",sumFoodLog];
                 [arrDropDownTxtFoodFav addObject:strSumFoodLog];
                 }*/
                [arrDropDownTxtFoodFav addObject:@"Breakfast"];
                [arrDropDownTxtFoodFav addObject:@"Lunch"];
                [arrDropDownTxtFoodFav addObject:@"Dinner"];
                [arrDropDownTxtFoodFav addObject:@"Snack"];
                
                if(dropDown == nil) {
                    CGFloat f = 250;
                    dropDown = [[NIDropDown alloc]showDropDown:dropdownCellBtn :&f :arrDropDownTxtFoodFav :arrDropDownImgFoodFav :@"down" :6];
                    dropDown.delegate = self;
                    dropdownCellBtn.alpha=0.5;
                    mAppDelegate.dropDown=dropDown;
                    mAppDelegate.btnDropDown=dropdownCellBtn;
                }
                else {
                    [dropDown hideDropDown:dropdownCellBtn];
                    dropdownCellBtn.alpha=1.0;
                    [self rel];
                }
                
                [sessionCollectionView reloadData];
            }
            
            
            
        }
        else{
            selectedIndexPathRecent=-1000000;
            selectedIndexPathRecentPrev=selectedIndexPathRecent;
            
            selectedIndexPathSearch=-2000000;
            
            selectedIndexPathNormal=-1000000;
            selectedIndexPathNormalPrev=selectedIndexPathNormal;
            
            selectedIndexPathFav=-1000000;
            selectedIndexPathFavPrev=selectedIndexPathFav;
            
            selectedItem=indexPath.item;
            selectedItemFav=indexPath.item;
            
            //selectedId=[[sessionArray objectAtIndex:indexPath.row] objectForKey:@"meal_type_id"];
            
            //For Favourite Food Section
            if(selectedItem==0)
            {
                _recentFoodArray=[NSMutableArray array];
               // _recentFoodArray=[foodLogObject getAllFavoriteFoodLog:@"" withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
                _recentFoodArray=[favFoodLogObj getAllFavoriteFoodLog:@"" withSelectedDate:logTimeStr withUserId:selectedUserProfileID];

                selectedFavMealTypeId=@"";
                if(dropDown != nil)
                {
                    [dropDown hideDropDown:btnDropDown];
                    [self rel];
                }
                
                //  [self createNavigationView:@"Favorites"];
                navTitle=@"Favorites";
                
                if([_recentFoodArray count]>0)
                {
                    [self reloadRecentFoodTable];
                    recentFoodTableView.hidden=NO;
                }
                else{
                    recentFoodTableView.hidden=YES;
                }
                [sessionCollectionView reloadData];
            }
            
            //For Favourite Meal Section
            else if(selectedItem==1)
            {
                [self createFavMealArr];
                //  [self createNavigationView:@"Favorites"];
                navTitle=@"Favorites";
                
                if([favMealArr count]>0)
                {
                    recentFoodTableView.hidden=NO;
                    
                    recentFoodTableView.tag=FAV_MEALSUBCAT_TABLE_TAG;
                    recentFoodTableView.delegate=self;
                    recentFoodTableView.dataSource=self;
                    [recentFoodTableView reloadData];
                    
                    recentFoodTableView.hidden=NO;
                }
                else{
                    recentFoodTableView.hidden=YES;
                }
                [sessionCollectionView reloadData];
            }
            
            //For Favourite Meal DropDown Section
            else
            {
                //  UICollectionViewCell *cell = (UICollectionViewCell*)[sessionCollectionView cellForItemAtIndexPath:indexPath];
                UIButton  *dropdownCellBtn=(UIButton*) [recentFoodView viewWithTag:999];//(UIButton *)[cell viewWithTag:999];
                
                NSMutableArray  *arrDropDownTxtFoodFav= [[NSMutableArray alloc]init];
                
                /*  int sumFood= [foodLogObject getFoodSumIndividualCalorieFav:@"" withUserProfileID:selectedUserProfileID withDate:logTimeStr];
                 NSString *strSumFoodTotal=[NSString stringWithFormat:@"%d",sumFood];
                 [arrDropDownTxtFoodFav addObject:strSumFoodTotal];*/
                
                // NSMutableArray  *arrDropDownImgFoodFav= [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"Breakfast.png"], [UIImage imageNamed:@"Lunch.png"], [UIImage imageNamed:@"Dinner.png"], [UIImage imageNamed:@"Snack.png"],  nil];
                NSMutableArray  *arrDropDownImgFoodFav= [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"breakfast_new"], [UIImage imageNamed:@"lunch_new"], [UIImage imageNamed:@"dinner_new"], [UIImage imageNamed:@"snack_new"],  nil];
                /*for(int i=0;i<4;i++)
                 {
                 NSString *mealID=[NSString stringWithFormat:@"%d",i+1];
                 int sumFoodLog= [foodLogObject getFoodSumIndividualCalorieFav:mealID withUserProfileID:selectedUserProfileID withDate:logTimeStr];
                 NSString *strSumFoodLog=[NSString stringWithFormat:@"%d",sumFoodLog];
                 [arrDropDownTxtFoodFav addObject:strSumFoodLog];
                 }*/
                [arrDropDownTxtFoodFav addObject:@"Breakfast"];
                [arrDropDownTxtFoodFav addObject:@"Lunch"];
                [arrDropDownTxtFoodFav addObject:@"Dinner"];
                [arrDropDownTxtFoodFav addObject:@"Snack"];
                
                if(dropDown == nil) {
                    CGFloat f = 250;
                    dropDown = [[NIDropDown alloc]showDropDown:dropdownCellBtn :&f :arrDropDownTxtFoodFav :arrDropDownImgFoodFav :@"down" :5];
                    dropDown.delegate = self;
                    dropdownCellBtn.alpha=0.5;
                    mAppDelegate.dropDown=dropDown;
                    mAppDelegate.btnDropDown=dropdownCellBtn;
                }
                else {
                    [dropDown hideDropDown:dropdownCellBtn];
                    dropdownCellBtn.alpha=1.0;
                    [self rel];
                }
                
                [sessionCollectionView reloadData];
            }
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception : %@",exception);
    }
    @finally {
        
    }
    
}

#pragma mark - "ScanBarcode" Button Action
-(IBAction)btnActionBar:(id)sender
{
    igViewController *barViewController = [[igViewController alloc]init];
    barViewController.delegate=self;
    _isBarCodeScanOpen=YES;
    [self presentViewController:barViewController animated:YES completion:NULL];
}

#pragma mark - BarCode Scan Delegate Method
-(void)notifyBarLog:(NSString*)strBar
{
    _isBarCodeScanOpen=YES;
    NSLog(@"strBar=%@",strBar);
    autoCompleteTextField.text =strBar;
    if(strBar.length>0)
    {
        if(!isConnection)
        {
            isConnection=YES;
            [[ServerConnection sharedInstance] setDelegate:self];
            // [[ServerConnection sharedInstance] searchFoodBarLog:@"52200004265"];
            [[ServerConnection sharedInstance] searchFoodBarLog:strBar];
            _connectType=@"searchBar";
        }
    }
}

- (IBAction)btnActionMic:(id)sender
{
}

- (IBAction)recentMealTouchOut:(id)sender
{
    NSLog(@"out======");
    sessionArray=[NSMutableArray array];
    sessionArray=[mealTypeObj findAllMealType];
    selectedItem=0;
    [sessionCollectionView reloadData];
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if(family==iPad)
            recentMealViewTopConstant.constant=260;
        else
            recentMealViewTopConstant.constant=200;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished){
        
    }];
    if(family==iPad)
        sessionCollectionViewHeight.constant=60;
    else
        sessionCollectionViewHeight.constant=40;
    
    [btn_recentMeal setBackgroundColor:[UIColor colorWithRed:183/255.0 green:32/255.0 blue:109/255.0 alpha:1]];
    
    [btn_recentFood setBackgroundColor:[UIColor colorWithRed:189/255.0 green:119/255.0 blue:164/255.0 alpha:1]];
    _recentFoodArray=[foodLogObject getAllLunchLog:@"1" withSelectedDate:@""  withUserId:selectedUserProfileID];
    [self reloadRecentFoodTable];
    
}

- (IBAction)recentMealTouchIn:(id)sender
{
    NSLog(@"IN========");
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGFloat f1;
        
        if([self.previous_activity isEqualToString:@"FromPlanner"]||[self.previous_activity isEqualToString:@"newPlanner"] ){
            f1=[[UIScreen mainScreen] bounds].size.height-204;
            totalViewBottomConstant.constant=39;
            //[self.view bringSubviewToFront:logView ];
        }
        else{
            
            if(family==iPad){
                f1=[[UIScreen mainScreen] bounds].size.height-260;
                //[self.view bringSubviewToFront:buttonView];
                sessionCollectionViewHeight.constant=40;
            }
            else{
                f1=[[UIScreen mainScreen] bounds].size.height-165;
                sessionCollectionViewHeight.constant=40;
            }
            totalViewBottomConstant.constant=0;
        }
        recentMealViewTopConstant.constant=f1;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished){
        
    }];
    
}

#pragma mark - UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag ==999){
        if(buttonIndex==0){
            saveRecentFood=0;
            if([_selectedFoodArr count]>0){
                _selectedFoodArr=[NSMutableArray array];
            }
            
        }
        else{
            [mymealView setHidden:YES];
            saveRecentFood=1;
            FavFoodVCount=0;
            _tblVw.tag=MEALSUBCATEGORY_TABLE_TAG;
            _tblVw.hidden=NO;
            _tblVw.delegate=self;
            _tblVw.dataSource=self;
            [_tblVw reloadData];
            goBack=1;
            logBtn.userInteractionEnabled=YES;
            selectedRecentFood=1;
            
            //[self performSelector:@selector(selfCalculateTotalSubCategoryMeal) withObject:nil afterDelay:3.0];
        }
        
    }
    
    else if(alertView.tag ==1000){
        if(buttonIndex==1){
            //APP_CTRL.searchStart=0;
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    
    else if(alertView.tag ==1002){
        if(buttonIndex==1){
            SettingsViewController *mVerificationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
            mVerificationViewController.navClass=@"settings";
            // APP_CTRL.searchStart=0;
            [self.navigationController pushViewController:mVerificationViewController animated:YES];
        }
        
    }
    else if(alertView.tag ==10)
    {
        if(buttonIndex==1){
            
              ProfileViewController *mVerificationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
                [self.navigationController pushViewController:mVerificationViewController animated:YES];
            
        }
    }

    
}

#pragma mark - BreakFast TapButton Action
- (IBAction)breakfastTapped:(UITapGestureRecognizer *)sender
{
    NSLog(@"breakfastTapped");
    
    [self updateSelectedIndexPath];
    
    [sessionView setHidden:YES];
    //[recentFoodView setHidden:YES];
    [mymealView setHidden:YES];
    if(![self.previous_activity isEqualToString:@"newPlanner"])
    {
        logViewHeight.constant=0;
        logBtn.hidden=YES;
        self.previous_activity=@"RadialTapp";
    }
    self.selectedMealTypeId=@"1";
    selectedMyMealType=@"1";
    sessionName.text=[NSString stringWithFormat:@"My %@",@"Breakfast"];
    sessionNm=[NSString stringWithFormat:@"My %@",@"Breakfast"];
    [self createNavigationView:@"Breakfast"];
    navTitle=@"Breakfast";
    [self reloadTableBySession];
}

#pragma mark - Lunch TapButton Action
- (IBAction)lunchTapped:(UITapGestureRecognizer *)sender
{
    NSLog(@"lunchTapped");
    [sessionView setHidden:YES];
    
    [self updateSelectedIndexPath];
    
    //[recentFoodView setHidden:YES];
    [mymealView setHidden:YES];
    if(![self.previous_activity isEqualToString:@"newPlanner"])
    {
        logViewHeight.constant=0;
        logBtn.hidden=YES;
        self.previous_activity=@"RadialTapp";
    }
    self.selectedMealTypeId=@"2";
    selectedMyMealType=@"2";
    sessionName.text=[NSString stringWithFormat:@"My %@",@"Lunch"];
    sessionNm=[NSString stringWithFormat:@"My %@",@"Lunch"];
    [self createNavigationView:@"Lunch"];
    navTitle=@"Lunch";
    [self reloadTableBySession];
}

#pragma mark - Dinner TapButton Action
- (IBAction)dinnerTapped:(id)sender
{
    NSLog(@"dinnerTapped");
    [sessionView setHidden:YES];
    
    [self updateSelectedIndexPath];
    //[recentFoodView setHidden:YES];
    [mymealView setHidden:YES];
    if(![self.previous_activity isEqualToString:@"newPlanner"])
    {
        logViewHeight.constant=0;
        logBtn.hidden=YES;
        self.previous_activity=@"RadialTapp";
    }
    self.selectedMealTypeId=@"3";
    selectedMyMealType=@"3";
    sessionName.text=[NSString stringWithFormat:@"My %@",@"Dinner"];
    sessionNm=[NSString stringWithFormat:@"My %@",@"Dinner"];
    [self createNavigationView:@"Dinner"];
    navTitle=@"Dinner";
    [self reloadTableBySession];
}

#pragma mark - Snack TapButton Action
- (IBAction)snackTapped:(id)sender
{
    NSLog(@"snackTapped");
    [sessionView setHidden:YES];
    
    [self updateSelectedIndexPath];
    
    //[recentFoodView setHidden:YES];
    [mymealView setHidden:YES];
    if(![self.previous_activity isEqualToString:@"newPlanner"])
    {
        logViewHeight.constant=0;
        logBtn.hidden=YES;
        self.previous_activity=@"RadialTapp";
    }
    self.selectedMealTypeId=@"4";
    selectedMyMealType=@"4";
    sessionName.text=[NSString stringWithFormat:@"My %@",@"Lunch"];
    sessionNm=[NSString stringWithFormat:@"My %@",@"Lunch"];
    [self createNavigationView:@"Snack"];
    navTitle=@"Snack";
    [self reloadTableBySession];
}

#pragma mark - "+" Button Tap Action
-(void)showSessionView
{
    sessionView.hidden=NO;
    /*CGRect frame = sessionView.frame;
     frame.size.height = self.view.frame.size.height;
     frame.origin.y=self.view.frame.origin.y;
     [foodPopupcontroller willMoveToParentViewController:self];
     foodPopupcontroller.delegate=self;
     foodPopupcontroller.navigateVal=@"food";
     [self.view addSubview:foodPopupcontroller.view];
     [self addChildViewController:foodPopupcontroller];
     [self.view bringSubviewToFront:sessionView];*/
}

-(void)tapAction:(UITapGestureRecognizer*)sender
{
    /*[self willMoveToParentViewController:nil];
     [self.view removeFromSuperview];
     [self removeFromParentViewController];*/
    [sessionView setHidden:YES];
}

#pragma mark - Reload by MealType Category Method
-(void)reloadTableBySession
{
    _selectedFoodArr=[NSMutableArray array];
    FavFoodVCount=0;
    
    _selectedFoodArr= _recentFoodArray=[foodLogObject getAllLunchLog:self.selectedMealTypeId withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
    if([_selectedFoodArr count]>0)
    {
        for(int i=0;i<_selectedFoodArr.count;i++)
        {
            if([[[_selectedFoodArr objectAtIndex:i] objectForKey:@"isFavMeal"] isEqualToString:@"1"])
            {
                FavFoodVCount++;
            }
        }
        
        autoCompleteTableView.hidden=YES;
        recentFoodTableView.hidden=YES;
        
        _tblVw.tag=MEALSUBCATEGORY_TABLE_TAG;
        _tblVw.delegate=self;
        _tblVw.dataSource=self;
        _tblVw.hidden=NO;
        [_tblVw reloadData];
        
        //[self performSelector:@selector(selfCalculateTotalSubCategoryMeal) withObject:nil afterDelay:3.0];
        
        if(FavFoodVCount==_selectedFoodArr.count)
        {
            [_btnTotalFav setImage:[UIImage imageNamed:@"green-star@3x.png"] forState:UIControlStateNormal];
        }
        else
        {
            [_btnTotalFav setImage:[UIImage imageNamed:@"green-star@3x_outline.png"] forState:UIControlStateNormal];
        }
        
    }
    else
    {
        FavFoodVCount=0;
        [_btnTotalFav setImage:[UIImage imageNamed:@"green-star@3x_outline.png"] forState:UIControlStateNormal];
        
        _tblVw.tag=MEALSUBCATEGORY_TABLE_TAG;
        _tblVw.delegate=self;
        _tblVw.dataSource=self;
        _tblVw.hidden=YES;
        [_tblVw reloadData];
        
        
        //[self performSelector:@selector(selfCalculateTotalSubCategoryMeal) withObject:nil afterDelay:3.0];
    }
    
    
  //  [self getTotalCal];
    
}
- (IBAction)btnActionAddFav:(id)sender
{
    
}

#pragma mark - Private Method
-(NSString *)gmToOz:(NSString *)foodWeight
{
    float foodWeightVal=0.035274*[foodWeight floatValue];
    NSString *finalFoodWeight=[NSString stringWithFormat:@"%.1f",foodWeightVal];
    return finalFoodWeight;
}

#pragma mark - FoodScale Weight Update Notification
- (void)updateFoodScaleData:(NSNotification *) notification
{
    @synchronized(self)
    {
   
    totalCalMealSub=0;
    NSLog(@"*********%@,%ld",_selectedFoodDictArr,selectedIndexPathNormal);
    _isKitchenScaleSync=YES;
    _isDeviceOn = TRUE;
    _isSelectedFoodScaleItem=NO;
        
        if(selectedIndexPathNormal>=0)
        {
        _tblVw.bounces=NO;
        }
        else
        {
          _tblVw.bounces=YES;
        }
   // NSMutableDictionary *selectedFoodDetails=[foodLogObject getSingleFoodLogDetails:[mAppDelegate.selectedFoodDict  objectForKey:@"id"]];
    
    //  NSString *totalgm=[NSString stringWithFormat:@"%@",[selectedFoodDetails objectForKey:@"item_weight"]];
    
    NSString *totalgm=[[notification userInfo] valueForKey:@"foodWeight"];
    
    if(![[self chkNullInputinitWithString:totalgm ] isEqualToString:@""] && [totalgm intValue]!=0)
    {
        if([selectedFoodScaleWeightUnit isEqualToString:@"oz"])
        {
                NSMutableAttributedString *mediumAttrString = [[NSMutableAttributedString alloc] initWithString:[self gmToOz:totalgm] attributes: _attributedTotDict];

            [mediumAttrString appendAttributedString:_LightAttrStringOZ];
            
            _lblBottomTotalGram.attributedText=mediumAttrString;
            
        }
        else if([selectedFoodScaleWeightUnit isEqualToString:@"gm"])
        {

            NSMutableAttributedString *mediumAttrString = [[NSMutableAttributedString alloc] initWithString:totalgm attributes: _attributedTotDict];
            
            [mediumAttrString appendAttributedString:_LightAttrStringGM];
            
            _lblBottomTotalGram.attributedText=mediumAttrString;
        }
    }
    else
    {
          NSMutableAttributedString *mediumAttrString = [[NSMutableAttributedString alloc] initWithString:@"0" attributes: _attributedTotDict];
        
        
        [mediumAttrString appendAttributedString:_LightAttrStringGM];
        
        _lblBottomTotalGram.attributedText=mediumAttrString;
    }
    
    /* if([navTitle isEqualToString:@"My Meal"])
     {
     [mymealView setHidden:NO];
     [self createMyMealArr];
     NSLog(@"myMealArr==%@",myMealArr);
     NSLog(@"myMealSecTitleArr==%@",myMealSecTitleArr);
     
     myMealTable.delegate=self;
     myMealTable.dataSource=self;
     myMealTable.hidden=NO;
     [myMealTable reloadData];
     }
    if([navTitle isEqualToString:@"Recent"])
    {
        _recentFoodArray=[foodLogObject getAllFoodLog:selectedUserProfileID ];
        selectedButton=1;
        [self reloadRecentFoodTable];
    }
    else if([navTitle isEqualToString:@"Favorites"])
    {
        _recentFoodArray=[foodLogObject getAllFavoriteFoodLog:@"" withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
        selectedButton=2;
        [self reloadRecentFoodTable];
    }
    
    else
    {*/
    
    if([self.previous_activity isEqualToString:@"FromPlanner"])
    {
        if(_selectedFoodDictArr.count>0)
        {
            int selectedIndex=0;
            if(selectedIndexPathNormal<0 ){
                selectedIndex=0;
            }
            else{
                selectedIndex=selectedIndexPathNormal;
                
            }
            float finalCal;
            float finalWeight;
            finalCal=[[[_selectedFoodDictArr objectAtIndex:selectedIndex] objectForKey:@"cals"] floatValue];
            finalWeight=[totalgm floatValue];
            NSLog(@"finalCal=%f---finalWeight=%f",finalCal,finalWeight);
            NSString *finalCalStr=[NSString stringWithFormat:@"%.1f",finalCal];
            
            NSString *finalWeightStr=[NSString stringWithFormat:@"%.1f",finalWeight];
            
            NSLog(@"finalCalStr==%@---finalWeightStr=%@",finalCalStr,finalWeightStr);
            
            NSMutableDictionary *oldDict =[_selectedFoodDictArr objectAtIndex:selectedIndex];
            [oldDict  setValue:finalCalStr forKey:@"cals"];
            [oldDict  setValue:finalWeightStr forKey:@"item_weight"];
            [_selectedFoodDictArr replaceObjectAtIndex:selectedIndex withObject:oldDict];
          _selectedFoodArr=[_selectedFoodDictArr mutableCopy];
        }
    }
    
    else if([self.previous_activity isEqualToString:@"newPlanner"])
    {
        
        if(_selectedFoodDictArr.count>0)
        {
            int selectedIndex=0;
            if(selectedIndexPathNormal<0 ){
                selectedIndex=0;
            }
            else{
                selectedIndex=selectedIndexPathNormal;
            
            }
            float finalCal;
            float finalWeight;
            /*if([[[_selectedFoodDictArr objectAtIndex:selectedIndexPathNormal] objectForKey:@"item_weight"] isEqualToString:@"0"])
            {*/
                finalCal=[[[_selectedFoodDictArr objectAtIndex:selectedIndex] objectForKey:@"cals"] floatValue];
                finalWeight=[totalgm floatValue];
                NSLog(@"finalCal=%f---finalWeight=%f",finalCal,finalWeight);
            /*}
           else
            {
                float clpergm=[[[_selectedFoodDictArr objectAtIndex:selectedIndexPathNormal] objectForKey:@"cals"] floatValue]/[[[_selectedFoodDictArr objectAtIndex:selectedIndexPathNormal] objectForKey:@"item_weight"] floatValue];
                
                
                finalCal=[totalgm floatValue]*clpergm;
                finalCal=[[[_selectedFoodDictArr objectAtIndex:selectedIndexPathNormal] objectForKey:@"cals"] floatValue]+finalCal;
                if(finalCal==NAN){
                    finalCal=[[[_selectedFoodDictArr objectAtIndex:selectedIndexPathNormal] objectForKey:@"cals"] floatValue];
                
                }
                finalWeight=[[[_selectedFoodDictArr objectAtIndex:selectedIndexPathNormal]objectForKey:@"item_weight"] floatValue]+[totalgm floatValue];
                NSLog(@"finalCal%f===clpergm=%f------finalWeight=%f",finalCal,clpergm,finalWeight);
            }*/
            
            NSString *finalCalStr=[NSString stringWithFormat:@"%.1f",finalCal];
            
            NSString *finalWeightStr=[NSString stringWithFormat:@"%.1f",finalWeight];
            
            NSLog(@"finalCalStr==%@---finalWeightStr=%@",finalCalStr,finalWeightStr);
 
            NSMutableDictionary *oldDict =[_selectedFoodDictArr objectAtIndex:selectedIndex];
            [oldDict  setValue:finalCalStr forKey:@"cals"];
            [oldDict  setValue:finalWeightStr forKey:@"item_weight"];
            [_selectedFoodDictArr replaceObjectAtIndex:selectedIndex withObject:oldDict];
            _selectedFoodArr=[_selectedFoodDictArr mutableCopy];
        }
    }
    else
    {
        _selectedFoodArr=[foodLogObject getAllLunchLog:self.selectedMealTypeId  withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
    }
        NSLog(@"modify_selectedFoodArr==%@===%ld",_selectedFoodArr,(long)selectedIndexPathNormal);
        if([_selectedFoodArr count]>0)
        {
            FavFoodVCount=0;
            _tblVw.tag=MEALSUBCATEGORY_TABLE_TAG;
            _tblVw.hidden=NO;
            
            if(selectedIndexPathNormal<[_selectedFoodArr count])
            {
                  if(selectedIndexPathNormal>=0)
                  {
                NSLog(@"REFRESH");
                NSArray *indexPathArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:selectedIndexPathNormal  inSection:0]];
                [_tblVw reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
                  }
            }
            /*_tblVw.delegate=self;
            _tblVw.dataSource=self;
            [_tblVw reloadData];*/
        }
        else
        {
            _tblVw.hidden=YES;
        }
   // }
    
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        int breakfastCal=0;
        NSMutableArray *breakfastMealArr=[foodLogObject getAllLunchLog:@"1" withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
        if(breakfastMealArr.count>0)
        {
            for(int j=0;j<breakfastMealArr.count;j++)
            {
                int breakfastTempCal=0;
                if([[[breakfastMealArr objectAtIndex:j]objectForKey:@"item_weight"]intValue]==0)
                {
                    breakfastCal=0+breakfastCal;
                }
                else
                {
                    breakfastTempCal=[[[breakfastMealArr objectAtIndex:j]objectForKey:@"cals"]intValue];
                    breakfastCal=breakfastTempCal+breakfastCal;
                }
            }
        }
        
        int lunchCal=0;
        NSMutableArray *lunchMealArr=[foodLogObject getAllLunchLog:@"2" withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
        if(lunchMealArr.count>0)
        {
            for(int j=0;j<lunchMealArr.count;j++)
            {
                int lunchTempCal=0;
                if([[[lunchMealArr objectAtIndex:j]objectForKey:@"item_weight"]intValue]==0)
                {
                    lunchCal=0+lunchCal;
                }
                else
                {
                    lunchTempCal=[[[lunchMealArr objectAtIndex:j]objectForKey:@"cals"]intValue];
                    lunchCal=lunchTempCal+lunchCal;
                }
            }
            
        }
        
        int dinnerCal=0;
        NSMutableArray *dinnerMealArr=[foodLogObject getAllLunchLog:@"3" withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
        if(dinnerMealArr.count>0)
        {
            for(int j=0;j<dinnerMealArr.count;j++)
            {
                int dinnerTempCal=0;
                if([[[dinnerMealArr objectAtIndex:j]objectForKey:@"item_weight"]intValue]==0)
                {
                    dinnerCal=0+dinnerCal;
                }
                else
                {
                    dinnerTempCal=[[[dinnerMealArr objectAtIndex:j]objectForKey:@"cals"]intValue];
                    dinnerCal=dinnerTempCal+dinnerCal;
                }
            }
            
        }
        
        int snacksCal=0;
        NSMutableArray *snacksMealArr=[foodLogObject getAllLunchLog:@"4" withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
        if(snacksMealArr.count>0)
        {
            for(int j=0;j<snacksMealArr.count;j++)
            {
                int snacksTempCal=0;
                if([[[snacksMealArr objectAtIndex:j]objectForKey:@"item_weight"]intValue]==0)
                {
                    snacksCal=0+snacksCal;
                }
                else
                {
                    snacksTempCal=[[[snacksMealArr objectAtIndex:j]objectForKey:@"cals"]intValue];
                    snacksCal=snacksTempCal+snacksCal;
                }
            }
            
        }
        
        NSString *totalcal=@"";
        
        if([self.selectedMealTypeId isEqualToString:@"1"])
            totalcal=[NSString stringWithFormat:@"%d",breakfastCal];
        if([self.selectedMealTypeId isEqualToString:@"2"])
            totalcal=[NSString stringWithFormat:@"%d",lunchCal];
        if([self.selectedMealTypeId isEqualToString:@"3"])
            totalcal=[NSString stringWithFormat:@"%d",dinnerCal];
        if([self.selectedMealTypeId isEqualToString:@"4"])
            totalcal=[NSString stringWithFormat:@"%d",snacksCal];

        NSMutableAttributedString *mediumAttrString = [[NSMutableAttributedString alloc] initWithString:totalcal attributes: _attributedTotDict];
        [mediumAttrString appendAttributedString:_LightAttrStringCAL];
        _lblBottomTotalCal.attributedText=mediumAttrString;
        
        int sumFood=0;
        sumFood=breakfastCal+lunchCal+dinnerCal+snacksCal;
        NSString *strSumFoodTotal=[NSString stringWithFormat:@"%d",sumFood];
        _lblTop2.text=strSumFoodTotal;
        
         int netCalorie=[[defaults objectForKey:@"TotalIntake" ] intValue]-sumFood;
        if(netCalorie<0)
            netCalorie= 0;
        _lblTop4.text=[NSString stringWithFormat:@"%d",netCalorie];
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    }
}

#pragma mark - updateSelectedIndexPath Method
-(void)updateSelectedIndexPath
{
    mAppDelegate.selectedFoodDict=nil;
    mAppDelegate.selectedFoodDict=[NSMutableDictionary dictionary];
    selectedIndexPathRecent=-1000000;
    selectedIndexPathRecentPrev=selectedIndexPathRecent;
    
    selectedIndexPathSearch=-2000000;
    
    selectedIndexPathNormal=-1000000;
    selectedIndexPathNormalPrev=selectedIndexPathNormal;
    
    selectedIndexPathFav=-1000000;
    selectedIndexPathFavPrev=selectedIndexPathFav;
}

#pragma mark - Total Bar Button Action Method
- (IBAction)btnActionTotalFav:(UIButton *)sender
{
    FavFoodVCount=0;
    for(int i=0;i<_selectedFoodArr.count;i++)
    {
        if([[[_selectedFoodArr objectAtIndex:i] objectForKey:@"isFavMeal"] isEqualToString:@"1"])
        {
            FavFoodVCount++;
        }
    }
    
    NSLog(@"%d",FavFoodVCount);
    
    
    if([self.previous_activity isEqualToString:@"FromPlanner"]||[self.previous_activity isEqualToString:@"newPlanner"])
    {
        if(FavFoodVCount==_selectedFoodArr.count)
        {
            [sender setImage:[UIImage imageNamed:@"green-star@3x_outline.png"] forState:UIControlStateNormal];
         }
        else
        {
            [sender setImage:[UIImage imageNamed:@"green-star@3x.png"] forState:UIControlStateNormal];
        }

        if(_selectedFoodDictArr.count>0)
        {
            for(int i=0;i<_selectedFoodDictArr.count;i++)
            {
                NSString *foodStatusToAddFav=[[_selectedFoodDictArr objectAtIndex:i]objectForKey:@"isFavorite"];
                if(FavFoodVCount==_selectedFoodArr.count)
                {
                    NSMutableDictionary *oldDict =[_selectedFoodDictArr objectAtIndex:i];
                    [oldDict  setValue:@"0" forKey:@"isFavMeal"];
                    [_selectedFoodDictArr replaceObjectAtIndex:i withObject:oldDict];
                }
                else
                {
                    NSMutableDictionary *oldDict =[_selectedFoodDictArr objectAtIndex:i];
                    [oldDict  setValue:@"1" forKey:@"isFavMeal"];
                    [_selectedFoodDictArr replaceObjectAtIndex:i withObject:oldDict];
                    
                }
            }
            _selectedFoodArr=[NSMutableArray array];
            _selectedFoodArr=[_selectedFoodDictArr mutableCopy];
        }
    }
    else
    {
        if(FavFoodVCount==_selectedFoodArr.count)
        {
            [sender setImage:[UIImage imageNamed:@"green-star@3x_outline.png"] forState:UIControlStateNormal];
            for(int i=0;i<_selectedFoodArr.count;i++)
            {
                [foodLogObject updateMealFavoriteStatus:@"0" foodID:[[_selectedFoodArr objectAtIndex:i]objectForKey:@"id" ]  withUserProfileID:selectedUserProfileID withMealFavStatus:@"0" withFoodRefID:[[_selectedFoodArr objectAtIndex:i]objectForKey:@"item" ]];
               [favMealLogObj deleteFavMealData:[[_selectedFoodArr objectAtIndex:i]objectForKey:@"id" ] withUserId:selectedUserProfileID];
            }
        }
        else
        {
            NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
            formatter1.dateFormat = @"EEEE, MMMM dd, yyyy";
            NSDate *dateFromString = [formatter1 dateFromString:[[Utility sharedManager] getSelectedDate]];
            //  NSDate *dateFromString = [formatter1 dateFromString:dateStr];
            NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc] init];
            [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
            logTimeStr= [dateFormatter2 stringFromDate:dateFromString];
            
            favMealLogObj.log_date_added=[self getCurrentDateTime];
            favMealLogObj.log_log_time=[NSString stringWithFormat:@"%@ %@",logTimeStr,[self getCurrentTime]];
  
            [sender setImage:[UIImage imageNamed:@"green-star@3x.png"] forState:UIControlStateNormal];
            for(int i=0;i<_selectedFoodArr.count;i++)
            {
                favMealLogObj.log_meal_id=[[_selectedFoodArr objectAtIndex:i] objectForKey:@"meal_id"];
                
                if([[[_selectedFoodArr objectAtIndex:i]  allKeys] containsObject:@"item_title"])
                {
                    favMealLogObj.log_item_title=[[_selectedFoodArr objectAtIndex:i]  objectForKey:@"item_title"];
                }
                else  if([[[_selectedFoodArr objectAtIndex:i]  allKeys] containsObject:@"food_name"])
                {
                    favMealLogObj.log_item_title=[[_selectedFoodArr objectAtIndex:i] objectForKey:@"food_name"];
                }
                
                favMealLogObj.log_item_desc=[[_selectedFoodArr objectAtIndex:i]  objectForKey:@"item_desc"];
                favMealLogObj.log_cals=[[_selectedFoodArr objectAtIndex:i]  objectForKey:@"cals"];
                favMealLogObj.log_serving_size=[[_selectedFoodArr objectAtIndex:i]  objectForKey:@"serving_size"];
                favMealLogObj.log_reference_food_id=[[_selectedFoodArr objectAtIndex:i]  objectForKey:@"item"];
                favMealLogObj.log_item_weight=[[_selectedFoodArr objectAtIndex:i] objectForKey:@"item_weight"];

                [foodLogObject updateMealFavoriteStatus:@"1" foodID:[[_selectedFoodArr objectAtIndex:i]objectForKey:@"id" ]  withUserProfileID:selectedUserProfileID withMealFavStatus:@"1" withFoodRefID:[[_selectedFoodArr objectAtIndex:i]objectForKey:@"item" ]];
                [favMealLogObj saveFavMealDataLog:[_selectedFoodArr objectAtIndex:i] withFoodID:[[_selectedFoodArr objectAtIndex:i]objectForKey:@"id" ] withLogUserID:[defaults objectForKey:@"user_id"] withUserProfileID:selectedUserProfileID];
            }
        }

        _selectedFoodArr=[NSMutableArray array];
        _selectedFoodArr= _recentFoodArray=[foodLogObject getAllLunchLog:self.selectedMealTypeId withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
    }
    
    
     if([_selectedFoodArr count]>0){
        mymealView.hidden=YES;
        autoCompleteTableView.hidden=YES;
        recentFoodTableView.hidden=YES;
        FavFoodVCount=0;
        _tblVw.tag=MEALSUBCATEGORY_TABLE_TAG;
        _tblVw.delegate=self;
        _tblVw.dataSource=self;
        _tblVw.hidden=NO;
        [_tblVw reloadData];
        
         //[self performSelector:@selector(selfCalculateTotalSubCategoryMeal) withObject:nil afterDelay:3.0];
    }
    else
    {
        mymealView.hidden=YES;
        FavFoodVCount=0;
        _tblVw.tag=MEALSUBCATEGORY_TABLE_TAG;
        _tblVw.delegate=self;
        _tblVw.dataSource=self;
        _tblVw.hidden=YES;
        [_tblVw reloadData];
        
        //[self performSelector:@selector(selfCalculateTotalSubCategoryMeal) withObject:nil afterDelay:3.0];
    }
    
    totalCal=0;
    NSMutableArray *individualMealArr=[foodLogObject getAllLunchLog:self.selectedMealTypeId withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
    if(individualMealArr.count>0)
    {
        for(int j=0;j<individualMealArr.count;j++)
        {
            int individualTempCal=[[[individualMealArr objectAtIndex:j]objectForKey:@"cals"]intValue];
            totalCal=individualTempCal+totalCal;
        }
    }

   // totalCal=[foodLogObject getFoodSumIndividualCalorie:self.selectedMealTypeId withUserProfileID:selectedUserProfileID withDate:logTimeStr];
    NSString *totalcal=[NSString stringWithFormat:@"%d",totalCal];
    
    UIFont *mediumFont = [UIFont fontWithName:@"SinkinSans-400regular" size:30];
    NSDictionary *mediumDict = [NSDictionary dictionaryWithObject: mediumFont forKey:NSFontAttributeName];
    NSMutableAttributedString *mediumAttrString = [[NSMutableAttributedString alloc] initWithString:totalcal attributes: mediumDict];
    
    UIFont *LightFont = [UIFont fontWithName:@"SinkinSans-300Light" size:15];
    NSDictionary *LightDict = [NSDictionary dictionaryWithObject:LightFont forKey:NSFontAttributeName];
    NSMutableAttributedString *LightAttrString = [[NSMutableAttributedString alloc]initWithString:@" cal"  attributes:LightDict];
    
    [mediumAttrString appendAttributedString:LightAttrString];
    _lblBottomTotalCal.attributedText=mediumAttrString;
}

- (IBAction)btnActionMTotal:(id)sender
{
    NSMutableDictionary *selectedFoodDetails=[foodLogObject getSingleFoodLogDetails:[mAppDelegate.selectedFoodDict  objectForKey:@"id"]];
    
    NSString *totalgm=[NSString stringWithFormat:@"%@",[selectedFoodDetails objectForKey:@"item_weight"]];
    
    if(![[self chkNullInputinitWithString:totalgm ] isEqualToString:@""] && [totalgm intValue]!=0)
    {
        
        if([selectedFoodScaleWeightUnit isEqualToString:@"gm"])
        {
            selectedFoodScaleWeightUnit=@"oz";
            UIFont *mediumFont = [UIFont fontWithName:@"SinkinSans-400regular" size:30];
            NSDictionary *mediumDict = [NSDictionary dictionaryWithObject: mediumFont forKey:NSFontAttributeName];
            NSMutableAttributedString *mediumAttrString = [[NSMutableAttributedString alloc] initWithString:[self gmToOz:totalgm] attributes: mediumDict];
            
            UIFont *LightFont = [UIFont fontWithName:@"SinkinSans-300Light" size:15];
            NSDictionary *LightDict = [NSDictionary dictionaryWithObject:LightFont forKey:NSFontAttributeName];
            NSMutableAttributedString *LightAttrString = [[NSMutableAttributedString alloc]initWithString:@" oz"  attributes:LightDict];
            
            [mediumAttrString appendAttributedString:LightAttrString];
            
            _lblBottomTotalGram.attributedText=mediumAttrString;
            
        }
        else if([selectedFoodScaleWeightUnit isEqualToString:@"oz"])
        {
            selectedFoodScaleWeightUnit=@"gm";
            UIFont *mediumFont = [UIFont fontWithName:@"SinkinSans-400regular" size:30];
            NSDictionary *mediumDict = [NSDictionary dictionaryWithObject: mediumFont forKey:NSFontAttributeName];
            NSMutableAttributedString *mediumAttrString = [[NSMutableAttributedString alloc] initWithString:totalgm attributes: mediumDict];
            
            UIFont *LightFont = [UIFont fontWithName:@"SinkinSans-300Light" size:15];
            NSDictionary *LightDict = [NSDictionary dictionaryWithObject:LightFont forKey:NSFontAttributeName];
            NSMutableAttributedString *LightAttrString = [[NSMutableAttributedString alloc]initWithString:@" g"  attributes:LightDict];
            
            [mediumAttrString appendAttributedString:LightAttrString];
            
            _lblBottomTotalGram.attributedText=mediumAttrString;
        }
    }
    else
    {
        if([selectedFoodScaleWeightUnit isEqualToString:@"gm"])
        {
            selectedFoodScaleWeightUnit=@"oz";
            UIFont *mediumFont = [UIFont fontWithName:@"SinkinSans-400regular" size:30];
            NSDictionary *mediumDict = [NSDictionary dictionaryWithObject: mediumFont forKey:NSFontAttributeName];
            NSMutableAttributedString *mediumAttrString = [[NSMutableAttributedString alloc] initWithString:@"0" attributes: mediumDict];
            
            UIFont *LightFont = [UIFont fontWithName:@"SinkinSans-300Light" size:15];
            NSDictionary *LightDict = [NSDictionary dictionaryWithObject:LightFont forKey:NSFontAttributeName];
            NSMutableAttributedString *LightAttrString = [[NSMutableAttributedString alloc]initWithString:@" oz"  attributes:LightDict];
            
            [mediumAttrString appendAttributedString:LightAttrString];
            
            _lblBottomTotalGram.attributedText=mediumAttrString;
            
        }
        else if([selectedFoodScaleWeightUnit isEqualToString:@"oz"])
        {
            selectedFoodScaleWeightUnit=@"gm";
            UIFont *mediumFont = [UIFont fontWithName:@"SinkinSans-400regular" size:30];
            NSDictionary *mediumDict = [NSDictionary dictionaryWithObject: mediumFont forKey:NSFontAttributeName];
            NSMutableAttributedString *mediumAttrString = [[NSMutableAttributedString alloc] initWithString:@"0" attributes: mediumDict];
            
            UIFont *LightFont = [UIFont fontWithName:@"SinkinSans-300Light" size:15];
            NSDictionary *LightDict = [NSDictionary dictionaryWithObject:LightFont forKey:NSFontAttributeName];
            NSMutableAttributedString *LightAttrString = [[NSMutableAttributedString alloc]initWithString:@" g"  attributes:LightDict];
            
            [mediumAttrString appendAttributedString:LightAttrString];
            
            _lblBottomTotalGram.attributedText=mediumAttrString;
        }
        
    }
}

- (IBAction)btnActionTTotal:(id)sender
{
    selectedFoodScaleWeightUnit=@"gm";
    
    [self getTotalWeight];
    mAppDelegate.selectedFoodDict=nil;
    mAppDelegate.selectedFoodDict=[NSMutableDictionary dictionary];
    selectedIndexPathNormal=-100000;
    selectedIndexPathNormalPrev=selectedIndexPathNormal;
    
    FavFoodVCount=0;
    [_tblVw reloadData];
    
    recentFoodTableView.tag=RECENT_TABLE_TAG;
    recentFoodTableView.delegate=self;
    recentFoodTableView.dataSource=self;
    [recentFoodTableView reloadData];
}

#pragma mark - create FavMeal Array Method
-(void)createFavMealArr
{
    NSMutableArray *allMealArr=[NSMutableArray array];
    allMealArr=[mealTypeObj findAllMealType];
    for(NSDictionary *dict in allMealArr)
    {
        if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"breakfast"])
            breakfastId=[dict objectForKey:@"meal_type_id"];
        
        else if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"lunch"])
            lunchId=[dict objectForKey:@"meal_type_id"];
        
        else if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"dinner"])
            dinnerId=[dict objectForKey:@"meal_type_id"];
        
        else if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"snack"])
            snackId=[dict objectForKey:@"meal_type_id"];
    }
    
    favMealArr=[NSMutableArray array];
    favMealSecTitleArr=[NSMutableArray array];
    favMealTitleArr=[NSMutableArray array];
    favMealTitleStr=@"";
    
   // NSMutableArray *arrFavDate=[foodLogObject getUniqueFavDate:selectedUserProfileID withMealID:@""];
     NSMutableArray *arrFavDate=[favMealLogObj getUniqueFavDate:selectedUserProfileID withMealID:@""];
    NSLog(@"arrFavDate==%@",arrFavDate);
    
    NSMutableArray *breakfastTitleFinalArr =[NSMutableArray array];
    NSMutableArray *breakfastMealFinalArr =[NSMutableArray array];
    
    for(int i=0;i<arrFavDate.count;i++)
    {
        
       // NSMutableArray *breakfastMealArr=[foodLogObject getFavMealFoodLog:breakfastId withSelectedDate:[arrFavDate objectAtIndex:i] withUserId:selectedUserProfileID];
        NSMutableArray *breakfastMealArr=[favMealLogObj getFavMealFoodLog:breakfastId withSelectedDate:[arrFavDate objectAtIndex:i] withUserId:selectedUserProfileID];

        if(breakfastMealArr.count>0)
        {
            NSMutableArray *breakfastTitleArr =[NSMutableArray array];
            
            NSString *breakfastTitleStr=@"";
            for(int i=0;i<breakfastMealArr.count;i++)
            {
                [breakfastTitleArr addObject:[[breakfastMealArr objectAtIndex:i]objectForKey:@"food_name"]];
            }
            breakfastTitleStr = [breakfastTitleArr componentsJoinedByString:@" , "];
            [breakfastTitleFinalArr addObject:breakfastTitleStr];
            
            [breakfastMealFinalArr addObject:breakfastMealArr];
        }
        
    }
    
    if(breakfastMealFinalArr.count>0)
    {
        [favMealTitleArr addObject:breakfastTitleFinalArr];
        [favMealArr addObject:breakfastMealFinalArr];
        
        [favMealSecTitleArr addObject:@"Breakfast"];
    }
    
    NSMutableArray *lunchTitleFinalArr =[NSMutableArray array];
    NSMutableArray *lunchMealFinalArr =[NSMutableArray array];
    
    for(int i=0;i<arrFavDate.count;i++)
    {
        
        //NSMutableArray *lunchMealArr=[foodLogObject getFavMealFoodLog:lunchId withSelectedDate:[arrFavDate objectAtIndex:i] withUserId:selectedUserProfileID];
        NSMutableArray *lunchMealArr=[favMealLogObj getFavMealFoodLog:lunchId withSelectedDate:[arrFavDate objectAtIndex:i] withUserId:selectedUserProfileID];

        if(lunchMealArr.count>0)
        {
            NSMutableArray *lunchTitleArr =[NSMutableArray array];
            
            NSString *lunchTitleStr=@"";
            for(int i=0;i<lunchMealArr.count;i++)
            {
                [lunchTitleArr addObject:[[lunchMealArr objectAtIndex:i]objectForKey:@"food_name"]];
            }
            lunchTitleStr = [lunchTitleArr componentsJoinedByString:@" , "];
            
            [lunchTitleFinalArr addObject:lunchTitleStr];
            [lunchMealFinalArr addObject:lunchMealArr];
        }
    }
    
    if(lunchMealFinalArr.count>0)
    {
        [favMealTitleArr addObject:lunchTitleFinalArr];
        [favMealArr addObject:lunchMealFinalArr];
        
        [favMealSecTitleArr addObject:@"Lunch"];
    }
    
    NSMutableArray *dinnerTitleFinalArr =[NSMutableArray array];
    NSMutableArray *dinnerMealFinalArr =[NSMutableArray array];
    
    for(int i=0;i<arrFavDate.count;i++)
    {
        //NSMutableArray *dinnerMealArr=[foodLogObject getFavMealFoodLog:dinnerId withSelectedDate:[arrFavDate objectAtIndex:i] withUserId:selectedUserProfileID];
        NSMutableArray *dinnerMealArr=[favMealLogObj getFavMealFoodLog:dinnerId withSelectedDate:[arrFavDate objectAtIndex:i] withUserId:selectedUserProfileID];
        
        if(dinnerMealArr.count>0)
        {
            NSMutableArray *dinnerTitleArr =[NSMutableArray array];
            NSString *dinnerTitleStr=@"";
            for(int i=0;i<dinnerMealArr.count;i++)
            {
                [dinnerTitleArr addObject:[[dinnerMealArr objectAtIndex:i]objectForKey:@"food_name"]];
            }
            dinnerTitleStr = [dinnerTitleArr componentsJoinedByString:@" , "];
            
            [dinnerTitleFinalArr addObject:dinnerTitleStr];
            [dinnerMealFinalArr addObject:dinnerMealArr];
        }
    }
    
    if(dinnerMealFinalArr.count>0)
    {
        [favMealTitleArr addObject:dinnerTitleFinalArr];
        [favMealArr addObject:dinnerMealFinalArr];
        
        [favMealSecTitleArr addObject:@"Dinner"];
    }
    
    NSMutableArray *snacksTitleFinalArr =[NSMutableArray array];
    NSMutableArray *snacksMealFinalArr =[NSMutableArray array];
    
    for(int i=0;i<arrFavDate.count;i++)
    {
      //  NSMutableArray *snacksMealArr=[foodLogObject getFavMealFoodLog:snackId withSelectedDate:[arrFavDate objectAtIndex:i] withUserId:selectedUserProfileID];
        NSMutableArray *snacksMealArr=[favMealLogObj getFavMealFoodLog:snackId withSelectedDate:[arrFavDate objectAtIndex:i] withUserId:selectedUserProfileID];

        if(snacksMealArr.count>0)
        {
            NSMutableArray *snacksTitleArr =[NSMutableArray array];
            NSString *snacksTitleStr=@"";
            for(int i=0;i<snacksMealArr.count;i++)
            {
                [snacksTitleArr addObject:[[snacksMealArr objectAtIndex:i]objectForKey:@"food_name"]];
            }
            snacksTitleStr = [snacksTitleArr componentsJoinedByString:@" , "];
            [snacksTitleFinalArr addObject:snacksTitleStr];
            [snacksMealFinalArr addObject:snacksMealArr];
        }
    }
    
    if(snacksMealFinalArr.count>0)
    {
        [favMealTitleArr addObject:snacksTitleFinalArr];
        [favMealArr addObject:snacksMealFinalArr];
        
        [favMealSecTitleArr addObject:@"Snack"];
    }
    
    selectedFavMealTypeId=@"";
    if(dropDown != nil)
    {
        [dropDown hideDropDown:btnDropDown];
        [self rel];
    }
    
    NSLog(@"favMealArr==%@",favMealArr);
    
    NSLog(@"favMealTitleArr==%@",favMealTitleArr);
}

#pragma mark - create RecentMeal Array Method
-(void)createRecentMealArr
{
    NSMutableArray *allMealArr=[NSMutableArray array];
    allMealArr=[mealTypeObj findAllMealType];
    for(NSDictionary *dict in allMealArr)
    {
        if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"breakfast"])
            breakfastId=[dict objectForKey:@"meal_type_id"];
        
        else if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"lunch"])
            lunchId=[dict objectForKey:@"meal_type_id"];
        
        else if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"dinner"])
            dinnerId=[dict objectForKey:@"meal_type_id"];
        
        else if([[dict objectForKey:@"meal_type_name"] isEqualToString:@"snack"])
            snackId=[dict objectForKey:@"meal_type_id"];
    }
    
    favMealArr=[NSMutableArray array];
    favMealSecTitleArr=[NSMutableArray array];
    favMealTitleArr=[NSMutableArray array];
    favMealTitleStr=@"";
    
    NSMutableArray *arrRecentDate=[foodLogObject getUniqueRecentDate:selectedUserProfileID withMealID:@""];
    NSLog(@"arrRecentDate==%@",arrRecentDate);
    
    NSMutableArray *breakfastTitleFinalArr =[NSMutableArray array];
    NSMutableArray *breakfastMealFinalArr =[NSMutableArray array];
    for(int i=0;i<arrRecentDate.count;i++)
    {
        NSMutableArray *breakfastMealArr=[foodLogObject getRecentMealFoodLog:breakfastId withSelectedDate:[arrRecentDate objectAtIndex:i] withUserId:selectedUserProfileID];
        
        if(breakfastMealArr.count>0)
        {
            NSMutableArray *breakfastTitleArr =[NSMutableArray array];
            
            NSString *breakfastTitleStr=@"";
            for(int i=0;i<breakfastMealArr.count;i++)
            {
                [breakfastTitleArr addObject:[[breakfastMealArr objectAtIndex:i]objectForKey:@"food_name"]];
            }
            breakfastTitleStr = [breakfastTitleArr componentsJoinedByString:@" , "];
            [breakfastTitleFinalArr addObject:breakfastTitleStr];
            
            [breakfastMealFinalArr addObject:breakfastMealArr];
        }
        
    }
    
    if(breakfastMealFinalArr.count>0)
    {
        [favMealTitleArr addObject:breakfastTitleFinalArr];
        [favMealArr addObject:breakfastMealFinalArr];
        
        [favMealSecTitleArr addObject:@"Breakfast"];
    }
    /*  NSMutableArray *breakfastMealArr=[foodLogObject getAllRecentFoodLog:breakfastId withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
     
     if(breakfastMealArr.count>0)
     {
     NSMutableArray *breakfastTitleArr =[NSMutableArray array];
     NSString *breakfastTitleStr=@"";
     for(int i=0;i<breakfastMealArr.count;i++)
     {
     [breakfastTitleArr addObject:[[breakfastMealArr objectAtIndex:i]objectForKey:@"food_name"]];
     }
     breakfastTitleStr = [breakfastTitleArr componentsJoinedByString:@" , "];
     [favMealTitleArr addObject:breakfastTitleStr];
     
     [favMealArr addObject:breakfastMealArr];
     [favMealSecTitleArr addObject:@"Breakfast"];
     }*/
    
    NSMutableArray *lunchTitleFinalArr =[NSMutableArray array];
    NSMutableArray *lunchMealFinalArr =[NSMutableArray array];
    
    for(int i=0;i<arrRecentDate.count;i++)
    {
        
        NSMutableArray *lunchMealArr=[foodLogObject getRecentMealFoodLog:lunchId withSelectedDate:[arrRecentDate objectAtIndex:i] withUserId:selectedUserProfileID];
        if(lunchMealArr.count>0)
        {
            NSMutableArray *lunchTitleArr =[NSMutableArray array];
            
            NSString *lunchTitleStr=@"";
            for(int i=0;i<lunchMealArr.count;i++)
            {
                [lunchTitleArr addObject:[[lunchMealArr objectAtIndex:i]objectForKey:@"food_name"]];
            }
            lunchTitleStr = [lunchTitleArr componentsJoinedByString:@" , "];
            
            [lunchTitleFinalArr addObject:lunchTitleStr];
            [lunchMealFinalArr addObject:lunchMealArr];
        }
    }
    
    if(lunchMealFinalArr.count>0)
    {
        [favMealTitleArr addObject:lunchTitleFinalArr];
        [favMealArr addObject:lunchMealFinalArr];
        
        [favMealSecTitleArr addObject:@"Lunch"];
    }
    
    NSMutableArray *dinnerTitleFinalArr =[NSMutableArray array];
    NSMutableArray *dinnerMealFinalArr =[NSMutableArray array];
    
    for(int i=0;i<arrRecentDate.count;i++)
    {
        NSMutableArray *dinnerMealArr=[foodLogObject getRecentMealFoodLog:dinnerId withSelectedDate:[arrRecentDate objectAtIndex:i] withUserId:selectedUserProfileID];
        
        if(dinnerMealArr.count>0)
        {
            NSMutableArray *dinnerTitleArr =[NSMutableArray array];
            NSString *dinnerTitleStr=@"";
            for(int i=0;i<dinnerMealArr.count;i++)
            {
                [dinnerTitleArr addObject:[[dinnerMealArr objectAtIndex:i]objectForKey:@"food_name"]];
            }
            dinnerTitleStr = [dinnerTitleArr componentsJoinedByString:@" , "];
            
            [dinnerTitleFinalArr addObject:dinnerTitleStr];
            [dinnerMealFinalArr addObject:dinnerMealArr];
        }
    }
    
    if(dinnerMealFinalArr.count>0)
    {
        [favMealTitleArr addObject:dinnerTitleFinalArr];
        [favMealArr addObject:dinnerMealFinalArr];
        
        [favMealSecTitleArr addObject:@"Dinner"];
    }
    
    NSMutableArray *snacksTitleFinalArr =[NSMutableArray array];
    NSMutableArray *snacksMealFinalArr =[NSMutableArray array];
    
    for(int i=0;i<arrRecentDate.count;i++)
    {
        NSMutableArray *snacksMealArr=[foodLogObject getRecentMealFoodLog:snackId withSelectedDate:[arrRecentDate objectAtIndex:i] withUserId:selectedUserProfileID];
        
        if(snacksMealArr.count>0)
        {
            NSMutableArray *snacksTitleArr =[NSMutableArray array];
            NSString *snacksTitleStr=@"";
            for(int i=0;i<snacksMealArr.count;i++)
            {
                [snacksTitleArr addObject:[[snacksMealArr objectAtIndex:i]objectForKey:@"food_name"]];
            }
            snacksTitleStr = [snacksTitleArr componentsJoinedByString:@" , "];
            [snacksTitleFinalArr addObject:snacksTitleStr];
            [snacksMealFinalArr addObject:snacksMealArr];
        }
    }
    
    if(snacksMealFinalArr.count>0)
    {
        [favMealTitleArr addObject:snacksTitleFinalArr];
        [favMealArr addObject:snacksMealFinalArr];
        
        [favMealSecTitleArr addObject:@"Snack"];
    }
    
    selectedFavMealTypeId=@"";
    if(dropDown != nil)
    {
        [dropDown hideDropDown:btnDropDown];
        [self rel];
    }
    
    NSLog(@"favMealArr==%@",favMealArr);
    
    NSLog(@"favMealTitleArr==%@",favMealTitleArr);
}

-(void)RecentSwipe:(UIPanGestureRecognizer *)sender
{
    
    self.meunHeight = recentFoodView.frame.size.height;
    self.menuWidth = recentFoodView.frame.size.width;
    self.inFrame = CGRectMake (0,0,self.menuWidth,self.meunHeight);
    self.outFrame = CGRectMake(0,SCREEN_HEIGHT-25,self.menuWidth,self.meunHeight);
    
    CGPoint velocity = [sender velocityInView:recentFoodView];
    CGPoint translation = [sender translationInView:recentFoodView];
    NSLog(@"direction======%f",velocity.y);
    arrowImageView.image=[UIImage imageNamed:@"kee_arrow"];
    UITableViewCell *cell = (UITableViewCell*)[myMealTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    UIButton *plusBtn=(UIButton *)[cell viewWithTag:1];
    [plusBtn setUserInteractionEnabled:NO];
    [btn1 setUserInteractionEnabled:NO];
    [btn2 setUserInteractionEnabled:NO];
    [btn3 setUserInteractionEnabled:NO];
    [btn4 setUserInteractionEnabled:NO];
    [autoCompleteTextField setUserInteractionEnabled:NO];
    [_btnBarCode setUserInteractionEnabled:NO];
    [_tblVw setUserInteractionEnabled:NO];
    [myMealTable setUserInteractionEnabled:NO];
    
    CGFloat f1;
    if([self.previous_activity isEqualToString:@"FromPlanner"]||[self.previous_activity isEqualToString:@"newPlanner"])
    {
        if(family==iPad){
            f1=[[UIScreen mainScreen] bounds].size.height-260;
            //f1=700;
            totalViewBottomConstant.constant=0;
        }
        else{
            f1=[[UIScreen mainScreen] bounds].size.height-(204-28);
            totalViewBottomConstant.constant=15;
        }
        [self.view bringSubviewToFront:logView ];
    }
    else{
        
        if(family==iPad){
            f1=[[UIScreen mainScreen] bounds].size.height-260;
            totalViewBottomConstant.constant=0;
        }
        else{
            f1=[[UIScreen mainScreen] bounds].size.height-140;
            totalViewBottomConstant.constant=18;
        }
    }
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        if ( velocity.y > KEYBOARD_TRIGGER_VELOCITY && !self.isOpen)
        {
            NSLog(@"Swipe Up");
            
            [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                if(family==iPad)
                    ;// recentMealViewTopConstant.constant=300;
                else
                    // recentMealViewTopConstant.constant=142;//150;
                    recentFoodView.frame=CGRectMake(0, 142+65, SCREEN_WEIDTH, SCREEN_HEIGHT-(142+65));
                
                // [self.view layoutIfNeeded];
            } completion:^(BOOL finished){
                
            }];
            self.isOpen= YES;
            id sender;
            
            if([selectedRecentFav isEqualToString:@"Recent"])
                [self btnActionRecentFood:sender];
            else
                [self btnActionRecentMeal:sender];
        }
        else if(velocity.y < -KEYBOARD_TRIGGER_VELOCITY && self.isOpen ){
            //        NSLog(@"changing");
            
            {
                NSLog(@"Swipe Down");
                id sender2;
                self.isOpen= NO;
                [self showHideRecentfoodView:sender2];
            }
        }
        
    }
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
        //        NSLog(@"changing");
        float movingx = recentFoodView.center.y + translation.y;
        //if ( movingx >SCREEN_HEIGHT-(140+self.meunHeight/2) && movingx < SCREEN_HEIGHT + self.meunHeight/2)
        if(movingx > 140+65+(SCREEN_HEIGHT-(142+65))/2 &&  movingx < SCREEN_HEIGHT + self.meunHeight/2){
            NSLog(@"s: 4");
            NSLog(@"movingx=== %f SCREEN_HEIGHT:%f meunHeight:%f val:%f ",movingx ,SCREEN_HEIGHT,  self.meunHeight ,SCREEN_HEIGHT-(140+self.meunHeight/2)+100);
            recentFoodView.center = CGPointMake(recentFoodView.center.x, movingx);
            [sender setTranslation:CGPointMake(0,0) inView:self.view];
            
        }
    }
    NSLog(@"%f -- %f ::%f ",recentFoodView.center.y,SCREEN_HEIGHT,(SCREEN_HEIGHT-self.meunHeight/2));
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        if (recentFoodView.frame.origin.y<=(SCREEN_HEIGHT-self.meunHeight/2)){
            NSLog(@"s: 5");
            
            [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                if(family==iPad)
                    ;// recentMealViewTopConstant.constant=300;
                else
                    // recentMealViewTopConstant.constant=142;//150;
                    recentFoodView.frame=CGRectMake(0, 142+65, SCREEN_WEIDTH, SCREEN_HEIGHT-(142+65));
                //  [self.view layoutIfNeeded];
            } completion:^(BOOL finished){
                
            }];
            self.isOpen= YES;
            id sender;
            if([selectedRecentFav isEqualToString:@"Recent"])
                [self btnActionRecentFood:sender];
            else
                [self btnActionRecentMeal:sender];
            
        }else if (recentFoodView.frame.origin.y>(SCREEN_HEIGHT-self.meunHeight/2)){
            NSLog(@"s: 6");
            NSLog(@"Swipe Down");
            id sender2;
            self.isOpen= NO;
            [self showHideRecentfoodView:sender2];
        }
    }
    
    
}

#pragma mark - Swipe Arrow Down Gesture Method
-(void)showHideRecentfoodView:(id)sender
{
    @try {
        
        arrowImageView.image=[UIImage imageNamed:@"kee_arrow_strate"];
        UITableViewCell *cell = (UITableViewCell*)[myMealTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        UIButton *plusBtn=(UIButton *)[cell viewWithTag:1];
        [plusBtn setUserInteractionEnabled:YES];
        [btn1 setUserInteractionEnabled:YES];
        [btn2 setUserInteractionEnabled:YES];
        [btn3 setUserInteractionEnabled:YES];
        [btn4 setUserInteractionEnabled:YES];
        [autoCompleteTextField setUserInteractionEnabled:YES];
        [_btnBarCode setUserInteractionEnabled:YES];
        [_tblVw setUserInteractionEnabled:YES];
        [myMealTable setUserInteractionEnabled:YES];
   
        if([sessionNm isEqualToString:@"My Meal"])
        {
            [mymealView setHidden:NO];
            [self createMyMealArr];
            NSLog(@"myMealArr==%@",myMealArr);
            NSLog(@"myMealSecTitleArr==%@",myMealSecTitleArr);
            
            if([self.previous_activity isEqualToString:@"FromPlanner"]||[self.previous_activity isEqualToString:@"newPlanner"] ){
                [mymealView setHidden:YES];
                _tblVw.delegate=self;
                _tblVw.dataSource=self;
                _tblVw.hidden=NO;
                [_tblVw reloadData];
                
                
            }
            else{
                myMealTable.delegate=self;
                myMealTable.dataSource=self;
                myMealTable.hidden=NO;
                [myMealTable reloadData];
            }
            ////
            
        }
        else
        {
            _selectedFoodArr=[foodLogObject getAllLunchLog:self.selectedMealTypeId  withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
            
            FavFoodVCount=0;
            if([_selectedFoodArr count]>0)
            {
                for(int i=0;i<_selectedFoodArr.count;i++)
                {
                    if([[[_selectedFoodArr objectAtIndex:i] objectForKey:@"isFavMeal"] isEqualToString:@"1"])
                    {
                        FavFoodVCount++;
                    }
                }
                if(FavFoodVCount==_selectedFoodArr.count)
                {
                    [_btnTotalFav setImage:[UIImage imageNamed:@"green-star@3x.png"] forState:UIControlStateNormal];
                }
                else
                {
                    [_btnTotalFav setImage:[UIImage imageNamed:@"green-star@3x_outline.png"] forState:UIControlStateNormal];
                }
                
                _tblVw.tag=MEALSUBCATEGORY_TABLE_TAG;
                _tblVw.hidden=NO;
//                _tblVw.delegate=self;
//                _tblVw.dataSource=self;
                [_tblVw reloadData];
                
                //[self performSelector:@selector(selfCalculateTotalSubCategoryMeal) withObject:nil afterDelay:3.0];
            }
            else
            {
                FavFoodVCount=0;
                [_btnTotalFav setImage:[UIImage imageNamed:@"green-star@3x_outline.png"] forState:UIControlStateNormal];
                _tblVw.hidden=YES;
            }
            
        }
        
        
        [swipeFood setDirection: UISwipeGestureRecognizerDirectionUp];
        // [swipeMeal setDirection:UISwipeGestureRecognizerDirectionUp];
        
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGFloat f1;
            
            if([self.previous_activity isEqualToString:@"FromPlanner"]||[self.previous_activity isEqualToString:@"newPlanner"] ){
                f1=[[UIScreen mainScreen] bounds].size.height-(204-28);
                totalViewBottomConstant.constant=15;
                //[self.view bringSubviewToFront:logView ];
            }
            else
            {
                if(family==iPad)
                {
                    f1=[[UIScreen mainScreen] bounds].size.height-260;
                    //[self.view bringSubviewToFront:buttonView];
                    sessionCollectionViewHeight.constant=40;
                }
                else
                {
                    f1=[[UIScreen mainScreen] bounds].size.height-140;
                }
                totalViewBottomConstant.constant=18;
            }
            //recentMealViewTopConstant.constant=f1;
            recentFoodView.frame=CGRectMake(0, f1+52, SCREEN_WEIDTH, SCREEN_HEIGHT-(140));
            
            //[self.view layoutIfNeeded];
        } completion:^(BOOL finished){
            
        }];
        
    }
    @catch (NSException *exception) {
        NSLog(@"Exception : %@",exception);
    }
    @finally {
        
    }
    
}

#pragma mark - Edit Weight Delegate Method
-(void)notifyWeightLog:(NSString*)str
{
        selectedIndexPathNormal=-1000000;
    selectedIndexPathNormalPrev=selectedIndexPathNormal;

    NSArray *itemArr=[[NSString stringWithFormat:@"%@",self.selectedRow ]componentsSeparatedByString:@"#"];
    NSLog(@"selected row is===%@",itemArr );
    foodIdToEdit=[itemArr objectAtIndex:1];
    if([[self chkNullInputinitWithString:foodIdToEdit] isEqualToString:@""]){
        FoodLog *obj=[FoodLog new];
        int row=[obj getMaxFoodID:selectedUserProfileID];
        foodIdToEdit=[NSString stringWithFormat:@"%d",row];
    }
    
    float originalCalVal=0.0,originalWeightVal=0.0,originalCalWeightVal=0.0,finalCal=0.0;
    NSMutableArray * arrAllFoodLog=[masterFoodObj getAllFoodLog];
    for(int i=0;i<arrAllFoodLog.count;i++)
    {
        if([[[arrAllFoodLog objectAtIndex:i]objectForKey:@"searchID"] isEqualToString:[[_selectedFoodArr objectAtIndex:[[itemArr objectAtIndex:0] integerValue]] objectForKey:@"item"]])
        {
            finalCal=[[[arrAllFoodLog objectAtIndex:i]objectForKey:@"gm_calorie"] floatValue]*[str floatValue];
          //  originalCalVal=[[[arrAllFoodLog objectAtIndex:i]objectForKey:@"cals"] intValue];
         //   originalWeightVal=[[[arrAllFoodLog objectAtIndex:i]objectForKey:@"item_weight"] intValue];
        }
    }

  /*  if (originalCalVal!=0 && originalWeightVal!=0)
    {
        originalCalWeightVal=originalCalVal/originalWeightVal;
        finalCal=[str floatValue]*originalCalWeightVal;
    }*/
    
    NSLog(@"finalCal==finalCal%f",finalCal);
    NSLog(@"weight===%@",str);
    if(selectedTableTag==MEALSUBCATEGORY_TABLE_TAG){
        if ([[_selectedFoodArr objectAtIndex:[[itemArr objectAtIndex:0] intValue]] isKindOfClass:[NSDictionary class]]){
            
            NSMutableDictionary *oldDict = [[NSMutableDictionary alloc] initWithDictionary:[_selectedFoodArr objectAtIndex:[[itemArr objectAtIndex:0] integerValue]]];
            [oldDict  setValue:str forKey:@"item_weight"];
            [oldDict  setValue:[NSString stringWithFormat:@"%.1f",finalCal] forKey:@"cals"];
            
            NSMutableArray *arrTemp = [[NSMutableArray alloc] initWithArray:_selectedFoodArr];
            [arrTemp replaceObjectAtIndex:[self.selectedRow integerValue] withObject:oldDict];
            
            _selectedFoodArr = [[NSMutableArray alloc] initWithArray:arrTemp];
            //[ _tblVw reloadData];
            
         //   if([self.previous_activity isEqualToString:@"RadialTapp"] || selectedButton==1 || selectedButton==2){
                NSLog(@"self.selectedMealTypeId==%@",self.selectedMealTypeId);
 
            [foodLogObject updateWeightLog:str withCalVal:[NSString stringWithFormat:@"%.1f",finalCal] foodID:foodIdToEdit  withUserProfileID:selectedUserProfileID];
                
           // }
            
        }
    }
    
    if([self.previous_activity isEqualToString:@"NotificationTapped"])
    {
        [foodLogObject updateWeightLog:str withCalVal:[NSString stringWithFormat:@"%.1f",finalCal] foodID:foodIdToEdit  withUserProfileID:selectedUserProfileID];

        _selectedFoodArr=[foodLogObject getAllLunchLog:self.selectedMealTypeId  withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
        
        FavFoodVCount=0;
        if([_selectedFoodArr count]>0)
        {
            for(int i=0;i<_selectedFoodArr.count;i++)
            {
                if([[[_selectedFoodArr objectAtIndex:i] objectForKey:@"isFavMeal"] isEqualToString:@"1"])
                {
                    FavFoodVCount++;
                }
            }
            if(FavFoodVCount==_selectedFoodArr.count)
            {
                [_btnTotalFav setImage:[UIImage imageNamed:@"green-star@3x.png"] forState:UIControlStateNormal];
            }
            else
            {
                [_btnTotalFav setImage:[UIImage imageNamed:@"green-star@3x_outline.png"] forState:UIControlStateNormal];
            }
            
            _tblVw.tag=MEALSUBCATEGORY_TABLE_TAG;
            _tblVw.hidden=NO;
            _tblVw.delegate=self;
            _tblVw.dataSource=self;
            [_tblVw reloadData];
            
            //[self performSelector:@selector(selfCalculateTotalSubCategoryMeal) withObject:nil afterDelay:3.0];
        }
        else
        {
            FavFoodVCount=0;
            [_btnTotalFav setImage:[UIImage imageNamed:@"green-star@3x_outline.png"] forState:UIControlStateNormal];
            _tblVw.hidden=YES;
        }
    }
    
    
    if([self.previous_activity isEqualToString:@"FromPlanner"]||[self.previous_activity isEqualToString:@"newPlanner"])
    {
        if([_selectedFoodArr count]>0)
        {
            _tblVw.tag=MEALSUBCATEGORY_TABLE_TAG;
            _tblVw.hidden=NO;
            _tblVw.delegate=self;
            _tblVw.dataSource=self;
            [_tblVw reloadData];
            
            //[self performSelector:@selector(selfCalculateTotalSubCategoryMeal) withObject:nil afterDelay:3.0];
        }
        
    }
    else
    {
        
     _selectedFoodArr=[foodLogObject getAllLunchLog:self.selectedMealTypeId  withSelectedDate:logTimeStr withUserId:selectedUserProfileID];
    
    FavFoodVCount=0;
    if([_selectedFoodArr count]>0)
    {
        for(int i=0;i<_selectedFoodArr.count;i++)
        {
            if([[[_selectedFoodArr objectAtIndex:i] objectForKey:@"isFavMeal"] isEqualToString:@"1"])
            {
                FavFoodVCount++;
            }
        }
        if(FavFoodVCount==_selectedFoodArr.count)
        {
            [_btnTotalFav setImage:[UIImage imageNamed:@"green-star@3x.png"] forState:UIControlStateNormal];
        }
        else
        {
            [_btnTotalFav setImage:[UIImage imageNamed:@"green-star@3x_outline.png"] forState:UIControlStateNormal];
        }
        
        _tblVw.tag=MEALSUBCATEGORY_TABLE_TAG;
        _tblVw.hidden=NO;
        _tblVw.delegate=self;
        _tblVw.dataSource=self;
        [_tblVw reloadData];
        
        //[self performSelector:@selector(selfCalculateTotalSubCategoryMeal) withObject:nil afterDelay:3.0];
    }
    else
    {
        FavFoodVCount=0;
        [_btnTotalFav setImage:[UIImage imageNamed:@"green-star@3x_outline.png"] forState:UIControlStateNormal];
        _tblVw.hidden=YES;
    }
  }

    [self refreshViewDropdownView];
    [self getTotalCal];
}
-(void)selfCalculateTotalSubCategoryMeal
{
    NSString *totalcalMealSub=[NSString stringWithFormat:@"%d",totalCalMealSub];
    
    NSMutableAttributedString *mediumAttrString = [[NSMutableAttributedString alloc] initWithString:totalcalMealSub attributes: _attributedTotDict];
    [mediumAttrString appendAttributedString:_LightAttrStringCAL];
    _lblBottomTotalCal.attributedText=mediumAttrString;
}
@end