//
//  CloverServiceManager.h
//  Clover
//
//  Created by Aswini Ramesh on 5/26/17.
//  Copyright © 2017 Aswini Ramesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "CloverDefines.h"

@interface CloverServiceManager : NSObject
+ (CloverServiceManager *)sharedInstance;


- (void)getDataWebServiceForAcronym:(NSString*) acronym andCompletion:(void(^)(NSMutableArray *arr, NSError *error))completion;


@end
