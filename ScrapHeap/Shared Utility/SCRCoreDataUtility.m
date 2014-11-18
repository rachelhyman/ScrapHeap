//
//  SCRCoreDataUtility.m
//  ScrapHeap
//
//  Created by Rachel Hyman on 11/3/14.
//  Copyright (c) 2014 Rachel Hyman. All rights reserved.
//

#import "SCRCoreDataUtility.h"

#import "VOKCoreDataManager.h"
#import "SCRBuilding.h"
#import "SCRViolation.h"

@implementation SCRCoreDataUtility

+ (void)resetCoreData
{
    [[VOKCoreDataManager sharedInstance] resetCoreData];
    [self setUpCoreData];
}

+ (void)setUpCoreData
{
    [self setUpCoreDataWithDatabaseName:SCRCoreData.SqliteDatabaseName];
}

+ (void)setUpCoreDataWithDatabaseName:(NSString *)databaseName
{
    [self setUpCoreDataStackWithDatabaseName:databaseName];
    [self setUpMapsForViolation];
}

+ (void)setUpCoreDataStackWithDatabaseName:(NSString *)databaseName
{
    [[VOKCoreDataManager sharedInstance] setResource:SCRCoreData.ModelName database:databaseName];
    [[VOKCoreDataManager sharedInstance] managedObjectContext];
}

+ (NSNumberFormatter *)sharedNumberFormatter
{
    static NSNumberFormatter *numberFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        numberFormatter = [[NSNumberFormatter alloc] init];
    });
    return numberFormatter;
}

+ (NSDateFormatter *)sharedDateFormatter
{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"YYYY-MM-dd'T'HH:mm:ss";
    });
    return dateFormatter;
}

+ (void)setUpMapsForViolation
{
    NSArray *maps = @[
                      VOK_MAP_FOREIGN_TO_LOCAL(@"violation_inspector_comments", inspectorComments),
                      [VOKManagedObjectMap mapWithForeignKeyPath:@"violation_last_modified_date"
                                                     coreDataKey:VOK_CDSELECTOR(lastModifiedDate)
                                                   dateFormatter:[self sharedDateFormatter]],
                      VOK_MAP_FOREIGN_TO_LOCAL(@"violation_ordinance", ordinance),
                      VOK_MAP_FOREIGN_TO_LOCAL(@"violation_status", status),
                      [VOKManagedObjectMap mapWithForeignKeyPath:@"violation_date"
                                                     coreDataKey:VOK_CDSELECTOR(violationDate)
                                                   dateFormatter:[self sharedDateFormatter]],
                      VOK_MAP_FOREIGN_TO_LOCAL(@"violation_description", violationDescription),
                      VOK_MAP_FOREIGN_TO_LOCAL(@"id", violationID),
                      ];
    
    VOKManagedObjectMapper *mapper = [VOKManagedObjectMapper mapperWithUniqueKey:VOK_CDSELECTOR(violationID) andMaps:maps];
    mapper.ignoreNullValueOverwrites = YES;
    
    mapper.importCompletionBlock = ^(NSDictionary *inputDict, NSManagedObject *outputObject) {
        SCRViolation *violation = (SCRViolation *)outputObject;
        NSString *address = [inputDict objectForKey:@"address"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", SCRBuildingAttributes.address, address];
        NSArray *buildingsArray = [[VOKCoreDataManager sharedInstance] arrayForClass:[SCRBuilding class]
                                                                       withPredicate:predicate
                                                                          forContext:violation.managedObjectContext];
        //manually linking buildings here instead of using a mapper to ensure that duplicate buildings are not created.
        //we check if a building with the address for the  violation being created exists.
        //if it does exist, we link it to the violation. if not, we create it and link it to the violation.
        if (!buildingsArray.firstObject) {
            SCRBuilding *building = [SCRBuilding vok_newInstanceWithContext:violation.managedObjectContext];
            building.address = inputDict[@"address"];
            building.latitude = [[self sharedNumberFormatter] numberFromString:inputDict[@"latitude"]];
            building.longitude = [[self sharedNumberFormatter] numberFromString:inputDict[@"longitude"]];
            violation.building = building;
        } else {
            SCRBuilding *building = (SCRBuilding *)[buildingsArray firstObject];
            violation.building = building;
        }
    };
    
    [[VOKCoreDataManager sharedInstance] setObjectMapper:mapper forClass:[SCRViolation class]];
}

+ (void)loadDataFromArray:(NSArray *)array
{
    [[VOKCoreDataManager sharedInstance] importArray:array forClass:[SCRViolation class] withContext:nil];
    [[VOKCoreDataManager sharedInstance] saveMainContext];
}

+ (void)getTestViolations
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"TestData" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSError *error;
    NSArray *testViolationsArray = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:&error];
    
    [self loadDataFromArray:testViolationsArray];
}

+ (NSArray *)fetchAllBuildings
{
    return [[VOKCoreDataManager sharedInstance] arrayForClass:[SCRBuilding class] forContext:nil];
}

@end
