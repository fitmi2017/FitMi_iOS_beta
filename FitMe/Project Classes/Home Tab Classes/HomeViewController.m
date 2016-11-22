//
//  HomeViewController.m
//  FitMe
//
//  Created by Debasish on 27/07/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import "HomeViewController.h"
#import "DateUpperCustomView.h"
#import "HomeTableViewCell.h"
#import "FoodLogViewController.h"
#import "WaterViewController.h"
#import "SettingsViewController.h"
#import "DejalActivityView.h"
#import "Utility.h"
#import "AWCollectionViewDialLayout.h"
#import "UserCalDetails.h"
#import "FoodLog.h"
#import "ExerciseLog.h"
#import "AppDelegate.h"
#import "WaterLog.h"
#import "SleepLog.h"
#import "WeightLog.h"
#import "BPLog.h"
#import "CalorieIntakeViewController.h"
#import "UnitsLog.h"

@interface HomeViewController ()
{
    Devicefamily family;
    DateUpperCustomView* mDateUpperCustomView;
    NSMutableArray *arrLeftLblVal,*arrMiddleLblVal,*arrRightSubVwHeight,*arrRightSubVwBPHeight,*arrImages;
    NSArray *radialArrItemsFood,*radialArrItemsActivity,*radialArrItemsWeight;
    User *mUser;
    
    NSMutableDictionary *thumbnailCache;
    AWCollectionViewDialLayout *dialLayout;

    int PlusBtnTag;
    
    NSUserDefaults *defaults;
     NSString *selectedUserProfileID;
    FoodLog *foodLogObj;
    ExerciseLog *exerciseLogObj;
    WaterLog *waterLogObj;
    WeightLog *weightLogObj;
    SleepLog *sleepLogObj;
    BPLog *bpLogObj;
    UnitsLog *unitsLogObj;
    UserCalDetails *userCalObj;
 }

@end

static NSString *cellId = @"cellId";

@implementation HomeViewController

#pragma mark - UIView LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setCurrentControllerNavigation];

    foodLogObj=[[FoodLog alloc]init];
    exerciseLogObj=[[ExerciseLog alloc]init];
    waterLogObj=[[WaterLog alloc]init];
    weightLogObj=[[WeightLog alloc]init];
    sleepLogObj=[[SleepLog alloc]init];
    bpLogObj=[[BPLog alloc]init];
    userCalObj=[[UserCalDetails alloc]init];

    [_radialCollectionVw setHidden:YES];
    
    defaults=[NSUserDefaults standardUserDefaults];
    selectedUserProfileID=[defaults valueForKey:@"selectedUserProfileID"];

    PlusBtnTag=-100;
    
    mUser = [[Utility sharedManager] retriveUserDetailsFromDefault];
  
    [self createHomeNavigationView:@"fitmi"];
    
    arrImages= [[NSMutableArray alloc] initWithObjects:@"foodlog_new",@"Water_white@3x.png",nil];
   
    radialArrItemsFood=[[NSArray alloc]initWithObjects:[[NSDictionary alloc]initWithObjectsAndKeys:@"1",@"name",@"breakfast_small.png",@"picture", nil],[[NSDictionary alloc]initWithObjectsAndKeys:@"2",@"name",@"lunch_small.png",@"picture", nil],[[NSDictionary alloc]initWithObjectsAndKeys:@"3",@"name",@"dinner_new.png",@"picture", nil],[[NSDictionary alloc]initWithObjectsAndKeys:@"4",@"name",@"snack_new.png",@"picture", nil],nil];
    
    
    [_radialCollectionVw registerNib:[UINib nibWithNibName:@"dialCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellId];

}

- (void)setCurrentControllerNavigation {
    APP_CTRL.CurrentControllerObj = self;
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.homeNavigation=self.navigationController;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setCurrentControllerNavigation];
    defaults=[NSUserDefaults standardUserDefaults];
    selectedUserProfileID=[defaults valueForKey:@"selectedUserProfileID"];
    
    /* if([self isNetworkAvailable]==NO){
     [self createAlertView:@"Alert" withAlertMessage:ConnectionUnavailable withAlertTag:3];
     }
     else
     {*/
    //[self getHomeDataServerConnection];
    [self getHomeDataLocalDB];
    //}
    
    if(mDateUpperCustomView)
    {
        [mDateUpperCustomView removeFromSuperview];
        [self hideCal];
    }
    
    NSArray * allTheViewsInMyNIB = [[NSBundle mainBundle] loadNibNamed:[self getNibName:@"DateUpperCustomView"] owner:self options:nil];
    mDateUpperCustomView = allTheViewsInMyNIB[0];
    mDateUpperCustomView.delegate=self;
    mDateUpperCustomView.frame = CGRectMake(0,0,self.view.frame.size.width,110);
    [self.view addSubview:mDateUpperCustomView];
    [mDateUpperCustomView.btnDate_Home setSelected:YES];
    [mDateUpperCustomView click_dateButton:nil];
    if (arrMiddleLblVal.count == 6) {
        [arrMiddleLblVal removeObjectAtIndex:1];
        [arrMiddleLblVal removeObjectAtIndex:2];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    [_radialCollectionVw setHidden:YES];
    PlusBtnTag=-100;
    [_tblVw reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UINavigation Button Action
-(void)showLeft
{
    SettingsViewController *mVerificationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    mVerificationViewController.navClass=@"settings";
    [self.navigationController pushViewController:mVerificationViewController animated:YES];
}
-(void)showRight
{
    SettingsViewController *mVerificationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    mVerificationViewController.navClass=@"settings";
    [self.navigationController pushViewController:mVerificationViewController animated:YES];
}

#pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView
 willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
      return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     return 140;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeTableViewCell *cell=nil;

    NSArray *nib=nil;
    nib=[[ NSBundle  mainBundle]loadNibNamed:@"HomeTableViewCell" owner:self options:nil];

   
    cell=(HomeTableViewCell*)[nib objectAtIndex:0];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if(PlusBtnTag<0)
    {
    }
    else
    {
        if(PlusBtnTag-1==0)
        {
            cell.vwBlur.hidden=YES;
        }
        else
        {
            cell.vwBlur.hidden=NO;
        }
    }
    
    NSNumber *num =[arrRightSubVwHeight objectAtIndex:indexPath.row];
    float height = [num floatValue];
    
    cell.vwSubRightHeightConstraint.constant=height;
    [cell.vwSubRight layoutIfNeeded];
    
    cell.lblLeft.text=[arrLeftLblVal objectAtIndex:indexPath.row];
    cell.lblLeft.adjustsFontSizeToFitWidth=YES;
    cell.lblLeft.minimumScaleFactor=0.6;
    
    if ([ cell.lblMiddle respondsToSelector:@selector(setAttributedText:)])
    {
        
        NSArray *valuesSeparatedByComma =[[arrMiddleLblVal objectAtIndex:indexPath.row]componentsSeparatedByString:@","];
        NSMutableAttributedString *mediumAttrString = [[NSMutableAttributedString alloc] init];
        for (int i=0;i<valuesSeparatedByComma.count;i++) {
            NSMutableArray *valuesSeaparatedBySpace = [[NSMutableArray alloc] initWithArray:[valuesSeparatedByComma[i] componentsSeparatedByString:@" "]];
            
            for (int m =0;m<valuesSeaparatedBySpace.count;m++) {
                if ([valuesSeaparatedBySpace[m] isEqualToString:@""]) {
                    [valuesSeaparatedBySpace removeObjectAtIndex:m];
                }
            }
            
            for (int j=0;j<valuesSeaparatedBySpace.count;j++) {
                
                UIFont *mediumFont1;
                if (j%2 == 0) {
                    mediumFont1= [UIFont fontWithName:@"SinkinSans-200XLight" size:50.0f];
                }
                else {
                    mediumFont1 = [UIFont fontWithName:@"SinkinSans-200XLight" size:25.0f];
                }
                
                family=thisDeviceFamily();
                if(family == iPad){
                }
                else{
                    if([self isIphoneSixPlus])
                    {
                        if (j%2 == 0) {
                            mediumFont1= [UIFont fontWithName:@"SinkinSans-200XLight" size:55.0f];
                        }
                        else {
                            mediumFont1 = [UIFont fontWithName:@"SinkinSans-200XLight" size:28.0f];
                        }
                        
                    }
                }
                
                NSDictionary *mediumDict1 = [NSDictionary dictionaryWithObject: mediumFont1 forKey:NSFontAttributeName];
                NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:valuesSeaparatedBySpace[j] attributes:mediumDict1];
                [mediumAttrString appendAttributedString:attrString];
                NSAttributedString *space_String = [[NSAttributedString alloc] initWithString:@" " attributes:mediumDict1];
                [mediumAttrString appendAttributedString:space_String];
            }
           
        }
        cell.lblMiddle.attributedText = mediumAttrString;
        
        
    }
    else
    {
        [ cell.lblMiddle setText:[arrMiddleLblVal objectAtIndex:indexPath.row]];
    }
    
    //For FoodLog Section
    if(indexPath.row==0)
    {
        cell.vwLeft.backgroundColor=[UIColor colorWithRed:0.0/255.0f green:143.0/255.0f blue:74.0/255.0f alpha:1.0f];
        cell.vwSubRight.backgroundColor=[UIColor colorWithRed:0.0/255.0f green:143.0/255.0f blue:74.0/255.0f alpha:1.0f];
        cell.vwRight.backgroundColor=[UIColor colorWithRed:153.0/255.0f green:209.0/255.0f blue:183.0/255.0f alpha:1.0f];
        // cell.vwSubRight.frame=CGRectMake(cell.vwSubRight.frame.origin.x, cell.vwSubRight.frame.origin.y, cell.vwRight.frame.size.width, height);
        cell.btnPlus.hidden=NO;
        
        cell.btnSideBar.hidden=NO;
        [cell.btnSideBar addTarget:self action:@selector(clickSideBar:) forControlEvents:UIControlEventTouchDown];
        cell.btnSubSideBar.hidden=NO;
        [cell.btnSubSideBar addTarget:self action:@selector(clickSideBar:) forControlEvents:UIControlEventTouchDown];
        
    }
    
    //For WaterLog Section
    else  if(indexPath.row==1) //indexPath.row==4
    {
        cell.vwLeft.backgroundColor=[UIColor colorWithRed:18.0/255.0f green:64.0/255.0f blue:89.0/255.0f alpha:1.0f];
        cell.vwSubRight.backgroundColor=[UIColor colorWithRed:18.0/255.0f green:64.0/255.0f blue:89.0/255.0f alpha:1.0f];
        cell.vwRight.backgroundColor=[UIColor colorWithRed:160.0/255.0f green:181.0/255.0f blue:189.0/255.0f alpha:1.0f];
        //  cell.vwSubRight.frame=CGRectMake(cell.vwSubRight.frame.origin.x, cell.vwSubRight.frame.origin.y, cell.vwSubRight.frame.size.width, height);
        cell.lblMiddle.hidden=NO;
        cell.lblMiddle1.hidden=YES;
        cell.lblMiddle2.hidden=YES;
        cell.btnPlus.hidden=YES;
        
        cell.btnSideBar.hidden=YES;
        cell.btnSubSideBar.hidden=YES;
    }
    
    cell.lblMiddle.adjustsFontSizeToFitWidth=YES;
    cell.lblMiddle.minimumScaleFactor=0.6;
    
    if (indexPath.row == 0) {
        [cell.btnPlus addTarget:self action:@selector(callDialVw:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnPlus.tag=indexPath.row+1;
    }
    
    
    [cell.imgVwLeftIcon setImage:[UIImage imageNamed:[arrImages objectAtIndex:indexPath.row]]];
    cell.imgVwLeftIcon.contentMode = UIViewContentModeScaleAspectFit;
    
    if(indexPath.row ==0)
    {
        UIImageView *line = [[UIImageView alloc] init];
        
        family = thisDeviceFamily();
        if (family == iPad)
            line.frame=CGRectMake(0, 0, 768, 1);
        else
            line.frame=CGRectMake(0, 0, 600, 1);
        
        line.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
        [cell addSubview:line];
    }
    
    if(PlusBtnTag<0)
    {
    }
    else
    {
        if (indexPath.row==0)
        {
            [cell.btnPlus setTitleColor:[UIColor colorWithRed:0.0/255.0f green:143.0/255.0f blue:74.0/255.0f alpha:1.0f] forState:UIControlStateNormal];
        }
        
        family = thisDeviceFamily();
        if (family == iPad)
            [cell.btnPlus.titleLabel setFont:[UIFont systemFontOfSize:25.0f]];
        else
            [cell.btnPlus.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
    }
   
 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //For FoodLog Section
    if(indexPath.row==0)
    {
        FoodLogViewController *mVerificationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FoodLogViewController"];
        mVerificationViewController.previous_activity=@"rowTapped";
         [self.navigationController pushViewController:mVerificationViewController animated:YES];
    }
     //For WaterLog Section
    else  if(indexPath.row==1)
    {
        WaterViewController *mVerificationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WaterViewController"];
        [self.navigationController pushViewController:mVerificationViewController animated:YES];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - Click on RightSide Bar Button Action
-(void)clickSideBar:(UIButton*)sender
{
    CalorieIntakeViewController *catloryIntake = [self.storyboard instantiateViewControllerWithIdentifier:@"CalorieIntakeViewController"];
    catloryIntake.previousNav=@"fitmi";
    [self.navigationController pushViewController:catloryIntake animated:YES];
}

#pragma mark - getHomeDataServerConnection Method
-(void)getHomeDataServerConnection
{
    NSString * timestamp = TimeStamp;
    self.view.userInteractionEnabled = NO;
    [DejalBezelActivityView activityViewForView:self.view];
    [[ServerConnection sharedInstance] setDelegate:self];
    [[ServerConnection sharedInstance] getHomeData:mUser.useraccess_key Timestamp:timestamp];
}

#pragma mark - Server Connection Delegate
-(void)requestDidFinished:(id)result
{
    self.view.userInteractionEnabled = YES;
    [DejalBezelActivityView removeViewAnimated:YES];
    
    if ([result isKindOfClass:[NSError class]])
    {
        NSError *error=(NSError *)result;
        [self createAlertView:@"Mesupro" withAlertMessage:error.localizedDescription withAlertTag:0];
        
        return;
    }
    if ([result isKindOfClass:[NSDictionary class]]){
        NSDictionary *dict = (NSDictionary *)result;
        if([[dict valueForKey:@"status"] isEqualToString:@"false"])
        {
            [self createAlertView:@"Mesupro" withAlertMessage:[dict valueForKey:@"message"] withAlertTag:0];
        }
        else{
            arrLeftLblVal= [[NSMutableArray alloc] init];
            arrMiddleLblVal= [[NSMutableArray alloc] init];
            
             if([[[dict valueForKey:@"system_info"] valueForKey:@"logged_in"]intValue]==1)
             {
                 if(![[[dict valueForKey:@"result"] valueForKey:@"intake"] isKindOfClass:[NSNull class]])
                 {
                     [arrLeftLblVal addObject:[[dict valueForKey:@"result"] valueForKey:@"intake"]];
                     [arrMiddleLblVal addObject:[[dict valueForKey:@"result"] valueForKey:@"intake"]];
                 }
                 else
                 {
                     [arrLeftLblVal addObject:@"0 cal"];
                     [arrMiddleLblVal addObject:@"0  cal"];
                 }
                 
                 if(![[[dict valueForKey:@"result"] valueForKey:@"burn"] isKindOfClass:[NSNull class]])
                 {
                     [arrLeftLblVal addObject:[[dict valueForKey:@"result"] valueForKey:@"burn"]];
                     [arrMiddleLblVal addObject:[[dict valueForKey:@"result"] valueForKey:@"burn"]];
                 }
                 else
                 {
                     [arrLeftLblVal addObject:@"0 cal"];
                     [arrMiddleLblVal addObject:@"0  cal"];
                 }
                 
                 if(![[[dict valueForKey:@"result"] valueForKey:@"weight"] isKindOfClass:[NSNull class]])
                 {
                     [arrLeftLblVal addObject:[[dict valueForKey:@"result"] valueForKey:@"weight"]];
                     [arrMiddleLblVal addObject:[[dict valueForKey:@"result"] valueForKey:@"weight"]];
                 }
                 else
                 {
                     [arrLeftLblVal addObject:@"0 lb"];
                     [arrMiddleLblVal addObject:@"0  lb"];
                 }
                 
                 
                 [arrLeftLblVal addObject:@"Normal"];
                 [arrLeftLblVal addObject:@"0 hr"];
                 [arrLeftLblVal addObject:@"0 cups"];
  
                 [arrMiddleLblVal addObject:@"120  sys,80  dia"];
                 [arrMiddleLblVal addObject:@"0  hr"];
                 [arrMiddleLblVal addObject:@"0  oz"];
             }
           else
           {
               [arrLeftLblVal addObject:@"0 cal"];
               [arrMiddleLblVal addObject:@"0  cal"];
               [arrLeftLblVal addObject:@"0 cal"];
               [arrMiddleLblVal addObject:@"0  cal"];
               [arrLeftLblVal addObject:@"0 lb"];
               [arrMiddleLblVal addObject:@"0  lb"];
               [arrLeftLblVal addObject:@"Normal"];
               [arrLeftLblVal addObject:@"0 hr"];
               [arrLeftLblVal addObject:@"0 cups"];
               
               [arrMiddleLblVal addObject:@"120  sys,80  dia"];
               [arrMiddleLblVal addObject:@"0  hr"];
               [arrMiddleLblVal addObject:@"0  oz"];

           }
 
            _tblVw.delegate=self;
            _tblVw.dataSource=self;
            [_tblVw reloadData];
        }
    }
}

#pragma mark - UITouch Delegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideCal];
}

#pragma mark - hideCalender Method
-(void)hideCal
{
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

#pragma mark - CollectionView Delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(PlusBtnTag==1)
    {
        return radialArrItemsFood.count;
    }
   
    return 0;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    cell = [cv dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    NSDictionary *item;
    NSString *imgURL;
    
    if(PlusBtnTag==1)
    {
        item = [radialArrItemsFood objectAtIndex:indexPath.item];
        imgURL = [item valueForKey:@"picture"];
    }
 
    UIImageView *imgView = (UIImageView*)[cell viewWithTag:100];
    UIView *imgParentView = (UIView*)[cell viewWithTag:200];

        //imgView.tag=indexPath.row+1;
        [imgView setImage:nil];
        __block UIImage *imageProduct = [thumbnailCache objectForKey:imgURL];
        if(imageProduct){
            imgView.image = imageProduct;
           
            if(PlusBtnTag==1)
            {
            imgView.backgroundColor=[UIColor colorWithRed:0.0/255.0f green:143.0/255.0f blue:74.0/255.0f alpha:1.0f];
            imgParentView.backgroundColor=[UIColor colorWithRed:0.0/255.0f green:143.0/255.0f blue:74.0/255.0f alpha:1.0f];
            }
           
        }
        else{
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue, ^{
                UIImage *image = [UIImage imageNamed:imgURL];
                dispatch_async(dispatch_get_main_queue(), ^{
                    imgView.image = image;
                    imgView.contentMode = UIViewContentModeScaleAspectFit;
                    [thumbnailCache setValue:image forKey:imgURL];
                  //  imgView.layer.cornerRadius=35.0f;
                    if(PlusBtnTag==1)
                    {
                        imgView.backgroundColor=[UIColor colorWithRed:0.0/255.0f green:143.0/255.0f blue:74.0/255.0f alpha:1.0f];
                        imgParentView.backgroundColor=[UIColor colorWithRed:0.0/255.0f green:143.0/255.0f blue:74.0/255.0f alpha:1.0f];
                    }
                    
                });
            });
        }
    
     //imgView.layer.cornerRadius=35.0f;
    
    
    imgParentView.layer.cornerRadius=imgParentView.bounds.size.width/2;
    imgView.layer.cornerRadius=imgView.bounds.size.width/2;
   /// NSLog(@"%@)
    imgView.layer.masksToBounds=YES;
    imgParentView.layer.masksToBounds=YES;

    UITapGestureRecognizer *recognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction1:)];
    [recognizer1 setNumberOfTapsRequired:1];
    
    [imgView addGestureRecognizer:recognizer1];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didEndDisplayingCell:%i", (int)indexPath.item);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 80);
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0 , 0, 0, 0);
}

#pragma mark - "+" Button Action
-(void)callDialVw:(UIButton*)sender
{
    NSLog(@"TAG==%ld",(long)sender.tag);
    PlusBtnTag=(int)sender.tag;
    
    [_radialCollectionVw reloadData];
    [_radialCollectionVw setHidden:NO];
    
    CGFloat cellHeight=sender.superview.superview.frame.size.height;
    CGFloat radius = 30;
    CGFloat angularSpacing = 0.16 * 90;
    CGFloat xOffset = .23 * 320;
    
    CGFloat cell_width = 80;
    CGFloat cell_height = 80;
    CGPoint buttonCenter = CGPointMake(sender.bounds.origin.x + sender.bounds.size.width/2,
                                       sender.bounds.origin.y + sender.bounds.size.height/2);
    CGPoint p = [sender convertPoint:buttonCenter toView:self.view];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [recognizer setNumberOfTapsRequired:1];
    
    _radialCollectionVw.delegate=self;
    _radialCollectionVw.dataSource=self;
    [_radialCollectionVw addGestureRecognizer:recognizer];

    dialLayout = [[AWCollectionViewDialLayout alloc] initWithRadius:radius andAngularSpacing:angularSpacing andCellSize:CGSizeMake(cell_width, cell_height) andAlignment:WHEELALIGNMENTCENTER andItemHeight:cell_height andXOffset:xOffset currentYPosition:p.y-(cellHeight/2+35)];
    
     [self switchExample];
    [_radialCollectionVw setCollectionViewLayout:dialLayout];
   
    [_tblVw reloadData];
}

#pragma mark - Tap to Open on Dial CellView Gesture Method
-(void)tapAction1:(UITapGestureRecognizer*)sender{
    
    NSLog(@"===%@",sender.view.superview.superview.superview.superview);
    UICollectionViewCell *cell=(UICollectionViewCell*)sender.view.superview.superview.superview.superview;
   NSIndexPath *path=[_radialCollectionVw indexPathForCell:cell];
    
    //For FoodLog Section
    if(PlusBtnTag==1)
     {
        FoodLogViewController *mVerificationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FoodLogViewController"];
         mVerificationViewController.previous_activity=@"RadialTapp";
 
    if(path.item==0)
        mVerificationViewController.selected_session=@"Breakfast";
    else if (path.item==1)
        mVerificationViewController.selected_session=@"Lunch";
    else if (path.item==2)
        mVerificationViewController.selected_session=@"Dinner";
    else
        mVerificationViewController.selected_session=@"Snack";
         
        [self.navigationController pushViewController:mVerificationViewController animated:YES];
     }
    NSLog(@"Image Tapped=====%ld",(long)path.item);
}

#pragma mark - Tap to Close on Dial CellView Gesture Method
-(void)tapAction:(UITapGestureRecognizer*)sender
{
    NSLog(@"Hide collection view=====");
    [_radialCollectionVw setHidden:YES];
    PlusBtnTag=-100;
    [_tblVw reloadData];
}

#pragma mark - Dial CellView Method
-(void)switchExample
{
    CGFloat radius = 0 ,angularSpacing  = 0, xOffset = 0;
    
    [dialLayout setCellSize:CGSizeMake(100, 100)];
    [dialLayout setWheelType:WHEELALIGNMENTLEFT];
    
    radius = -110;
    angularSpacing = 45;
    if([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone){
       if([[UIScreen mainScreen]bounds].size.height > 568)
         xOffset = 240;
       else
         xOffset = 190;
     }
    else{
    
       xOffset = 650;
    }
    [dialLayout setDialRadius:radius];
    [dialLayout setAngularSpacing:angularSpacing];
    [dialLayout setXOffset:xOffset];
    
    // [_radialCollectionVw reloadData];
}

#pragma mark - getHomeDataLocalDB Method
-(void)getHomeDataLocalDB
{
      dispatch_queue_t queue = dispatch_get_global_queue(
                                                       DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        //  NSDate *now = [[NSDate alloc] init];
        //NSString *dateString = [format stringFromDate:now];
        
        //NSString *dateString =[[Utility sharedManager]getSelectedDateFormat];
        NSString *selectedWeight=@"";
        
        unitsLogObj=[[UnitsLog alloc]init];
        
        NSMutableArray *arrUnitsLog=[unitsLogObj getAllUnitDataLog:[defaults valueForKey:@"selectedUserProfileID"]];
        
        if(arrUnitsLog.count>0)
        {
            for(int i=0;i<arrUnitsLog.count;i++)
            {
                NSDictionary *dict=[arrUnitsLog objectAtIndex:i];
                if([[dict objectForKey:@"type"] isEqualToString:@"weight"])
                {
                    selectedWeight=[unitsLogObj getUnitType:[dict objectForKey:@"unit_id"] withUnitCategory:@"weight"];
                }
            }
        }
        else
        {
            selectedWeight=@"lbs";
        }

        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        formatter1.dateFormat = @"EEEE, MMMM dd, yyyy";
        NSDate *dateFromString = [formatter1 dateFromString:[[Utility sharedManager] getSelectedDate]];
        NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString= [dateFormatter2 stringFromDate:dateFromString];
    
        int breakfastCal=0;
        NSMutableArray *breakfastMealArr=[foodLogObj getAllLunchLog:@"1" withSelectedDate:dateString withUserId:selectedUserProfileID];
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
        NSMutableArray *lunchMealArr=[foodLogObj getAllLunchLog:@"2" withSelectedDate:dateString withUserId:selectedUserProfileID];
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
        NSMutableArray *dinnerMealArr=[foodLogObj getAllLunchLog:@"3" withSelectedDate:dateString withUserId:selectedUserProfileID];
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
        NSMutableArray *snacksMealArr=[foodLogObj getAllLunchLog:@"4" withSelectedDate:dateString withUserId:selectedUserProfileID];
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
        
        int sumFoodLog=0;
        sumFoodLog=breakfastCal+lunchCal+dinnerCal+snacksCal;
        
     
        
        int sumexerciseLog= [exerciseLogObj getActivitySumBurned:dateString todate:dateString withUserProfileID:selectedUserProfileID];
        
        float sumWaterLog=[waterLogObj getWaterSumBurned:dateString todate:dateString withUserProfileID:selectedUserProfileID];
        
        int sumWaterCup=0;
        float sumWaterOz=0.0;
        if(sumWaterLog>=8.0)
        {
            sumWaterCup=sumWaterLog/8.0;
            sumWaterOz=fmodf(sumWaterLog,8.0f);
        }
        else
        {
            sumWaterCup=0;
            sumWaterOz=fmodf(sumWaterLog,8.0f);
        }
        
        int aWeightLog;
        
        if([selectedWeight isEqualToString:@"lbs"])
        {
            aWeightLog=[self weightKGtoLB:[weightLogObj getWeight:dateString todate:dateString withUserProfileID:selectedUserProfileID]];
        }
        else
        {
            
        aWeightLog=[weightLogObj getWeight:dateString todate:dateString withUserProfileID:selectedUserProfileID];

        }
        
        
        int sumSleepLog=[sleepLogObj getSleepSumBurned:dateString todate:dateString withUserProfileID:selectedUserProfileID];
        
        int aBPSysLog=[[[bpLogObj getBP:dateString todate:dateString withUserProfileID:selectedUserProfileID]valueForKey:@"sys"]intValue];
        int aBPDiaLog=[[[bpLogObj getBP:dateString todate:dateString withUserProfileID:selectedUserProfileID]valueForKey:@"dia"]intValue];
        
        NSMutableArray *usersCalArr=[userCalObj getUserCalorieDetails:selectedUserProfileID];
        
        arrLeftLblVal= [[NSMutableArray alloc] init];
        arrMiddleLblVal= [[NSMutableArray alloc] init];
        
        if(usersCalArr.count>0)
        {
            userCalObj=[usersCalArr objectAtIndex:0];
            
            [arrLeftLblVal addObject:[NSString stringWithFormat:@"%@ cal",userCalObj.total_intake]];
            [arrLeftLblVal addObject:userCalObj.water];
            
            [arrMiddleLblVal addObject:[NSString stringWithFormat:@"%d  cal",sumFoodLog]];
            [arrMiddleLblVal addObject:[NSString stringWithFormat:@"%d  cups  %.1f  oz",sumWaterCup,sumWaterOz]];
            
            float IntakeValPercent=0.0f;
            float IntakeValHeight=0.0f;
            if(sumFoodLog<[userCalObj.total_intake floatValue])
            {
                IntakeValPercent=((float)sumFoodLog/[userCalObj.total_intake floatValue])*100.0f;
            }
            else{
                IntakeValPercent=100.0f;
            }
            IntakeValHeight=(IntakeValPercent/100.0f)*140.0f;
            
            float ActivityValPercent=0.0f;
            float ActivityValHeight=0.0f;
            if(sumexerciseLog<[userCalObj.total_burned intValue])
            {
                ActivityValPercent=((float)sumexerciseLog/[userCalObj.total_burned floatValue])*100.0f;
            }
            else{
                ActivityValPercent=100.0f;
            }
            ActivityValHeight=(ActivityValPercent/100.0f)*140.0f;
            
            float WeightValPercent=0.0f;
            float WeightValHeight=0.0f;
            if(aWeightLog<[userCalObj.weight intValue])
            {
                WeightValPercent=((float)aWeightLog/[userCalObj.weight floatValue])*100.0f;
            }
            else{
                WeightValPercent=100.0f;
            }
            WeightValHeight=(WeightValPercent/100.0f)*140.0f;
           
            
            float BPSysValPercent=0.0f;
            float BPSysValHeight=0.0f;
            if(aBPSysLog<[userCalObj.bp_sys intValue])
            {
                BPSysValPercent=((float)aBPSysLog/[userCalObj.bp_sys floatValue])*100.0f;
            }
            else{
                BPSysValPercent=100.0f;
            }
            BPSysValHeight=(BPSysValPercent/100.0f)*69.0f;

            float BPDiaValPercent=0.0f;
            float BPDiaValHeight=0.0f;
            if(aBPDiaLog<[userCalObj.bp_dia intValue])
            {
                BPDiaValPercent=((float)aBPDiaLog/[userCalObj.bp_dia floatValue])*100.0f;
            }
            else{
                BPDiaValPercent=100.0f;
            }
            BPDiaValHeight=(BPDiaValPercent/100.0f)*69.0f;
            
            float SleepValPercent=0.0f;
            float SleepValHeight=0.0f;
            if(sumSleepLog<[userCalObj.sleep intValue])
            {
                SleepValPercent=((float)sumSleepLog/[userCalObj.sleep floatValue])*100.0f;
             }
            else{
                SleepValPercent=100.0f;
            }
            SleepValHeight=(SleepValPercent/100.0f)*140.0f;
            
            float WaterValPercent=0.0f;
            float WaterValHeight=0.0f;
            if(sumWaterLog<64.0f)
            {
                WaterValPercent=((float)sumWaterLog/64.0f)*100.0f;
            }
            else{
                WaterValPercent=100.0f;
            }
           WaterValHeight=(WaterValPercent/100.0f)*140.0f;
            
            arrRightSubVwHeight= [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithFloat:IntakeValHeight],[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:SleepValHeight],[NSNumber numberWithFloat:WaterValHeight],nil];
            
            arrRightSubVwBPHeight= [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithFloat:BPSysValHeight],[NSNumber numberWithFloat:BPDiaValHeight],nil];
         }
        else
        {
            
            [arrLeftLblVal addObject:@"0 cal"];
            [arrLeftLblVal addObject:@"0 cups"];
            
            [arrMiddleLblVal addObject:@"0  cal"];
            [arrMiddleLblVal addObject:@"0  cups  0  oz"];
            
            
            arrRightSubVwHeight= [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:0.0f],nil];
            
            arrRightSubVwBPHeight= [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.0],nil];

        }

        dispatch_async(dispatch_get_main_queue(), ^{
            
            _tblVw.delegate=self;
            _tblVw.dataSource=self;
            [_tblVw reloadData];

        });
    });
 
}

#pragma mark - Calender Notification Method
-(void)notifySelectedDate:(NSString *)dateStr
{
    [self getHomeDataLocalDB];
}
-(void)notifyDate:(NSString *)dateStr
{
    // NSLog(@"dateStr========%@",dateStr);
}
-(int)weightKGtoLB:(int)weight
{
    return weight*2.20462;
}
@end
