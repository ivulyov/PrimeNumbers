//
//  PrimeNumbersGenerator.h
//  PrimeNumbers
//
//  Created by Dmitry Ivulyov on 26.07.15.
//  Copyright (c) 2015 Dmitry Ivulyov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PrimeNumbersGenerator;

@interface PrimeNumbersGenerator : NSObject

@property (nonatomic, assign) BOOL isGenerating;

- (id)initWithLimit:(NSInteger)limit;
- (void)generateWithCompletionBlock:(void (^)(NSArray *result))completionBlock;
- (void)cancelGeneration;

@end
