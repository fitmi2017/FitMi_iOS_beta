//
//  FoodLogViewController.h
//  FitMe
//
//  Created by Debasish on 12/08/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "NIDropDown.h"
#import "FoodLogPopUPViewController.h"
#import "ServerConnection.h"
#import "DateUpperCustomView.h"
#import "FoodLog.h"
#import "EditCalViewController.h"
#import "LogOtherFoodViewController.h"
#import "MealType.h"
#import "igViewController.h"
#import "EditWeightViewController.h"
@interface FoodLogViewController : BaseViewController<NIDropDownDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDelegate,UITableViewDataSource,FoodLogPopupDelegate,ServerConnectionDelegate,DateUpperCustomViewDelegate,editCalorieDelegate,editWeightDelegate,UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,bardelegate>
{
    
    __weak IBOutlet UIButton *btn1;
    __weak IBOutlet UIButton *btn2;
    
    __weak IBOutlet UIButton *btn3;
    
    __weak IBOutlet UIButton *btn4;
    __weak IBOutlet NSLayoutConstraint *dropdown_imgBtnWidth_Constant;
    __weak IBOutlet UIView *mymealView;
    NIDropDown *dropDown;
}

@property(nonatomic,assign)BOOL isBarCodeScanOpen,isSelectedFoodScaleItem,isKitchenScaleSync;
- (IBAction)btnAction1:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblTop1;
@property (strong, nonatomic) IBOutlet UIImageView *imgVwTop1;
@property (strong, nonatomic) IBOutlet UIImageView *imgVwTop2;
@property (strong, nonatomic) IBOutlet UILabel *lblTop2;
- (IBAction)btnAction2:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *imgVwTop3;
@property (strong, nonatomic) IBOutlet UILabel *lblTop3;
- (IBAction)btnAction3:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *imgVwTop4;
@property (strong, nonatomic) IBOutlet UILabel *lblTop4;
- (IBAction)btnAction4:(id)sender;

-(void)rel;
@property (strong, nonatomic) IBOutlet UILabel *lblBottomTotal;
@property (strong, nonatomic) IBOutlet UILabel *lblBottomTotalGram;
@property (strong, nonatomic) IBOutlet UILabel *lblBottomTotalCal;
@property (strong, nonatomic) IBOutlet UITableView *tblVw;
@property (weak, nonatomic) IBOutlet UIButton *btnTotalFav;

@property (strong, nonatomic) NSString *selected_session;
@property (strong, nonatomic) NSString *previous_activity;
- (IBAction)btnActionTotalFav:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnMTotal;
- (IBAction)btnActionMTotal:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnTTotal;
- (IBAction)btnActionTTotal:(id)sender;

@property (strong, nonatomic) NSMutableDictionary *selectedFoodDict;
@property (strong, nonatomic) NSMutableArray *selectedFoodDictArr;
@property (strong, nonatomic) NSMutableArray *recentSelectedFoodArr;
@property(nonatomic,strong) NSString *selectedRow;
- (IBAction)btnActionRecentFood:(id)sender;
- (IBAction)btnActionRecentMeals:(id)sender;

@property (strong, nonatomic) NSString *action_selected;
@property (strong, nonatomic) NSString *logTime;

@property (strong, nonatomic) NSMutableArray *recentFoodArray;
@property (strong, nonatomic) NSMutableArray *sessionArray;

@property(nonatomic,strong)NSString *connectType;
@property(nonatomic,strong)NSMutableArray *carryFromActivityArr;
@property(nonatomic,strong)NSString *carryMealTypeActivity;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomRecentTblVwConst;
@property(strong,nonatomic)NSString *selectedMealTypeId;
@property(strong,nonatomic)NSMutableArray *allSearchedFoodArr;

@property (weak, nonatomic) IBOutlet UIButton *btnBarCode;

//////////////
@property (nonatomic) BOOL isOpen;
@property (nonatomic) float meunHeight;
@property (nonatomic) float menuWidth;
@property (nonatomic) CGRect outFrame;
@property (nonatomic) CGRect inFrame;

@end
