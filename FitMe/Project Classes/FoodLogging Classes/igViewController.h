//
//  igViewController.h
//  ScanBarCodes
//
//  Created by Torrey Betts on 10/10/13.
//  Copyright (c) 2013 Infragistics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@protocol bardelegate
@optional
-(void)notifyBarLog:(NSString*)strBar;
@end

@interface igViewController : ViewController
{
    
}
@property (nonatomic, assign) id<bardelegate> delegate;

@end