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
- (void)L3SDKCardsView_Scrolling:(UISwipeGestureRecognizerDirection)scrollDirection;
- (void)L3SDKCardsView_CardWillRemove:(L3SDKCard*)view;
- (void)L3SDKCardsView_CardDidlRemove:(L3SDKCard*)view;
- (void)L3SDKCardsView_AllCardRemoved;
- (void)L3SDKCardsView_UpperLimitReached;
- (void)L3SDKCardsView_BottomLimitReached;

@end



@interface L3SDKCardsView : UIView
@property (nonatomic,assign)IBOutlet id<L3SDKCardsViewDelegate> delegate;
@property (readonly,nonatomic,strong)NSMutableArray*cards;
@property (readonly,nonatomic,strong)NSMutableArray*subViews;
@property (nonatomic,assign)CGRect zeroFrame;

-(void)addCard:(L3SDKCard*)card;
-(void)addSubviewAtBottom:(UIView *)view;
@end
