//
//  PhoneCodesConstants.m
//  PetBooking
//
//  Created by Ryniere S Silva on 07/12/16.
//  Copyright © 2016 B2Beauty. All rights reserved.
//

#import "PhoneCodesConstants.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>


@implementation PhoneCodesConstants

+(NSDictionary*)getCarrierLocalCodeConstDictionary {
	static NSDictionary *inst = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		inst = @{
						 @"00": @"99",
						 @"02": @"41",
						 @"03": @"41",
						 @"04": @"41",
						 @"05": @"21",
						 @"06": @"15",
						 @"10": @"15",
						 @"11": @"15",
						 @"15": @"43",
						 @"23": @"15",
						 @"30": @"14",
						 @"32": @"14",
						 @"38": @"21",
						 @"39": @"99",
						 @"54": @"41"
						 };
	});
	return inst;
}

+(NSString*)getLocalCodeforCarrier {
	
	CTTelephonyNetworkInfo *network_Info = [CTTelephonyNetworkInfo new];
	CTCarrier *carrier = network_Info.subscriberCellularProvider;
	NSString *mnc = [carrier mobileNetworkCode];
	NSString *mcc = [carrier mobileCountryCode];
	NSLog(@"country code is: %@, mnc: %@, mcc: %@", carrier.mobileCountryCode, mnc, mcc);
	
	NSString* localCode = [[PhoneCodesConstants getCarrierLocalCodeConstDictionary] objectForKey:mnc];
	
	if (localCode != nil) {
		return localCode;
	}
	
	return @"21";
}


@end
