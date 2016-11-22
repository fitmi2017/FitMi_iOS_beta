//
//  FoodLogPopUPViewController.m
//  FitMe
//
//  Created by Krishnendu Ghosh on 11/09/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import "FoodLogPopUPViewController.h"

@interface FoodLogPopUPViewController (){


    __weak IBOutlet UIView *upperView;
    __weak IBOutlet UIView *centerView;
    __weak IBOutlet UILabel *lblTopTitle;
}

@end

@implementation FoodLogPopUPViewController

#pragma mark - UIView LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([_navigateVal isEqualToString:@"food"])
    {
    lblTopTitle.text=@"Would you like to log this meal?";
    }
    else  if([_navigateVal isEqualToString:@"activity"])
    {
    lblTopTitle.text=@"Would you like to log this exercise?";
    }

    centerView.layer.cornerRadius=25;
    centerView.layer.borderColor=[[UIColor grayColor] CGColor];
    centerView.layer.borderWidth=.5;
    
    UITapGestureRecognizer *touchHold = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
      touchHold.delegate=self;
    [upperView addGestureRecognizer:touchHold];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)yesButtonTapped:(id)sender
{
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
      [_delegate notifyEvent:@"YES"];
 }

- (IBAction)editButtonTapped:(id)sender
{
    [_delegate notifyEvent:@"BACK"];
    
}

- (IBAction)NoButtonTapped:(id)sender {
    
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    [_delegate notifyEvent:@"NO"];
  //  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tapCenterView:(UITapGestureRecognizer *)sender {
    
    NSLog(@"Do nothing");
}

-(void)tapAction:(UITapGestureRecognizer*)sender{
    NSLog(@"Tag====%ld",(long)sender.view.tag);
    if(sender.view.tag==100){
        
     [self willMoveToParentViewController:nil];
     [self.view removeFromSuperview];
     [self removeFromParentViewController];
     [_delegate notifyEvent:@"BACK"];
    }

}

@end
