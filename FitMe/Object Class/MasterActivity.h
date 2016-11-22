//
//  MasterActivity.h
//  FitMe
//
//  Created by Debasish on 16/09/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DbController.h"
@interface MasterActivity : NSObject

@property(nonatomic,strong)NSString *item_title;
@property(nonatomic,strong)NSString *cals;
@property(nonatomic,strong)NSString *item_desc;
@property(nonatomic,strong)NSString *livestrong_id;
-(void)saveUserActivityData;
-(NSMutableArray*)findDuplicateActivity;
-(NSMutableDictionary*)findIndividualExercise:(int)activityID;

@end
