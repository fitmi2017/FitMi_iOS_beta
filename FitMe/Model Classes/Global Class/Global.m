//
//  Global.m
//  Ugo jersey
//
//  Created by Debasish Pal on 08/09/13.
//  Copyright (c) 2013 Debasish Pal. All rights reserved.
//

#import "Global.h"

@implementation Global
@synthesize CountryArr,CurrencyArr,LeadSrcArr,CatArr,CustomerTagArr,OwnerArr;
@synthesize AssignToArr,NoteTypeArr,NotifyListArr,TemplateArr;
@synthesize TaskAssignToArr,TaskNotifyToList;
@synthesize TaskNotifyToNm,AppointNotifyToNm,TaskNotifyToID,AppointNotifyToID;
@synthesize AppointSelectNotifyToList,TaskSelectNotifyToList;
@synthesize ShareFileList,ShareFileNm,ShareFileID;
+ (Global *)sharedInstance
{
    static Global *myInstance = nil;
	
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
        
    }
    
    return myInstance;
}
+(void)getdata
{

    [Global sharedInstance].CountryArr=[[NSMutableArray alloc]initWithObjects:nil];
    [Global sharedInstance].CurrencyArr=[[NSMutableArray alloc]initWithObjects:nil];
    [Global sharedInstance].LeadSrcArr=[[NSMutableArray alloc]initWithObjects:nil];
    [Global sharedInstance].CatArr=[[NSMutableArray alloc]initWithObjects:nil];
    [Global sharedInstance].CustomerTagArr=[[NSMutableArray alloc]initWithObjects:nil];
    [Global sharedInstance].OwnerArr=[[NSMutableArray alloc]initWithObjects:nil];

    [Global sharedInstance].AssignToArr=[[NSMutableArray alloc]initWithObjects:nil];
    [Global sharedInstance].NoteTypeArr=[[NSMutableArray alloc]initWithObjects:nil];
    [Global sharedInstance].NotifyListArr=[[NSMutableArray alloc]initWithObjects:nil];
    [Global sharedInstance].TemplateArr=[[NSMutableArray alloc]initWithObjects:nil];
    
    [Global sharedInstance].TaskAssignToArr=[[NSMutableArray alloc]initWithObjects:nil];
    [Global sharedInstance].TaskNotifyToList=[[NSMutableArray alloc]initWithObjects:nil];

    [Global sharedInstance].AppointSelectNotifyToList=[[NSMutableArray alloc]initWithObjects:nil];
    [Global sharedInstance].TaskSelectNotifyToList=[[NSMutableArray alloc]initWithObjects:nil];

    [Global sharedInstance].TaskNotifyToNm=[[NSString alloc]init];
    [Global sharedInstance].AppointNotifyToNm=[[NSString alloc]init];
    [Global sharedInstance].TaskNotifyToID=[[NSString alloc]init];
    [Global sharedInstance].AppointNotifyToID=[[NSString alloc]init];

    [Global sharedInstance].ShareFileList=[[NSMutableArray alloc]initWithObjects:nil];
    
    [Global sharedInstance].ShareFileNm=[[NSString alloc]init];
    [Global sharedInstance].ShareFileID=[[NSString alloc]init];

}

+(void)releasedata
{
    if([Global sharedInstance].CountryArr)
    {
        [[Global sharedInstance].CountryArr release];
        [Global sharedInstance].CountryArr=nil;
    }
    if(![Global sharedInstance].CountryArr)
    {
        [Global sharedInstance].CountryArr=[[NSMutableArray alloc]initWithObjects:nil];
    }
}

@end
