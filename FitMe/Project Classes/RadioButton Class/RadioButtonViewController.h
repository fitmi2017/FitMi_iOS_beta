//
//  RadioButtonViewController.h
//  FitMe
//
//  Created by Debasish on 09/11/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol radioButtondelegate

@optional
-(void)notifyradioButtonLog:(NSString*)strOption withTag:(int)tag;
@end

@interface RadioButtonViewController : UIViewController<UIGestureRecognizerDelegate>

@property (nonatomic, assign) id<radioButtondelegate> delegate;
@property(nonatomic,strong)NSString *radioType;
@property(nonatomic,strong)NSMutableArray *radioBtnArr;
@property(nonatomic,strong)NSString *selectedOption;
@property(nonatomic,assign)int tag,selectedIndex;

@end
