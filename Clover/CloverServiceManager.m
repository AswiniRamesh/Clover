//
//  CloverServiceManager.m
//  Clover
//
//  Created by Aswini Ramesh on 5/26/17.
//  Copyright © 2017 Aswini Ramesh. All rights reserved.
//

#import "CloverServiceManager.h"

@implementation CloverServiceManager

+ (instancetype)sharedInstance
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[[self class] alloc] init];
        
    });
    
    
    return _sharedInstance;
}
- (void)getDataWebServiceForAcronym:(NSString *)acronym andCompletion:(void (^)(NSMutableArray *, NSError *))completion
{
    NSString *getDataString = [BASE_URL stringByAppendingString:acronym];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:getDataString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         NSError *error = nil;
         NSMutableArray *arr = (NSMutableArray*)responseObject;
         NSLog(@"response%@",arr);
         
         if (!error)
             completion(arr, nil);
         else
             completion(nil, error);
         
         
         
     } failure:^(NSURLSessionTask *operation, NSError *error) {
         
         if (completion)
             completion(nil, error);
         
     }];
}


@end
