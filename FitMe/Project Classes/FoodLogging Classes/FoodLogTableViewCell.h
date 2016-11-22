//
//  FoodLogTableViewCell.h
//  FitMe
//
//  Created by Debasish on 12/08/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodLogTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblSubTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleVal;
@property (strong, nonatomic) IBOutlet UILabel *lblSubTitleVal;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;

@end
