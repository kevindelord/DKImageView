//
//  DKViewController.m
//  DKImageView
//
//  Created by Kévin Delord on 2/23/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import "DKAppDelegate.h"
#import "DKViewController.h"
#import "DKPreviewViewController.h"

@interface DKViewController ()

@end

@implementation DKViewController

- (IIViewDeckController *)viewDeckController {
    return ((DKAppDelegate *)[[UIApplication sharedApplication] delegate]).viewDeckController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - Action methods

- (IBAction)menu {
    [self.viewDeckController toggleLeftViewAnimated:YES];
}

- (IBAction)preview {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    DKPreviewViewController *previewVC = (DKPreviewViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"previewVC"];
    previewVC.image = self.imageView.croppedImage;
    [self presentViewController:previewVC animated:YES completion:nil];
}

@end
