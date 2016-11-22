//
//  LCCChatViewController.m
//  MobiLiveChat
//
//  Created by Krzysztof Górski on 12/11/13.
//  Copyright (c) 2013 Krzysztof Górski. All rights reserved.
//

#import "LCCChatViewController.h"

@interface LCCChatViewController ()

@property (nonatomic, copy) NSString *chatUrl;

@end

@implementation LCCChatViewController

- (id)initWithChatUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        [self setChatUrl:url];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createNavigationView:@"Chat"];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
   // [self setTitle:@"Chat"];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    self.chatView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    [self.chatView setAlpha:0.0];
    [self.chatView setDelegate:self];
    [self.view addSubview:self.chatView];
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    [self.indicator setColor:[UIColor blackColor]];
    [self.indicator startAnimating];               
    [self.view addSubview:self.indicator];
    
    NSURL *url = [NSURL URLWithString:self.chatUrl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.chatView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    void (^showChatView)(void) = ^(void) {
        [self.chatView setAlpha:1.0];
        [self.indicator setAlpha:0.0];
    };
    
    void (^stopIndicator)(BOOL) = ^(BOOL finished) {
        [self.indicator stopAnimating];
    };
    
    [UIView animateWithDuration:1.0
                          delay:1.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:showChatView
                     completion:stopIndicator];
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
