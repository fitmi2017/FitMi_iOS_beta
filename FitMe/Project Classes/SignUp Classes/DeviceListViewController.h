//
//  DeviceListViewController.h
//  FitMe
//
//  Created by Debasish on 10/08/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "UserProfileDetails.h"

@interface DeviceListViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    
}
@property(nonatomic,strong)UserProfileDetails *userProfileObj;
@end
