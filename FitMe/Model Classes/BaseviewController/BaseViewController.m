//
//  BaseViewController.m
//  Write Right
//
//  Created by F9 Mac 2 on 25/06/13.
//  Copyright (c) 2013 Sourish Ghosh. All rights reserved.
//

#import "BaseViewController.h"
#import "JSON.h"
#import "SBJSON.h"
#import "Reachability.h"
@interface BaseViewController ()
{
    ConnectionModel *conModel;
}

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}
-(void) viewWillAppear:(BOOL)animated
{
     [self.presentingViewController beginAppearanceTransition:YES animated: animated];
}
-(void) viewDidAppear:(BOOL)animated
{
    [self.presentingViewController endAppearanceTransition];
}
-(void) viewWillDisappear:(BOOL)animated
{
    [self.presentingViewController beginAppearanceTransition: NO animated: animated];
}
-(void) viewDidDisappear:(BOOL)animated
{
    [self.presentingViewController endAppearanceTransition];
}

#pragma mark - Create NavigationView Method
-(void)createTitleNavigationView:(NSString*)strHeading
{
    for(UIView* view in self.navigationController.navigationBar.subviews)
    {
        if ([view isKindOfClass:[UILabel class]])
        {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UIButton class]])
        {
            [view removeFromSuperview];
        }
    }
    
    UILabel *lblHeading=[[UILabel alloc] initWithFrame:CGRectMake(60, 6, 160,32)];
    lblHeading.textAlignment=NSTextAlignmentCenter;
    lblHeading.text=strHeading;
    lblHeading.textColor=[UIColor whiteColor];
    lblHeading.font=[UIFont fontWithName:@"SinkinSans-300Light" size:24.0f];
    [lblHeading setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView=lblHeading;
}
#pragma mark - Create createHomeNavigationView Method
-(void)createHomeNavigationView:(NSString*)strHeading
{
    for(UIView* view in self.navigationController.navigationBar.subviews)
    {
        if ([view isKindOfClass:[UILabel class]])
        {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UIButton class]])
        {
            [view removeFromSuperview];
        }
    }
    
    UILabel *lblHeading=[[UILabel alloc] initWithFrame:CGRectMake(60, 6, 160,32)];
    lblHeading.textAlignment=NSTextAlignmentCenter;
    lblHeading.text=strHeading;
    lblHeading.textColor=[UIColor whiteColor];
    lblHeading.font=[UIFont fontWithName:@"SinkinSans-300Light" size:24.0f];
    [lblHeading setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView=lblHeading;
    
    UIButton *btnRight=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"Settings"];
    [btnRight setImage:image  forState:UIControlStateNormal ];
    [btnRight addTarget:self action:@selector(showRight) forControlEvents:UIControlEventTouchUpInside];
    //[btnRight setFrame:CGRectMake(0, 0, image.size.width, image.size.height) ];
   [btnRight setFrame:CGRectMake(0, 0, 22, 22) ];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnRight];

}

-(void)createHeaderView:(NSString*)strHeading
{
    for(UIView* view in self.navigationController.navigationBar.subviews)
    {
        if ([view isKindOfClass:[UILabel class]])
        {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UIButton class]])
        {
            [view removeFromSuperview];
        }
    }
    
    UILabel *lblHeading=[[UILabel alloc] initWithFrame:CGRectMake(60, 6, 160,32)];
    lblHeading.textAlignment=NSTextAlignmentCenter;
    lblHeading.text=strHeading;
    lblHeading.textColor=[UIColor whiteColor];
    lblHeading.font=[UIFont fontWithName:@"SinkinSans-300Light" size:24.0f];
    [lblHeading setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView=lblHeading;
    
}
#pragma mark - Create NavigationView Method
-(void)createNavigationView:(NSString*)strHeading
{
    for(UIView* view in self.navigationController.navigationBar.subviews)
    {
        if ([view isKindOfClass:[UILabel class]])
        {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UIButton class]])
        {
            [view removeFromSuperview];
        }
    }
    
    UIButton *btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setImage:[UIImage imageNamed:@"backArrow@3x"]  forState:UIControlStateNormal ];
    [btnLeft addTarget:self action:@selector(showLeft) forControlEvents:UIControlEventTouchUpInside];
    [btnLeft setFrame:CGRectMake(0, 0, 12, 20) ];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    
    UIButton *btnRight=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"Settings"];
    [btnRight setImage:image  forState:UIControlStateNormal ];
    [btnRight addTarget:self action:@selector(showRight) forControlEvents:UIControlEventTouchUpInside];
    //[btnRight setFrame:CGRectMake(0, 0, image.size.width, image.size.height) ];
    [btnRight setFrame:CGRectMake(0, 0, 22, 22) ];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnRight];

    UILabel *lblHeading=[[UILabel alloc] initWithFrame:CGRectMake(60, 6, 160,32)];
    lblHeading.textAlignment=NSTextAlignmentCenter;
    lblHeading.text=strHeading;
    lblHeading.textColor=[UIColor whiteColor];
    lblHeading.font=[UIFont fontWithName:@"SinkinSans-300Light" size:24.0f];
    [lblHeading setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView=lblHeading;
}

-(void)createNavigationSlideView:(NSString*)strHeading
{
    for(UIView* view in self.navigationController.navigationBar.subviews)
    {
        if ([view isKindOfClass:[UILabel class]])
        {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UIButton class]])
        {
            [view removeFromSuperview];
        }
    }
     
    for(UIView* view in self.navigationController.view.subviews)
    {
        if(view.tag == 100 )
        {
            [view removeFromSuperview];
        }
    }

    UIButton *btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setImage:[UIImage imageNamed:@"listing_icon.png"]  forState:UIControlStateNormal ];
    [btnLeft addTarget:self action:@selector(showLeft) forControlEvents:UIControlEventTouchUpInside];
    [btnLeft setFrame:CGRectMake(0, 0, 22, 12) ];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    
    UILabel *lblHeading=[[UILabel alloc] initWithFrame:CGRectMake(60, 6, 160,32)];
    lblHeading.textAlignment=NSTextAlignmentCenter;
    lblHeading.text=strHeading;
    lblHeading.textColor=[UIColor blackColor];
    lblHeading.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:20.0f];
    [lblHeading setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView=lblHeading;
  }

-(void)createNavigationSlideDetailView:(NSString*)strHeading
{
    for(UIView* view in self.navigationController.navigationBar.subviews)
    {
        if ([view isKindOfClass:[UILabel class]])
        {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UIButton class]])
        {
            [view removeFromSuperview];
        }
    }
    
    for(UIView* view in self.navigationController.view.subviews)
    {
        if(view.tag == 100 )
        {
            [view removeFromSuperview];
        }
    }
    
    UIButton *btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setImage:[UIImage imageNamed:@"listing_icon.png"]  forState:UIControlStateNormal ];
    [btnLeft addTarget:self action:@selector(showLeft) forControlEvents:UIControlEventTouchUpInside];
    [btnLeft setFrame:CGRectMake(0, 0, 22, 12) ];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    
    UIButton *btnRight=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnRight setImage:[UIImage imageNamed:@"btngoback.png"]  forState:UIControlStateNormal ];
    [btnRight addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [btnRight setFrame:CGRectMake(0, 0, 63, 28) ];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
  
    UILabel *lblHeading=[[UILabel alloc] initWithFrame:CGRectMake(60, 6, 160,32)];
    lblHeading.textAlignment=NSTextAlignmentCenter;
    lblHeading.text=strHeading;
    lblHeading.textColor=[UIColor blackColor];
    lblHeading.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:20.0f];
    [lblHeading setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView=lblHeading;
}

-(void)createNavigationAddView:(NSString*)strHeading
{
    for(UIView* view in self.navigationController.navigationBar.subviews)
    {
        if ([view isKindOfClass:[UILabel class]])
        {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UIButton class]])
        {
            [view removeFromSuperview];
        }
    }
    
    for(UIView* view in self.navigationController.view.subviews)
    {
       if(view.tag == 100 )
       {
            [view removeFromSuperview];
        }
    }
    
    UIBarButtonItem* btnLeft = [[UIBarButtonItem alloc] initWithTitle: @"Save"
                                                               style: UIBarButtonItemStylePlain
                                                              target: self
                                                              action: @selector(save)];
   self.navigationItem.leftBarButtonItem = btnLeft;
    
    UIBarButtonItem* btnRight= [[UIBarButtonItem alloc] initWithTitle: @"Cancel"
                                                                style: UIBarButtonItemStylePlain
                                                               target: self
                                                               action: @selector(cancel)];
    self.navigationItem.rightBarButtonItem = btnRight;

    UILabel *lblHeading=[[UILabel alloc] initWithFrame:CGRectMake(60, 6, 160,32)];
    lblHeading.textAlignment=NSTextAlignmentCenter;
    lblHeading.text=strHeading;
    lblHeading.textColor=[UIColor blackColor];
    lblHeading.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:20.0f];
    [lblHeading setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView=lblHeading;
}

#pragma mark - Check network reachability Method
 BOOL isNetworkAvailable ()
{
    BOOL isInternet=NO;
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
       isInternet=NO;
    else
       isInternet=YES;
    
    return isInternet;
}

#pragma mark - Check iPhone ScreenSize Method
BOOL iphoneTallScreen ()
{
    BOOL isChecked= NO;
    
    if ([UIScreen mainScreen].scale == 2.0f)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        CGFloat scale = [UIScreen mainScreen].scale;
        result = CGSizeMake(result.width * scale, result.height * scale);
        if(result.height == 1136)
        {
            isChecked=YES;
        }
    }
    return isChecked;
}

#pragma mark - Check Device types Method
Devicefamily thisDeviceFamily()
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        if (iphoneTallScreen()) return iPhone5;
        else return iPhone;
    }
    else return iPad;
}

#pragma mark - ValidateEmail Method
-(BOOL)validateEmail:(NSString *)str
{
	BOOL stricterFilter = YES;
	NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
	NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	return [emailTest evaluateWithObject:str];
}

#pragma mark - Keyboard resign First responder on anywhere tap
/*-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:nil];
    [self.view endEditing:YES];
}*/

#pragma mark - createAlertView Method
-(void)createAlertView:(NSString *)alrtTitle withAlertMessage:(NSString *)alrtMsg withAlertTag:(int)alrtTag
{
    UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:alrtTitle
                                                      message:alrtMsg
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"OK", nil];
    myAlert.tag=alrtTag;
    [myAlert show];
}

#pragma mark - convertToCorrectDate Method
-(NSString *)convertToCorrectDate:(NSString *)strTransDate
{
    NSArray *arrDateTime=[strTransDate componentsSeparatedByString:@" "];
    NSString *strDate=[arrDateTime objectAtIndex:0];
    NSArray *arrDate=[strDate componentsSeparatedByString:@"-"];
    NSString *stryyyy=[arrDate objectAtIndex:0];
    NSString *strMM=[arrDate objectAtIndex:1];
    NSString *strdd=[arrDate objectAtIndex:2];
    
    NSString *strFinalDate=[NSString stringWithFormat:@"%@.%@.%@",strdd,strMM,stryyyy];
    return strFinalDate;
}

-(NSString *)convertToDate:(NSString *)strDate
{
    NSArray *arrDate=[strDate componentsSeparatedByString:@"/"];
    
    //NSString *stryyyy=[arrDate objectAtIndex:0];
    NSString *strMM=[arrDate objectAtIndex:1];
    NSString *strMonthNm=[self monthName:strMM];
    NSString *strdd=[arrDate objectAtIndex:2];
    NSString *strFinalDate=[NSString stringWithFormat:@"%@ %@",strMonthNm,strdd];
 
    return strFinalDate;
}
-(NSString *)convertToFileDate:(NSString *)strDate
{
    NSArray *arrDate=[strDate componentsSeparatedByString:@"/"];
    
    //NSString *stryyyy=[arrDate objectAtIndex:0];
    NSString *strMM=[arrDate objectAtIndex:0];
    NSString *strMonthNm=[self monthName:strMM];
    NSString *strdd=[arrDate objectAtIndex:1];
    NSString *strFinalDate=[NSString stringWithFormat:@"%@ %@",strMonthNm,strdd];
    
    return strFinalDate;
}

#pragma mark - convert monthName Method
-(NSString*)monthName:(NSString *)monthVal
{
    if([monthVal isEqualToString:@"01"])
        return  @"Jan";
        //return  @"January";
    
    if([monthVal isEqualToString:@"02"])
        return   @"Feb";
       // return   @"February";
    
    if([monthVal isEqualToString:@"03"])
         return  @"Mar";
        //return  @"March";
    
    if([monthVal isEqualToString:@"04"])
          return @"Apr";
       // return @"April";
    
    if([monthVal isEqualToString:@"05"])
        return @"May";
    
    if([monthVal isEqualToString:@"06"])
        return @"June";
    
    if([monthVal isEqualToString:@"07"])
        return   @"July";
    
    if([monthVal isEqualToString:@"08"])
        return  @"Aug";
        //return  @"August";
    
    if([monthVal isEqualToString:@"09"])
        return @"Sept";
        //return @"September";
    
    if([monthVal isEqualToString:@"10"])
        return @"Oct";
        //return @"October";
    
    if([monthVal isEqualToString:@"11"])
        return @"Nov";
        //return @"November";
    
    if([monthVal isEqualToString:@"12"])
        return @"Dec";
        //return @"December";
    
    return nil;
}

#pragma mark - convertToCapital Method
-(NSString*)convertToCapital:(NSString *)strInput
{
    NSString *firstCapChar = [[strInput substringToIndex:1] capitalizedString];
    NSString *cappedStr = [strInput stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
 
    return cappedStr;
}

- (UIViewController *)backViewController
{
    NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;
    
    if (numberOfViewControllers < 2)
        return nil;
    else
        return [self.navigationController.viewControllers objectAtIndex:numberOfViewControllers - 2];
}

#pragma mark - Convert Address to Coordinate Point Method
- (CLLocationCoordinate2D) geoCodeUsingAddress:(NSString *)address
{
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude = latitude;
    center.longitude = longitude;
    return center;
}

#pragma mark - Image Resize Method
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - validateUrl Method
- (BOOL) validateUrl: (NSString *) candidate {
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}

#pragma mark - getCurrentCurrency Method
-(NSString*)getCurrentCurrency
{
NSLocale *theLocale = [NSLocale currentLocale];
NSString *symbol = [theLocale objectForKey:NSLocaleCurrencySymbol];
NSString *code = [theLocale objectForKey:NSLocaleCurrencyCode];
 
return  code;
}

#pragma mark - Null / Empty Check
-(BOOL)isEmpty:(NSString *)str
{
    if(str.length==0 || [str isKindOfClass:[NSNull class]] || [str isEqualToString:@""]||[str  isEqualToString:NULL]||[str isEqualToString:@"(null)"]||str==nil || [str isEqualToString:@"<null>"]){
        return YES;
    }
    return NO;
}


-(NSString*)getCurrentYear
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *yearString = [formatter stringFromDate:[NSDate date]];
    return yearString;
}

#pragma mark - Get Model Version
-(NSString *)GetIphoneModelVersion
{
    if ([[UIScreen mainScreen]bounds].size.height==480)
        return @"4";
    else if ([[UIScreen mainScreen]bounds].size.height==568)
        return @"5";
    else if ([[UIScreen mainScreen]bounds].size.height==667)
        return @"6";
    else if ([[UIScreen mainScreen]bounds].size.height==1104 || [[UIScreen mainScreen]bounds].size.height==960 || [[UIScreen mainScreen]bounds].size.height==736 || [[UIScreen mainScreen]bounds].size.height>670)//736
        return @"6Plus";
    return @"";
}

/********************************************
 @brief This method is used to move up the view
 ***********************************************/

-(void)moveUpViewFrame:(CGFloat)height//call at begin editing
{
    CGRect viewFrame = self.view.frame;
    if (viewFrame.origin.y>=0 )
    {
        viewFrame.origin.y -= height;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:.5];
        [self.view setFrame:viewFrame];
        [UIView commitAnimations];
    }
}


/********************************************
 @brief This method is used to move down the view
***********************************************/

-(void)moveDownViewFrame:(CGFloat)height//call at return
{
    CGRect viewFrame = self.view.frame;
    if (viewFrame.origin.y<0)
    {
        viewFrame.origin.y += height;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:.5];
        [self.view setFrame:viewFrame];
        [UIView commitAnimations];
    }
}


- (BOOL)isNetworkAvailable{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return NO;
    } else {
        return YES;
    }
}

-(NSString *)getCurrentTime{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm:ss";
    NSString *string = [formatter stringFromDate:[NSDate date]];
    return string;
}
-(NSString*)getCurrentDate{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"Y-M-dd HH:mm:ss";
    NSString *string = [formatter stringFromDate:[NSDate date]];
    return string;
}
-(NSString*)getCurrentDateTime{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"Y-M-dd HH:mm:ss";
    NSString *string = [formatter stringFromDate:[NSDate date]];
    return string;
}
-(NSString *)chkNullInputinitWithString:(NSString*)InputString
{
    if( (InputString == nil) ||(InputString ==(NSString*)[NSNull null])||([InputString isEqual:nil])||([InputString length] == 0)||([InputString isEqualToString:@""])||([InputString isEqualToString:@"(NULL)"])||([InputString isEqualToString:@"<NULL>"])||([InputString isEqualToString:@"<null>"]||([InputString isEqualToString:@"(null)"])||([InputString isEqualToString:@"NULL"]) ||([InputString isEqualToString:@"null"])))
        
        return @"";
    else
        return InputString ;
}



-(BOOL) isValidNumeric:(NSString*) checkText{
    
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    //Set the locale to US
    [numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    //Set the number style to Scientific
    [numberFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    NSNumber* number = [numberFormatter numberFromString:checkText];
    if (number != nil) {
        return true;
    }
    return false;
}

-(NSString *)getNibName:(NSString*)name{
    if (thisDeviceFamily()==iPad) {
        name = [name stringByAppendingString:@"_iPad"];
    }
    return name;
}
-(BOOL) isIphoneSixPlus{
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone ){
        if([[UIScreen mainScreen]bounds].size.width>375)
            return YES;
        else
            return NO;
        
    }
    else{
        return NO;
        
    }
    
}

-(NSString *)findFirstDayOfMonth:(NSString*)InputString{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [dateFormatter dateFromString:InputString];
    NSLog(@"Day In Month : %@", [dateFormatter stringFromDate:date]);
    
    // Setup a calendar and extract components and force to the first
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponants = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate: date];
    
    [dateComponants setDay:1];
    
    date = [calendar dateFromComponents:dateComponants];
    NSLog(@"First Day : %@", [dateFormatter stringFromDate:date]);
    
    // Change the formatter for the Day name
    [dateFormatter setDateFormat:@"EEEE"];
    NSLog(@"Day Name : %@", [dateFormatter stringFromDate:date]);

   return [dateFormatter stringFromDate:date];

}
@end
