//
//  Decode64.h
//  PlatinumProducer
//
//  Created by Debasish Pal on 05/07/11.
//  Copyright 2011 ObjectSol. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Base64 : NSObject {
	
}


+ (NSString*) encode:(const uint8_t*) input length:(NSInteger) length;
+ (NSString*) encode:(NSData*) rawBytes;
+ (NSData*) decode:(const char*) string length:(NSInteger) inputLength;
+ (NSData*) decode:(NSString*) string;



@end
