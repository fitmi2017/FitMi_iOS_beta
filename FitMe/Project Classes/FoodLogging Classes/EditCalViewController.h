//
//  EditCalViewController.h
//  FitMe
//
//  Created by Krishnendu Ghosh on 18/09/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import "ViewController.h"
@protocol editCalorieDelegate
@optional
-(void)notifyCalorieLog:(NSString*)str;
@end
@interface EditCalViewController : ViewController<UIGestureRecognizerDelegate>
@property (nonatomic, assign) id<editCalorieDelegate> delegate;
@property(nonatomic,strong)NSString *navigateVal;
@end
