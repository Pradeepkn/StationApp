//
//  Stations+CoreDataProperties.m
//  
//
//  Created by Pradeep Narendra on 10/25/16.
//
//

#import "Stations+CoreDataProperties.h"

@implementation Stations (CoreDataProperties)

+ (NSFetchRequest<Stations *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Stations"];
}

@dynamic stationId;
@dynamic stationName;
@dynamic statusColor;
@dynamic stationCode;
@dynamic phaseNumber;
@dynamic isIRSDC;

@end
