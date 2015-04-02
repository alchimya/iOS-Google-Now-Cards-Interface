//
//  L3SDKCardsView.h
//  Parallax
//
//  Created by Domenico Vacchiano on 01/04/15.
//  Copyright (c) 2015 LamCube. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L3SDKCard.h"
@protocol L3SDKCardsViewDelegate <NSObject>

@optional
- (void)L3SDKCardsView_OnScrolling:(UISwipeGestureRecognizerDirection)scrollDirection;
- (void)L3SDKCardsView_OnCardRemoved:(L3SDKCard*)view;
- (void)L3SDKCardsView_OnAllCardRemoved;
- (void)L3SDKCardsView_OnUpperLimitReached;
- (void)L3SDKCardsView_OnBottomLimitReached;
@end



@interface L3SDKCardsView : UIView
@property (nonatomic,assign)IBOutlet id<L3SDKCardsViewDelegate> delegate;
@property (readonly,nonatomic,strong)NSMutableArray*cards;
@property (readonly,nonatomic,strong)NSMutableArray*subViews;
-(void)addCard:(L3SDKCard*)card;
-(void)addSubviewAtBottom:(UIView *)view;
@end
