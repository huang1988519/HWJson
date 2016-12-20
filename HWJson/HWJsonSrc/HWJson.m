//
//  HWJson.m
//  HWJson
//
//  Created by huanwh on 2016/12/19.
//  Copyright © 2016年 huanwh. All rights reserved.
//

#import "HWJson.h"

@interface HWJson ()
@property (nonatomic, strong)id jsonObj;
@property (nonatomic, strong)NSArray        * jsonArray;
@property (nonatomic, strong)NSString       * jsonString;
@end

@implementation HWJson

-(instancetype)init {
    self = [super init];
    
    if (self) {}
    
    return self;
}

- (instancetype)initWithString:(NSString *)jsonString {
    
    NSDictionary * dic = nil;
    
    if (jsonString && jsonString.length > 0) {
        NSError * error;
        dic = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
        
        if (error) {
            NSLog(@"[Json][Error] %@", error);
        }
        NSParameterAssert(!error);
    }
    
    return [self initWithDictionary:dic];
}

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    self = [self init];
    
    if (self) {
        _jsonObj = dic;
    }
    
    return self;
}

- (instancetype)objectForQuery:(NSString *)queryString {
    
    NSArray * queryItems = [self queryString:queryString];
    
    if (!queryItems) {
        return [[HWJson alloc] initWithDictionary:_jsonObj];
    }
    
    id result = _jsonObj;
    for (NSString * query in queryItems) {
        result = [self itemForQuery:query from:result];
    }
    
    return [[HWJson alloc] initWithDictionary:result];
}


- (BOOL)isValid {
    return (_jsonObj != nil | _jsonArray != nil);
}

- (id)result {
    return _jsonObj;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", _jsonObj];
}

#pragma mark -  privita 

- (NSArray *)queryString:(NSString *)key {
    if (!key) {
        return nil;
    }
    
    NSArray * queryItems = [key componentsSeparatedByString:@"."];
    return queryItems;
}

- (id)itemForQuery:(NSString *)key from:(id)jsonObj {
    if (!key) {
        return nil;
    }
    
    // 如果是数组直接获取  index
    if ([jsonObj isKindOfClass:[NSArray class]]) {
        // 获取 数组 index
        NSNumber    * index = [self getIndexFromNodeName:key];
        NSLog(@"[HWJson][DEBUG] 查询： %@ [%@]", key, index);
        return (NSArray *)jsonObj[index.intValue];
    }
    
    
    NSNumber    * index = [self getIndexFromNodeName:key];
    NSString    * keyName   = [self getKeyFromNodeName:key];
    
    NSLog(@"[HWJson][DEBUG] 查询： %@", keyName);
    
    id object  = jsonObj[keyName];
    if (!object) {
        return nil;
    }
    
    if ([object isKindOfClass:[NSDictionary class]])
    {
        return (NSDictionary *)object;
    }
    else if ([object isKindOfClass:[NSArray class]])
    {
        if (index && [(NSArray *)object count] > [index intValue]) {
            return [(NSArray *)object objectAtIndex:[index intValue]];
        }
        
        return (NSArray *)object;
    }
    else
    {
        return object;
    }
    
    return nil;
}


-(NSString *)getKeyFromNodeName:(NSString *)node {
    NSRange range = [node rangeOfString:@"["];
    if (range.location == NSNotFound) {
        return node;
    }
    
    if (node && node.length - 1 > range.location) {
        return [node substringToIndex:range.location];
    }
    
    return nil;
}

-(NSNumber *)getIndexFromNodeName:(NSString *)node {
    if (!node) {
        return nil;
    }
    
    // 获取 数组 index
    NSString * indexString = [node subStringFrom:@"[" end:@"]"];
    if (indexString) {
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber * index = [f numberFromString:indexString];
        
        return index;
    }
    
    return nil;
}

@end





@implementation NSString (SubString)

-(NSString *)subStringFrom:(NSString *)start end:(NSString *)end {
    
    NSRange startRange   = [self rangeOfString:start];
    NSRange endRange     = [self rangeOfString:end];
    
    if (startRange.location == NSNotFound  || endRange.location == NSNotFound) {
        return nil;
    }
    
    NSRange range = NSMakeRange(startRange.location + 1, endRange.location - startRange.location - 1);
    return [self substringWithRange:range];
}

@end




@implementation HWJson (Type)

- (NSString *)toString {
    id obj = self.jsonObj;
    
    if ([obj isKindOfClass:[NSString class]]) {
        return [NSString stringWithFormat:@"%@", obj];
    }
    
    NSLog(@"[Json][Error] %@", @"HWJson to String failed! it`s not a string type");
    
    return nil;
}

- (NSNumber *)toNumber {
    id obj = self.jsonObj;

    if ([self toString]) {
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber * index = [f numberFromString:[self toString]];
        
        return index;
    }else if([obj isKindOfClass:[NSNumber class]]) {
        NSString * numberString = [NSString stringWithFormat:@"%@",obj];
        
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber * index = [f numberFromString:numberString];
        
        return index;
    }
    
    NSLog(@"[Json][Error] %@", @"HWJson to Number failed! it`s not a Number type");
    
    return nil;
}

- (NSArray  *)toArray {
    id obj = self.jsonObj;
    
    if ([obj isKindOfClass:[NSArray class]]) {
        return [NSArray arrayWithArray:obj];
    }
    
    NSLog(@"[Json][Error] %@", @"HWJson to Array failed! it`s not a Array type");
    
    return nil;
}

- (NSDictionary *)toDictionary {
    id obj = self.jsonObj;
    
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return [NSDictionary dictionaryWithDictionary:obj];
    }
    
    NSLog(@"[Json][Error] %@", @"HWJson to Dictionary failed! it`s not a Dictionary type");
    
    return nil;
}

- (BOOL)toBool {
    
    if ([self toNumber]) {
        NSInteger number = [[self toNumber] integerValue];
        if (number == 0) {
            return NO;
        }else if(number == 1) {
            return YES;
        }
    }else if (self.jsonObj) {
        
        NSLog(@"[Json][Warmming] %@", @"HWJson to Bool warmming! it`s not a 0 | 1  value");

        return YES;
    }
    
    NSLog(@"[Json][Warmming] %@", @"HWJson to Bool warmming! it`s not a 0 | 1  value");
    
    return NO;
}

@end
