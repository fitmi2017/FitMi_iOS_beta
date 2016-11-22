//
//  ChangePassViewController.h
//  FitMe
//
//  Created by Debasish on 18/08/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ChangePassViewController : BaseViewController<UITextFieldDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *txtFldEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtFldFNm;
@property (strong, nonatomic) IBOutlet UITextField *txtFldLNm;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollVwBG;

@property (nonatomic,strong)UITextField *activeTextField;


@end
