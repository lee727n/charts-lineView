//
//  ViewController.m
//  lineview
//
//  Created by 刘梓轩 on 2017/7/28.
//  Copyright © 2017年 MIKEz. All rights reserved.
//
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"
#import "DateValueFormatter.h"
#import "ViewController.h"
#import "lineview-Bridging-Header.h"

@interface ViewController ()
@property (nonatomic) UIImageView *firstIV;
@property (nonatomic) NSArray *data;
@property (nonatomic)LineChartView *chartView;
@property(nonatomic) UILabel *label;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self firstIV];
    self.label.text = @"点击加载折线图";
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  self.data = [NSArray new];
}
-(UILabel *)label{
    if(_label == nil){
        _label = [UILabel new];
        _label.textColor = [UIColor blueColor];
        _label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        _label.textAlignment = NSTextAlignmentCenter;
       
    }
    [self.view addSubview:_label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(50);
        make.centerX.equalTo(0);
    }];
    
    return _label;
}
-(UIImageView *)firstIV{
    if (_firstIV == nil) {
        _firstIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 100, 300, 150)];
    }
    //_firstIV.backgroundColor = [UIColor redColor];
    [self.view addSubview:_firstIV];
  
    return _firstIV;
}

-(void)setData:(NSArray *)data{
    _data = data;
    //折线图实现
  
    
    if (!self.chartView) {
        self.chartView = [LineChartView new];
        [self.firstIV addSubview:_chartView];
        [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    
    [self initLineViewWithData:data];
    
    
    
}

#pragma mark - 折线图部分
-(void)initLineViewWithData:(NSArray*)data{
    
    _chartView.chartDescription.enabled = NO;
    
    _chartView.dragEnabled = YES;
    [_chartView setScaleEnabled:YES];
    _chartView.pinchZoomEnabled = YES;
    _chartView.drawGridBackgroundEnabled = NO;
    
    //x轴
    _chartView.xAxis.gridLineDashLengths = @[@5.0, @5.0];
    _chartView.xAxis.gridLineDashPhase = 0.f;
    _chartView.xAxis.labelPosition= XAxisLabelPositionBottom;//设置x轴数据在底部
    _chartView.xAxis.labelCount = 4;
    
    //    _chartView.xAxis.axisMinValue = 1;
    //    _chartView.xAxis.axisMaxValue = 5;
    //X轴上面需要显示的数据
    
    
    //y轴
    ChartYAxis *leftAxis = _chartView.leftAxis;
    [leftAxis removeAllLimitLines];
    leftAxis.axisMaximum = 1000.0;
    leftAxis.axisMinimum = 0;
    
    leftAxis.gridLineDashLengths = @[@5.f, @5.f];
    leftAxis.drawZeroLineEnabled = NO;
    leftAxis.drawLimitLinesBehindDataEnabled = YES;
    //    NSArray *yVals = [NSArray new];
    //    yVals = @[@"00:00",@"06:00",@"12:00",@"18:00",@"24:00",@"44"];
    //
    //    leftAxis.valueFormatter = [[DateValueFormatter alloc]initWithArr:yVals];
    //修改Y轴后缀
    //    NSNumberFormatter *rightAxisFormatter = [[NSNumberFormatter alloc] init];
    //    //负数的后缀
    //    rightAxisFormatter.negativeSuffix = @" %";
    //    //正数的后缀
    //    rightAxisFormatter.positiveSuffix = @" %";
    
    
    //   leftAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc]initWithFormatter:rightAxisFormatter];
    
    _chartView.rightAxis.enabled = NO;
    
    
    _chartView.legend.form = ChartLegendFormCircle;
    
    [self setDataCount:5 range:1000 data:data];
    
    [_chartView animateWithXAxisDuration:2.5];
    
}
- (void)setDataCount:(int)count range:(double)range data:(NSArray*)data
{
    //for循环初始化数据
    //NSInteger xVals_count = count;//X轴上要显示多少条数据
    //X轴上面需要显示的数据
    //    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    //    for (int i = 0; i <= xVals_count; i++) {
    //
    //            [xVals addObject: [NSString stringWithFormat:@"02-%d",i]];
    //
    //    }
    //写死数据
    NSArray *xVals = [NSArray new];
    xVals = @[@"00:00",@"06:00",@"12:00",@"18:00",@"24:00"];
    self.chartView.xAxis.valueFormatter = [[DateValueFormatter alloc]initWithArr:xVals];
    
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
        NSArray *va = [NSArray new];
        va = @[@800,@100,@300,@200,@100];
    for (int i = 0; i < count; i++)
    {
        double val = [va[i] doubleValue];
        
        [values addObject:[[ChartDataEntry alloc] initWithX:i y:val icon: [UIImage imageNamed:@"icon"]]];
    }
    
    LineChartDataSet *set1 = nil;
    if (_chartView.data.dataSetCount > 0)
    {
        set1 = (LineChartDataSet *)_chartView.data.dataSets[0];
        set1.values = values;
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[LineChartDataSet alloc] initWithValues:values label:@"sale"];
        
        set1.drawIconsEnabled = NO;
        
        set1.lineDashLengths = @[@5.f, @0.f];
        //set1.highlightLineDashLengths = @[@5.f, @0.f];
        [set1 setColor:UIColor.blueColor];
        [set1 setCircleColor:UIColor.blueColor];
        set1.lineWidth = 1.0;
        set1.circleRadius = 3.0;
        set1.drawCircleHoleEnabled = NO;
        set1.valueFont = [UIFont systemFontOfSize:9.f];
        //        set1.formLineDashLengths = @[@20.f, @2.5f];
        //        set1.formLineWidth = 1.0;
        //        set1.formSize = 15.0;
        
        //控制填充颜色
        //        NSArray *gradientColors = @[
        //                                    (id)[ChartColorTemplates colorFromString:@"#0000FFF0"].CGColor,
        //                                    (id)[ChartColorTemplates colorFromString:@"#ffff0000"].CGColor
        //                                    ];
        //        CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
        //
        //        set1.fillAlpha = 1.f;
        //        set1.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
        //        set1.drawFilledEnabled = YES;
        //
        //        CGGradientRelease(gradient);
        
        //同样控制填充色
        //set1.drawFilledEnabled = NO;//是否填充颜色
        
        //
        //        set1.drawSteppedEnabled = NO;//是否开启绘制阶梯样式的折线图
        //        //折线拐点样式
        //        set1.drawCirclesEnabled = NO;//是否绘制拐点
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        
        _chartView.data = data;
    }
}



@end
