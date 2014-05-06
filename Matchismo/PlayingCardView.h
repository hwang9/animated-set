//
//  PlayingCardView.h
//  Matchismo
//
//  Created by Jed Tan on 5/5/14.
//  Copyright (c) 2014 Henry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView
@property (nonatomic, strong) NSString *suit;
@property (nonatomic) NSUInteger rank;
@property (nonatomic) BOOL faceUp;

@end
