//
//  PrimeNumbersArchive.h
//  PrimeNumbers
//
//  Created by Dmitry Ivulyov on 27.07.15.
//  Copyright (c) 2015 Dmitry Ivulyov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PrimeNumbersArchive : NSObject

- (NSArray *)archivedNumbers;
- (void)updateArchiveWithNumbers:(NSArray *)numbers;

@end
