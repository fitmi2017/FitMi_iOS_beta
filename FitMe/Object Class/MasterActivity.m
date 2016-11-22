//
//  MasterActivity.m
//  FitMe
//
//  Created by Debasish on 16/09/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import "MasterActivity.h"

@implementation MasterActivity

-(void)saveUserActivityData{
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"insert into fitmi_exercise (exercise, cals_per_hour,description,livestrong_id,is_default) values ('%@','%@','%@','%@','%d')",self.item_title,self.cals,self.item_desc,self.livestrong_id,0];
        [[DbController mDBHandler] executeUpdate:sqlQry];
        
        [[DbController mDBHandler] commit];
    }
    
    
}
-(NSMutableArray*)findDuplicateActivity{
    
    NSMutableArray *arr=[NSMutableArray array];
    
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry = [NSString stringWithFormat:@"select livestrong_id from fitmi_exercise"];
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            [arr addObject:[NSString stringWithFormat:@"%d",[rs intForColumn:@"livestrong_id"]]];
        }
        [[DbController mDBHandler] commit];
    }
    
    return arr;
    
}

-(NSMutableDictionary*)findIndividualExercise:(int)activityID{
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    
       if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry = [NSString stringWithFormat:@"select * from fitmi_exercise where id='%d'",activityID];
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            [dict setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"id"]] forKey:@"exercise_id"];
            [dict setValue:[rs stringForColumn:@"exercise"] forKey:@"exercise_name"];
             [dict setValue:[rs stringForColumn:@"description"] forKey:@"exercise_desc"];
             [dict setValue:[rs stringForColumn:@"cals_per_hour"] forKey:@"cals_per_hour"];
             [dict setValue:[rs stringForColumn:@"livestrong_id"] forKey:@"livestrong_id"];
            
          }
        [[DbController mDBHandler] commit];
    }
    
    return dict;
    
    
}


@end
