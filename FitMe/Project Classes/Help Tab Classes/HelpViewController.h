//
//  HelpViewController.h
//  FitMe
//
//  Created by Debasish on 27/07/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "Decode64.h"
#import "LCCChatViewController.h"
@interface HelpViewController : BaseViewController<UICollectionViewDelegate,UICollectionViewDataSource,MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *helpCollectionView;
@property(nonatomic, strong) LCCChatViewController *chatViewController;
@end
