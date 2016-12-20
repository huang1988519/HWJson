//
//  HWJson.h
//  HWJson
//
//  Created by huanwh on 2016/12/19.
//  Copyright © 2016年 huanwh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWJson : NSObject

// 初始化
- (instancetype)initWithString:(NSString *)jsonString;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
// 查询
- (instancetype)objectForQuery:(NSString *)queryString;

- (BOOL)isValid;

@end







@interface NSString (SubString)

-(NSString *)subStringFrom:(NSString *)start end:(NSString *)end;

@end



@interface HWJson (Type)

- (NSString *)toString;
- (NSNumber *)toNumber;
- (NSArray  *)toArray;
- (NSDictionary *)toDictionary;

- (BOOL)toBool;

@end
