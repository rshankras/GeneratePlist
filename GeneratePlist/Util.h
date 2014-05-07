//
//  Util.h
//  GeneratePlist
//
//  Created by Ravi Shankar on 07/07/13.
//  Copyright (c) 2013 Ravi Shankar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

+(NSMutableArray *)readCSVFile:(NSString *)fileName;

+(void) saveContent:(NSArray *)content toFile:(NSString *)fileName;

+(NSArray *) getColumnValues:(NSArray *)content fromIndex:(int) index;

+(void)generatePlist:(NSString *)filePrefix;

+(void)generateCombinedPlist:(NSArray *)files;

@end
