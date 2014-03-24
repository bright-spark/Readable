//
//  QRContentMobilizer.h
//  QRContentMobilizer
//
//  Created by Wojciech Czekalski on 21.03.2014.
//  Copyright (c) 2014 Wojciech Czekalski. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString * const QRContentTitle;
FOUNDATION_EXPORT NSString * const QRContentAuthor;
FOUNDATION_EXPORT NSString * const QRContentPlainText;
FOUNDATION_EXPORT NSString * const QRContentPrimaryImageURL;
FOUNDATION_EXPORT NSString * const QRContentHTML;
FOUNDATION_EXPORT NSString * const QRContentDate;
FOUNDATION_EXPORT NSString * const QRContentLanguage;

typedef NS_ENUM(NSInteger, QRMobilizerError) {
    QRMobilizerErrorUnauthorized = 1,
    QRMobilizerErrorNotFound,
    QRMobilizerErrorAPILimit,
    QRMobilizerErrorProcessingFailed
};

@interface QRContentMobilizer : NSObject
+ (instancetype)mobilizer;
- (void)mobilizeContentsOfURL:(NSURL *)url completion:(void (^)(NSDictionary *content, NSError *error))completionBlock;
+ (NSString *)token;
+ (void)setToken:(NSString *)token;
@end