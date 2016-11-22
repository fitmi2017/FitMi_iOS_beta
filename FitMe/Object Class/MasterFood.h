//
//  MasterFood.h
//  FitMe
//
//  Created by Krishnendu Ghosh on 14/09/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DbController.h"
@interface MasterFood : NSObject
@property(nonatomic,strong)NSString *item_title;
@property(nonatomic,strong)NSString *cals;
@property(nonatomic,strong)NSString *item_desc;
@property(nonatomic,strong)NSString *item_weight;
@property(nonatomic,strong)NSString *item_gm_cal;
@property(nonatomic,strong)NSString *serving_size;
@property(nonatomic,strong)NSString *livestrong_id;
-(void)saveUserFoodData;
-(NSMutableArray*)findDuplicateFood;
-(NSMutableArray*)getAllFoodLog;
@end
 