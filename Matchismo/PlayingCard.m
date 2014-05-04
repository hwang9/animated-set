//
//  PlayingCard.m
//  Matchismo
//
//  Created by Henry Wang on 4/3/14.
//  Copyright (c) 2014 Henry. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

// This method is similar to what was written in lecture
- (int) match:(NSArray *)otherCards
{
    int score = 0;
    
    for (id card in otherCards) {
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *otherCard = (PlayingCard *)card;
            score += [self matchWith:otherCard];
        }
    }
    
    return score;
}


// This helper method returns the appropriate score for a single match between two cards.
- (int) matchWith:(PlayingCard *)otherCard
{
    if ([self.suit isEqualToString:otherCard.suit]) {
        return 2;
    } else if (self.rank == otherCard.rank) {
        return 6;
    }
    return 0;
}

// Overrides the getter in the superclass by doing something more sensible for a PlayingCard.
- (NSString *)contents
{
    return [[PlayingCard rankStrings][self.rank]stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

// Returns an array of valid suits in poker.
+ (NSArray *)validSuits
{
    return @[@"♣", @"♥", @"♦", @"♠"];
}

// Overrides setter for suit to include a sanity check.
- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit])
    {
        _suit = suit;
    }
}

// Overrides getter for suit to assign a value to nil.
- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

// Returns the max rank a PlayingCard can have.
+ (NSUInteger)maxRank
{
    return [[self rankStrings] count]-1;
}

// Returns an array of valid PlayingCard ranks.
+ (NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

// Overrides the superclass's method to specify that a playing card can only match with one other playing card.
- (NSUInteger)numOtherCardsToMatch
{
    return 1;
}



@end
