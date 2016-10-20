//
//  ViewController.m
//  JZFlickrImageSearch
//
//  Created by Iuliia Zhelem on 10/20/16.
//  Copyright © 2016 JZhelem. All rights reserved.
//

#import "ViewController.h"
#import "JZFlickrNetworking.h"
#import "JZPhotoCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "JZPhotoViewController.h"

@interface ViewController ()<UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *imagesCollectionView;

@property (strong, nonatomic) NSArray *searchResult;

@end

@implementation ViewController

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
    [JZFlickrNetworking searchImagesWithName:searchBar.text completionHandler:^(NSArray *searchResult) {
        self.searchResult = searchResult;
    } errorHandler:^(NSError *error) {
        [self showError:error];
    }];
}

- (void)setSearchResult:(NSArray *)searchResult {
    _searchResult = searchResult;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.imagesCollectionView reloadData];
    });
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.searchResult.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JZPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JZPhotoCollectionViewCell" forIndexPath:indexPath];
    
    if (indexPath.row < _searchResult.count) {
        NSURLRequest *request = [JZFlickrNetworking createImageURLRequestFromJSON:_searchResult[indexPath.row] withSize:JZImageSizeThumbnail];
        
        __weak typeof(JZPhotoCollectionViewCell *) weakCell = cell;
        //Asynchronously downloads an image from the specified URL, and sets it once
        //the request is finished. Any previous image request for the receiver will be
        //automatically cancelled.
        [cell.imageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"placeholder"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            weakCell.imageView.image = image;
        } failure:nil];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"placeholder"];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JZPhotoCollectionViewCell *photoCell = (JZPhotoCollectionViewCell *)cell;
    [photoCell.imageView cancelImageDownloadTask];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JZPhotoViewController *vc = (JZPhotoViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"JZPhotoViewController"];

    vc.photoURL = [JZFlickrNetworking createImageURLFromJSON:_searchResult[indexPath.row] withSize:JZImageSizeLarge];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        vc.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)showError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ImageSearch Error" message:error.userInfo[@"message"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

@end
