//
//  ContentParserTests.m
//  RutrackerFilms
//
//  Created by denis on 15.06.17.
//  Copyright © 2017 uncorner. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ContentParser.h"
#import "Common.h"

@interface ContentParserTests : XCTestCase
{
    NSString *contentType;
    NSData *dataSaved;
}

@end

@implementation ContentParserTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testParsePosterUrlFromHtml {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    [self makeRequestWithUrl:@"forum/viewtopic.php?t=5415833"];
    
    ContentParser *parser = [[ContentParser alloc] init];
    NSString* imageUrl = [parser parsePosterUrlFromHtml:dataSaved contentType:contentType];
    
    
    
    
}

- (void) makeRequestWithUrl: (NSString*)urlPart {
    NSMutableString *stringUrl = [NSMutableString stringWithString:WebsiteUrl];
    [stringUrl appendString:@"/"];
    [stringUrl appendString:urlPart];
    
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    [request setValue:@"UTF-8" forHTTPHeaderField:@"Accept-Charset" ];
    [request setValue:@"ru-RU" forHTTPHeaderField:@"Content-Language"];
    [request setValue:@"UTF-8" forHTTPHeaderField:@"Charset"];
    [request setValue:@"application/x-www-form-urlencoded charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    
    //NSData *dataSaved = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          if (error) {
                                              XCTFail(@"request error %@", error.description);
                                          }
                                          
                                          contentType = nil;
                                          if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                              NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
                                              contentType = headers[@"Content-Type"];
                                          }
                                          
                                          
                                          //dataSaved = data;
                                          dataSaved = [NSData dataWithData:data];
                                          
                                          //
                                          //                                          ContentParser *parser = [[ContentParser alloc]init];
                                          //                                          NSMutableArray<FilmInfo*>* filmInfoItems = [parser parseFilmListFromHtml:data contentType:contentType];
                                          
                                          dispatch_semaphore_signal(semaphore);
                                      }];
    
    [dataTask resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
