//
//  Global.h
//  Ugo jersey
//
//  Created by Debasish Pal on 08/09/13.
//  Copyright (c) 2013 Debasish Pal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Global : NSObject
{
      NSMutableArray *CountryArr;
}
@property(nonatomic,retain) NSMutableArray *CountryArr,*CurrencyArr,*LeadSrcArr,*CatArr,*CustomerTagArr,*OwnerArr;
@property(nonatomic,retain) NSMutableArray *AssignToArr,*NoteTypeArr,*NotifyListArr,*TemplateArr;
@property(nonatomic,retain)NSMutableArray *TaskAssignToArr,*TaskNotifyToList;
@property(nonatomic,retain)NSMutableArray *AppointSelectNotifyToList,*TaskSelectNotifyToList;
@property(nonatomic,retain)NSString *TaskNotifyToNm,*AppointNotifyToNm,*TaskNotifyToID,*AppointNotifyToID;

@property(nonatomic,retain)NSMutableArray *ShareFileList;
@property(nonatomic,retain)NSString *ShareFileNm,*ShareFileID;


+ (Global *)sharedInstance;
+(void)getdata;
+(void)releasedata;

@end
