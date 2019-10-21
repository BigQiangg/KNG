//
//  EncryptUtil.m
//  EasyLoyogou
//
//  Created by LiZ on 15/3/15.
//  Copyright (c) 2015年 LiZ. All rights reserved.
//

#import "EncryptUtil.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

#define DES_KEY @"lyg#2015"
#define FileHashDefaultChunkSizeForReadingData (1024*8)

@implementation EncryptUtil

+ (NSString *)encryptWithText:(NSString *)sText
{
    // doCipher 不能编汉字，所以要进行 url encode
    NSMutableString* str1 = [EncryptUtil urlEncode:sText];
    NSMutableString* encode = [NSMutableString stringWithString:[EncryptUtil doCipher:str1 key:DES_KEY context:kCCEncrypt]];
    [EncryptUtil formatSpecialCharacters:encode];
    return encode;
}

+ (NSString *)decryptWithText:(NSString *)sText
{
    if (!sText || ![sText length]) {
        return nil;
    }
    NSMutableString *str1 = [NSMutableString stringWithString:sText];
    [EncryptUtil reformatSpecialCharacters:str1];
    NSString *rt = [EncryptUtil doCipher:str1 key:DES_KEY context:kCCDecrypt];
    rt = [EncryptUtil urlDecode:rt];
    return rt;
}

+ (NSMutableString *)urlDecode:(NSString*)str
{
    if (!str) {
        return [NSMutableString stringWithString:@""];
    }
    NSMutableString* encodeStr = [NSMutableString stringWithString:[str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [encodeStr replaceOccurrencesOfString:@"%2B" withString:@"+" options:NSWidthInsensitiveSearch range:NSMakeRange(0, [encodeStr length])];
    [encodeStr replaceOccurrencesOfString:@"%2F" withString:@"/" options:NSWidthInsensitiveSearch range:NSMakeRange(0, [encodeStr length])];
    return encodeStr;
}

+ (NSMutableString *)urlEncode:(NSString*)str
{
    if (!str) {
        return [NSMutableString stringWithString:@""];
    }
    NSMutableString* encodeStr = [NSMutableString stringWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [encodeStr replaceOccurrencesOfString:@"%2B" withString:@"+" options:NSWidthInsensitiveSearch range:NSMakeRange(0, [encodeStr length])];
    [encodeStr replaceOccurrencesOfString:@"%2F" withString:@"/" options:NSWidthInsensitiveSearch range:NSMakeRange(0, [encodeStr length])];
    return encodeStr;
}


+ (void)formatSpecialCharacters:(NSMutableString *)str
{
    [str replaceOccurrencesOfString:@"+" withString:@"$$" options:NSWidthInsensitiveSearch range:NSMakeRange(0, [str length])];
    [str replaceOccurrencesOfString:@"/" withString:@"@@" options:NSWidthInsensitiveSearch range:NSMakeRange(0, [str length])];
}


+ (void)reformatSpecialCharacters:(NSMutableString *)str
{
    [str replaceOccurrencesOfString:@"$$" withString:@"+" options:NSWidthInsensitiveSearch range:NSMakeRange(0, [str length])];
    [str replaceOccurrencesOfString:@"@@" withString:@"/" options:NSWidthInsensitiveSearch range:NSMakeRange(0, [str length])];
}


+ (NSString *)doCipher:(NSString *)sTextIn key:(NSString *)sKey
               context:(CCOperation)encryptOrDecrypt {
    NSStringEncoding EnC = NSUTF8StringEncoding;
    
    NSMutableData *dTextIn;
    if (encryptOrDecrypt == kCCDecrypt) {
        dTextIn = [[EncryptUtil decodeHEXWithString:sTextIn] mutableCopy];
        //        dTextIn = [[LYCryptTool decodeBase64WithString:sTextIn] mutableCopy];
    }
    else{
        dTextIn = [[sTextIn dataUsingEncoding: EnC] mutableCopy];
    }
    NSMutableData * dKey = [[sKey dataUsingEncoding:EnC] mutableCopy];
    [dKey setLength:kCCBlockSizeDES];
    uint8_t *bufferPtr1 = NULL;
    size_t bufferPtrSize1 = 0;
    size_t movedBytes1 = 0;
    //uint8_t iv[kCCBlockSizeDES];
    //memset((void *) iv, 0x0, (size_t) sizeof(iv));
    //Byte iv[] = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
    bufferPtrSize1 = ([sTextIn length] + kCCKeySizeDES) & ~(kCCKeySizeDES -1);
    bufferPtr1 = malloc(bufferPtrSize1 * sizeof(uint8_t));
    memset((void *)bufferPtr1, 0x00, bufferPtrSize1);
    
    CCCrypt(encryptOrDecrypt, // CCOperation op
            kCCAlgorithmDES, // CCAlgorithm alg
            kCCOptionPKCS7Padding, // CCOptions options
            [dKey bytes], // const void *key
            [dKey length], // size_t keyLength //
            [dKey bytes], // const void *iv
            [dTextIn bytes], // const void *dataIn
            [dTextIn length],  // size_t dataInLength
            (void *)bufferPtr1, // void *dataOut
            bufferPtrSize1,     // size_t dataOutAvailable
            &movedBytes1);
    //[dTextIn release];
    //[dKey release];
    
    NSString * sResult;
    if (encryptOrDecrypt == kCCDecrypt){
        sResult = [[NSString alloc] initWithData:[NSData dataWithBytes:bufferPtr1 length:movedBytes1] encoding:EnC];
        free(bufferPtr1);
    }
    else {
        NSData *dResult = [NSData dataWithBytes:bufferPtr1 length:movedBytes1];
        free(bufferPtr1);
        sResult = [EncryptUtil encodeHEXWithData:dResult];
        //        sResult = [LYCryptTool encodeBase64WithData:dResult];
    }
    return sResult;
}

+ (NSString *)encodeHEXWithData:(NSData *)data{
    Byte *bytes = (Byte *)[data bytes];
    
    NSString *hexStr=@"";
    
    for(int i=0;i<[data length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return [hexStr uppercaseString];
}

+ (NSData *)decodeHEXWithString:(NSString *)string{
    NSString *lowerString = [string lowercaseString];
    NSUInteger len = [lowerString length]/2;    // Target length
    unsigned char *buf = malloc(len);
    unsigned char *whole_byte = buf;
    char byte_chars[3] = {'\0','\0','\0'};
    
    int i;
    for (i=0; i < len; i++) {
        byte_chars[0] = [lowerString characterAtIndex:i*2];
        byte_chars[1] = [lowerString characterAtIndex:i*2+1];
        *whole_byte = strtol(byte_chars, NULL, 16);
        whole_byte++;
    }
    
    NSData *data = [NSData dataWithBytes:buf length:len];
    free( buf );
    return data;
}


//MD5
+(NSString *)md5: (NSString *) inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

//sha1
+ (NSString *)sha1:(NSString *)inPutText
{
    const char *cstr = [inPutText cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [NSData dataWithBytes:cstr length:inPutText.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

//文件MD5

//60M,执行350~370ms 之间
+ (NSString *)getFileMD5WithPath:(NSString *)path withSecret:(NSString *)secretKey
{
    if (![path length]) {
        return nil;
    }
    NSURL *url = [NSURL fileURLWithPath:path];
    return [EncryptUtil getFileMD5WithURL:url withSecret:secretKey];
}

+ (NSString *)getFileMD5WithURL:(NSURL *)url withSecret:(NSString *)secretKey
{
    NSData *data = [secretKey dataUsingEncoding:NSUTF8StringEncoding];
    return (__bridge_transfer NSString *)getFileMD5HashCreateWithURL((__bridge CFURLRef)url, FileHashDefaultChunkSizeForReadingData,data);
}

CFStringRef getFileMD5HashCreateWithPath(CFStringRef filePath,size_t chunkSizeForReadingData,NSData *secretKeyData)
{
    CFStringRef result = NULL;
    // Get the file URL
    CFURLRef fileURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                                     (CFStringRef)filePath,
                                                     kCFURLPOSIXPathStyle,
                                                     (Boolean)false);
    
    result = getFileMD5HashCreateWithURL(fileURL,chunkSizeForReadingData,secretKeyData);
    if (fileURL) {
        CFRelease(fileURL);
    }
    return result;
}

CFStringRef getFileMD5HashCreateWithURL(CFURLRef urlPath,size_t chunkSizeForReadingData,NSData *secretKeyData)
{
    // Declare needed variables
    CFStringRef result = NULL;
    CFReadStreamRef readStream = NULL;
    
    CFURLRef fileURL = CFRetain(urlPath);
    if (!fileURL) goto done;
    
    // Create and open the read stream
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                            (CFURLRef)fileURL);
    if (!readStream) goto done;
    
    bool didSucceed = (bool)CFReadStreamOpen(readStream);
    if (!didSucceed) goto done;
    
    // Initialize the hash object
    CC_MD5_CTX hashObject;
    CC_MD5_Init(&hashObject);
    
    // Make sure chunkSizeForReadingData is valid
    if (!chunkSizeForReadingData) {
        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
    }
    
    // Feed the data to the hash object
    
    //加前缀MD5
    if (secretKeyData && [secretKeyData length]) {
        CC_MD5_Update(&hashObject, [secretKeyData bytes], (CC_LONG)[secretKeyData length]);
    }
    bool hasMoreData = true;
    while (hasMoreData) {
        
        uint8_t buffer[chunkSizeForReadingData];
        CFIndex readBytesCount = CFReadStreamRead(readStream,(UInt8 *)buffer,(CFIndex)sizeof(buffer));
        
        if (readBytesCount == -1) break;
        
        if (readBytesCount == 0) {
            
            hasMoreData = false;
            continue;
        }
        CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)readBytesCount);
    }
    
    // Check if the read operation succeeded
    didSucceed = !hasMoreData;
    
    // Compute the hash digest
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &hashObject);
    
    // Abort if the read operation failed
    if (!didSucceed) goto done;
    
    // Compute the string result
    char hash[2 * sizeof(digest) + 1];
    for (size_t i = 0; i < sizeof(digest); ++i) {
        snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
    }
    result = CFStringCreateWithCString(kCFAllocatorDefault,(const char *)hash,kCFStringEncodingUTF8);
    
done:
    
    if (readStream) {
        CFReadStreamClose(readStream);
        CFRelease(readStream);
    }
    
    if (fileURL) {
        CFRelease(fileURL);
    }
    
    return result;
}

+ (NSString *)getFileMD5WithPath2:(NSString *)path withSecret:(NSString *)secretKey
{
    
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if(handle == nil) return @"ERROR GETTING FILE MD5"; // file didnt exist
    
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    
    NSData *secretKeyData = [secretKey dataUsingEncoding:NSUTF8StringEncoding];
    //加前缀MD5
    if (secretKeyData && [secretKeyData length]) {
        CC_MD5_Update(&md5, [secretKeyData bytes], (CC_LONG)[secretKeyData length]);
    }
    BOOL done = NO;
    while(!done) {
        NSData *fileData = [handle readDataOfLength:FileHashDefaultChunkSizeForReadingData];
        CC_MD5_Update(&md5, [fileData bytes], (CC_LONG)[fileData length]);
        
        if( [fileData length] == 0 ) done = YES;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString *result = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                        digest[0], digest[1],
                        digest[2], digest[3],
                        digest[4], digest[5],
                        digest[6], digest[7],
                        digest[8], digest[9],
                        digest[10], digest[11],
                        digest[12], digest[13],
                        digest[14], digest[15]];
    return result;
}

@end
