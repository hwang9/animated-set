//
//  Card.m
//  Matchismo
//
//  Created by Henry Wang on 4/3/14.
//  Copyright (c) 2014 Henry. All rights reserved.
//

#import "Card.h"

@implementation Card

// Returns a score of 1 if any card in the array passed in matches this card instance, 0 otherwise.
- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    for (Card *card in otherCards) {
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
        }
    }
    
    return score;
}

//Returns the contents of this card instance
- (NSString *)description
{
    return self.contents;
}

- (NSUInteger)numOtherCardsToMatch
{
    return 0;
}

@end
