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

typedef NS_ENUM(UInt8, JZImageSize) {
    JZImageSizeThumbnail,//t	thumbnail, 100 on longest side
    JZImageSizeMedium, //z	medium 640, 640 on longest side
    JZImageSizeLarge, //b	large, 1024 on longest side
};

@interface JZFlickrNetworking : NSObject

+ (void)searchImagesWithName:(NSString *)name completionHandler:(JZSearchCompletionHandler)completionHandler errorHandler:(JZErrorHandler)errorHandler;

+ (NSURL *)createImageURLFromJSON:(NSDictionary *)imageData withSize:(JZImageSize)imageSize;

+ (NSURLRequest *)createImageURLRequestFromJSON:(NSDictionary *)imageData withSize:(JZImageSize)imageSize;

@end
