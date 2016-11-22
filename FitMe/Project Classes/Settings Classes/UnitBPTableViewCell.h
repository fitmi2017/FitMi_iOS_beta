//
//  UnitBPTableViewCell.h
//  FitMe
//
//  Created by Krishnendu Ghosh on 26/08/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnitBPTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btn_mmhg;

@property (weak, nonatomic) IBOutlet UIButton *btn_kpa;

@property (weak, nonatomic) IBOutlet UIButton *btn_aha;

@property (weak, nonatomic) IBOutlet UIButton *btn_who;

@property (weak, nonatomic) IBOutlet UILabel *lbl_us;


@property (weak, nonatomic) IBOutlet UILabel *lbl_Eu;

@end
