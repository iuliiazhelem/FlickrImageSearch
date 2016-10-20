//
//  ViewController.m
//  JZFlickrImageSearch
//
//  Created by Iuliia Zhelem on 10/20/16.
//  Copyright © 2016 JZhelem. All rights reserved.
//

#import "ViewController.h"
#import "JZFlickrNetworking.h"

@interface ViewController ()<UISearchBarDelegate>

@end

@implementation ViewController

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
    [JZFlickrNetworking searchImagesWithName:searchBar.text completionHandler:^(NSArray *searchResult) {
        NSLog(@"RESULT : %@", searchResult);
    } errorHandler:^(NSError *error) {
        NSLog(@"ERROR : %@", error);
    }];
}

@end
