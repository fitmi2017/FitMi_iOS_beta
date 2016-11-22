//
//  Profile.m
//  FitMe
//
//  Created by Debasish on 21/08/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import "Profile.h"

@implementation Profile

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.height_feet forKey:@"height_feet"];
    [encoder encodeObject:self.height_inch forKey:@"height_inch"];
    [encoder encodeObject:self.DOB forKey:@"DOB"];
    [encoder encodeObject:self.activityLevel forKey:@"activityLevel"];
    [encoder encodeObject:self.dailyCalIntake forKey:@"dailyCalIntake"];
 }

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
        self.height_feet=[decoder decodeObjectForKey:@"height_feet"];
        self.height_inch=[decoder decodeObjectForKey:@"height_inch"];
        self.DOB=[decoder decodeObjectForKey:@"DOB"];
        self.activityLevel=[decoder decodeObjectForKey:@"activityLevel"];
        self.dailyCalIntake=[decoder decodeObjectForKey:@"dailyCalIntake"];
    }
    return self;
}

@end
