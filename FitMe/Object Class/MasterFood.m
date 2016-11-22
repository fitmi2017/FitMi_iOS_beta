//
//  MasterFood.m
//  FitMe
//
//  Created by Krishnendu Ghosh on 14/09/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import "MasterFood.h"

@implementation MasterFood
-(void)saveUserFoodData{
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"insert into fitmi_food (item_title, cals,item_desc, serving_size,livestrong_id,item_weight,gm_calorie) values ('%@','%@','%@','%@','%@','%@','%@')",self.item_title,self.cals,self.item_desc,self.serving_size,self.livestrong_id,self.item_weight,self.item_gm_cal];
        [[DbController mDBHandler] executeUpdate:sqlQry];
        
        [[DbController mDBHandler] commit];
    }
    
    
}
-(NSMutableArray*)findDuplicateFood{
    
    NSMutableArray *arr=[NSMutableArray array];
    
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry = [NSString stringWithFormat:@"select livestrong_id from fitmi_food"];
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            [arr addObject:[NSString stringWithFormat:@"%d",[rs intForColumn:@"livestrong_id"]]];
        }
        [[DbController mDBHandler] commit];
    }
    
    return arr;
    
}
-(NSMutableArray*)getAllFoodLog{
    
    NSMutableArray *arr=[NSMutableArray array];
    
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
          NSString *sqlQry = [NSString stringWithFormat:@"select * from fitmi_food"];
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            [dic setValue:[rs stringForColumn:@"item_title"] forKey:@"item_title"];
            [dic setValue:[rs stringForColumn:@"item_desc"] forKey:@"item_desc"];
            [dic setValue:[rs stringForColumn:@"cals"] forKey:@"cals"];
            [dic setValue:[rs stringForColumn:@"serving_size"] forKey:@"serving_size"];
            [dic setValue:[rs stringForColumn:@"item_weight"] forKey:@"item_weight"];
            [dic setValue:[rs stringForColumn:@"gm_calorie"] forKey:@"gm_calorie"];
            [dic setValue:[rs stringForColumn:@"livestrong_id"] forKey:@"searchID"];

            [arr addObject:dic];
            
        }
        [[DbController mDBHandler] commit];
    }
    
    return arr;
    
    
}

@end
