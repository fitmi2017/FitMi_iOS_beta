//
//  GraphView.m
//  CorePlotBarChartExample
//
//  Created by Anthony Perozzo on 8/06/12.
//  Copyright (c) 2012 Gilthonwe Apps. All rights reserved.
//

#import "GraphView.h"
#import "Utility.h"
@implementation GraphView

- (void)generateData:(NSMutableArray *)arrWeightData withArray:(NSMutableArray *)weekStartEndArray withCategory:(NSString *)param
{
    NSMutableArray *bpInputArr=[[NSMutableArray alloc]init];
   
    
    NSLog(@"arrWeightData==%@",arrWeightData);
    //For Monthly
    if([param isEqualToString:@"monthly"])
    {
        dates=[weekStartEndArray mutableCopy];
        bpInputArr=[arrWeightData mutableCopy];
       /* NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        formatter1.dateFormat = @"EEEE, MMMM dd, yyyy";
        NSDate *dateFromString = [formatter1 dateFromString:[[Utility sharedManager] getSelectedDate]];
        NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString= [dateFormatter2 stringFromDate:dateFromString];
    
        NSArray *dateArr =[dateString componentsSeparatedByString:@"-"];
        NSString *month=[NSString stringWithFormat:@"%@",[dateArr objectAtIndex:1]];
        NSString *year=[NSString stringWithFormat:@"%@",[dateArr objectAtIndex:0]];
    
        NSCalendar* cal = [NSCalendar currentCalendar];
        NSDateComponents* comps = [[NSDateComponents alloc] init];
     
        // Set your month here
        [comps setMonth:[month intValue]];
        [comps setYear:[year intValue]];
        
        NSRange range = [cal rangeOfUnit:NSCalendarUnitDay
                                  inUnit:NSCalendarUnitMonth
                                 forDate:[cal dateFromComponents:comps]];
        NSLog(@"Month Length%d", range.length);
        
        dates=[[NSMutableArray alloc] init];
        //int inputbp=0;
         
       for(int i=range.location;i<=range.length;i++ ){
     
        if(i==1 || i==range.length || i==range.length/2){
         [dates addObject:[NSString stringWithFormat:@"%d",i]];
          //  [dates addObject:[NSString stringWithFormat:@"%d-%@-%@",i,month,year]];
        }
        else
        {//[dates addObject:[NSString stringWithFormat:@""]];
         [dates addObject:[NSString stringWithFormat:@"%d",i]];
        }
       // [bpInputArr addObject:[NSNumber numberWithFloat:inputbp]];
      
        //inputbp++;
      }
      
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;

        
         bpInputArr=[arrWeightData mutableCopy];*/
    }
    
    //For Weekly
    else if([param isEqualToString:@"weekly"])
    {
        dates=[weekStartEndArray mutableCopy];
        bpInputArr=[arrWeightData mutableCopy];

    //Array containing all the dates that will be displayed on the X axis
    /*dates = [NSMutableArray arrayWithObjects:@"Sun", @"Mon", @"Tue",
             @"Wed", @"Thu", @"Fri", @"Sat", nil];

        [bpInputArr addObject:[NSNumber numberWithFloat:0]];
        [bpInputArr addObject:[NSNumber numberWithFloat:0]];
        [bpInputArr addObject:[NSNumber numberWithFloat:0]];
        [bpInputArr addObject:[NSNumber numberWithFloat:0]];
        [bpInputArr addObject:[NSNumber numberWithFloat:0]];
        [bpInputArr addObject:[NSNumber numberWithFloat:0]];
        [bpInputArr addObject:[NSNumber numberWithFloat:0]];

        
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;

        if(arrWeightData.count>0)
        {
            for(int i=0;i<arrWeightData.count;i++)
            {
                NSNumber *weight = [f numberFromString:[[arrWeightData objectAtIndex:i]objectForKey:@"weight"]];
                [bpInputArr replaceObjectAtIndex:i withObject:weight];
            }
        }*/
       
    }
    
    //For daily
    else
    {
      /*  NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        formatter1.dateFormat = @"EEEE, MMMM dd, yyyy";
        NSDate *dateFromString = [formatter1 dateFromString:[[Utility sharedManager] getSelectedDate]];
        NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString= [dateFormatter2 stringFromDate:dateFromString];

        //Array containing all the dates that will be displayed on the X axis
        dates = [NSMutableArray arrayWithObjects:dateString, nil];
        
        
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
         
        if(arrWeightData.count>0)
        {
        NSNumber *weight = [f numberFromString:[[arrWeightData objectAtIndex:0]objectForKey:@"weight"]];
          [bpInputArr addObject:weight];
        }
        else
        {
           [bpInputArr addObject:[NSNumber numberWithFloat:0]];
        }*/
       
        
        NSString *startDate=[weekStartEndArray objectAtIndex:0];
        
        NSCalendar *cal = [NSCalendar currentCalendar];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *dateFromStringStartDate = [[NSDate alloc] init];
        
        dateFromStringStartDate = [dateFormatter dateFromString:startDate];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay| NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:dateFromStringStartDate];
        
        NSLog(@"iiiiiiiiiiiiiiiii==========%@",arrWeightData);
  
        for (int i=0; i<7; i++) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"log_date = '%@'",startDate]];
            
            NSArray *results = [arrWeightData filteredArrayUsingPredicate:predicate];
            if([results count]==0){
                NSMutableDictionary *dict=[NSMutableDictionary dictionary];
                [dict setObject:@"0" forKey:@"weight_id"];
                [dict setObject:@"0" forKey:@"weight"];
                [dict setObject:startDate forKey:@"log_date"];
                [dict setObject:@"" forKey:@"log_time"];
                [arrWeightData addObject:dict];
                
            }
            else{
                int sumweight=0,avgweight;
                if([results count]>1){
                    for(int i=0;i<[results count];i++){
                        sumweight+=[[[results objectAtIndex:i] objectForKey:@"weight"]intValue];
                     }
                    avgweight=sumweight/[results count];
                    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
                    [dict setObject:[[results objectAtIndex:0] objectForKey:@"weight_id"] forKey:@"weight_id"];
                    [dict setObject:[NSString stringWithFormat:@"%d",avgweight]forKey:@"weight"];
                    [dict setObject:startDate forKey:@"log_date"];
                    [dict setObject:[[results objectAtIndex:0] objectForKey:@"log_time"]  forKey:@"log_time"];
                    NSMutableSet *setmain = [NSMutableSet setWithArray:arrWeightData];
                    NSMutableSet *setSub = [NSMutableSet setWithArray:results];
                    [setmain minusSet:setSub];
                    arrWeightData = [NSMutableArray arrayWithArray:setmain.allObjects];
                    [arrWeightData addObject:dict];
                    
                }
                
            }
            components.day = components.day + 1;
            // components1.minute = components1.minute + (1+i)*1;
            NSDate *date=[cal dateFromComponents:components];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            startDate = [dateFormatter stringFromDate:date];
            
        }
        
        
        
        NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"log_date"  ascending:YES];
        
        NSArray *sortDescriptors = @[nameDescriptor];
        NSArray *ordered_arrWeightData = [arrWeightData sortedArrayUsingDescriptors:sortDescriptors];
        NSLog(@"iiiiiiiiiiiiiiiii==========%@",ordered_arrWeightData);
        
        dates = [NSMutableArray arrayWithObjects:@"Sun", @"Mon", @"Tue",
                 @"Wed", @"Thu", @"Fri", @"Sat", nil];
        //Dictionary containing the name of the two sets and their associated color
        
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        
        if(ordered_arrWeightData.count>0)
        {
            for(int i=0;i<ordered_arrWeightData.count;i++)
            {
                NSNumber *weight = [f numberFromString:[[ordered_arrWeightData objectAtIndex:i]objectForKey:@"weight"]];
                [bpInputArr addObject:weight];
            }
        }
        
        NSLog(@"bpInputArr========%@",bpInputArr);
/////////////////////////////////////////////////////////////////////////////////////
      }

    //Dictionary containing the name of the two sets and their associated color
    //used for the demo
    NSMutableDictionary *dataTemp = [[NSMutableDictionary alloc] init];
    sets = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:149.0/255.0 green:27.0/255.0 blue:103.0/255.0 alpha:1], @"Plot 1",
            nil];
    
    //Generate random data for each set of data that will be displayed for each day
    //Numbers between 1 and 10
    
    
    xmax = -MAXFLOAT;
    xmin = MAXFLOAT;
    
    if(bpInputArr.count>0)
    {
    for (NSNumber *num in bpInputArr) {
        float x = num.floatValue;
        if (x < xmin) xmin = x;
        if (x > xmax) xmax = x;
    }
    
    minindex = [bpInputArr indexOfObject:[NSNumber numberWithFloat:xmin]];
    maxindex = [bpInputArr indexOfObject:[NSNumber numberWithFloat:xmax]];
    }
   
    int i=0;
    
   int j=0;
    
    
    for (NSString *date in dates) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (NSString *set in sets) {
           
            if([param isEqualToString:@"monthly"]){
                if(bpInputArr.count>0)
                {
                      [dict setObject:[bpInputArr objectAtIndex:j] forKey:set];
                  // [dict setObject:[NSNumber numberWithInt:j] forKey:set];
                }
                   j++;
                }
                else
                 {
                     if(bpInputArr.count>0)
                     {
                    [dict setObject:[bpInputArr objectAtIndex:i] forKey:set];
                     }
                    i++;
                 }
            
        }
       
        [dataTemp setObject:dict forKey:date];
    }
   
    
    
    data = [dataTemp copy];
    [dataTemp release];
    
    NSLog(@"Data is====%@", data);
}
-(CPTFill *)barFillForBarPlot:(CPTBarPlot *)barPlot recordIndex:(NSUInteger)idx {
    
    if(idx==minindex|| idx==maxindex )
        return [CPTFill fillWithColor:[CPTColor colorWithComponentRed:88/255. green:144/255. blue:85/255 alpha:1]];
    
    return nil;
    
}
- (void)generateLayout:(NSMutableArray *)arrWeightData withCategory:(NSString *)param
{
    //Create graph from theme
    graph                               = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    [graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    self.hostedGraph                    = graph;
    graph.plotAreaFrame.masksToBorder   = NO;
    graph.paddingLeft                   = 0.0f;
    graph.paddingTop                    = 0.0f;
    graph.paddingRight                  = 0.0f;
    graph.paddingBottom                 = 0.0f;
    
    CPTMutableLineStyle *borderLineStyle    = [CPTMutableLineStyle lineStyle];
    borderLineStyle.lineColor               = [CPTColor whiteColor];
    borderLineStyle.lineWidth               = 2.0f;
    graph.plotAreaFrame.borderLineStyle     = borderLineStyle;
    graph.plotAreaFrame.paddingTop          = 10.0;
    graph.plotAreaFrame.paddingRight        = 0.0;
    graph.plotAreaFrame.paddingBottom       = 80.0;
    graph.plotAreaFrame.paddingLeft         = 0.0;
    graph.plotAreaFrame.paddingTop    = 20.0;
    graph.plotAreaFrame.paddingBottom = 50.0;
    graph.plotAreaFrame.paddingLeft   = 40.0;
    graph.plotAreaFrame.paddingRight  = 5.0;
   // graph.cornerRadius=20;
    
    //Add plot space
    CPTXYPlotSpace *plotSpace       = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.delegate              = self;
    
    plotSpace.yRange                = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(40)
                                                                   length:CPTDecimalFromInt(120)];
    
    if([param isEqualToString:@"monthly"]){
    
    plotSpace.xRange                = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(-1)
                                                                   length:CPTDecimalFromInt((int)[dates count]+1)];
    }
   else if([param isEqualToString:@"weekly"]){
        
        plotSpace.xRange                = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(-1)
                                                                       length:CPTDecimalFromInt((int)[dates count]+1)];
    }

    else{
    
        plotSpace.xRange                = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(-1)
                                                                       length:CPTDecimalFromInt(8)];
    }
    
    //Grid line styles
    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth            = 1.0;
    majorGridLineStyle.lineColor            = [[CPTColor lightGrayColor] colorWithAlphaComponent:.5];
    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    minorGridLineStyle.lineWidth            = 0.25;
    minorGridLineStyle.lineColor            = [[CPTColor redColor] colorWithAlphaComponent:0.1];
    
    //Axes
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    
    //X axis
    CPTXYAxis *x                    = axisSet.xAxis;
    x.orthogonalCoordinateDecimal   = CPTDecimalFromInt(0);
    x.majorIntervalLength = CPTDecimalFromInt(1);

   // if([param isEqualToString:@"monthly"])
    // x.majorIntervalLength           = CPTDecimalFromInt(1);
    
    x.minorTicksPerInterval         = 0;
     if([param isEqualToString:@"monthly"])
         x.minorTicksPerInterval         = 0;
    x.labelingPolicy                = CPTAxisLabelingPolicyNone;
    if([param isEqualToString:@"monthly"])
    x.labelingPolicy                = CPTAxisLabelingPolicyNone;
    
    x.majorGridLineStyle            = majorGridLineStyle;
    x.axisConstraints               = [CPTConstraints constraintWithLowerOffset:0.0];
    
    if([param isEqualToString:@"monthly"]){
   //NSArray *exclusionRanges = [NSArray arrayWithObjects:
                               // [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(30)],
//                                [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(3) length:CPTDecimalFromFloat(12)],
//                              //  [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(2.99) length:CPTDecimalFromFloat(0.02)],
                             //  nil];
     //  x.labelExclusionRanges=exclusionRanges;
        
       // axisSet.xAxis.visibleRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(1) length:CPTDecimalFromInt(30)];
    }
    CPTMutableTextStyle *newStyle = [x.labelTextStyle mutableCopy];
    newStyle.color = [CPTColor colorWithComponentRed:102.0/255.0 green:182.0/255.0 blue:234.0/255.0 alpha:1];
    
    if([param isEqualToString:@"monthly"])
    {
        newStyle.fontSize=12;//8
       // newStyle.color = [CPTColor colorWithComponentRed:102.0/255.0 green:182.0/255.0 blue:234.0/255.0 alpha:0];
    }
    else
      newStyle.fontSize=12;
    //X labels
    
    int labelLocations = 0;
    
    if([param isEqualToString:@"monthly"])
        labelLocations =0;
    else
        labelLocations = 0;
        
    NSMutableArray *customXLabels = [NSMutableArray array];
    NSMutableArray *customXLabels1 = [NSMutableArray array];
    for (NSString *day in dates) {
        CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:day textStyle:newStyle];
        newLabel.tickLocation   = [[NSNumber numberWithInt:labelLocations] decimalValue];
        newLabel.offset         = x.labelOffset + x.majorTickLength;
        //newLabel.rotation       = M_PI / 4;
        [customXLabels addObject:newLabel];
        
        if([param isEqualToString:@"monthly"])
            labelLocations++;
         else
             
        labelLocations++;
        [newLabel release];
    }
    x.axisLabels                    = [NSSet setWithArray:customXLabels];
    
    
    //Y axis
    CPTXYAxis *y            = axisSet.yAxis;
    //y.title                 = @"Value";
    y.axisLineStyle=nil;
    
    y.backgroundColor=[[UIColor clearColor] CGColor];
    y.titleOffset           = -100.0f;
    y.labelingPolicy = CPTAxisLabelingPolicyFixedInterval;
    y.majorIntervalLength = CPTDecimalFromDouble(10);
    
    // y.labelOffset = -50;
    // y.tickDirection=
    CPTMutableTextStyle *newStyle1 = [y.labelTextStyle mutableCopy];
    newStyle1.color  = [CPTColor colorWithComponentRed:102.0/255.0 green:182.0/255.0 blue:234.0/255.0 alpha:1];
    if([param isEqualToString:@"monthly"])
        newStyle1.fontSize=12;
    else
        newStyle1.fontSize=12;
    CPTMutableLineStyle *tickLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineWidth = 1.0f;
    tickLineStyle.lineColor = [CPTColor blackColor];
    axisSet.yAxis.majorTickLineStyle = nil;
    axisSet.yAxis.minorTickLineStyle = nil;
    y.majorGridLineStyle    = majorGridLineStyle;
    y.minorGridLineStyle    = minorGridLineStyle;
    
    y.axisConstraints       = [CPTConstraints constraintWithLowerOffset:0.0];
    y.labelTextStyle=newStyle1;
  
    y.axisLabels     = [NSSet setWithArray:customXLabels1];
 
    //Create a bar line style
    CPTMutableLineStyle *barLineStyle   = [[[CPTMutableLineStyle alloc] init] autorelease];
    barLineStyle.lineWidth              = 2.0;
    barLineStyle.lineColor              = [CPTColor clearColor];
    CPTMutableTextStyle *whiteTextStyle = [CPTMutableTextStyle textStyle];
    whiteTextStyle.color                = [CPTColor purpleColor];
    
    //Plot
    BOOL firstPlot = YES;
    int count=[[sets allKeys] count];
    int i=1;
    for (NSString *set in [[sets allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]) {
        CPTBarPlot *plot        = [CPTBarPlot tubularBarPlotWithColor:[CPTColor redColor] horizontalBars:NO];
        plot.lineStyle          = barLineStyle;
        plot.delegate=self;
        plot.dataSource=self;
        CGColorRef color        = ((UIColor *)[sets objectForKey:set]).CGColor;
        plot.fill               = [CPTFill fillWithColor:[CPTColor colorWithCGColor:color]];
        if (firstPlot) {
            plot.barBasesVary   = NO;
            firstPlot           = NO;
        } else {
            plot.barBasesVary   = YES;
            
        }
         if([param isEqualToString:@"monthly"])
        plot.barWidth           =CPTDecimalFromFloat(0.2f);// CPTDecimalFromFloat(0.05f);
        
        else if([param isEqualToString:@"weekly"])
                plot.barWidth           = CPTDecimalFromFloat(0.3f);
         else
             plot.barWidth           = CPTDecimalFromFloat(0.5f);
        plot.barsAreHorizontal  = NO;
        
        plot.cornerRadius=0;
        plot.dataSource         = self;
        plot.identifier         = set;
        if(i==count)
            plot.barCornerRadius=40;
        //CPTBarPlotFieldBarLocation
        
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
        [anim setDuration:0.5f];
        
        anim.toValue = [NSNumber numberWithFloat:1.0f];
        anim.fromValue = [NSNumber numberWithFloat:0.0f];
        anim.removedOnCompletion = NO;
        anim.delegate = self;
        anim.fillMode = kCAFillModeForwards;
        
        plot.anchorPoint = CGPointMake(0.0, 0.0);
        
        [plot addAnimation:anim forKey:@"grow"];

        [graph addPlot:plot toPlotSpace:plotSpace];
        
        i++;
    }
    
    //Add legend
    CPTLegend *theLegend      = [CPTLegend legendWithGraph:graph];
    theLegend.numberOfRows	  = sets.count;
    theLegend.fill			  = [CPTFill fillWithColor:[CPTColor colorWithCGColor:[[UIColor clearColor] CGColor]]];
    theLegend.borderLineStyle = barLineStyle;
    theLegend.cornerRadius	  = 0;
    theLegend.swatchSize	  = CGSizeMake(15.0, 15.0);
    whiteTextStyle.fontSize	  = 13.0;
    theLegend.textStyle		  = whiteTextStyle;
    theLegend.rowMargin		  = 5.0;
    theLegend.paddingLeft	  = 10.0;
    theLegend.paddingTop	  = 10.0;
    theLegend.paddingRight	  = 10.0;
    theLegend.paddingBottom	  = 10.0;
    //graph.legend              = theLegend;
    //graph.legendAnchor        = CPTRectAnchorTopLeft;
    // graph.legendDisplacement  = CGPointMake(80.0, -10.0);
    
    
}

- (void)createGraph:(NSMutableArray *)arrWeightData withArray:(NSMutableArray *)weekStartEndArray withCategory:(NSString *)param
{
    //Generate data
    [self generateData:arrWeightData withArray:(NSMutableArray *)weekStartEndArray withCategory:(NSString *)param];
    
    //Generate layout
    [self generateLayout:arrWeightData withCategory:(NSString *)param];
}

- (void)dealloc
{
    [data release];
    [super dealloc];
}

#pragma mark - CPTPlotDataSource methods
-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
   
        NSDictionary *bar = [dates objectAtIndex:index];
        
        
            return [bar valueForKey:@"POSITION"];
    
    
    return [NSNumber numberWithFloat:0];
}
- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return dates.count;
}

- (double)doubleForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    double num = NAN;
    
    //X Value
    if (fieldEnum == 0) {
        num = index;
    }
    
    else {
        double offset = 0;
        if (((CPTBarPlot *)plot).barBasesVary) {
            for (NSString *set in [[sets allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]) {
                if ([plot.identifier isEqual:set]) {
                    break;
                }
                offset += [[[data objectForKey:[dates objectAtIndex:index]] objectForKey:set] doubleValue];
            }
        }
        
        //Y Value
        if (fieldEnum == 1) {
            num = [[[data objectForKey:[dates objectAtIndex:index]] objectForKey:plot.identifier] doubleValue] + offset;
        }
        
        //Offset for stacked bar
        else {
            num = offset;
        }
    }
    
    //NSLog(@"%@ - %d - %d - %f", plot.identifier, index, fieldEnum, num);
    
    return num;
}

@end
