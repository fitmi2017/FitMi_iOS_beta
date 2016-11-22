//
//  appController.m
//  AquariaApp
//
//  Created by MAC2 on 10/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "appController.h"
#import <sys/utsname.h>
#import "Reachability.h"
#import "DejalActivityView.h"


@interface appController(){
    

}

@property (nonatomic,strong)UIViewController *viewControllerModule;
@property (nonatomic,strong)NSMutableDictionary *KeyValueWebService;
@property (nonatomic,assign) SEL callbackWebservice;
@end

@implementation appController
@synthesize cuatomTabbar,CurrentControllerObj,BleManagerGlobal,isShowDevice;

static appController *sharedappController = nil;

+(appController *)sharedappController{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedappController = [[self alloc] init];
    
    });
    return sharedappController;
}


- (NSString*)deviceModelName {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *machineName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    NSDictionary *commonNamesDictionary =
    @{
      @"i386":     @"iPhone Simulator",
      @"x86_64":   @"iPad Simulator",
      
      @"iPhone1,1":    @"iPhone",
      @"iPhone1,2":    @"iPhone 3G",
      @"iPhone2,1":    @"iPhone 3GS",
      @"iPhone3,1":    @"iPhone 4",
      @"iPhone3,2":    @"iPhone 4(Rev A)",
      @"iPhone3,3":    @"iPhone 4(CDMA)",
      @"iPhone4,1":    @"iPhone 4S",
      @"iPhone5,1":    @"iPhone 5(GSM)",
      @"iPhone5,2":    @"iPhone 5(GSM+CDMA)",
      @"iPhone5,3":    @"iPhone 5c(GSM)",
      @"iPhone5,4":    @"iPhone 5c(GSM+CDMA)",
      @"iPhone6,1":    @"iPhone 5s(GSM)",
      @"iPhone6,2":    @"iPhone 5s(GSM+CDMA)",
      
      @"iPhone7,1":    @"iPhone 6+ (GSM+CDMA)",
      @"iPhone7,2":    @"iPhone 6 (GSM+CDMA)",
      
      @"iPad1,1":  @"iPad",
      @"iPad2,1":  @"iPad 2(WiFi)",
      @"iPad2,2":  @"iPad 2(GSM)",
      @"iPad2,3":  @"iPad 2(CDMA)",
      @"iPad2,4":  @"iPad 2(WiFi Rev A)",
      @"iPad2,5":  @"iPad Mini 1G (WiFi)",
      @"iPad2,6":  @"iPad Mini 1G (GSM)",
      @"iPad2,7":  @"iPad Mini 1G (GSM+CDMA)",
      @"iPad3,1":  @"iPad 3(WiFi)",
      @"iPad3,2":  @"iPad 3(GSM+CDMA)",
      @"iPad3,3":  @"iPad 3(GSM)",
      @"iPad3,4":  @"iPad 4(WiFi)",
      @"iPad3,5":  @"iPad 4(GSM)",
      @"iPad3,6":  @"iPad 4(GSM+CDMA)",
      
      @"iPad4,1":  @"iPad Air(WiFi)",
      @"iPad4,2":  @"iPad Air(GSM)",
      @"iPad4,3":  @"iPad Air(GSM+CDMA)",
      
      @"iPad4,4":  @"iPad Mini 2G (WiFi)",
      @"iPad4,5":  @"iPad Mini 2G (GSM)",
      @"iPad4,6":  @"iPad Mini 2G (GSM+CDMA)",
      
      @"iPod1,1":  @"iPod 1st Gen",
      @"iPod2,1":  @"iPod 2nd Gen",
      @"iPod3,1":  @"iPod 3rd Gen",
      @"iPod4,1":  @"iPod 4th Gen",
      @"iPod5,1":  @"iPod 5th Gen",
      
      };
    
    NSString *deviceName = commonNamesDictionary[machineName];
    
    if (deviceName == nil) {
        deviceName = machineName;
    }
    
    return deviceName;
}
- (id)init {
    if (self = [super init]) {
       // self.isShowDevice=FALSE;
        self.isShowDevice=TRUE;
    }
    return self;
}
#pragma mark - TimeInterval to Time Format
- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
}
#pragma mark - Is Dictioanary contains Key
-(BOOL)IsDictionaryContains:(NSDictionary *)dict KeyString:(NSString *)stringKey{
    return [[dict allKeys] containsObject:[NSString stringWithFormat:@"stringKey"]];
}
NSString* deviceName()
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}
- (NSInteger)GetAgeInYears:(NSDate *)birthdate{
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components: (NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit )
                                                        fromDate:birthdate
                                                          toDate:[NSDate date]
                                                         options:0];
    return [components year];
    
    /*NSLog(@"%ld", [components year]);
     NSLog(@"%ld", [components month]);
     NSLog(@"%ld", [components day]);
     NSLog(@"%ld", [components hour]);
     NSLog(@"%ld", [components minute]);
     NSLog(@"%ld", [components second]);*/
}
#pragma mark - Generate File Name Randomly
- (NSString*)generateFileNameWithExtension:(NSString *)extensionString
{
    // Extenstion string is like @".png"
    
    NSDate *time = [NSDate date];
    NSDateFormatter* df = [NSDateFormatter new];
    [df setDateFormat:@"MM-dd-yyyy-hh-mm-ss"];
    NSString *timeString = [df stringFromDate:time];
    NSString *fileName = [NSString stringWithFormat:@"File-%@%@", timeString, extensionString];
    
    return fileName;
}
#pragma mark - ValidateEmail
-(BOOL) validEmail:(NSString*) emailString {
    NSString *regExPattern = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    NSLog(@"%lu", (unsigned long)regExMatches);
    if (regExMatches == 0) {
        return NO;
    } else
        return YES;
}
#pragma mark - isIphone
-(BOOL)IsiPhone{
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        return TRUE;
    }
    else return FALSE;
}
#pragma mark - Network Check
- (BOOL)isNetworkAvailable {
    Reachability * reachability = [Reachability reachabilityForInternetConnection];
    if ([reachability currentReachabilityStatus] == NotReachable) {
        return NO;
    }
    return YES;
}

#pragma mark - Set Placeholder Text White
-(void)setTextPlaceholderColor:(UIColor *)color textfield:(UITextField *)textfield fontSize:(float)fontsize{
    
    textfield.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:textfield.placeholder
                                    attributes:@{
                                                 NSForegroundColorAttributeName: color,
                                                 NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Medium" size:fontsize]
                                                 }];
}
#pragma mark - Show Alert
- (void)ShowAlertWithTitle:(NSString *)titleStr Message:(NSString *)message ViewController:(UIViewController *)controller{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 8.0f) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:titleStr==NULL||[titleStr isEqualToString:@""]?@"Alert":titleStr message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:NULL];
        [alert addAction:actionCancel];
        [controller presentViewController:alert animated:YES completion:NULL];
    }
    else{
        [[[UIAlertView alloc] initWithTitle:titleStr==NULL||[titleStr isEqualToString:@""]?@"Alert":titleStr message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
    }
}
#pragma mark - IS Nueric Checking
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
-(BOOL)isValidNumericText:(NSString *)strText{
    
    NSScanner *scan = [NSScanner scannerWithString:strText];
    
    if (![scan scanFloat:NULL] || ![scan isAtEnd])
    {
        return FALSE;
    }
    else
    {
        return TRUE;
    }
}




#pragma mark - Remove Space From Front
-(NSString *)removeWhiteSpaceFromFront:(NSString *)strMsg{
    while ([strMsg rangeOfString:@" "].location != NSNotFound) {
        strMsg = [strMsg stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return strMsg;
    
}

#pragma mark - Save and Get String
-(void)SaveString:(NSString *)strValue strKey:(NSString *)strKey{
    [[NSUserDefaults standardUserDefaults] setObject:strValue forKey:strKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(id)GetString:(NSString *)strKey{
    id object = [[NSUserDefaults standardUserDefaults] objectForKey:strKey];
    return object;
}
#pragma mark - Null / Empty Check
-(BOOL)isEmpty:(NSString *)str
{
    if(str.length==0 || [str isKindOfClass:[NSNull class]] || [str isEqualToString:@""]||[str  isEqualToString:NULL]||[str isEqualToString:@"(null)"]||str==nil || [str isEqualToString:@"<null>"]){
        return YES;
    }
    return NO;
}

#pragma mark - Sort Array Of Dict
-(NSArray *)sortArrayOfDictionary:(NSArray *)arrayToSort sortKey:(NSString *)keyString{
    
    NSSortDescriptor *brandDescriptor = [[NSSortDescriptor alloc] initWithKey:keyString ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:brandDescriptor];
    NSArray *sortedArray = [arrayToSort sortedArrayUsingDescriptors:sortDescriptors];
    return sortedArray;
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

-(NSString *)getFormattedDate:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"MM/dd/yyyy"];
    
    return [format stringFromDate:date];
}



#pragma mark - Device Check
-(BOOL)isDeviceIpad{
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        return YES;
    return NO;
}
-(BOOL)isDeviceIphone{
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
        return YES;
    return NO;
}
#pragma mark - Object Null Check
-(BOOL)isNullCheck:(NSString *)stringToCheck
{
    if ([stringToCheck isKindOfClass:[[NSNull null] class]] || stringToCheck == NULL || [stringToCheck isEqualToString:@"<null>"]) {
        return YES;
    }
    else
        return NO;
}

#pragma mark - Get All DB Information and Access
-(void)getDocumentsPath
{
    //---------Document Directory Path-----------
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSLog(@"Path = %@",documentsPath);
}

- (NSString*)textToHtml:(NSString*)htmlString {
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&amp;"  withString:@"&"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&lt;"  withString:@"<"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&gt;"  withString:@">"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&quot;" withString:@""""];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#039;"  withString:@"'"];
    
    htmlString = [@"<p>" stringByAppendingString:htmlString];
    htmlString = [htmlString stringByAppendingString:@"</p>"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"\n" withString:@"</p><p>"];
    while ([htmlString rangeOfString:@"  "].length > 0) {
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"  " withString:@"&nbsp;&nbsp;"];
    }
    return htmlString;
}
@end
