//
//  ProfileTableViewCell.h
//  FitMe
//
//  Created by Debasish on 28/07/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblVal;
@property (strong, nonatomic) IBOutlet UILabel *lblDeviceNm;
@property (strong, nonatomic) IBOutlet UILabel *lblDeviceStatus;
@property (strong, nonatomic) IBOutlet UIImageView *imgVw;
@property (weak, nonatomic) IBOutlet UIButton *btnArrow;

@end
