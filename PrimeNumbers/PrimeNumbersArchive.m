//
//  PrimeNumbersArchive.m
//  PrimeNumbers
//
//  Created by Dmitry Ivulyov on 27.07.15.
//  Copyright (c) 2015 Dmitry Ivulyov. All rights reserved.
//

#import "PrimeNumbersArchive.h"

@interface PrimeNumbersArchive()

@property (nonatomic, strong) NSArray *cachedArray;
@property (nonatomic, assign) BOOL isDataModifiedOnDiskSinceLastCaching;

@end

@implementation PrimeNumbersArchive

- (NSString *)primeNumbersArchivePath {
    NSString *documentsDirectory = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                            inDomains:NSUserDomainMask] lastObject] path];
    return [documentsDirectory stringByAppendingPathComponent:@"prime_numbers.dat"];
}

- (NSArray *)archivedNumbers {
    NSString *fileName = [self primeNumbersArchivePath];
    if (self.cachingEnabled) {
        if (!self.cachedArray || self.isDataModifiedOnDiskSinceLastCaching) {
            self.cachedArray = [[NSArray alloc] initWithContentsOfFile:fileName];
        }
        
        self.isDataModifiedOnDiskSinceLastCaching = NO;
        return self.cachedArray;
    }
    else {
        return [[NSArray alloc] initWithContentsOfFile:fileName];
    }
}

- (void)updateArchiveWithNumbers:(NSArray *)numbers {
    NSString *fileName = [self primeNumbersArchivePath];
    NSArray *oldResultsArray = [[NSArray alloc] initWithContentsOfFile:fileName];
    if ([numbers count] > [oldResultsArray count]) {
        [numbers writeToFile:fileName atomically:YES];
        self.isDataModifiedOnDiskSinceLastCaching = YES;
    }
}

@end
