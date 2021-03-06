//
//  SCRCoreDataUtility.m
//  ScrapHeap
//
//  Created by Rachel Hyman on 11/3/14.
//  Copyright (c) 2014 Rachel Hyman. All rights reserved.
//

#import "SCRCoreDataUtility.h"

#import "VOKCoreDataManager.h"
#import "SCRUtility.h"
#import "SCRBuilding.h"
#import "SCRViolation.h"

@implementation SCRCoreDataUtility

+ (void)resetCoreData
{
    [[VOKCoreDataManager sharedInstance] resetCoreData];
    [self setUpCoreData];
}

+ (void)copySqliteDatabaseFromBundle
{
    NSURL *applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [applicationDocumentsDirectory URLByAppendingPathComponent:SCRCoreData.SqliteDatabaseName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]]) {
        NSURL *bundleStoreURL = [[NSBundle mainBundle] URLForResource:SCRCoreData.DatabaseResourceName withExtension:SCRCoreData.DatabaseResourceFileExtension];
        if (bundleStoreURL) {
            [[NSFileManager defaultManager] copyItemAtURL:bundleStoreURL toURL:storeURL error:NULL];
        }
    }
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
    [self copySqliteDatabaseFromBundle];
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

+ (void)setUpMapsForViolation
{
    NSArray *maps = @[
                      VOK_MAP_FOREIGN_TO_LOCAL(@"violation_inspector_comments", inspectorComments),
                      [VOKManagedObjectMap mapWithForeignKeyPath:@"violation_last_modified_date"
                                                     coreDataKey:VOK_CDSELECTOR(lastModifiedDate)
                                                   dateFormatter:[SCRUtility sharedDateFormatter]],
                      VOK_MAP_FOREIGN_TO_LOCAL(@"violation_ordinance", ordinance),
                      VOK_MAP_FOREIGN_TO_LOCAL(@"violation_status", status),
                      [VOKManagedObjectMap mapWithForeignKeyPath:@"violation_date"
                                                     coreDataKey:VOK_CDSELECTOR(violationDate)
                                                   dateFormatter:[SCRUtility sharedDateFormatter]],
                      VOK_MAP_FOREIGN_TO_LOCAL(@"violation_description", violationDescription),
                      VOK_MAP_FOREIGN_TO_LOCAL(@"id", violationID),
                      ];
    
    VOKManagedObjectMapper *mapper = [VOKManagedObjectMapper mapperWithUniqueKey:VOK_CDSELECTOR(violationID) andMaps:maps];
    mapper.ignoreNullValueOverwrites = YES;
    mapper.ignoreOptionalNullValues = YES;
    
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

+ (NSArray *)violationsArrayLoadedFromArray:(NSArray *)array
{
    return [[VOKCoreDataManager sharedInstance] importArray:array
                                                   forClass:[SCRViolation class]
                                                withContext:nil];
}

+ (void)loadDataFromArray:(NSArray *)array completion:(SCRBasicCompletionHandler)handler
{
    [VOKCoreDataManager writeToTemporaryContext:^(NSManagedObjectContext *tempContext) {
        [[VOKCoreDataManager sharedInstance] importArray:array
                                                forClass:[SCRViolation class]
                                             withContext:tempContext];
    }
                                     completion:handler];
}

+ (void)getTestViolationsWithCompletion:(SCRBasicCompletionHandler)handler
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"TestData" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSError *error;
    NSArray *testViolationsArray = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:&error];
    
    [self loadDataFromArray:testViolationsArray completion:handler];
}

+ (NSArray *)fetchAllBuildings
{
    return [[VOKCoreDataManager sharedInstance] arrayForClass:[SCRBuilding class] forContext:nil];
}

+ (NSArray *)fetchMostRecentBuildingsWithViolationsCount:(NSInteger)countToFetch
{
    NSArray *allViolations = [[VOKCoreDataManager sharedInstance] arrayForClass:[SCRViolation class] forContext:nil];
    if (allViolations.count > 0 && allViolations.count >= countToFetch) {
        NSMutableArray *sortedViolations = [[allViolations sortedArrayUsingDescriptors:[SCRViolation defaultSortDescriptors]] mutableCopy];
        [sortedViolations removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(countToFetch, sortedViolations.count - countToFetch)]];
        
        //we make a set to ensure that duplicate buildings are not added
        NSMutableSet *buildingsSet = [NSMutableSet set];
        for (SCRViolation *violation in sortedViolations) {
            NSArray *buildingMatch = [[VOKCoreDataManager sharedInstance] arrayForClass:[SCRBuilding class] withPredicate:[SCRBuilding predicateForBuildingForViolation:violation] forContext:nil];
            [buildingsSet addObjectsFromArray:buildingMatch];
        }
        return [NSArray arrayWithArray:[buildingsSet allObjects]];
    }
    return [NSArray array];
}

+ (NSArray *)fetchBuildingsWithViolationsArray:(NSArray *)violationsArray
{
    //we make a set to ensure that duplicate buildings are not added
    NSMutableSet *buildingsSet = [NSMutableSet set];
    for (SCRViolation *violation in violationsArray) {
        NSArray *buildingMatch = [[VOKCoreDataManager sharedInstance] arrayForClass:[SCRBuilding class] withPredicate:[SCRBuilding predicateForBuildingForViolation:violation] forContext:nil];
        [buildingsSet addObjectsFromArray:buildingMatch];
    }
    return [NSArray arrayWithArray:[buildingsSet allObjects]];
}

@end
