//
//  FoodLogPopUPViewController.h
//  FitMe
//
//  Created by Krishnendu Ghosh on 11/09/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FoodLogPopupDelegate
@optional
-(void)notifyEvent:(NSString*)msg;
@end
@interface FoodLogPopUPViewController : UIViewController<UIGestureRecognizerDelegate>
@property (nonatomic, assign) id<FoodLogPopupDelegate> delegate;
@property(nonatomic,strong)NSString *navigateVal;
@end
