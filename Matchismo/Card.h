//
//  Card.h
//  Matchismo
//
//  Created by Henry Wang on 4/3/14.
//  Copyright (c) 2014 Henry. All rights reserved.
//

// This file and the corresponding implementation file are copied straight from lecture slides. No additional implementation was added.

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (nonatomic, strong) NSString *contents;

@property (nonatomic, getter = isChosen) BOOL chosen;
@property (nonatomic, getter = isMatched) BOOL matched;

// Simple matching algorithm, will be overridden in subclasses
- (int)match:(NSArray *)otherCards;

// Every game will have a different number of cards to match against. Keep this abstract
- (NSUInteger)numOtherCardsToMatch;

@end
