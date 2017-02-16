//
//  NSString+Util.m
//  UsedCar
//
//  Created by Alan on 13-11-8.
//  Copyright (c) 2013年 Alan. All rights reserved.
//

#import "NSString+Util.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "Base64.h"
#import "OpenUDID.h"

#define gKey    @"appapiche168comappapiche"
#define gIv     @"appapich"

#define IOS8_OR_LATER       ([[[UIDevice currentDevice] systemVersion] compare:@"8" options:NSNumericSearch] != NSOrderedAscending)

@implementation NSString (Util)


+ (NSString *)openUDID
{
//    return [OpenUDID value];
    return nil;
}

- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

- (NSString *)encrypt3DES
{
    return [self encrypt3DES:gKey iv:gIv];
}

/* 3DES加密 */
- (NSString *)encrypt3DES:(NSString *)key iv:(NSString *)iv
{
    NSData      *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    size_t      plainTextBufferSize = [data length];
    const void  *vplainText = (const void *)[data bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t         *bufferPtr = NULL;
    size_t          bufferPtrSize = 0;
    size_t          movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc(bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void  *vkey = (const void *)[key UTF8String];
    const void  *vinitVec = (const void *)[iv UTF8String];
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData      *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    NSString    *result = [Base64 encode:myData];
    
    free(bufferPtr);
    
    return result;
}

- (NSString *)decrypt3DES
{
    return [self decrypt3DES:gKey iv:gIv];
}

/* 3DES解密 */
- (NSString *)decrypt3DES:(NSString *)key iv:(NSString *)iv
{
    NSData      *encryptData = [Base64 decode:self];
    size_t      plainTextBufferSize = [encryptData length];
    const void  *vplainText = [encryptData bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t         *bufferPtr = NULL;
    size_t          bufferPtrSize = 0;
    size_t          movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc(bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void  *vkey = (const void *)[key UTF8String];
    const void  *vinitVec = (const void *)[iv UTF8String];
    
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSString *result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding];
    
    free(bufferPtr);
    
    return result;
}


/* 转url编码 */
- (NSString *)encodeURL
{
    NSString *newString = (__bridge_transfer NSString *)(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding))) ;
    if (newString) {
        return newString;
    }
    
    return @"";
}

/* 修剪 */
- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

/* 防止显示（null） */
- (NSString *)dNull
{
    return (self.length > 0 ? self : @"");
}

/* 防止显示（null） */
- (NSString *)dNull:(NSString *)replace
{
    return (self.length > 0 ? self :replace);
}

/** 是否包含字符串 */
- (BOOL)isContainsString:(NSString *)aString
{
    if (IOS8_OR_LATER) {
        return [self containsString:aString];
    } else {
        NSRange range = [self rangeOfString:aString];
        return range.length != 0;
    }
}
/* 中英区别统计长度 英占1 中占2 */
- (int)lengthUnicode {
    int strlength = 0;
    char* p = (char *)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0; i < [self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength + 1) / 2;
}

/* 字符串超出宽度省略号 */
- (NSString *)omitForSize:(CGSize)size font:(UIFont *)font
{
    //NSMutableString *str = [NSMutableString stringWithString:self];
    //[self componentsSeparatedByCharactersInSet:(NSCharacterSet *)]
    
    //    CGSize orgSize = [self sizeWithFont:font constrainedToSize:CGSizeMake(size.width, MAXFLOAT) lineBreakMode:UILineBreakModeCharacterWrap];
    //
    //    if (orgSize.height <= size.height && orgSize.width <= size.width)
    //        return self;
    
    NSMutableString *strOmit = [NSMutableString string];
    
    CGSize newSize = CGSizeZero;
    NSUInteger index = 0;
    BOOL isNewline = NO;
    while (YES) {
        
        if (newSize.height > size.height) {
            // 删除两个使其超出范围的字符 (一个删除超出, 一个为了替换成"…");
            [strOmit deleteCharactersInRange:NSMakeRange(index - 2, 2)];
            [strOmit appendString:@"…"];
            break;
        }
        
        if (index < self.length) {
            if (isNewline) {
                [strOmit insertString:@"\n" atIndex:strOmit.length - 1];
            } else {
                [strOmit appendString:[self substringWithRange:NSMakeRange(index, 1)]];
                index++;
            }
        } else
            break;
        
//        CGSize tmpSize = [strOmit sizeWithFont:font constrainedToSize:CGSizeMake(size.width, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        CGSize tmpSize = [strOmit boundingRectWithSize:CGSizeMake(size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size;
        if (newSize.height > 0 && newSize.height < tmpSize.height)
            isNewline = YES;
        else
            isNewline = NO;
        newSize = tmpSize;
    }
    
    return strOmit;
}

- (NSString *)encodeToPercentEscapeString {
    return  (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, 
                                                                                   (CFStringRef)self,
                                                                                   NULL,
                                                                                   (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                   kCFStringEncodingUTF8));
    
}

- (NSString *)decodeFromPercentEscapeString {
        NSMutableString *outputStr = [NSMutableString stringWithString:self];
        [outputStr replaceOccurrencesOfString:@"+"
                                            withString:@" "
                                      options:NSLiteralSearch
                                        range:NSMakeRange(0, [outputStr length])];
        return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (CGSize)sizeWithFontEX:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode {
    NSMutableDictionary *attr = [NSMutableDictionary dictionaryWithCapacity:10];
    if (font) {
        [attr setValue:font forKey:NSFontAttributeName];
    }
    if (lineBreakMode) {
        NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
        [ps setLineBreakMode:NSLineBreakByCharWrapping];
        [attr setValue:ps forKey:NSParagraphStyleAttributeName];
    }
    CGRect rect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attr context:nil];
    return CGSizeMake(ceil(rect.size.width), ceil(rect.size.height)); //进位取整, 防止文字内带字母计算太极端问题
}

@end
