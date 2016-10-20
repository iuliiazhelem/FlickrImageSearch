//
//  JZFlickrNetworking.m
//  JZFlickrImageSearch
//
//  Created by Iuliia Zhelem on 10/20/16.
//  Copyright © 2016 JZhelem. All rights reserved.
//

#import "JZFlickrNetworking.h"

static NSString *kFlickrApiKey = @"1bc2b94129342ef59b9bb253fbf4ab71";
static NSUInteger kImagesPerPage = 50;

@implementation JZFlickrNetworking

+ (void)searchImagesWithName:(NSString *)name completionHandler:(JZSearchCompletionHandler)completionHandler errorHandler:(JZErrorHandler)errorHandler {
    
    NSString *searchName = [name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&text=%@&per_page=%lu&format=json&nojsoncallback=1", kFlickrApiKey, searchName, (unsigned long)kImagesPerPage]];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error && errorHandler) {
            errorHandler(error);
            return;
        }
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([json[@"stat"] isEqualToString:@"ok"]) {
            NSDictionary *photos = json[@"photos"];
            
            if (photos && completionHandler) {
                completionHandler(photos[@"photo"]);
            }
        } else {
            if (errorHandler) {
                errorHandler([[self class] errorWithJSON:json]);
            }
        }
        
    }] resume];
}

+ (NSError *)errorWithJSON:(NSDictionary *)json {
    return [NSError errorWithDomain:@"JZFlickrImageSearch" code:[json[@"code"] integerValue] userInfo:@{@"message": json[@"message"]}];
}

+ (NSURL *)createImageURLFromJSON:(NSDictionary *)imageData withSize:(JZImageSize)imageSize {
    //https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
    NSString *imgSize;
    switch (imageSize) {
        case JZImageSizeThumbnail:
            imgSize = @"t";
            break;
        case JZImageSizeMedium:
            imgSize = @"z";
            break;
        default:
            imgSize = @"b";
            break;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_%@.jpg", imageData[@"farm"], imageData[@"server"], imageData[@"id"], imageData[@"secret"], imgSize];
    
    return [NSURL URLWithString:urlString];
}

+ (NSURLRequest *)createImageURLRequestFromJSON:(NSDictionary *)imageData withSize:(JZImageSize)imageSize {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self.class createImageURLFromJSON:imageData withSize:imageSize]];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    return request;
}

@end
