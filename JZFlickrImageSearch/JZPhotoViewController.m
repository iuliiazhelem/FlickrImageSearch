//
//  JZPhotoViewController.m
//  JZFlickrImageSearch
//
//  Created by Iuliia Zhelem on 10/20/16.
//  Copyright © 2016 JZhelem. All rights reserved.
//

#import "JZPhotoViewController.h"
#import "UIImageView+AFNetworking.h"

@interface JZPhotoViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)clickCloseButton:(id)sender;

@end

@implementation JZPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.imageView setImageWithURL:self.photoURL
                   placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotationWithGestureRecognizer:)];
    [self.imageView addGestureRecognizer:rotationGestureRecognizer];
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchZoomWithGestureRecognizer:)];
    [self.imageView addGestureRecognizer:pinchGestureRecognizer];
    
    self.scrollView.contentSize=self.imageView.frame.size;
}

-(void)handlePinchZoomWithGestureRecognizer:(UIPinchGestureRecognizer *)pinchGestureRecognizer {
    self.imageView.transform = CGAffineTransformScale(self.imageView.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
    pinchGestureRecognizer.scale = 1.0;
    self.scrollView.contentSize = self.imageView.frame.size;
    
}
-(void)handleRotationWithGestureRecognizer:(UIRotationGestureRecognizer *)rotationGestureRecognizer{
    self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, rotationGestureRecognizer.rotation);
    
    rotationGestureRecognizer.rotation = 0.0;
}

- (IBAction)clickCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
