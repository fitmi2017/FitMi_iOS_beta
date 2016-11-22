//
//  HomeTableViewCell.h
//  FitMe
//
//  Created by Debasish on 10/08/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *vwLeft;
@property (strong, nonatomic) IBOutlet UIImageView *imgVwLeftIcon;
@property (strong, nonatomic) IBOutlet UILabel *lblLeft;
@property (strong, nonatomic) IBOutlet UILabel *vwMiddle;
@property (strong, nonatomic) IBOutlet UILabel *lblMiddle;
@property (strong, nonatomic) IBOutlet UIButton *btnPlus;
@property (strong, nonatomic) IBOutlet UIView *vwRight;
@property (strong, nonatomic) IBOutlet UIView *vwSubRight;
@property (strong, nonatomic) IBOutlet UIView *vwRightBottom;
@property (strong, nonatomic) IBOutlet UIView *vwSubRightBottom;
@property (weak, nonatomic) IBOutlet UILabel *lblSysTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDiaTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnSideBar,*btnSubSideBar;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *vwSubRightHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *vwSubRightBottomHeightConstraint;

@property (strong, nonatomic) IBOutlet UILabel *lblMiddle1;
@property (strong, nonatomic) IBOutlet UILabel *lblMiddle2;
@property (weak, nonatomic) IBOutlet UIView *vwBlur;

@end
