//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Henry Wang on 4/10/14.
//  Copyright (c) 2014 Henry. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingCardView.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController


- (UIView *) returnBlankButton
{
    return [[PlayingCardView alloc] init];
}

// Overrides the superclass's method by creating an appropriate deck of playing cards.
- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (NSUInteger)numCardsAtStart
{
    return 16;
}

// Overrides the superclass's method by only presenting the card contents when the card is faceup (chosen). Returns an empty string otherwise.
/*- (NSAttributedString *)attTitleForCard:(Card *)card
{
    if (card.isChosen)
        return [self buildCardAttString:card];
    else
        return [[NSAttributedString alloc] initWithString:@""];
}*/

// Builds an appropriate title for a playing card. An NSAttributedString is used to ensure that the suits reflect their appropriate colors (hearts and diamonds are red, while clubs and spades are black)
/*- (NSAttributedString *)buildCardAttString:(Card *)card
{
    NSMutableAttributedString *ret;
    
    ret = [[NSMutableAttributedString alloc] initWithString:card.contents attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    if ([card isKindOfClass:[PlayingCard class]]) {
        PlayingCard *playingCard = (PlayingCard *)card;
        NSRange range;
        if (playingCard.rank == 10)
            range = NSMakeRange(2, [card.contents length]-2);
        else
            range = NSMakeRange(1, [card.contents length]-1);
        if ([playingCard.suit isEqualToString:@"♥"] || [playingCard.suit isEqualToString:@"♦"]) {
            [ret addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
        } else {
            [ret addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
        }
    }
    
    return ret;
}*/

// Overrides the superclass's method by providing the correct background images when a card is (un)chosen
- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

// Overrides the superclass's method by providing the correct values for the card
- (void)updateButton:(UIView *)cardButton inputCard:(Card *)card
{
    PlayingCardView * currentCardButton = ((PlayingCardView *)cardButton);
    PlayingCard * currentCard = ((PlayingCard *)card);
    currentCardButton.rank = currentCard.rank;
    currentCardButton.suit = currentCard.suit;
    currentCardButton.faceUp = card.isChosen;
    
    if (card.isMatched) cardButton.alpha = 0.4;
    
    [currentCardButton setNeedsDisplay];
}

@end
