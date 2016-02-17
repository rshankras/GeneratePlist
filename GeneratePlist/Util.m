//
//  Util.m
//  GeneratePlist
//
//  Created by Ravi Shankar on 07/07/13.
//  Copyright (c) 2013 Ravi Shankar. All rights reserved.
//

#import "Util.h"

@implementation Util


+(NSMutableArray *)readCSVFile:(NSString *)fileName
{
    NSError *error;
    NSString *filePath =  [[NSBundle mainBundle] pathForResource:fileName ofType:@"csv"];
    NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    NSMutableArray *data = [[fileContent componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"\n"]] mutableCopy];
    return data;
}


+(NSArray *) getColumnValues:(NSArray *)content fromIndex:(int) index
{
    NSString* currentPointString = [content objectAtIndex:index];
    NSArray* arr = [currentPointString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
    return arr;
}

+(void) saveContent:(NSArray *)content toFile:(NSString *)fileName;
{
    NSString *DocPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath=[DocPath stringByAppendingPathComponent:fileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        [content writeToFile:filePath atomically:YES];
    }
}

+(void)generatePlist:(NSString *)filePrefix
{
        
    NSMutableArray *mrts_main_data = [Util readCSVFile:[NSString stringWithFormat:@"%@_main",filePrefix]];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *timings_WD1 = [self populateTimings:[NSString stringWithFormat:@"%@_WD1",filePrefix]];
    NSMutableArray *timings_WD2 = [self populateTimings:[NSString stringWithFormat:@"%@_WD2",filePrefix]];
    NSMutableArray *timings_WE1 = [self populateTimings:[NSString stringWithFormat:@"%@_WE1",filePrefix]];
    NSMutableArray *timings_WE2 = [self populateTimings:[NSString stringWithFormat:@"%@_WE2",filePrefix]];
    
    NSMutableArray *rootArray = [[NSMutableArray alloc] init];
    
    for (int count = 0; count < mrts_main_data.count; count++)
    {
        NSArray* arr = [Util getColumnValues:mrts_main_data fromIndex:count];
        if (arr.count > 0) {
            dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[NSNumber numberWithInteger:[[arr objectAtIndex:0] integerValue]] forKey:@"no"];
            [dict setObject:[arr objectAtIndex:1] forKey:@"title"];
            [dict setObject:[NSNumber numberWithFloat:[[arr objectAtIndex:2] floatValue]] forKey:@"lat"];
            [dict setObject:[NSNumber numberWithFloat:[[arr objectAtIndex:3] floatValue]] forKey:@"long"];
            [dict setObject:[timings_WD1 objectAtIndex:count] forKey:@"toStation1WDs"];
            [dict setObject:[timings_WD2 objectAtIndex:[timings_WD2 count] - count -1] forKey:@"toStation2WDs"];
            [dict setObject:[timings_WE1 objectAtIndex:count] forKey:@"toStation1WEs"];
            [dict setObject:[timings_WE2 objectAtIndex:[timings_WE2 count] - count -1] forKey:@"toStation2WEs"];
            [rootArray addObject:dict];
        }
    }
    
    NSLog(@"%@", rootArray);
    
    [Util saveContent:rootArray toFile:[NSString stringWithFormat:@"%@.plist",filePrefix]];

}

+(NSMutableArray *)populateTimings:(NSString *) fileName
{
    NSMutableArray *fileContent = [Util readCSVFile:fileName];
    NSMutableArray *timings = [[NSMutableArray alloc] init];
    for(int idx = 0; idx < fileContent.count; idx++)
    {
        [timings addObject:[Util getColumnValues:fileContent fromIndex:idx]];
    }
    return timings;
}


// Read the filenames,
// Open file, and add title to new array object
// add index
// add station no
// add route.

+(void)generateCombinedPlist:(NSArray *)files
{
    NSString *path;
    NSArray  *location;
    NSMutableArray *newFile = [[NSMutableArray alloc] init];
    NSMutableArray *recent = [[NSMutableArray alloc] init];
    NSArray *recent_temp = [[NSArray alloc] init];
    NSMutableDictionary *content = [[NSMutableDictionary alloc] init];
    NSInteger index = 0;
    NSString *stationName;
    NSString *stationNo;
    
    for (NSString *file in files)
    {
       path = [[NSBundle mainBundle] pathForResource:file ofType:@"plist"];
       location= [NSArray arrayWithContentsOfFile:path];
        
        for (NSDictionary *row in location)
        {
            content = [[NSMutableDictionary alloc] init];
            [content setObject:[NSNumber numberWithInteger:index] forKey:@"identifier"];
            
            stationName = [row objectForKey:@"title"];
            stationNo = [row objectForKey:@"no"];
            
            [content setObject:stationName forKey:@"title"];
            [content setObject:stationNo forKey:@"no"];
            [content setObject:file forKey:@"route"];
            [newFile addObject:content];
            index ++;
        }
    }
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"title"  ascending:YES];
    recent_temp=[newFile sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
    recent = [recent_temp copy];
    [Util saveContent:recent toFile:[NSString stringWithFormat:@"allstations.plist"]];
}

@end
