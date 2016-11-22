//
//  RadioButtonViewController.m
//  FitMe
//
//  Created by Debasish on 09/11/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import "RadioButtonViewController.h"

@interface RadioButtonViewController ()
{
    __weak IBOutlet UIView *centerView;
    __weak IBOutlet UIView *upperView;
    __weak IBOutlet UILabel *lblTitle;
}
@end

@implementation RadioButtonViewController

#pragma mark - UIView LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    centerView.layer.cornerRadius=25;
    centerView.layer.borderColor=[[UIColor grayColor] CGColor];
    centerView.layer.borderWidth=.5;
   
    lblTitle.text=_radioType;
    
    UITapGestureRecognizer *touchHold = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    touchHold.delegate=self;
    [upperView addGestureRecognizer:touchHold];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITapGestureRecognizer Action Method
-(void)tapAction:(UITapGestureRecognizer*)sender
{
    NSLog(@"Tag====%ld",(long)sender.view.tag);
        [self willMoveToParentViewController:nil];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        [_delegate notifyradioButtonLog:@"BACK" withTag:_tag];
}

#pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView
 willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _radioBtnArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    static NSString *simpleTableIdentifier = @"radioButtonCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    UILabel *titleLabel=(UILabel*)[cell viewWithTag:2];
    titleLabel.text=[_radioBtnArr objectAtIndex:indexPath.row];
    
    UIButton *btnOption=(UIButton*)[cell viewWithTag:1];
    if(_selectedIndex==indexPath.row)
        [btnOption setImage:[UIImage imageNamed:@"selectedCirCle"] forState:UIControlStateNormal];
    else
        [btnOption setImage:[UIImage imageNamed:@"deselectedCircle"] forState:UIControlStateNormal];
    
    [btnOption addTarget:self action:@selector(selectedTap:) forControlEvents:UIControlEventTouchUpInside];
    btnOption.accessibilityHint=[NSString stringWithFormat:@"%@",[_radioBtnArr objectAtIndex:indexPath.row]];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedOption=[NSString stringWithFormat:@"%@",[_radioBtnArr objectAtIndex:indexPath.row]];
    
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    [_delegate notifyradioButtonLog:self.selectedOption withTag:_tag];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

#pragma mark - Selected Option Button Action
-(void)selectedTap:(UIButton* )sender
{
     self.selectedOption=[NSString stringWithFormat:@"%@",sender.accessibilityHint];
    
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    [_delegate notifyradioButtonLog:self.selectedOption withTag:_tag];
}

@end
