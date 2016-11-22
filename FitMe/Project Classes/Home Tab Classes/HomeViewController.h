//
//  HomeViewController.h
//  FitMe
//
//  Created by Debasish on 27/07/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ServerConnection.h"
#import "DateUpperCustomView.h"
@interface HomeViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,ServerConnectionDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate,DateUpperCustomViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tblVw;
@property (strong, nonatomic) IBOutlet UICollectionView *radialCollectionVw;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeightConstraint;
@end
