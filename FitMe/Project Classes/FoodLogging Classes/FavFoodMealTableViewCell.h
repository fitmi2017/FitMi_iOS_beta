//
//  FavFoodMealTableViewCell.h
//  FitMe
//
//  Created by Debasish on 04/01/16.
//  Copyright (c) 2016 Dreamztech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavFoodMealTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnFav;
@property (weak, nonatomic) IBOutlet UILabel *lblSepararor;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@end
