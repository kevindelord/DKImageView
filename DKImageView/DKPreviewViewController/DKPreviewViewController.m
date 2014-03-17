//
//  DKPreviewViewController.m
//  DKImageView
//
//  Created by Kévin Delord on 3/17/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import "DKPreviewViewController.h"

@implementation DKPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.imageView setImage:self.image];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
