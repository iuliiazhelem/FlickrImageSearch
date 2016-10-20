//
//  JZPhotoViewController.m
//  JZFlickrImageSearch
//
//  Created by Iuliia Zhelem on 10/20/16.
//  Copyright © 2016 JZhelem. All rights reserved.
//

#import "JZPhotoViewController.h"
#import "UIImageView+AFNetworking.h"

@interface JZPhotoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)clickCloseButton:(id)sender;

@end

@implementation JZPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.imageView setImageWithURL:self.photoURL
                   placeholderImage:[UIImage imageNamed:@"placeholder"]];
}

- (IBAction)clickCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
