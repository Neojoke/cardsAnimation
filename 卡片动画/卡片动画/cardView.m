//
//  cardView.m
//  卡片动画
//
//  Created by Neo on 15/6/27.
//  Copyright (c) 2015年 KuBao. All rights reserved.
//

#import "cardView.h"
#import "circleView.h"
#import <POP.h>
@interface cardView()
@property (weak, nonatomic) IBOutlet UIButton *tapButton;
@property (strong, nonatomic)  circleView *circleView1;
@property (strong, nonatomic)  circleView *circleView2;

@end

@implementation cardView
-(void)awakeFromNib
{
    

    self.circleView1 = [[circleView alloc]initWithFrame:CGRectMake(15, 15, self.circleSize.width, self.circleSize.height)];
    self.circleView2 = [[circleView alloc]initWithFrame:CGRectMake(15, 15, self.circleSize.width, self.circleSize.height)];
    //[self config];
}
-(void)prepareForInterfaceBuilder
{
    [self config];
}
-(void)config{
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.layer.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(self.cornerRadius, self.cornerRadius)].CGPath;
    self.layer.mask = maskLayer;
    [self setBackgroundColor:self.bgColor];
    self.circleView1 = [[circleView alloc]initWithFrame:CGRectMake(15, 15, self.circleSize.width, self.circleSize.height)];
    self.circleView2 = [[circleView alloc]initWithFrame:CGRectMake(15, 15, self.circleSize.width, self.circleSize.height)];
    self.circleView1.lineColor = self.tapColor1;
    self.circleView2.lineColor = self.tapColor2;
    self.circleView2.center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
    self.circleView1.transform = CGAffineTransformScale(self.circleView1.transform, 0.5, 0.5);
    self.circleView1.center = CGPointMake(15+self.circleSize.width/2/2, 15+self.circleSize.width/2/2);
    [self addSubview:self.circleView1];
    [self addSubview:self.circleView2];
    [self.circleView1 setCircleStrokeEnd:0.0f animated:YES];
    [self.circleView2 setCircleStrokeEnd:1.0f animated:YES];
    self.tapButton.layer.cornerRadius = self.buttonConnerRadius;
    self.tapButton.layer.masksToBounds = YES;
    NSLog(@"%@",NSStringFromCGRect(self.circleView1.frame));
    [self.tapButton updateConstraints];
    [self layoutIfNeeded];
#if !TARGET_INTERFACE_BUILDER
    // this code will run in the app itself
#else
    // this code will execute only in IB
#endif
}
- (IBAction)tapClick:(id)sender {
    BOOL firstIsCenter;
    if (CGPointEqualToPoint(CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2), self.circleView1.center)) {
        firstIsCenter = YES;
    }
    else{
        firstIsCenter = NO;
    }
    POPBasicAnimation * bAni1 = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    POPBasicAnimation * bAni2 = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    POPSpringAnimation * sSani1 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    POPSpringAnimation * sSani2 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    sSani1.springSpeed = 12.0f;
    sSani2.springSpeed = 12.0f;
    sSani1.springBounciness = 20.0f;
    sSani2.springBounciness = 20.0f;
    sSani1.velocity = [NSValue valueWithCGPoint:CGPointMake(5, 5)];
    sSani2.velocity = [NSValue valueWithCGPoint:CGPointMake(5, 5)];
    if (firstIsCenter) {
        sSani2.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
        sSani1.toValue = [NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)];
        bAni1.toValue = [NSValue valueWithCGPoint:CGPointMake(15+self.circleSize.width/2/2, 15+self.circleSize.width/2/2)];
        bAni2.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2)];
    }
    else
    {
        sSani1.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
        sSani2.toValue = [NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)];
        bAni2.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetWidth(self.bounds)-15-self.circleSize.width/2/2, 15+self.circleSize.width/2/2)];
        bAni1.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2)];
    }
    bAni1.duration = 0.4f;
    bAni1.duration = 0.4f;
    if (firstIsCenter) {
        [bAni1 setCompletionBlock:^(POPAnimation *animation, BOOL isFinish) {
            if (isFinish) {
                [self.circleView1 setCircleStrokeEnd:0.0f animated:YES];
            }
        }];
        [bAni2 setCompletionBlock:^(POPAnimation *animation, BOOL isFinish) {
            if (isFinish) {
                [self.circleView2 setCircleStrokeEnd:1.0f animated:YES];
            }
        }];
    }
    else
    {
        [bAni1 setCompletionBlock:^(POPAnimation *animation, BOOL isFinish) {
            if (isFinish) {
                [self.circleView1 setCircleStrokeEnd:1.0f animated:YES];
            }
        }];
        [bAni2 setCompletionBlock:^(POPAnimation *animation, BOOL isFinish) {
            if (isFinish) {
                [self.circleView2 setCircleStrokeEnd:0.0f animated:YES];
            }
        }];
    }
    [self.circleView1 pop_addAnimation:sSani1 forKey:@"1233"];
    [self.circleView2 pop_addAnimation:sSani2 forKey:@"1233"];
    [self.circleView1 pop_addAnimation:bAni1 forKey:@"123"];
    [self.circleView2 pop_addAnimation:bAni2 forKey:@"123"];
    
    
    POPBasicAnimation * butBani = [POPBasicAnimation animationWithPropertyNamed:kPOPViewSize];
    butBani.duration = 0.4f;
    butBani.toValue = [NSValue valueWithCGSize:CGSizeMake(40, 40)];
    [butBani setCompletionBlock:^(POPAnimation * ani, BOOL isFinished) {
        if (isFinished) {
            POPBasicAnimation *butBani1 = [POPBasicAnimation animationWithPropertyNamed:kPOPViewSize];
            butBani1.duration = 0.4f;
            butBani1.toValue = [NSValue valueWithCGSize:CGSizeMake(CGRectGetWidth(self.bounds)*0.8, 40)];
            [self.tapButton pop_addAnimation:butBani1 forKey:@"1233"];
        }
    }];
    POPBasicAnimation * butBcolorAni = [POPBasicAnimation animationWithPropertyNamed:kPOPViewBackgroundColor];
    butBcolorAni.duration = 0.8;
    if (firstIsCenter) {
        butBcolorAni.toValue = self.tapColor2;
    }
    else
    {
        butBcolorAni.toValue = self.tapColor1;
    }
    [self.tapButton pop_addAnimation:butBcolorAni forKey:@"321"];
    [self.tapButton pop_addAnimation:butBani forKey:@"123"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
