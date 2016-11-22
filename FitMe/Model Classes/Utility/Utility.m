
/********************************************//*!
* @file Utility.m
* @brief Contains constants and global parameters
* DreamzTech Solution ("COMPANY") CONFIDENTIAL
* Unpublished Copyright (c) 2015 DreamzTech Solution, All Rights Reserved.
***********************************************/


#import "Utility.h"
#import "Alert.h"
#import "Reachability.h"
#import "NSString+HTML.h"

#define SQUARE(i) ((i)*(i))
#define USER_INFO @"UD@UserInfo"
#define SELECTED_DATE @"UD@SelectedDate"
#define SELECTED_DATE_YMD @"UD@SelectedDateYMD"
#define SELECTED_MONTH @"yrarmonth"
#define SELECTED_DATE_PLANNER_DAILY @"plannerDailyDate"
#define SELECTED_DATE_PLANNER_MULTIPLE @"plannerDateMultiple"
#define CURRENT_YEAR_MONTH @"currentYearMonth"
#define SELECTED_DATE_PLANNER_WEEKLY @"plannerDateWeekly"
inline static void zeroClearInt(int* p, size_t count) { memset(p, 0, sizeof(int) * count); }

@implementation Utility

+ (Utility *)sharedManager {
    static Utility *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(void)setAllDates:(NSMutableArray *)array{
    _allDatesOfMonthArr=[NSMutableArray new];
    _allDatesOfMonthArr=[array mutableCopy];

}

-(NSMutableArray*)getAllDates{
    return _allDatesOfMonthArr;

}
-(BOOL)isUserLoggedIn {
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"userLogin"] isEqualToString:@"YES"]){
        return YES;
    }
    else{
        return NO;
    }
}

-(void)setUserLoginEnable:(BOOL)login {
    [[NSUserDefaults standardUserDefaults] setValue:login == YES ? @"YES" : @"NO" forKey:@"userLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString *)getReplacedXMLEncodedCharacterString:(NSString *)str{
    if ([str isKindOfClass:[NSNull class]]||str==nil||str.length<=0) {
        return @"";
    }
    return [str stringByReplacingOccurrencesOfString: @"&amp;" withString:@"&"];
}

-(NSString *)nextUpdateEvent:(NSString *)updateDate{
    NSString *strNextUpdate = updateDate;
    NSDateFormatter *dateFormatter_current = [[NSDateFormatter alloc] init];
    [dateFormatter_current setDateFormat:@"yyyy-MM-dd"];
    NSDate *date;
    date =[dateFormatter_current dateFromString:strNextUpdate];
    [dateFormatter_current setDateFormat:@"MMMM dd, yyyy"];// MMMM dd, yyyy EEEE
    strNextUpdate=[dateFormatter_current stringFromDate:date];
    return strNextUpdate;
}

-(void)saveUserDetailsTouserDeafult:(User*)user{
    NSData *userEncoderObject = [NSKeyedArchiver archivedDataWithRootObject:user];
    [[NSUserDefaults standardUserDefaults] setObject:userEncoderObject forKey:SaveUser];    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
-(void)clearUserValues{    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:SaveUser];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(User*)retriveUserDetailsFromDefault{
    User *user=(User*)[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] valueForKey:SaveUser]];
    return user;
}

-(void)saveProfileDetailsTouserDefault:(Profile*)profile{
    NSData *userEncoderObject = [NSKeyedArchiver archivedDataWithRootObject:profile];
    [[NSUserDefaults standardUserDefaults] setObject:userEncoderObject forKey:SaveProfile];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(Profile*)retriveProfileDetailsFromDefault{
    Profile *profile=(Profile*)[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] valueForKey:SaveProfile]];
    return profile;
}

-(BOOL)isIpad{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) return NO;
    return YES;
}

-(NSMutableArray *)returnUniqueArray :(NSMutableArray *)originalArray{
    NSMutableArray *uniqueArray = [NSMutableArray array];
    NSMutableSet *MsgID = [NSMutableSet set];
    for (id obj in originalArray) {
        NSString *destinationID = [obj valueForKey:@"id"];
        if (![MsgID containsObject:destinationID]) {
            [uniqueArray addObject:obj];
            [MsgID addObject:destinationID];
        }
        else{
            ;
        }
    }
    return uniqueArray;
}

- (UIImage *)resizeImageKeepingAspectRatio:(UIImage *)sourceImage byWidth:(CGFloat)width{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = width / oldWidth;
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)resizeImageKeepingAspectRatio:(UIImage *)sourceImage byHeight:(CGFloat)height {
    float oldWidth = sourceImage.size.height;
    float scaleFactor = height / oldWidth;
    float  newWidth = sourceImage.size.width * scaleFactor;
    float newHeight = oldWidth * scaleFactor;
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


- (UIImage *)resizeImageIgnoringAspectRatio:(UIImage *)sourceImage bySize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [sourceImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*)mergeImage:(UIImage*)firstImage withImage:(UIImage*)secondImage
{
    CGFloat secondWidth = secondImage.size.width;
    CGFloat secondHeight = secondImage.size.height;
    CGSize mergedSize = CGSizeMake(MAX(secondWidth, secondWidth), MAX(secondHeight, secondHeight));
    UIGraphicsBeginImageContext(mergedSize);
    [firstImage drawInRect:CGRectMake(0, 0, secondWidth, secondHeight)];
    [secondImage drawInRect:CGRectMake(0, 0, secondWidth, secondHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)blurImage:(UIImage *)sourceImage blurAmount:(float)blur {
    if (blur < 1){
        return sourceImage;
    }
    // Suggestion xidew to prevent crash if size is null
    if (CGSizeEqualToSize(sourceImage.size, CGSizeZero)) {
        return sourceImage;
    }
    
    //	return [other applyBlendFilter:filterOverlay  other:self context:nil];
    // First get the image into your data buffer
    CGImageRef inImage = sourceImage.CGImage;
    long nbPerCompt = CGImageGetBitsPerPixel(inImage);
    if(nbPerCompt != 32){
        UIImage *tmpImage = [self normalize:sourceImage];
        inImage = tmpImage.CGImage;
    }
    CFDataRef dataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));
    CFMutableDataRef m_DataRef = CFDataCreateMutableCopy(0, 0, dataRef);
    CFRelease(dataRef);
    UInt8 * m_PixelBuf=malloc(CFDataGetLength(m_DataRef));
    CFDataGetBytes(m_DataRef,
                   CFRangeMake(0,CFDataGetLength(m_DataRef)) ,
                   m_PixelBuf);
    
    CGContextRef ctx = CGBitmapContextCreate(m_PixelBuf,
                                             CGImageGetWidth(inImage),
                                             CGImageGetHeight(inImage),
                                             CGImageGetBitsPerComponent(inImage),
                                             CGImageGetBytesPerRow(inImage),
                                             CGImageGetColorSpace(inImage),
                                             CGImageGetBitmapInfo(inImage)
                                             );
    
    // Apply stack blur
    const int imageWidth  = CGImageGetWidth(inImage);
    const int imageHeight = CGImageGetHeight(inImage);
    [self applyStackBlurToBuffer:m_PixelBuf
                           width:imageWidth
                          height:imageHeight
                      withRadius:blur];
    
    // Make new image
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
    
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CFRelease(m_DataRef);
    free(m_PixelBuf);
    return finalImage;
}

- (UIImage *) normalize:(UIImage *)image {
    int width = image.size.width;
    int height = image.size.height;
    CGColorSpaceRef genericColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef thumbBitmapCtxt = CGBitmapContextCreate(NULL,
                                                         width,
                                                         height,
                                                         8, (4 * width),
                                                         genericColorSpace,
                                                         kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(genericColorSpace);
    CGContextSetInterpolationQuality(thumbBitmapCtxt, kCGInterpolationDefault);
    CGRect destRect = CGRectMake(0, 0, width, height);
    CGContextDrawImage(thumbBitmapCtxt, destRect, image.CGImage);
    CGImageRef tmpThumbImage = CGBitmapContextCreateImage(thumbBitmapCtxt);
    CGContextRelease(thumbBitmapCtxt);
    UIImage *result = [UIImage imageWithCGImage:tmpThumbImage];
    CGImageRelease(tmpThumbImage);
    return result;
}

- (NSString *)changeDate:(NSString *)date fromFormat:(NSString *)from toFormat:(NSString *)to {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:from];
    NSDate *dt = [dateFormatter dateFromString:date];
    [dateFormatter setDateFormat:to];
    return [dateFormatter stringFromDate:dt];
}

- (UIImage *)cropImage:(UIImage *)sourceImage withRect:(CGRect)rect {
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, sourceImage.size.width, sourceImage.size.height);
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
    [sourceImage drawInRect:drawRect];
    UIImage* subImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return subImage;
}

- (UIImage *)maskImage:(UIImage *)sourceImage withMask:(UIImage *)maskImage
{
    CGImageRef imageReference = sourceImage.CGImage;
    CGImageRef maskReference = maskImage.CGImage;
    
    CGImageRef imageMask = CGImageMaskCreate(CGImageGetWidth(maskReference),
                                             CGImageGetHeight(maskReference),
                                             CGImageGetBitsPerComponent(maskReference),
                                             CGImageGetBitsPerPixel(maskReference),
                                             CGImageGetBytesPerRow(maskReference),
                                             CGImageGetDataProvider(maskReference),
                                             NULL, // Decode is null
                                             YES // Should interpolate
                                             );
    CGImageRef maskedReference = CGImageCreateWithMask(imageReference, imageMask);
    CGImageRelease(imageMask);
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedReference];
    CGImageRelease(maskedReference);
    return maskedImage;
}

- (UIImage *)normalizedCapturedImage:(UIImage *)rawImage {
    if (rawImage.imageOrientation == UIImageOrientationUp)return rawImage ;
    
    UIGraphicsBeginImageContextWithOptions(rawImage.size, NO, rawImage.scale);
    [rawImage drawInRect:(CGRect){0, 0, rawImage.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

- (UIImage *)getCurrentScreenShot:(UIViewController *)viewController {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(viewController.view.window.bounds.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(viewController.view.window.bounds.size);
    [viewController.view.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenShot;
}


- (void) applyStackBlurToBuffer:(UInt8*)targetBuffer width:(const int)w height:(const int)h withRadius:(NSUInteger)inradius {
    // Constants
    const int radius = (int)inradius; // Transform unsigned into signed for further operations
    const int wm = w - 1;
    const int hm = h - 1;
    const int wh = w*h;
    const int div = radius + radius + 1;
    const int r1 = radius + 1;
    const int divsum = SQUARE((div+1)>>1);
    
    // Small buffers
    int stack[div*3];
    zeroClearInt(stack, div*3);
    
    int vmin[MAX(w,h)];
    zeroClearInt(vmin, MAX(w,h));
    
    // Large buffers
    int *r = malloc(wh*sizeof(int));
    int *g = malloc(wh*sizeof(int));
    int *b = malloc(wh*sizeof(int));
    zeroClearInt(r, wh);
    zeroClearInt(g, wh);
    zeroClearInt(b, wh);
    
    const size_t dvcount = 256 * divsum;
    int *dv = malloc(sizeof(int) * dvcount);
    for (int i = 0;(size_t)i < dvcount;i++) {
        dv[i] = (i / divsum);
    }
    
    // Variables
    int x, y;
    int *sir;
    int routsum,goutsum,boutsum;
    int rinsum,ginsum,binsum;
    int rsum, gsum, bsum, p, yp;
    int stackpointer;
    int stackstart;
    int rbs;
    
    int yw = 0, yi = 0;
    for (y = 0;y < h;y++) {
        rinsum = ginsum = binsum = routsum = goutsum = boutsum = rsum = gsum = bsum = 0;
        
        for(int i = -radius;i <= radius;i++){
            sir = &stack[(i + radius)*3];
            int offset = (yi + MIN(wm, MAX(i, 0)))*4;
            sir[0] = targetBuffer[offset];
            sir[1] = targetBuffer[offset + 1];
            sir[2] = targetBuffer[offset + 2];
            
            rbs = r1 - abs(i);
            rsum += sir[0] * rbs;
            gsum += sir[1] * rbs;
            bsum += sir[2] * rbs;
            if (i > 0){
                rinsum += sir[0];
                ginsum += sir[1];
                binsum += sir[2];
            } else {
                routsum += sir[0];
                goutsum += sir[1];
                boutsum += sir[2];
            }
        }
        stackpointer = radius;
        
        for (x = 0;x < w;x++) {
            r[yi] = dv[rsum];
            g[yi] = dv[gsum];
            b[yi] = dv[bsum];
            
            rsum -= routsum;
            gsum -= goutsum;
            bsum -= boutsum;
            
            stackstart = stackpointer - radius + div;
            sir = &stack[(stackstart % div)*3];
            
            routsum -= sir[0];
            goutsum -= sir[1];
            boutsum -= sir[2];
            
            if (y == 0){
                vmin[x] = MIN(x + radius + 1, wm);
            }
            
            int offset = (yw + vmin[x])*4;
            sir[0] = targetBuffer[offset];
            sir[1] = targetBuffer[offset + 1];
            sir[2] = targetBuffer[offset + 2];
            rinsum += sir[0];
            ginsum += sir[1];
            binsum += sir[2];
            
            rsum += rinsum;
            gsum += ginsum;
            bsum += binsum;
            
            stackpointer = (stackpointer + 1) % div;
            sir = &stack[(stackpointer % div)*3];
            
            routsum += sir[0];
            goutsum += sir[1];
            boutsum += sir[2];
            
            rinsum -= sir[0];
            ginsum -= sir[1];
            binsum -= sir[2];
            
            yi++;
        }
        yw += w;
    }
    
    for (x = 0;x < w;x++) {
        rinsum = ginsum = binsum = routsum = goutsum = boutsum = rsum = gsum = bsum = 0;
        yp = -radius*w;
        for(int i = -radius;i <= radius;i++) {
            yi = MAX(0, yp) + x;
            
            sir = &stack[(i + radius)*3];
            
            sir[0] = r[yi];
            sir[1] = g[yi];
            sir[2] = b[yi];
            
            rbs = r1 - abs(i);
            
            rsum += r[yi]*rbs;
            gsum += g[yi]*rbs;
            bsum += b[yi]*rbs;
            
            if (i > 0) {
                rinsum += sir[0];
                ginsum += sir[1];
                binsum += sir[2];
            } else {
                routsum += sir[0];
                goutsum += sir[1];
                boutsum += sir[2];
            }
            
            if (i < hm) {
                yp += w;
            }
        }
        yi = x;
        stackpointer = radius;
        for (y = 0;y < h;y++) {
            int offset = yi*4;
            targetBuffer[offset]     = dv[rsum];
            targetBuffer[offset + 1] = dv[gsum];
            targetBuffer[offset + 2] = dv[bsum];
            rsum -= routsum;
            gsum -= goutsum;
            bsum -= boutsum;
            
            stackstart = stackpointer - radius + div;
            sir = &stack[(stackstart % div)*3];
            
            routsum -= sir[0];
            goutsum -= sir[1];
            boutsum -= sir[2];
            
            if (x == 0){
                vmin[y] = MIN(y + r1, hm)*w;
            }
            p = x + vmin[y];
            
            sir[0] = r[p];
            sir[1] = g[p];
            sir[2] = b[p];
            
            rinsum += sir[0];
            ginsum += sir[1];
            binsum += sir[2];
            
            rsum += rinsum;
            gsum += ginsum;
            bsum += binsum;
            
            stackpointer = (stackpointer + 1) % div;
            sir = &stack[stackpointer*3];
            
            routsum += sir[0];
            goutsum += sir[1];
            boutsum += sir[2];
            
            rinsum -= sir[0];
            ginsum -= sir[1];
            binsum -= sir[2];
            
            yi += w;
        }
    }
    free(r);
    free(g);
    free(b);
    free(dv);
}

- (NSString *)getProjectVersionNumber {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

- (NSString *)getBuildVersionNumber {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

- (CGSize)getDeviceScreenSize {
    return [[UIScreen mainScreen] bounds].size;
}

- (NSString *)getDeviceOSVersionNumber {
    return [[UIDevice currentDevice] systemVersion];
}

- (BOOL)isNetworkAvailable{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    return ([networkReachability currentReachabilityStatus] == NotReachable) ? NO : YES;
}

- (NSDate *)getGMTDateTimeFromLocalDateTime:(NSDate *)date {
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    [dateFormatter setTimeZone:timeZone];
    return [dateFormatter dateFromString:[dateFormatter stringFromDate:date]];
}

- (int)differenceBetweenTwoDates:(NSDate *)startDate endDate:(NSDate *)endDate {
    NSTimeInterval secondsBetween = [endDate timeIntervalSinceDate:startDate];
    return secondsBetween / 86400;
}

- (NSDate *)getLocalDateTimeFromGMTDateTime:(NSDate *)date {
    NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
    NSDate *dateInLocalTimezone = [date dateByAddingTimeInterval:timeZoneSeconds];
    return dateInLocalTimezone;
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

- (NSString *)stripTags:(NSString *)str
{
    NSMutableString *html = [NSMutableString stringWithCapacity:[str length]];
    NSScanner *scanner = [NSScanner scannerWithString:str];
    scanner.charactersToBeSkipped = NULL;
    NSString *tempText = nil;
    while (![scanner isAtEnd])
    {
        [scanner scanUpToString:@"<" intoString:&tempText];
        if (tempText != nil)
            [html appendString:tempText];
        [scanner scanUpToString:@">" intoString:NULL];
        if (![scanner isAtEnd])
            [scanner setScanLocation:[scanner scanLocation] + 1];
        tempText = nil;
    }
    return html;
}

- (NSString*)textToHtml:(NSString*)htmlString {
    
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&amp;"  withString:@"&"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&lt;"  withString:@"<"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&gt;"  withString:@">"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&quot;" withString:@""""];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#039;"  withString:@"'"];
    
    htmlString = [@"<p>" stringByAppendingString:htmlString];
    htmlString = [htmlString stringByAppendingString:@"</p>"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"\n" withString:@"</p><p>"];
    while ([htmlString rangeOfString:@"  "].length > 0) {
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"  " withString:@"&nbsp;&nbsp;"];
    }
    return htmlString;
}

- (NSString *)encodeStringToBase64:(NSString *)str {
    str= [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSString *htmlEncodedString = [str kv_encodeHTMLCharacterEntities];
    
    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 7) {
        NSData *plainData = [htmlEncodedString dataUsingEncoding:NSUTF8StringEncoding];
        NSString *str = [plainData base64EncodedStringWithOptions:0];
        str = [str stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
        return str;
    }
    else
    {
        static char base64EncodingTable[64] = {
            'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
            'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
            'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
            'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
        };
        
        unsigned long ixtext, lentext;
        long ctremaining;
        unsigned char input[3], output[4];
        short i, charsonline = 0, ctcopy;
        const unsigned char *raw;
        NSMutableString *result;
        NSData* data = [htmlEncodedString dataUsingEncoding:NSUTF8StringEncoding];
        lentext = [data length];
        if (lentext < 1)
            return @"";
        result = [NSMutableString stringWithCapacity: lentext];
        raw = [data bytes];
        ixtext = 0;
        
        while (true) {
            ctremaining = lentext - ixtext;
            if (ctremaining <= 0)
                break;
            for (i = 0; i < 3; i++) {
                unsigned long ix = ixtext + i;
                if (ix < lentext)
                    input[i] = raw[ix];
                else
                    input[i] = 0;
            }
            output[0] = (input[0] & 0xFC) >> 2;
            output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
            output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
            output[3] = input[2] & 0x3F;
            ctcopy = 4;
            switch (ctremaining) {
                case 1:
                    ctcopy = 2;
                    break;
                case 2:
                    ctcopy = 3;
                    break;
            }
            
            for (i = 0; i < ctcopy; i++)
                [result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
            
            for (i = ctcopy; i < 4; i++)
                [result appendString: @"="];
            
            ixtext += 3;
            charsonline += 4;
            
            if ((lentext > 0) && (charsonline >= lentext))
                charsonline = 0;
        }
        NSString *finalString = [result stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
        return finalString;
    }
}

- (NSString *)decodeStringFromBase64:(NSString *)str {
    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 7) {
        NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:str options:0];
        NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
        decodedString = [decodedString stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];
        return [decodedString kv_decodeHTMLCharacterEntities];
    }
    else
    {
        unsigned long ixtext, lentext;
        unsigned char ch, inbuf[4], outbuf[3];
        short i, ixinbuf;
        Boolean flignore, flendtext = false;
        const unsigned char *tempcstring;
        NSMutableData *theData;
        if (str == nil)
        {
            NSString* responseString = [[NSString alloc] initWithData:[NSData data] encoding:NSNonLossyASCIIStringEncoding];
            return responseString;
        }
        ixtext = 0;
        tempcstring = (const unsigned char *)[str UTF8String];
        lentext = [str length];
        theData = [NSMutableData dataWithCapacity: lentext];
        ixinbuf = 0;
        while (true)
        {
            if (ixtext >= lentext)
            {
                break;
            }
            ch = tempcstring [ixtext++];
            
            flignore = false;
            
            if ((ch >= 'A') && (ch <= 'Z'))
            {
                ch = ch - 'A';
            }
            else if ((ch >= 'a') && (ch <= 'z'))
            {
                ch = ch - 'a' + 26;
            }
            else if ((ch >= '0') && (ch <= '9'))
            {
                ch = ch - '0' + 52;
            }
            else if (ch == '+')
            {
                ch = 62;
            }
            else if (ch == '=')
            {
                flendtext = true;
            }
            else if (ch == '/')
            {
                ch = 63;
            }
            else
            {
                flignore = true;
            }
            if (!flignore)
            {
                short ctcharsinbuf = 3;
                Boolean flbreak = false;
                if (flendtext)
                {
                    if (ixinbuf == 0)
                    {
                        break;
                    }
                    if ((ixinbuf == 1) || (ixinbuf == 2))
                    {
                        ctcharsinbuf = 1;
                    }
                    else
                    {
                        ctcharsinbuf = 2;
                    }
                    ixinbuf = 3;
                    flbreak = true;
                }
                inbuf [ixinbuf++] = ch;
                if (ixinbuf == 4)
                {
                    ixinbuf = 0;
                    outbuf[0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
                    outbuf[1] = ((inbuf[1] & 0x0F) << 4) | ((inbuf[2] & 0x3C) >> 2);
                    outbuf[2] = ((inbuf[2] & 0x03) << 6) | (inbuf[3] & 0x3F);
                    for (i = 0; i < ctcharsinbuf; i++)
                    {
                        [theData appendBytes: &outbuf[i] length: 1];
                    }
                }
                if (flbreak)
                {
                    break;
                }
            }
        }
        NSString* decodeString = [[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding];
        decodeString = [decodeString stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];
        return [decodeString kv_decodeHTMLCharacterEntities];
    }
}

- (NSString *)getDocumentDirectoryPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

- (NSString *)createFolderInDocumentDirectory:(NSString *)folderName {
    if ([folderName isEqualToString:@""] || folderName == nil)
        return nil;
    NSError *error;
    NSString *dataPath = [[self getDocumentDirectoryPath] stringByAppendingPathComponent:folderName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    return dataPath;
}

- (NSString *)getFolderPathFromDocumentDirectory:(NSString *)folderName {
    if ([folderName isEqualToString:@""] || folderName == nil)
        return nil;
    NSString *dataPath = [[self getDocumentDirectoryPath] stringByAppendingPathComponent:folderName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        return nil;
    return dataPath;
}

- (NSString *)getFilePathFromDocumentDirectory:(NSString *)fileName inFolder:(NSString *)folderName {
    NSString *folderPath = [self getDocumentDirectoryPath];
    if (!([folderName isEqualToString:@""] || folderName == nil))
        folderPath = [folderName stringByAppendingString:folderName];
    NSDirectoryEnumerator *direnum = [[NSFileManager defaultManager] enumeratorAtPath:folderPath];
    NSString *documentsSubpath;
    BOOL isFound = NO;
    while (documentsSubpath = [direnum nextObject]) {
        if (![documentsSubpath.lastPathComponent isEqual:fileName])
            continue;
        isFound = YES;
        break;
    }
    return isFound == YES ? [folderPath stringByAppendingString:documentsSubpath] : nil;
}

- (NSString *)saveFileInDocumentDirectory:(NSData *)fileData fileName:(NSString *)fileName inDirectory:(NSString *)folderName {
    NSString *filePath = [self getDocumentDirectoryPath];
    if (!([folderName isEqualToString:@""] || folderName == nil)) {
        filePath = [filePath stringByAppendingString:folderName];
        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
            filePath = [self createFolderInDocumentDirectory:folderName];
    }
    filePath = [filePath stringByAppendingPathComponent:[fileName isEqualToString:@""] || fileName == nil ? @"undefined" : fileName];
    [fileData writeToFile:filePath atomically:NO];
    return filePath;
}

- (BOOL)removeSpecificFileFromDirectory:(NSString *)folderName fileName:(NSString *)fileName {
    if (fileName == nil || [fileName isEqualToString:@""])
        return NO;
    NSString *filePath = [self getDocumentDirectoryPath];
    if (!([folderName isEqualToString:@""] || folderName == nil)) {
        filePath = [filePath stringByAppendingPathComponent:folderName];
    }
    NSError *error;
    filePath = [filePath stringByAppendingPathComponent:fileName];
    if (![[NSFileManager defaultManager] removeItemAtPath:filePath error:&error]) {
        NSLog(@"Error to delete file : %@", error);
        return NO;
    }
    return YES;
}

- (BOOL)removeAllFilesFromDirectory:(NSString *)folderName {
    if (folderName != nil || [folderName isEqualToString:@""]) {
        NSString *fPath = [self getFolderPathFromDocumentDirectory:folderName];
        if (fPath == nil)
            return NO;
        NSFileManager *fm = [NSFileManager defaultManager];
        NSString *directory = [fPath stringByAppendingPathComponent:@"/"];
        NSError *error;
        for (NSString *file in [fm contentsOfDirectoryAtPath:directory error:&error]) {
            BOOL success = [fm removeItemAtPath:[NSString stringWithFormat:@"%@/%@", directory, file] error:&error];
            if (!success || error)
                NSLog(@"Error to delete file : %@", error);
        }
        fm = nil;
        return YES;
    }
    return NO;
}

- (BOOL)removeSpecificDirectoryFromDocumentDirectory:(NSString *)folderName {
    if ([folderName isEqualToString:@""] || folderName == nil)
        return NO;
    NSString *folderPath = [[self getDocumentDirectoryPath] stringByAppendingPathComponent:folderName];
    NSError *error;
    if (![[NSFileManager defaultManager] removeItemAtPath:folderPath error:&error]) {
        return NO;
    }
    return YES;
}

- (BOOL)removeAllFilesAndFolderFromDocumentDirectory {
    NSString *documentDirectoryPath = [self getDocumentDirectoryPath];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
    for (NSString *file in [fm contentsOfDirectoryAtPath:documentDirectoryPath error:&error]) {
        BOOL success = [fm removeItemAtPath:[NSString stringWithFormat:@"%@/%@", documentDirectoryPath, file] error:&error];
        if (!success || error)
            NSLog(@"Error to delete file : %@", error);
    }
    fm = nil;
    return YES;
}
- (void)saveSelectedDateYMD:(NSString *)selectedDate{
    [[NSUserDefaults standardUserDefaults] setObject:selectedDate forKey:SELECTED_DATE_YMD];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (void)saveSelectedCalMonth:(NSString *)selectedDate{
    [[NSUserDefaults standardUserDefaults] setObject:selectedDate forKey:SELECTED_MONTH];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (NSString *)getSelectedCalMonth {
    return [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_MONTH];
}
- (void)saveSelectedDate:(NSString *)selectedDate {
    [[NSUserDefaults standardUserDefaults] setObject:selectedDate forKey:SELECTED_DATE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getSelectedDate {
    return [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_DATE];
}
- (NSString *)getSelectedDateFormat {
    return [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_DATE_YMD];
}

- (void)savePlannerDailyDate:(NSString *)selectedDate{
    [[NSUserDefaults standardUserDefaults] setObject:selectedDate forKey:SELECTED_DATE_PLANNER_DAILY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (NSString *)getPlannerDailyDate {
    return [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_DATE_PLANNER_DAILY];
}

- (void)removePlannerDailyDate {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SELECTED_DATE_PLANNER_DAILY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
////////////////////////

- (void)saveCurrentYearMonth:(NSString *)selectedDate{
    [[NSUserDefaults standardUserDefaults] setObject:selectedDate forKey:CURRENT_YEAR_MONTH];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (NSString *)getCurrentYearMonth {
    return [[NSUserDefaults standardUserDefaults] objectForKey:CURRENT_YEAR_MONTH];
}

- (void)removeCurrentYearMonth {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CURRENT_YEAR_MONTH];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


////////////////////////
- (void)removeSelectedDate {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SELECTED_DATE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)removeSelectedMonth {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SELECTED_MONTH];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)savePlannerMultipleDate:(NSMutableArray *)selectedDateArray{

    [[NSUserDefaults standardUserDefaults] setObject:selectedDateArray forKey:SELECTED_DATE_PLANNER_MULTIPLE];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
- (NSMutableArray *)getPlannerMultipleDate{
    return [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_DATE_PLANNER_MULTIPLE];
}
- (void)removePlannerMultipleDate{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SELECTED_DATE_PLANNER_MULTIPLE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
///////////////////////// weekly date ///////////////////////
- (void)saveWeeklyDate:(NSMutableArray *)selectedDateArray{
    [[NSUserDefaults standardUserDefaults] setObject:selectedDateArray forKey:SELECTED_DATE_PLANNER_WEEKLY];
    [[NSUserDefaults standardUserDefaults] synchronize];
  
}

- (NSMutableArray *)getWeeklyDate{
   return [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_DATE_PLANNER_WEEKLY];
}

- (void)removeWeeklyDate{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SELECTED_DATE_PLANNER_WEEKLY];
    [[NSUserDefaults standardUserDefaults] synchronize];

}



/////////////////////////////////////////////////////////////

+(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
