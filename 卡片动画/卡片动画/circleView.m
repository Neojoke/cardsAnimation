//
//  circleView.m
//  卡片动画
//
//  Created by Neo on 15/6/23.
//  Copyright (c) 2015年 KuBao. All rights reserved.
//

#import "circleView.h"
#import <POP.h>
#import <QuartzCore/QuartzCore.h>
@interface circleView()
@property(nonatomic,strong)CAShapeLayer * circleLayer;
@property(nonatomic,strong)UILabel * label;
@end
@implementation circleView
-(void)awakeFromNib
{
    [self configCircle];
    [self configLabel];
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self configCircle];
        [self configLabel];
    }
    return self;
}
-(void)configLabel{
    self.label = [[UILabel alloc]init];
    self.label.text = @"0%";
    self.label.frame = CGRectMake(0, 0, 100, 100);
    self.label.textColor = [UIColor whiteColor];
    self.label.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    self.label.font = [UIFont systemFontOfSize:25];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.label];
}
-(void)configCircle{
    self.circleLayer = [CAShapeLayer layer];
    CGFloat lineWidth = 4.0f;
    CGFloat radius = self.bounds.size.width/2-lineWidth;
    CGRect rect = CGRectMake(lineWidth/2, lineWidth/2, radius*2, radius*2);
    UIBezierPath * bez = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    self.circleLayer.strokeColor = self.lineColor.CGColor;
    self.circleLayer.path = bez.CGPath;
    self.circleLayer.fillColor = nil;
    self.circleLayer.lineJoin = kCALineJoinRound;
    self.circleLayer.lineCap =kCALineCapRound;
    self.circleLayer.lineWidth = lineWidth;
    CAShapeLayer * bgCircle = [CAShapeLayer layer];
    bgCircle.lineWidth = 1.0f;
    bgCircle.strokeStart = 0.0f;
    bgCircle.strokeEnd = 1.0f;
    bgCircle.strokeColor = [UIColor grayColor].CGColor;
    bgCircle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(lineWidth-1, lineWidth-1, radius*2, radius*2) cornerRadius:radius-lineWidth+1].CGPath;
    bgCircle.lineCap = kCALineCapRound;
    bgCircle.lineJoin = kCALineJoinRound;
    bgCircle.fillColor = nil;
    [self.layer addSublayer:bgCircle];
    [self.layer addSublayer:self.circleLayer];
}
-(void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    self.circleLayer.strokeColor = self.lineColor.CGColor;
}
-(void)animationWithStrokeEnd:(CGFloat)strokeEnd{
    POPBasicAnimation * bAni = [POPBasicAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
   
    bAni.toValue = @(strokeEnd);
    bAni.duration = 1;
    bAni.removedOnCompletion = NO;
    [self.circleLayer pop_addAnimation:bAni forKey:@"123"];
    POPBasicAnimation * labelBani = [POPBasicAnimation animation];
    labelBani.duration =1;
    POPAnimatableProperty * prop = [POPAnimatableProperty propertyWithName:@"count" initializer:^(POPMutableAnimatableProperty *prop) {
       [prop setReadBlock:^(id obj, CGFloat values[]) {
           values[0] = [[obj description] floatValue];
       }];
        [prop setWriteBlock:^(id obj, const CGFloat values[]) {
            NSString * str =[NSString stringWithFormat:@"%.2f",values[0]];
            [obj setText:[NSString stringWithFormat:@"%@%%",str]];
        }];
        prop.threshold = 0.01;
    }];
    labelBani.property = prop;
    labelBani.fromValue = @(0.0);
    labelBani.toValue = @(100.0f*strokeEnd);
    [self.label pop_addAnimation:labelBani forKey:@"123"];
    
}
-(void)setCircleStrokeEnd:(CGFloat)strokeEnd animated:(BOOL)animated{
    if (animated) {
        [self animationWithStrokeEnd:strokeEnd];
    }
    else
    {
        self.circleLayer.strokeEnd = strokeEnd;
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
