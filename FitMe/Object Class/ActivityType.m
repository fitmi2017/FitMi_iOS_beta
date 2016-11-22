//
//  ActivityType.m
//  FitMe
//
//  Created by Debasish on 16/09/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import "ActivityType.h"

@implementation ActivityType
-(NSMutableArray*)findAllActivityType{
    
    NSMutableArray *arr=[NSMutableArray array];
    
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry = [NSString stringWithFormat:@"select id,exercise from fitmi_exercise"];
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"id"]] forKey:@"exercise_type_id"];
            [dic setValue:[rs stringForColumn:@"exercise"] forKey:@"exercise_type_name"];
            [arr addObject:dic];
            
        }
        [[DbController mDBHandler] commit];
    }
    
    return arr;
    
    
}

-(int)saveCustomActivity{
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"insert into fitmi_exercise (exercise,description,cals_per_hour,livestrong_id,is_default) values ('%@','%@','%@','%@','%@')",self.exercise_name,@"",@"",@"",@""];
        [[DbController mDBHandler] executeUpdate:sqlQry];
        int rowId=0;
        rowId=[[DbController mDBHandler] saveProfileUser:sqlQry];
        [[DbController mDBHandler] commit];
        return rowId;
    }
    
    
    return 0;
    
}


@end
