//
//  ActivityType.h
//  FitMe
//
//  Created by Debasish on 16/09/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DbController.h"

@interface ActivityType : NSObject
@property(nonatomic,strong)NSString *exercise_name;
@property(nonatomic,strong)NSString *active;
@property(nonatomic,strong)NSString *exercise_desc;
@property(nonatomic,strong)NSString *calsVal;
@property(nonatomic,strong)NSString *live_Strong_id;

-(NSMutableArray*)findAllActivityType;
-(int)saveCustomActivity;

@end
