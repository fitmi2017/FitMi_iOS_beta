//
//  SignUpViewController.h
//  FitMe
//
//  Created by Debasish on 27/07/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ServerConnection.h"
@interface SignUpViewController : BaseViewController<ServerConnectionDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic)  UITextField *txtFldEmail;
@property (strong, nonatomic)  UITextField *txtFldPass;
@property (strong, nonatomic)  UITextField *txtFldConPass;
@property (strong, nonatomic)  UITextField *txtFldFNm;
@property (strong, nonatomic)  UITextField *txtFldLNm;
@property (weak, nonatomic) IBOutlet UITableView *tblVw;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomTblVwConst;

@property (nonatomic,strong)UITextField *activeTextField;

@property (nonatomic, strong) NSMutableDictionary *dicCell;
@end
