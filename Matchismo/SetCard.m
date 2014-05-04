//
//  SetCard.m
//  Matchismo
//
//  Created by Henry Wang on 4/22/14.
//  Copyright (c) 2014 Henry. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

// Overrides the superclass's methods to match Set cards against each other. Broken down into 4 subcategories to implement the 4 different rules of Set.
- (int) match:(NSArray *) otherCards
{
    int score = 0;
    
    if([otherCards count] == 2) {
        if([self matchNumber:otherCards] && [self matchSymbol:otherCards] && [self matchShading:otherCards] && [self matchColor:otherCards]) {
            score += 4;
        }
    }
    
    return score;
}

// Returns true if all 3 numbers are the same or all 3 are different. False otherwise
- (BOOL)matchNumber:(NSArray *)otherCards
{
    BOOL ret = FALSE;
    id card1 = otherCards[0];
    id card2 = otherCards[1];
    if ([card1 isKindOfClass:[SetCard class]] && [card2 isKindOfClass:[SetCard class]]) {
        SetCard *setCard1 = (SetCard *)card1;
        SetCard *setCard2 = (SetCard *)card2;
        if (self.number == setCard1.number && self.number == setCard2.number)
            ret = TRUE;
        else if (self.number != setCard1.number && self.number != setCard2.number && setCard1.number != setCard2.number)
            ret = TRUE;
    }
    
    return ret;
}

// Returns true if all 3 symbols are the same or all 3 are different. False otherwise
- (BOOL)matchSymbol:(NSArray *)otherCards
{
    BOOL ret = FALSE;
    id card1 = otherCards[0];
    id card2 = otherCards[1];
    if ([card1 isKindOfClass:[SetCard class]] && [card2 isKindOfClass:[SetCard class]]) {
        SetCard *setCard1 = (SetCard *)card1;
        SetCard *setCard2 = (SetCard *)card2;
        if ([self.symbol isEqualToString:setCard1.symbol]  && [self.symbol isEqualToString:setCard2.symbol])
            ret = TRUE;
        else if (![self.symbol isEqualToString:setCard1.symbol] && ![self.symbol isEqualToString:setCard2.symbol] && ![setCard1.symbol isEqualToString:setCard2.symbol])
            ret = TRUE;
    }
    return ret;
}

// Returns true if all 3 shadings are the same or all 3 are different. False otherwise
- (BOOL)matchShading:(NSArray *)otherCards
{
    BOOL ret = FALSE;
    id card1 = otherCards[0];
    id card2 = otherCards[1];
    if ([card1 isKindOfClass:[SetCard class]] && [card2 isKindOfClass:[SetCard class]]) {
        SetCard *setCard1 = (SetCard *)card1;
        SetCard *setCard2 = (SetCard *)card2;
        if ([self.shading isEqualToNumber:setCard1.shading] && [self.shading isEqualToNumber:setCard2.shading])
            ret = TRUE;
        else if (![self.shading isEqualToNumber:setCard1.shading] && ![self.shading isEqualToNumber:setCard2.shading] && ![setCard1.shading isEqualToNumber:setCard2.shading])
            ret = TRUE;
    }
    return ret;
}

// Returns true if all 3 colors are the same or all 3 are different. False otherwise
- (BOOL)matchColor:(NSArray *)otherCards
{
    BOOL ret = FALSE;
    id card1 = otherCards[0];
    id card2 = otherCards[1];
    if ([card1 isKindOfClass:[SetCard class]] && [card2 isKindOfClass:[SetCard class]]) {
        SetCard *setCard1 = (SetCard *)card1;
        SetCard *setCard2 = (SetCard *)card2;
        if ((self.color == setCard1.color)  && (self.color == setCard2.color))
            ret = TRUE;
        else if ((self.color != setCard1.color) && (self.color !=setCard2.color) && (setCard1.color != setCard2.color))
            ret = TRUE;
    }
    return ret;
}

// We cannot easily represent the contents of a set card without UI, so we will not be using this property.
- (NSString *)contents
{
    return nil;
}

// A card can only have up to 3 symbols
+ (NSUInteger)maxNumber
{
    return 3;
}

// Returns an array of the three valid symbols on a Set card.
+ (NSArray *)validSymbols
{
    return @[@"▲", @"●", @"■"];
}

// Returns an array of the three valid shadings on a Set card.
+ (NSArray *)validShadings
{
    return @[@0.0, @0.3, @1.0];
}

// A card can only have one of 3 different colors
+ (NSUInteger)maxColor
{
    return 3;
}

// Overrides the superclass's method to specify that we need 2 other cards to match with our current card.
- (NSUInteger)numOtherCardsToMatch
{
    return 2;
}

@end
