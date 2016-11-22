//
//  FAQViewController.m
//  FitMe
//
//  Created by dts_user on 23/04/16.
//  Copyright © 2016 Dreamztech Solutions. All rights reserved.
//

#import "FAQViewController.h"
#import "DejalActivityView.h"
@interface FAQViewController ()

@end

@implementation FAQViewController

#pragma mark - UIView Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createNavigationView:@"FAQ"];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // [self setTitle:@"Chat"];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    self.FAQView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height-40.0)];
    [self.FAQView setDelegate:self];
    [self.view addSubview:self.FAQView];
    
    NSURL *url = [NSURL URLWithString:@"http://fitmi.com/#FAQ"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.FAQView loadRequest:request];

//    NSString *defaultURL = ;
//    //self.webVw.autoresizingMask   = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
//    self.webVw.delegate=self;
//    [self.webVw loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:defaultURL]]];
}
-(void)viewWillAppear:(BOOL)animated
{
  //  [self.navigationItem setHidesBackButton:YES animated:NO];
   // [self createNavigationView:@"News"];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
   [DejalBezelActivityView activityViewForView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [DejalBezelActivityView removeViewAnimated:YES];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [DejalBezelActivityView removeViewAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)createNavigationView:(NSString*)strHeading
{
    for(UIView* view in self.navigationController.navigationBar.subviews)
    {
        if ([view isKindOfClass:[UILabel class]])
        {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UIButton class]])
        {
            [view removeFromSuperview];
        }
    }
    
    UIButton *btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setImage:[UIImage imageNamed:@"backArrow@3x"]  forState:UIControlStateNormal ];
    [btnLeft addTarget:self action:@selector(showLeft) forControlEvents:UIControlEventTouchUpInside];
    [btnLeft setFrame:CGRectMake(0, 0, 12, 20) ];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    
    UILabel *lblHeading=[[UILabel alloc] initWithFrame:CGRectMake(60, 6, 160,32)];
    lblHeading.textAlignment=NSTextAlignmentCenter;
    lblHeading.text=strHeading;
    lblHeading.textColor=[UIColor whiteColor];
    lblHeading.font=[UIFont fontWithName:@"SinkinSans-300Light" size:24.0f];
    [lblHeading setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView=lblHeading;
}
-(void)showLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
