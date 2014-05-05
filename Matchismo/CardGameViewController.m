//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Henry Wang on 4/3/14.
//  Copyright (c) 2014 Henry. All rights reserved.
//
//  Image Sources:
//  Cardback:http://www.creationdunproduitinnovant.com/blog/wp-content/uploads/2008/12/stanford_university_hoover_tower.jpg
//  AppIcon:http://ms.ahsd.org/teachers/brunom/cards.png
//  LaunchIcon: "http://fierceandnerdy.com/wp-content/uploads/2009/01/deckofcards.jpg"
//

#import "CardGameViewController.h"

@interface CardGameViewController ()

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end

@implementation CardGameViewController


// Update the UI whenever the view is loaded.
- (void)viewDidLoad
{
    [self initUI];
}


// Simple getter for the game property that includes lazy instantiation.
- (CardMatchingGame *)game
{
    if(!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
    }
    return _game;
}

// This method takes care of the resets needed when the Redeal button is pressed. It reinitializes the game and updates the UI.
- (IBAction)touchRedealButton {
    _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
    
    [self initUI];
    
}

// This method takes care of the actions required when a user turns over a card.
- (IBAction)touchCardButton:(UIButton *)sender
{
    if([sender isSelected]){
    NSLog(@"HI :)");
    }
    else NSLog(@"BYE :(");
    NSUInteger cardIndex = [self.cardButtons indexOfObject:sender];
    
    [self.game chooseCardAtIndex:cardIndex];
    
    Card *card = [self.game cardAtIndex:cardIndex];
    
    // Updates the UI
    //[self updateUI];
    
    if (self.game.shouldMatch) {
        self.game.cardsInPlay = nil;
        
        if (self.game.matchScore <= 0) {
            [self.game.cardsInPlay addObject:card];
        }
    }
}

- (void)setSender:(UIView *)sender cardVal:(Card *)card
{

}

// This method updates the UI and returns a boolean value to let the touchCardButton method know whether it should keep the most recent card or not.
- (void)initUI
{
    
    // Updates every button on the screen
    for (UIView *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        
        [self setSender:cardButton cardVal:card];
        
        //[self setCardNeedsDisplaysetNeedsDisplay];
        
        //[cardButton setAttributedTitle:[self attTitleForCard:card] forState:UIControlStateNormal];
        
        //[cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        
        //cardButton.enabled = card.isMatched ? NO : YES;
        
       
    }
    
    // Updates scoreLabel
    self.scoreLabel.text = [NSString stringWithFormat:@"Score :%d", self.game.gameScore];
}

// Different games have different decks. Keep this abstract.
- (Deck *)createDeck
{
    return nil;
}

// Different games will want to express their titles differently. Keep this abstract.
- (NSAttributedString *)attTitleForCard:(Card *)card
{
    return nil;
}


// Different games will require different background images. Keep this abstract.
- (UIImage *)backgroundImageForCard:(Card *)card
{
    return nil;
}


@end
