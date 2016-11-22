
/********************************************//*!
* @file User.h
* @brief Contains constants and global parameters
* DreamzTech Solution ("COMPANY") CONFIDENTIAL
* Unpublished Copyright (c) 2015 DreamzTech Solution, All Rights Reserved.
***********************************************/


#import <Foundation/Foundation.h>


@interface User : NSObject

@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *passWord;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *phoneNo;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *birthDay;
@property (nonatomic, retain) NSString *confirmPassWord;
@property (nonatomic, retain) NSString *gender;
@property(retain,nonatomic) NSString *useraccess_key;
@property(retain,nonatomic) NSString *userpassword;



@end
