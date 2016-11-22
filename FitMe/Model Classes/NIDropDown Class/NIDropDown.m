//
//  NIDropDown.m
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import "NIDropDown.h"
#import "QuartzCore/QuartzCore.h"
#import "NIDropDownTableViewCell.h"
@interface NIDropDown ()
@property(nonatomic, strong) UITableView *table;
@property(nonatomic, strong) UIButton *btnSender;
@property(nonatomic, retain) NSArray *list;
@property(nonatomic, retain) NSArray *imageList;
@property(nonatomic,assign)int Tag;
@end

@implementation NIDropDown
@synthesize table;
@synthesize btnSender;
@synthesize list;
@synthesize imageList;
@synthesize delegate;
@synthesize animationDirection;
@synthesize Tag;

- (id)showDropDown :(UIButton *)b :(CGFloat *)height :(NSMutableArray *)arr :(NSArray *)imgArr :(NSString *)direction :(int)tag{
    
    Tag=tag;
    btnSender = b;
    animationDirection = direction;
    
    *height=arr.count>=5?250:50*arr.count;
    self.table = (UITableView *)[super init];
    if (self) {
        // Initialization code
        CGRect btn = b.frame;
        self.list =arr;// [NSArray arrayWithArray:arr];
        self.imageList = [NSArray arrayWithArray:imgArr];
        if ([direction isEqualToString:@"up"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width, 0);
            self.layer.shadowOffset = CGSizeMake(-5, -5);
        }else if ([direction isEqualToString:@"down"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
            self.layer.shadowOffset = CGSizeMake(-5, 5);
        }
        
        self.layer.masksToBounds = NO;
       // self.layer.cornerRadius = 8;
//        self.layer.shadowRadius = 5;
//        self.layer.shadowOpacity = 0.5;
        
        table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, btn.size.width, 0)];
        table.delegate = self;
        table.dataSource = self;
      //  table.layer.cornerRadius = 5;
        table.backgroundColor = [UIColor whiteColor];
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.separatorColor = [UIColor clearColor];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        if ([direction isEqualToString:@"up"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y-*height, btn.size.width, *height);
        } else if([direction isEqualToString:@"down"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, *height);
        }
        table.frame = CGRectMake(0, 0, btn.size.width, *height);
        [UIView commitAnimations];
        [b.superview addSubview:self];
        [self addSubview:table];
    }
    return self;
}

-(void)hideDropDown:(UIButton *)b {
    CGRect btn = b.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    if ([animationDirection isEqualToString:@"up"]) {
        self.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width, 0);
    }else if ([animationDirection isEqualToString:@"down"]) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, btn.size.width, 0);
    }
    table.frame = CGRectMake(0, 0, btn.size.width, 0);
    [UIView commitAnimations];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.list count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  /*  static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.imageView.frame = CGRectMake(2, 5, 20, 20);
    }
    if ([self.imageList count] == [self.list count]) {
        cell.textLabel.text =[list objectAtIndex:indexPath.row];
        cell.imageView.image = [imageList objectAtIndex:indexPath.row];
    } else if ([self.imageList count] > [self.list count]) {
        cell.textLabel.text =[list objectAtIndex:indexPath.row];
        if (indexPath.row < [imageList count]) {
            cell.imageView.image = [imageList objectAtIndex:indexPath.row];
        }
    } else if ([self.imageList count] < [self.list count]) {
        cell.textLabel.text =[list objectAtIndex:indexPath.row];
        if (indexPath.row < [imageList count]) {
            cell.imageView.image = [imageList objectAtIndex:indexPath.row];
        }
    }
    
    cell.textLabel.textColor = [UIColor blackColor];
    
    UIView * v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = v;*/
    
    NIDropDownTableViewCell *cell=nil;
    NSArray *nib=nil;
    
    nib=[[ NSBundle  mainBundle]loadNibNamed:@"NIDropDownTableViewCell" owner:self options:nil];
    
    cell=(NIDropDownTableViewCell*)[nib objectAtIndex:0];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    if ([self.imageList count] == [self.list count])
    {
    cell.lblTitle.text =[list objectAtIndex:indexPath.row];
    cell.imgVw.image = [imageList objectAtIndex:indexPath.row];
     }
    else if ([self.imageList count] > [self.list count])
    {
    cell.lblTitle.text =[list objectAtIndex:indexPath.row];
    if (indexPath.row < [imageList count]) {
        cell.imgVw.image = [imageList objectAtIndex:indexPath.row];
    }
   }
    else if ([self.imageList count] < [self.list count])
    {
    cell.lblTitle.text =[list objectAtIndex:indexPath.row];
    if (indexPath.row < [imageList count]) {
        cell.imgVw.image = [imageList objectAtIndex:indexPath.row];
    }
   }
    if(Tag==2)
    {
        if(indexPath.row ==0)
        {
            UIImageView *line = [[UIImageView alloc] init];
            line.frame=CGRectMake(0, 0, 768, 1);
            line.backgroundColor = [UIColor whiteColor];
            [cell addSubview:line];
        }
        cell.contentView.backgroundColor=[UIColor colorWithRed:0.0/255.0f green:145.0/255.0f blue:77.0/255.0f alpha:1.0f];
       /* cell.imgVw.backgroundColor=[UIColor colorWithRed:5.0/255.0f green:143.0/255.0f blue:78.0/255.0f alpha:1.0f];
        cell.imgVw.layer.cornerRadius=12.0f;
        cell.imgVw.layer.masksToBounds = YES;*/
        
        cell.lblTitle.textColor=[UIColor whiteColor];
        
        NSInteger selectedMenu = [[NSUserDefaults standardUserDefaults] integerForKey:@"selectedFoodLogMenu"];
         if (selectedMenu==indexPath.row)
        {
            cell.lblTitle.alpha=1.0;
            cell.imgVw.alpha=1.0;
         //  cell.lblTitle.textColor=[UIColor colorWithRed:5.0/255.0f green:143.0/255.0f blue:78.0/255.0f alpha:1.0f];
        }
         else
         {
             cell.lblTitle.alpha=0.6;
             cell.imgVw.alpha=0.6;
            //cell.lblTitle.textColor=[UIColor blackColor];
         }
        
        if(indexPath.row != [self.list count])
        {
            UIImageView *line = [[UIImageView alloc] init];
            line.frame=CGRectMake(0, 49, 768, 1);
            line.backgroundColor = [UIColor whiteColor];
            [cell addSubview:line];
        }
        
    }
    else if (Tag==3)
    {
        cell.imgVw.backgroundColor=[UIColor colorWithRed:183.0/255.0f green:32.0/255.0f blue:109.0/255.0f alpha:1.0f];
        cell.imgVw.layer.cornerRadius=12.0f;
        cell.imgVw.layer.masksToBounds = YES;

        NSInteger selectedMenu = [[NSUserDefaults standardUserDefaults] integerForKey:@"selectedActivityLogMenu"];

        if (selectedMenu==indexPath.row)
            {
                cell.lblTitle.textColor=[UIColor colorWithRed:183.0/255.0f green:32.0/255.0f blue:109.0/255.0f alpha:1.0f];
            }
            else
            {
                cell.lblTitle.textColor=[UIColor blackColor];
            }
        
        
        if(indexPath.row != [self.list count])
        {
            UIImageView *line = [[UIImageView alloc] init];
            line.frame=CGRectMake(0, 49, 768, 1);
            line.backgroundColor = [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1.0];
            [cell addSubview:line];
        }
     }
    else if(Tag==5 || Tag==6)
    {
       
        if(indexPath.row ==0)
        {
            UIImageView *line = [[UIImageView alloc] init];
            line.frame=CGRectMake(0, 0, 768, 1);
            line.backgroundColor = [UIColor whiteColor];
            [cell addSubview:line];
        }
        cell.contentView.backgroundColor=[UIColor colorWithRed:0.0/255.0f green:145.0/255.0f blue:77.0/255.0f alpha:1.0f];

      /*  cell.imgVw.backgroundColor=[UIColor colorWithRed:5.0/255.0f green:143.0/255.0f blue:78.0/255.0f alpha:1.0f];
        cell.imgVw.layer.cornerRadius=12.0f;
        cell.imgVw.layer.masksToBounds = YES;*/
        
        cell.lblTitle.textColor=[UIColor whiteColor];
        
        NSInteger selectedMenu = [[NSUserDefaults standardUserDefaults] integerForKey:@"selectedFavLogMenu"];
        if (selectedMenu==indexPath.row)
        {
            cell.lblTitle.alpha=1.0;
            cell.imgVw.alpha=1.0;
            //  cell.lblTitle.textColor=[UIColor colorWithRed:5.0/255.0f green:143.0/255.0f blue:78.0/255.0f alpha:1.0f];
        }
        else
        {
            cell.lblTitle.alpha=0.6;
            cell.imgVw.alpha=0.6;
            //cell.lblTitle.textColor=[UIColor blackColor];
        }
        if(indexPath.row != [self.list count])
        {
            UIImageView *line = [[UIImageView alloc] init];
            line.frame=CGRectMake(0, 49, 768, 1);
            line.backgroundColor = [UIColor whiteColor];
            [cell addSubview:line];
        }
    }

    cell.imgVw.contentMode=UIViewContentModeScaleAspectFit;
    
 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideDropDown:btnSender];
    
    UITableViewCell *c = [tableView cellForRowAtIndexPath:indexPath];
    for (UIView *subview in btnSender.subviews) {
        if ([subview isKindOfClass:[UIImageView class]]) {
            [subview removeFromSuperview];
        }
    }
    imgView.image = c.imageView.image;
    imgView = [[UIImageView alloc] initWithImage:c.imageView.image];
    imgView.frame = CGRectMake(5, 5, 25, 25);
    [btnSender addSubview:imgView];
    [self myDelegate:c.textLabel.text Index:indexPath.row];
}

- (void) myDelegate:(NSString *)selectedText Index:(NSInteger)selectedindex {
    [self.delegate niDropDownDelegateMethod:self SelectedText:selectedText selectedIndex:selectedindex tag:Tag];
}

-(void)dealloc {
    //    [super dealloc];
    //    [table release];
    //    [self release];
}

@end
