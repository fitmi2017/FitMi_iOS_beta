//
//  MealType.h
//  FitMe
//
//  Created by Krishnendu Ghosh on 15/09/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DbController.h"

@interface MealType : NSObject
@property(nonatomic,strong)NSString *meal_type_name;
@property(nonatomic,strong)NSString *images_id;
@property(nonatomic,strong)NSString *images_url;
@property(nonatomic,strong)NSString *meal_type_is_default;
@property(nonatomic,strong)NSString *active;
@property(nonatomic,strong)NSString *deleted;
-(NSMutableArray*)findAllMealType;
-(int)saveCustomMeal;
@end
