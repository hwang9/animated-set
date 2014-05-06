//
//  SetCardView.h
//  Matchismo
//
//  Created by Henry Wang on 5/6/14.
//  Copyright (c) 2014 Henry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView

@property (nonatomic) NSUInteger number;
@property (nonatomic) NSUInteger symbol;
@property (nonatomic) NSUInteger shading;
@property (nonatomic) NSUInteger color;

@property (nonatomic) BOOL chosen;

@end
