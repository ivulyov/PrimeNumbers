//
//  PrimeNumbersGenerator.m
//  PrimeNumbers
//
//  Created by Dmitry Ivulyov on 26.07.15.
//  Copyright (c) 2015 Dmitry Ivulyov. All rights reserved.
//

#import "PrimeNumbersGenerator.h"

@interface PrimeNumbersGenerator()

@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, assign) BOOL isCanceled;

@end

@implementation PrimeNumbersGenerator

- (id)initWithLimit:(NSInteger)limit {
    self = [super init];
    if (self) {
        self.limit = limit;
    }
    return self;
}

- (void)generateWithCompletionBlock:(void (^)(NSArray *))completionBlock {
    self.isGenerating = YES;
    self.isCanceled = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (self.isCanceled) {
            return;
        }
        BOOL *primes = malloc(sizeof(BOOL) * self.limit);
        
        for (NSInteger i = 2; i < self.limit; i++) {
            if (self.isCanceled) {
                return;
            }
            primes[i] = YES;
        }
        
        for (NSInteger i = 2; i < self.limit; i++) {
            if (self.isCanceled) {
                return;
            }
            if (primes[i]) {
                for (NSInteger j = i; i * j < self.limit; j++) {
                    if (self.isCanceled) {
                        return;
                    }
                    primes[i * j] = NO;
                }
            }
        }
        
        NSMutableArray *results = [NSMutableArray new];
        for (NSInteger i = 2; i < self.limit; i++) {
            if (self.isCanceled) {
                return;
            }
            if (primes[i]) {
                [results addObject:@(i)];
            }
        }
        
        completionBlock(results);
        self.isGenerating = NO;
    });
}

- (void)cancelGeneration {
    self.isCanceled = YES;
    self.isGenerating = NO;
}

@end
