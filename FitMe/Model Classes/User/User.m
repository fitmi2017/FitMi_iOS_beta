
/********************************************//*!
* @file User.m
* @brief Contains constants and global parameters
* DreamzTech Solution ("COMPANY") CONFIDENTIAL
* Unpublished Copyright (c) 2015 DreamzTech Solution, All Rights Reserved.
***********************************************/


#import "User.h"
@implementation User



- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.firstName forKey:@"firstName"];
    [encoder encodeObject:self.lastName forKey:@"lastName"];
    [encoder encodeObject:self.userName forKey:@"userName"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.birthDay forKey:@"birthDay"];
    [encoder encodeObject:self.phoneNo forKey:@"phoneNo"];
    [encoder encodeObject:self.useraccess_key forKey:@"useraccess_key"];
    [encoder encodeObject:self.passWord forKey:@"password"];
    [encoder encodeObject:self.gender forKey:@"gender"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
        self.firstName=[decoder decodeObjectForKey:@"firstName"];
        self.lastName=[decoder decodeObjectForKey:@"lastName"];
        self.userName=[decoder decodeObjectForKey:@"userName"];
        self.email=[decoder decodeObjectForKey:@"email"];
        self.birthDay=[decoder decodeObjectForKey:@"birthDay"];
        self.phoneNo=[decoder decodeObjectForKey:@"phoneNo"];
        self.useraccess_key=[decoder decodeObjectForKey:@"useraccess_key"];
        self.passWord = [decoder decodeObjectForKey:@"password"];
        self.gender = [decoder decodeObjectForKey:@"gender"];
    }
    return self;
}

@end
