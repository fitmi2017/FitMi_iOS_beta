//
//  MealType.m
//  FitMe
//
//  Created by Krishnendu Ghosh on 15/09/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import "MealType.h"

@implementation MealType
-(NSMutableArray*)findAllMealType{

    NSMutableArray *arr=[NSMutableArray array];
    
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry = [NSString stringWithFormat:@"select meal_type_id,meal_type_name from meal_type"];
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"meal_type_id"]] forKey:@"meal_type_id"];
            [dic setValue:[rs stringForColumn:@"meal_type_name"] forKey:@"meal_type_name"];
            [arr addObject:dic];

        }
        [[DbController mDBHandler] commit];
    }
    
    return arr;


}

-(int)saveCustomMeal{

    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"insert into meal_type (meal_type_name,images_id,images_url,meal_type_is_default,active,deleted) values ('%@','%@','%@','%@','%@','%@')",self.meal_type_name,@"",@"",@"",@"",@""];
        //[[DbController mDBHandler] executeUpdate:sqlQry];
         int rowId=0;
         rowId=[[DbController mDBHandler] saveProfileUser:sqlQry];
        [[DbController mDBHandler] commit];
        return rowId;
    }
    

    return 0;

}

@end
