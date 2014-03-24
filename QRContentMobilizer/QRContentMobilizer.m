//
//  QRContentMobilizer.m
//  QRContentMobilizer
//
//  Created by Wojciech Czekalski on 21.03.2014.
//  Copyright (c) 2014 Wojciech Czekalski. All rights reserved.
//

#import "QRContentMobilizer.h"
#import "AFHTTPRequestOperationManager.h"
#import "SSKeychain.h"

CGFloat const QRParsingConfidenceMax = 1.f;
CGFloat const QRParsingConfidenceAllowable = .3f;
CGFloat const QRParsingConfidenceNone = 0.f;

NSString * const QRDiffbotToken = @"QRDiffbotToken";
NSString * const QRDiffbotService = @"QRDiffbot";

NSString * const QRTokenKey = @"token";
NSString * const QRURLKey = @"url";
NSString * const QRPagingKey = @"paging";
NSString * const QRFieldsKey = @"fields";

NSString * const QRContentTitle = @"title";
NSString * const QRContentAuthor = @"author";
NSString * const QRContentPlainText = @"text";
NSString * const QRContentPrimaryImageURL = @"image";
NSString * const QRContentHTML = @"html";
NSString * const QRContentDate = @"date";
NSString * const QRContentLanguage = @"humanLanguage";

BOOL const QRPagingEnabled = NO;

@interface QRContentMobilizer ()
@property (readonly, nonatomic) AFHTTPRequestOperationManager *manager;
@property (readonly, nonatomic) NSArray *defaultFields;
@property (strong, nonatomic) NSMutableDictionary *attributes;
@property (nonatomic, readonly) NSDateFormatter *dateFormatter;
@end

@implementation QRContentMobilizer {
    AFHTTPRequestOperationManager *_manager;
    NSString *_token;
    NSArray *_defaultFields;
    NSDateFormatter *_dateFormatter;
}

+(instancetype) mobilizer {
    static dispatch_once_t pred;
    static id shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (void)mobilizeContentsOfURL:(NSURL *)url completion:(void (^)(NSDictionary *response, NSError *error))completionBlock {
    
    [self.manager GET:@"article" parameters:@{QRTokenKey: [self token], QRURLKey : [url absoluteString], QRPagingKey : @(QRPagingEnabled), QRFieldsKey : self.defaultFields} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSNumber *errorCode = responseObject[@"errorCode"];
        if (errorCode) {
            NSInteger intErrorCode = [errorCode integerValue];
            NSError *error = nil;
            switch (intErrorCode) {
                case 401:
                    error = [NSError errorWithDomain:@"com.quickread.mobilizer" code:QRMobilizerErrorUnauthorized userInfo:@{NSLocalizedDescriptionKey: @"Mobilizer unauthorized, Check if the token was set"}];
                    break;
                case 404:
                    error = [NSError errorWithDomain:@"com.quickread.mobilizer" code:QRMobilizerErrorNotFound userInfo:@{NSLocalizedDescriptionKey: @"Requested page not found"}];
                    break;
                case 429:
                    error = [NSError errorWithDomain:@"com.quickread.mobilizer" code:QRMobilizerErrorAPILimit userInfo:@{NSLocalizedDescriptionKey: @"Your token has exceeded the allowed number of calls, or has otherwise been throttled for API abuse"}];
                    break;
                case 500:
                    error = [NSError errorWithDomain:@"com.quickread.mobilizer" code:QRMobilizerErrorProcessingFailed userInfo:@{NSLocalizedDescriptionKey: @"Error processing the page."}];
                    break;
            }
            completionBlock(nil, error);
        } else {
            
            NSMutableDictionary *formattedDictionary = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
            
            if (formattedDictionary[QRContentDate]) {
                [formattedDictionary setObject:[self.dateFormatter dateFromString:formattedDictionary[QRContentDate]] forKey:QRContentDate];
            }
            
            for (NSDictionary *image in responseObject[@"images"]) {
                if ([image[@"primary"] boolValue]) {
                    [formattedDictionary removeObjectForKey:@"images"];
                    [formattedDictionary setObject:[NSURL URLWithString:image[@"url"]] forKey:QRContentPrimaryImageURL];
                    break;
                }
            }
            
            completionBlock(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(nil, error);
    }];
}

- (AFHTTPRequestOperationManager *)manager {
    if (!_manager) {
        _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://api.diffbot.com/v2/"]];
    }
    return _manager;
}

- (NSArray *)defaultFields {
    if (!_defaultFields) {
        _defaultFields = @[QRContentTitle, QRContentPlainText, QRContentHTML, QRContentDate, QRContentAuthor, QRContentLanguage, @"images(url,primary)"];
    }
    return _defaultFields;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        _dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        [_dateFormatter setDateFormat:@"EEE',' dd MMM yyyy HH':'mm':'ss z"];
    }
    return _dateFormatter;
}

- (NSString *)token {
    if (!_token) {
        _token = @"";
    }
    return _token;
}

@end
