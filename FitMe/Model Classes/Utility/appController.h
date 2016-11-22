//
//  appController.h
//  AquariaApp
//
//  Created by MAC2 on 10/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//com.objectsol.orderstore
//97203
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <LifesenseBluetooth/LSBLEDeviceManager.h>



@interface appController : NSObject


+(appController *)sharedappController;
- (NSString*)deviceModelName;
- (NSString*)textToHtml:(NSString*)htmlString;
-(BOOL) validEmail:(NSString*) emailString;
-(BOOL) isValidNumeric:(NSString*) checkText;
-(BOOL)isValidNumericText:(NSString *)strText;
-(NSString *)removeWhiteSpaceFromFront:(NSString *)strMsg;
-(NSArray *)sortArrayOfDictionary:(NSArray *)arrayToSort sortKey:(NSString *)keyString;
- (BOOL)isNetworkAvailable;
-(void)CallWebservice:(NSMutableDictionary *)KeyValues ControllerClass:(UIViewController *)CtrlClass CallBackFunction:(SEL)callBackFunctionn WithAction:(NSString *)str;
-(BOOL)isDeviceIpad;
-(BOOL)isDeviceIphone;
-(BOOL)isNullCheck:(NSString *)stringToCheck;
-(void)getDocumentsPath;
- (NSString*)generateFileNameWithExtension:(NSString *)extensionString;

-(BOOL)IsDictionaryContains:(NSDictionary *)dict KeyString:(NSString *)stringKey;
-(void)setTextPlaceholderColor:(UIColor *)color textfield:(UITextField *)textfield fontSize:(float)fontsize;
-(BOOL)isEmpty:(NSString *)str;
-(void)SaveString:(NSString *)strValue strKey:(NSString *)strKey;
-(id)GetString:(NSString *)strKey;
-(BOOL)IsiPhone;
-(NSString *)GetIphoneModelVersion;
- (void)ShowAlertWithTitle:(NSString *)titleStr Message:(NSString *)message ViewController:(UIViewController *)controller;
- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval;
//========== User Defined Objects====================
@property(nonatomic,strong)NSDictionary *carryDataDict;
@property(nonatomic,strong)NSDictionary *carryPlannerDataDataDict;
@property(nonatomic,strong)NSMutableArray *carryPlannerDataArr;
@property(nonatomic)BOOL searchStart,isFirstLaunch,isShowDevice;
@property (nonatomic,strong) MHCustomTabBarController *cuatomTabbar;
@property (nonatomic,strong) UIViewController *CurrentControllerObj;
@property (nonatomic,strong) LSBLEDeviceManager *BleManagerGlobal;
@end
