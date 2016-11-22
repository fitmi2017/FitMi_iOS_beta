//
//  EditWeightViewController.h
//  FitMe
//
//  Created by Krishnendu Ghosh on 19/01/16.
//  Copyright (c) 2016 Dreamztech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol editWeightDelegate
@optional
-(void)notifyWeightLog:(NSString*)str;
@end
@interface EditWeightViewController : BaseViewController<UIGestureRecognizerDelegate>
@property (nonatomic, assign) id<editWeightDelegate> delegate;
@property(nonatomic,strong)NSString *navigateVal;
@end
