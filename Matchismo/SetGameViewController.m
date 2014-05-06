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

- (NSUInteger)numCardsAtStart
{
    return 12;
}

// Override the superclass's method by simply using the attributed string for the card, since this will always be displayed on the card
- (NSAttributedString *)attTitleForCard:(Card *)card
{
    NSString *str = @"";
    NSMutableAttributedString *attStr;
    if ([card isKindOfClass:[SetCard class]]) {
        SetCard *setcard = (SetCard *)card;
        for (NSUInteger num=0; num < setcard.number; num++) {
            str = [str stringByAppendingString:[self getSymbol:setcard.symbol]];
        }
        
        if (setcard.color == 1) {
            attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:1 green:0 blue:0 alpha:[self getShading:setcard.shading]]}];
            if (setcard.shading == 1) {
                NSRange range = NSMakeRange(0, [attStr length]);
                [attStr addAttributes:@{NSStrokeWidthAttributeName:@(-5), NSStrokeColorAttributeName:[UIColor redColor]} range:range];
            }
        }
        if (setcard.color == 2) {
            attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0 green:1 blue:0 alpha:[self getShading:setcard.shading]]}];
            if (setcard.shading == 1) {
                NSRange range = NSMakeRange(0, [attStr length]);
                [attStr addAttributes:@{NSStrokeWidthAttributeName:@(-5), NSStrokeColorAttributeName:[UIColor greenColor]} range:range];
            }
        }
        if (setcard.color == 3) {
            attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0 green:0 blue:1 alpha:[self getShading:setcard.shading]]}];
            if (setcard.shading == 1) {
                NSRange range = NSMakeRange(0, [attStr length]);
                [attStr addAttributes:@{NSStrokeWidthAttributeName:@(-5), NSStrokeColorAttributeName:[UIColor blueColor]} range:range];
            }
        }
        
        return attStr;
    }
    return nil;
}

- (NSString *)getSymbol:(NSUInteger)symbol
{
    if (symbol == 1) return @"▲";
    if (symbol == 2) return @"●";
    if (symbol == 3) return @"■";
    return nil;
}

- (CGFloat)getShading:(NSUInteger)shading
{
    if (shading == 1) return 0.0;
    if (shading == 2) return 0.4;
    if (shading == 3) return 1.0;
    return -1.0;
}

// Override the superclass's method by returning the proper images for the card when (un)chosen
- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfronttint" : @"cardfront"];
}

- (void)updateUI
{
    if(self.game.shouldMatch && self.game.matchScore > 0) {
        NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
        for (Card *card in self.game.cardsInPlay) {
            NSUInteger cardIndex = [self.game indexOfCard:card];
            __block UIButton *button = [self.cardButtons objectAtIndex:cardIndex];
            [indexSet addIndex:cardIndex];
            [UIView transitionWithView:button duration:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                button.frame = CGRectMake(0, 0, 0, 0);
            } completion:^(BOOL finished) {
                if(finished) [button removeFromSuperview];
            }];
        }
        [self.cardButtons removeObjectsAtIndexes:indexSet];
        [self.game removeMatchedCards];
    }
    [super updateUI];
}


- (IBAction)addThreeCards:(UIButton *)sender {
    if (![self.game drawThreeCards])
        sender.userInteractionEnabled = NO;
    else {
        for (int i=0; i < 3; i++) {
            __block UIButton *button = [self addCardButton];
            [self.cardsView addSubview:button];
            [UIView transitionWithView:button duration:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                button.frame = [self getFrameAtIndex:([self.cardButtons count] - 1)];
            } completion:nil];
        }
    }
    [super updateUI];
}


@end
