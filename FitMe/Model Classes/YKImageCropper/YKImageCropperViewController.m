//
//  YKImageCropperViewController.m
//  Copyright (c) 2013 yuyak. All rights reserved.
//

#import "YKImageCropperViewController.h"
#import "UserInfoViewController.h"
#import "YKImageCropperView.h"
#import "UserInfoViewController.h"
@interface YKImageCropperViewController ()
{
    BOOL _mediaTypeImage;
    NSString *_mediaPath;
    
}

@property (nonatomic, strong) YKImageCropperView *imageCropperView;

@end

@implementation YKImageCropperViewController

- (id)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"Crop Photo", @"");
        self.imageCropperView = [[YKImageCropperView alloc] initWithImage:image];
        [self.view addSubview:self.imageCropperView];

//        [self.navigationController.toolbar setBarTintColor:[UIColor colorWithRed:208.0/255.0 green:24.0/255.0 blue:101.0/255.0 alpha:1.0]];
//        [self.navigationController.toolbar setTranslucent:NO];
        
        
      /*  UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCancel.frame=CGRectMake(0,0, 80, 30);
        [btnCancel setTitle:@"Constrain" forState:UIControlStateNormal];
        [btnCancel setTitleColor:[UIColor blueColor]   forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(constrainAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithCustomView:btnCancel];*/
        
        UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDone.frame=CGRectMake(80,0, 100, 30);
        [btnDone setTitle:@"Reset" forState:UIControlStateNormal];
        [btnDone setTitleColor:[UIColor blueColor]   forState:UIControlStateNormal];
        [btnDone addTarget:self.imageCropperView action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithCustomView:btnDone];
        
        UIButton *btnSpace = [UIButton buttonWithType:UIButtonTypeCustom];
        btnSpace.frame=CGRectMake(0,0, 80, 30);
        [btnSpace setTitle:@"" forState:UIControlStateNormal];
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithCustomView:btnSpace];
        
        //self.toolbarItems = @[cancelButton,flexible ,doneButton];
        self.toolbarItems = @[flexible,doneButton];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                              target:self
                                                                                              action:@selector(cancelAction)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                               target:self
                                                                                               action:@selector(doneAction)];

      /*  UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil
                                                                               action:nil];
        UIBarButtonItem *constrainButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Constrain", @"")
                                                                            style:UIBarButtonItemStyleBordered
                                                                           target:self
                                                                           action:@selector(constrainAction)];
        UIBarButtonItem *revertButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Reset", @"")
                                                                            style:UIBarButtonItemStyleBordered
                                                                           target:self.imageCropperView
                                                                           action:@selector(reset)];*/

        //self.toolbarItems = @[space, constrainButton, space, revertButton, space];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)constrainAction {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"Square", @""),
                                                                      NSLocalizedString(@"3 x 2", @""),
                                                                      NSLocalizedString(@"4 x 3", @""),
                                                                      NSLocalizedString(@"16 x 9", @""),
                                                                      nil];
    [actionSheet showInView:self.view.window];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) return;

    switch (buttonIndex) {
        case 0:
            [self.imageCropperView setConstrain:CGSizeMake(1, 1)];
            break;

        case 1:
            [self.imageCropperView setConstrain:CGSizeMake(3, 2)];
            break;

        case 2:
            [self.imageCropperView setConstrain:CGSizeMake(4, 3)];
            break;

        case 3:
            [self.imageCropperView setConstrain:CGSizeMake(16, 9)];
            break;
    }
}

- (void)cancelAction {
   /* if (self.cancelHandler)
        self.cancelHandler();*/
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneAction {
    NSLog(@"* Done");
   // NSLog(@"Original: %@, Edited: %@", NSStringFromCGSize(squareImage.size), NSStringFromCGSize(editedImage.size));

   // NSData *imgData = UIImageJPEGRepresentation([self.imageCropperView editedImage], 1);
    NSData *imgData =UIImagePNGRepresentation([self.imageCropperView editedImage]);
    
     [self dismissViewControllerAnimated:YES completion:nil];
    /*if (self.doneHandler)
        self.doneHandler([self.imageCropperView editedImage]);*/
}

@end