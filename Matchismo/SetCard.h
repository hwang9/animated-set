//
//  SetCard.h
//  Matchismo
//
//  Created by Henry Wang on 4/22/14.
//  Copyright (c) 2014 Henry. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

// The 4 properties of every Set card
@property (nonatomic) NSUInteger number;
@property (nonatomic) NSString *symbol;
@property (nonatomic) NSNumber *shading;
@property (nonatomic) NSUInteger color;

// Class methods to help with deck construction
+ (NSUInteger)maxNumber;
+ (NSArray *)validSymbols;
+ (NSArray *)validShadings;
+ (NSUInteger)maxColor;

@end
