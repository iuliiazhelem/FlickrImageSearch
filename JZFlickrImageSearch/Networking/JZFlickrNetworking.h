//
//  JZFlickrNetworking.h
//  JZFlickrImageSearch
//
//  Created by Iuliia Zhelem on 10/20/16.
//  Copyright © 2016 JZhelem. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^JZSearchCompletionHandler)(NSArray *searchResult);
typedef void (^JZErrorHandler)(NSError *error);

@interface JZFlickrNetworking : NSObject

+ (void)searchImagesWithName:(NSString *)name completionHandler:(JZSearchCompletionHandler)completionHandler errorHandler:(JZErrorHandler)errorHandler;

@end
