//
//  ViewController.m
//  iOS-Google-Now-Cards-Interface
//
//  Created by Domenico Vacchiano on 02/04/15.
//  Copyright (c) 2015 LamCube. All rights reserved.
//

#import "ViewController.h"
#import "L3SDKCardsView.h"
#import "L3SDKCard.h"

@interface ViewController ()
//see links on Main.storyboard
@property (nonatomic,strong)IBOutlet UIView*headerView;
@property (nonatomic,strong)IBOutlet L3SDKCardsView*containerView;
@property (nonatomic,strong)UIButton*moreButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //sets delegate
    self.containerView.delegate=self;
    
    //card setup
    //NOTE It's needed to specify only the height of the card
    L3SDKCard*card;
    //card1
    card=[[L3SDKCard alloc]initWithFrame:CGRectMake(0, 0, 0, 100)];
    [self.containerView addCard:card];
    //card2
    card=[[L3SDKCard alloc]initWithFrame:CGRectMake(0, 0, 0, 150)];
    [self.containerView addCard:card];
    //card3
    card=[[L3SDKCard alloc]initWithFrame:CGRectMake(0, 0, 0, 80)];
    [self.containerView addCard:card];
    //card4
    card=[[L3SDKCard alloc]initWithFrame:CGRectMake(0, 0, 0, 120)];
    [self.containerView addCard:card];
    //card5
    card=[[L3SDKCard alloc]initWithFrame:CGRectMake(0, 0, 0, 220)];
    [self.containerView addCard:card];
    
    
    //add a view (UIButton) at bottom
    self.moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.moreButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.containerView.frame.size.width, 40)];
    [self.moreButton setTitle:@"More" forState:UIControlStateNormal];
    self.moreButton.backgroundColor=[UIColor whiteColor];
    [self.moreButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.moreButton.titleLabel.font= [UIFont italicSystemFontOfSize:16.0f];
    
    [self.containerView addSubviewAtBottom:self.moreButton];
    
}

//////////////////////////////////////////////////////////////////////////////////
//EVENTS
#pragma mark - L3SDKCardsView_ events delegate
- (void)L3SDKCardsView_OnScrolling:(UISwipeGestureRecognizerDirection)scrollDirection{
    if (scrollDirection==UISwipeGestureRecognizerDirectionUp) {
        if (self.headerView.alpha>0) {
            self.headerView.alpha=self.headerView.alpha-0.02;
        }
    }else  if (scrollDirection==UISwipeGestureRecognizerDirectionDown) {
        if (self.headerView.alpha<1) {
            self.headerView.alpha=self.headerView.alpha+0.02;
        }
    }
}
- (void)L3SDKCardsView_OnUpperLimitReached{
    self.headerView.alpha=0;
}
- (void)L3SDKCardsView_OnBottomLimitReached{
    self.headerView.alpha=1;
}

- (void)L3SDKCardsView_OnCardRemoved:(L3SDKCard*)view{
    NSLog(@"card deleted");
}
- (void)L3SDKCardsView_OnAllCardRemoved{
    self.headerView.alpha=1;
}
//////////////////////////////////////////////////////////////////////////////////

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
