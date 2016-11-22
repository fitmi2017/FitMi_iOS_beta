
/********************************************//*!
* @file Utility.h
* @brief Contains constants and global parameters
* DreamzTech Solution ("COMPANY") CONFIDENTIAL
* Unpublished Copyright (c) 2015 DreamzTech Solution, All Rights Reserved.
***********************************************/


#import <Foundation/Foundation.h>
#import "User.h"
#import "Profile.h"
#import <UIKit/UIKit.h>

typedef enum{
    LoginActionLoginIn,
    LoginActionLogOut,
    LoginActionUpdateUserInfo,
    LoginForgetPassword,
    SignUp,
    InitialConnection
}LoginAction;


@interface Utility : NSObject
+ (id)sharedManager;

-(BOOL)isUserLoggedIn;
-(void)setUserLoginEnable:(BOOL)login;
-(NSString *)getReplacedXMLEncodedCharacterString:(NSString *)str;
-(NSString *)nextUpdateEvent:(NSString *)updateDate;

-(void)saveUserDetailsTouserDeafult:(User*)user;
-(User*)retriveUserDetailsFromDefault;

-(void)saveProfileDetailsTouserDefault:(Profile*)profile;
-(Profile*)retriveProfileDetailsFromDefault;

-(BOOL)isIpad;
-(void)clearUserValues;
-(NSMutableArray *)returnUniqueArray :(NSMutableArray *)originalArray;


- (UIImage *)resizeImageKeepingAspectRatio:(UIImage *)sourceImage byWidth:(CGFloat)width;
- (UIImage *)resizeImageKeepingAspectRatio:(UIImage *)sourceImage byHeight:(CGFloat)height;
- (UIImage *)resizeImageIgnoringAspectRatio:(UIImage *)sourceImage bySize:(CGSize)newSize;
- (UIImage *)cropImage:(UIImage *)sourceImage withRect:(CGRect)rect;
- (UIImage *)blurImage:(UIImage *)sourceImage blurAmount:(float)blur;
- (UIImage*)mergeImage:(UIImage*)firstImage withImage:(UIImage*)secondImage;
- (UIImage *)maskImage:(UIImage *)sourceImage withMask:(UIImage *)maskImage;
- (UIImage *)normalizedCapturedImage:(UIImage *)rawImage;
- (UIImage *)getCurrentScreenShot:(UIViewController *)viewController;

- (NSString *)getProjectVersionNumber;
- (NSString *)getBuildVersionNumber;
- (CGSize)getDeviceScreenSize;
- (NSString *)getDeviceOSVersionNumber;

- (BOOL)isNetworkAvailable;
- (NSDate *)getGMTDateTimeFromLocalDateTime:(NSDate *)date;
- (int)differenceBetweenTwoDates:(NSDate *)startDate endDate:(NSDate *)endDate;
- (NSDate *)getLocalDateTimeFromGMTDateTime:(NSDate *)date;
- (NSString *)timeFormatted:(int)totalSeconds;

- (NSString *)stripTags:(NSString *)str;
- (NSString*)textToHtml:(NSString*)htmlString;
- (NSString *)encodeStringToBase64:(NSString *)str;
- (NSString *)decodeStringFromBase64:(NSString *)str;
- (NSString *)changeDate:(NSString *)date fromFormat:(NSString *)from toFormat:(NSString *)to;

- (NSString *)getDocumentDirectoryPath;
- (NSString *)createFolderInDocumentDirectory:(NSString *)folderName;
- (NSString *)getFolderPathFromDocumentDirectory:(NSString *)folderName;
- (NSString *)getFilePathFromDocumentDirectory:(NSString *)fileName inFolder:(NSString *)folderName;
- (NSString *)saveFileInDocumentDirectory:(NSData *)fileData fileName:(NSString *)fileName inDirectory:(NSString *)folderName;

- (BOOL)removeSpecificFileFromDirectory:(NSString *)folderName fileName:(NSString *)fileName;
- (BOOL)removeAllFilesFromDirectory:(NSString *)folderName;
- (BOOL)removeSpecificDirectoryFromDocumentDirectory:(NSString *)folderName;
- (BOOL)removeAllFilesAndFolderFromDocumentDirectory;

- (void)saveSelectedDate:(NSString *)selectedDate;
- (void)saveSelectedDateYMD:(NSString *)selectedDate;
- (NSString *)getSelectedDate;
-(NSString*)getSelectedDateFormat;
- (void)removeSelectedDate;

+(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width;
@property(nonatomic,strong) NSMutableArray *allDatesOfMonthArr;
-(void)setAllDates:(NSMutableArray *)array;
-(NSMutableArray*)getAllDates;
/////
- (NSString *)getSelectedCalMonth;
- (void)saveSelectedCalMonth:(NSString *)selectedDate;
- (void)removeSelectedMonth ;

///////
- (void)savePlannerDailyDate:(NSString *)selectedDate;
- (NSString *)getPlannerDailyDate;
- (void)removePlannerDailyDate;
//////
- (void)savePlannerMultipleDate:(NSMutableArray *)selectedDateArray;
- (NSMutableArray *)getPlannerMultipleDate;
- (void)removePlannerMultipleDate;
/////
- (void)saveCurrentYearMonth:(NSString *)selectedDate;

- (NSString *)getCurrentYearMonth;

- (void)removeCurrentYearMonth;
/////////////////////
- (void)saveWeeklyDate:(NSMutableArray *)selectedDateArray;

- (NSMutableArray *)getWeeklyDate;

- (void)removeWeeklyDate;

@end

