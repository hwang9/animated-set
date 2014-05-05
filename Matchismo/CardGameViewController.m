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
#import "Grid.h"

@interface CardGameViewController ()


@property (weak, nonatomic) IBOutlet UIView *cardsView;
@property (nonatomic) NSMutableArray *cardButtons;
@property (nonatomic) Grid *cardsGrid;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end

@implementation CardGameViewController


// Update the UI whenever the view is loaded.
- (void)viewDidLoad
{
    [self updateUI];
}

- (NSMutableArray *)cardButtons
{
    if (!_cardButtons) _cardButtons = [[NSMutableArray alloc] init];
    return _cardButtons;
}

- (Grid *)cardsGrid
{
    if(!_cardsGrid) {
        _cardsGrid = [[Grid alloc] init];
        _cardsGrid.size = self.cardsView.bounds.size;
        _cardsGrid.cellAspectRatio = 0.66;
        _cardsGrid.minimumNumberOfCells = [self numCardsAtStart];
    }
    return _cardsGrid;
}


// Simple getter for the game property that includes lazy instantiation.
- (CardMatchingGame *)game
{
    if(!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self numCardsAtStart] usingDeck:[self createDeck]];
    }
    return _game;
}

// This method takes care of the resets needed when the Redeal button is pressed. It reinitializes the game and updates the UI.
- (IBAction)touchRedealButton {
    _game = [[CardMatchingGame alloc] initWithCardCount:[self numCardsAtStart] usingDeck:[self createDeck]];
    
    [self updateUI];
    
}
- (IBAction)touchCardButton:(UITapGestureRecognizer *)sender
{
    //NSUInteger cardIndex = [self.cardButtons indexOfObject:sender];
    NSUInteger cardIndex = 0;
    
    [self.game chooseCardAtIndex:cardIndex];
    
    Card *card = [self.game cardAtIndex:cardIndex];
    
    // Updates the UI
    [self updateUI];
    
    if (self.game.shouldMatch) {
        self.game.cardsInPlay = nil;
        
        if (self.game.matchScore <= 0) {
            [self.game.cardsInPlay addObject:card];
        }
    }
}

// This method updates the UI and returns a boolean value to let the touchCardButton method know whether it should keep the most recent card or not.
- (void)updateUI
{
    self.cardsGrid.minimumNumberOfCells = [self.game numCardsOnTable];
    NSUInteger rowCount = [self.cardsGrid rowCount];
    NSUInteger colCount = [self.cardsGrid columnCount];
    
    // Updates every button on the screen
    for (int i=0; i<[self.game numCardsOnTable]; i++) {
        UIButton *cardButton = [[UIButton alloc] initWithFrame:CGRectMake([self.cardsGrid frameOfCellAtRow:i/rowCount inColumn:i%colCount].origin.x, [self.cardsGrid frameOfCellAtRow:i/rowCount inColumn:i%colCount].origin.y, [self.cardsGrid cellSize].width, [self.cardsGrid cellSize].height)];
        
        Card *card = [self.game cardAtIndex:i];
        
        [cardButton setAttributedTitle:[self attTitleForCard:card] forState:UIControlStateNormal];
        
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        
        cardButton.enabled = card.isMatched ? NO : YES;
        
        [self.cardButtons addObject:cardButton];
        [self.cardsView addSubview:cardButton];
    }
    
    // Updates scoreLabel
    self.scoreLabel.text = [NSString stringWithFormat:@"Score :%d", self.game.gameScore];
}

// Different games have different decks. Keep this abstract.
- (Deck *)createDeck
{
    return nil;
}

- (NSUInteger)numCardsAtStart
{
    return 0;
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
