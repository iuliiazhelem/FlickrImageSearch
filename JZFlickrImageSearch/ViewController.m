//
//  ViewController.m
//  JZFlickrImageSearch
//
//  Created by Iuliia Zhelem on 10/20/16.
//  Copyright © 2016 JZhelem. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UISearchBarDelegate>

@end

@implementation ViewController

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"self.searchBar.text");
    [searchBar resignFirstResponder];
}

@end
