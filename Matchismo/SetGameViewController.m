//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Henry Wang on 4/22/14.
//  Copyright (c) 2014 Henry. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetDeck.h"
#import "SetCard.h"

@interface SetGameViewController ()

@end

@implementation SetGameViewController


// Override the superclass's method by calling alloc/init on the proper deck
- (Deck *)createDeck
{
    return [[SetDeck alloc] init];
}

// Override the superclass's method by simply using the attributed string for the card, since this will always be displayed on the card
- (NSAttributedString *)attTitleForCard:(Card *)card
{
    return [self buildCardAttString:card];
}

// Override the superclass's method by returning the proper string representing the card
- (NSAttributedString *) buildCardAttString:(Card *)card
{
    NSString *str = @"";
    NSMutableAttributedString *attStr;
    if ([card isKindOfClass:[SetCard class]]) {
        SetCard *setcard = (SetCard *)card;
        for (NSUInteger num=0; num < setcard.number; num++) {
            str = [str stringByAppendingString:setcard.symbol];
        }
        
        if (setcard.color == 1) {
            attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:1 green:0 blue:0 alpha:[setcard.shading floatValue]]}];
            if ([setcard.shading isEqualToNumber:@(0.0)]) {
                NSRange range = NSMakeRange(0, [attStr length]);
                [attStr addAttributes:@{NSStrokeWidthAttributeName:@(-5), NSStrokeColorAttributeName:[UIColor redColor]} range:range];
            }
        }
        if (setcard.color == 2) {
            attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0 green:1 blue:0 alpha:[setcard.shading floatValue]]}];
            if ([setcard.shading isEqualToNumber:@(0.0)]) {
                NSRange range = NSMakeRange(0, [attStr length]);
                [attStr addAttributes:@{NSStrokeWidthAttributeName:@(-5), NSStrokeColorAttributeName:[UIColor greenColor]} range:range];
            }
        }
        if (setcard.color == 3) {
            attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0 green:0 blue:1 alpha:[setcard.shading floatValue]]}];
            if ([setcard.shading isEqualToNumber:@(0.0)]) {
                NSRange range = NSMakeRange(0, [attStr length]);
                [attStr addAttributes:@{NSStrokeWidthAttributeName:@(-5), NSStrokeColorAttributeName:[UIColor blueColor]} range:range];
            }
        }
        
        return attStr;
    }
    return nil;
}

// Override the superclass's method by returning the proper images for the card when (un)chosen
- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfronttint" : @"cardfront"];
}


@end
