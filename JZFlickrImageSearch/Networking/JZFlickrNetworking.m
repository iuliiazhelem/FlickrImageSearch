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

@end
