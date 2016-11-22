//
//  HelpViewController.m
//  FitMe
//
//  Created by Debasish on 27/07/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import "HelpViewController.h"
#import "SettingsViewController.h"
#import "collectionViewCellClass.h"
#import "AppDelegate.h"
#import "AFJSONRequestOperation.h"
#import "FAQViewController.h"
#define LC_URL              "https://cdn.livechatinc.com/app/mobile/urls.json"
#define LC_LICENSE          "3498581"
#define LC_CHAT_GROUP       "0"

@interface HelpViewController ()
{
    NSMutableArray *arrHelpLblTitle,*arrHelpImg;
    __weak IBOutlet UILabel *helpText;
    Devicefamily family;
    
}
@property (nonatomic, strong) NSString *chatURL;

- (void) requestUrl;
- (NSString*) prepareUrl:(NSString *)url;
- (void) startChat:(UIButton*)button;

@end

@implementation HelpViewController

#pragma mark - UIView LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arrHelpImg=[[NSMutableArray alloc]initWithObjects:@"Email@3x.png",@"Chat_color@3x.png",@"FAQ@3x.png",@"PDF@3x.png", nil];
     [self createTitleNavigationView:@"Help"];
    
    arrHelpLblTitle= [[NSMutableArray alloc] initWithObjects:@"info@measupro.com",@"Chat with Us",@"Questions & Answers",@"User Manual",nil];

    UINib *cellNib = [UINib nibWithNibName:[self getNibName:@"PhotoCell"] bundle:nil];
    [_helpCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"CollectionViewCELL"];
    
    _helpCollectionView.showsVerticalScrollIndicator = FALSE;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    NSLog(@"==%f,==%f",screenWidth/2,screenHeight);
    [flowLayout setItemSize:CGSizeMake(screenWidth/2, (screenHeight-160.0)/2)];
    
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [_helpCollectionView setCollectionViewLayout:flowLayout];

      family=thisDeviceFamily();
    if(family == iPad){
       [helpText setFont:[UIFont fontWithName:@"SinkinSans-300Light" size:21]];
    
    }
    else{
    
     if([self isIphoneSixPlus]){
        [helpText setFont:[UIFont fontWithName:@"SinkinSans-300Light" size:17]];
        
      }
        
    }
    //////////////////  for chat ///////
    [self requestUrl];
 }

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.helpNavigation=self.navigationController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UINavigation Button Action
-(void)showLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)showRight
{
    SettingsViewController *mVerificationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    mVerificationViewController.navClass=@"settings";
    [self.navigationController pushViewController:mVerificationViewController animated:YES];
}

#pragma mark - Collection View Delegate
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0,0,0,0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}
-(collectionViewCellClass *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CollectionViewCELL";
    collectionViewCellClass *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[collectionViewCellClass alloc] initWithFrame:CGRectMake(0, 0, 300, 500)];
        /*   cell.cellImage= [[UIImageView alloc] init];
         cell.cellImage.tag = 10;
         [cell.contentView addSubview:cell.cellImage];*/
    }
    else{
        //Old cell...get previously createdd imageview
        // cell.cellImage = (UIImageView*)[cell.contentView viewWithTag:10];
    }
    if(family == iPad){
        [cell.cellLabel setFont:[UIFont fontWithName:@"SinkinSans-200XLight" size:20]];
        
    }
    else{

    if([self isIphoneSixPlus]){
        
        cell.cellLabel.font=[UIFont fontWithName:@"SinkinSans-200XLight" size:15];
      }
    }
    switch (indexPath.item) {
        case 0:
        {
            cell.cellLabel.textColor=[UIColor colorWithRed:78.0/255.0f green:161.0/255.0f blue:191.0/255.0f alpha:1.0f];
        }
            break;
        case 1:
        {
            cell.cellLabel.textColor=[UIColor colorWithRed:45.0/255.0f green:150.0/255.0f blue:81.0/255.0f alpha:1.0f];
        }
            break;
        case 2:
        {
            cell.cellLabel.textColor=[UIColor colorWithRed:173.0/255.0f green:21.0/255.0f blue:104.0/255.0f alpha:1.0f];
        }
            break;
        case 3:
        {
            cell.cellLabel.textColor=[UIColor colorWithRed:27.0/255.0f green:63.0/255.0f blue:89.0/255.0f alpha:1.0f];
          }
            break;
        default:
            break;
    }
    
    
    cell.cellLabel.text =[arrHelpLblTitle objectAtIndex:indexPath.row];
    cell.cellLabel.adjustsFontSizeToFitWidth=YES;
    cell.cellLabel.minimumScaleFactor=0.7;
    
    [cell.cellImage setImage:[UIImage imageNamed:[arrHelpImg objectAtIndex:indexPath.row]]];
    
    cell.cellImage.contentMode = UIViewContentModeScaleAspectFit;
    
    cell.layer.borderWidth=1.0f;
    cell.layer.borderColor=[UIColor colorWithRed:217.0/255.0f green:217.0/255.0f blue:217.0/255.0f alpha:1.0f].CGColor;
    
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected Item : %ld",(long)indexPath.row);
    if(indexPath.row==0)
    {
        NSString *strTitle=@"FitMi App";
        UIImage *img=[UIImage imageNamed:@"App_iCon-120.png"];
        //        mail *send=[[mail alloc] init];
        //        [send mailWithVC:self withMessage:strTitle withImage:img];
        
        if(![self callForSendingMail])
            return;
        
        MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
        mailComposer.mailComposeDelegate = self;
        //mailComposer.title=@"FitMi App";
        
        [mailComposer setSubject:strTitle];
        NSArray * arrReceipents = [[NSArray alloc] initWithObjects:@"", nil];
        [mailComposer setToRecipients:arrReceipents];
        
        NSArray * arrCCReceipents = [[NSArray alloc] initWithObjects:@"", nil];
        if(arrCCReceipents.count>0)
            [mailComposer setCcRecipients:[NSArray arrayWithArray:arrCCReceipents]];
        
        /* NSString *emailBody = [NSString stringWithFormat:@"Please find the location details for the following:</br></br>Insured:  %@</br>Latitude: %@</br>Longitude: %@</br>Comments: %@",insuredNameStr,Lat,lng,comment ];*/
        NSString *emailBody =@"FitMi App";
        [mailComposer setMessageBody:emailBody isHTML:NO];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *fileName =[NSString stringWithFormat:@"1.png"];
        
        fileName = [documentsDirectory stringByAppendingPathComponent:fileName];
        // NSData *imageData = [NSData dataWithContentsOfFile:fileName];
        
        NSString *mimeType=[@"" stringByAppendingFormat:@"image/png"];
        NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(img, 0.6)];
        [mailComposer addAttachmentData:imageData mimeType:mimeType fileName:fileName];
        
        //  [mailComposer setEditing:TRUE];
        
        [self presentViewController:mailComposer animated:YES completion:nil];
 
    }
    else if (indexPath.row==1){
        if (!self.chatViewController) {
            self.chatViewController = [[LCCChatViewController alloc] initWithChatUrl:self.chatURL];
        }
       [self.navigationController pushViewController:self.chatViewController animated:YES];
    
    
    }
    else if (indexPath.row==2){
      
      FAQViewController  *FAQVwCont = [[FAQViewController alloc] init];
        [self.navigationController pushViewController:FAQVwCont animated:YES];

    }
  //  [self imagePreviewFunction : indexPath.row];
}

-(BOOL)callForSendingMail
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        if ([mailClass canSendMail])
        {
            return YES;
        }
        else
        {
            [self launchMailAppOnDevice];
        }
    }
    else
    {
        [self launchMailAppOnDevice];
    }
    
    return NO;
}
-(void)launchMailAppOnDevice
{
    NSString *emailBody = @"";
    NSString *recipients = [NSString stringWithFormat:@"mailto:?to=%@&subject=%@",@"",@""];
    NSString *body = [NSString stringWithFormat:@"&body=%@",emailBody];
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

#pragma mark Compose Mail
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"%@", @"Result: canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"%@", @"Result: saved");
            break;
        case MFMailComposeResultSent:
            [self createAlertView:@"" withAlertMessage:@"Your Mail was sent Successfully." withAlertTag:5];
            NSLog(@"%@", @"Result: sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"%@", @"Result: failed");
            break;
        default:
            NSLog(@"%@", @"Result: not sent");
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self dismissModalViewControllerAnimated:YES];
}
#pragma mark Tasks

- (void)requestUrl
{
    void(^successHandler)(NSURLRequest*, NSHTTPURLResponse*, id) = ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if ([JSON isKindOfClass:[NSDictionary class]]) {
            self.chatURL = [self prepareUrl:JSON[@"chat_url"]];
        }
    };
    
    void(^failureHandler)(NSURLRequest*, NSHTTPURLResponse*, NSError*, id) = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"%@", error);
    };
    
    NSURL *url = [NSURL URLWithString:@LC_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:successHandler
                                                                                        failure:failureHandler];
    [operation start];
}

#pragma mark -
#pragma mark Helper functions

- (NSString *)prepareUrl:(NSString *)url
{
    NSMutableString *string = [NSMutableString stringWithFormat:@"https://%@", url];
    
    [string replaceOccurrencesOfString:@"{%license%}"
                            withString:@LC_LICENSE
                               options:NSLiteralSearch
                                 range:NSMakeRange(0, [string length])];
    
    [string replaceOccurrencesOfString:@"{%group%}"
                            withString:@LC_CHAT_GROUP
                               options:NSLiteralSearch
                                 range:NSMakeRange(0, [string length])];
    
    return string;
}


@end
