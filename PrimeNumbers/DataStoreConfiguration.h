//
//  DataStoreConfiguration.h
//  PrimeNumbers
//
//  Created by Dmitry Ivulyov on 26.07.15.
//  Copyright (c) 2015 Dmitry Ivulyov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataStoreConfiguration : NSObject

@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
