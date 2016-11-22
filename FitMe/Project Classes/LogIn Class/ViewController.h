//
//  ViewController.h
//  FitMe
//
//  Created by Debasish on 24/07/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ServerConnection.h"

@interface ViewController : BaseViewController<UITextFieldDelegate,ServerConnectionDelegate>

@property (strong, nonatomic) IBOutlet UITextField *txtFldUserNm;
@property (strong, nonatomic) IBOutlet UITextField *txtFldPass;

- (IBAction)btnActionChk:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnChk,*btnChkBig;

- (IBAction)btnActionForgotPass:(id)sender;
- (IBAction)btnActionLogin:(id)sender;

@property(nonatomic,assign)BOOL isChecked;

@property (strong, nonatomic)  UITextField *txtfldPopCustDomain;
@property (strong, nonatomic)  UITextField *txtfldPopEmail;
@property (strong, nonatomic)  UILabel *lblPopCustDomain;
@property (strong, nonatomic) IBOutlet UILabel *lblRemMe;
@property (strong, nonatomic) IBOutlet UILabel *lblForgotPass;

@property(nonatomic,strong)NSString *connectType;

@end

