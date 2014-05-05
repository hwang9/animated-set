//
//  SetDeck.m
//  Matchismo
//
//  Created by Henry Wang on 4/22/14.
//  Copyright (c) 2014 Henry. All rights reserved.
//

#import "SetDeck.h"
#import "SetCard.h"

@implementation SetDeck

// Initialize a Set deck by placing one card of each combination of properties into the deck
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        for (NSUInteger num = 1; num <= [SetCard maxNumber]; num++) {
            for (NSUInteger symbol = 1; symbol <= [SetCard maxNumber]; symbol++) {
                for (NSUInteger shading = 1; shading <= [SetCard maxNumber]; shading++) {
                    for (NSUInteger color = 1; color <= [SetCard maxNumber]; color++) {
                        SetCard *card = [[SetCard alloc] init];
                        card.number = num;
                        card.symbol = symbol;
                        card.shading = shading;
                        card.color = color;
                        [self addCard:card];
                    }
                }
            }
        }
    }
    
    return self;
}


@end
