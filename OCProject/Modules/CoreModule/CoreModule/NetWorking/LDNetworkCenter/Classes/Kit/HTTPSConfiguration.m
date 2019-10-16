//
//  HTTPSConfiguration.m
//  laoyuegou
//
//  Created by Xiangqi on 2017/4/19.
//  Copyright © 2017年 HaiNanLexin. All rights reserved.
//

#import "HTTPSConfiguration.h"
#import "AFHTTPSessionManager.h"
#import <AssertMacros.h>
#import "AFSecurityPolicy.h"

@interface HTTPSConfiguration ()

@property (nonatomic, strong) AFSecurityPolicy *policy;

@end

@implementation HTTPSConfiguration

- (id)initWithAFHTTPSessionManager:(AFHTTPSessionManager *)sessionManager
{
    if (self = [super init]) {
        
        [self configPinnedCertificatesWithSessionManager:sessionManager];
        
        [self configHTTPSChallengeWithSessionManager:sessionManager];
    }
    
    return self;
}

- (void)configPinnedCertificatesWithSessionManager:(AFHTTPSessionManager *)sessionManager
{
    NSString *path = [self bundlePath];
    NSString *certFilePath1 = [path stringByAppendingPathComponent:@"appv2_gank.cer"];
    NSString *certFilePath2 = [path stringByAppendingPathComponent:@"gank_gg.cer"];
    NSString *certFilePath3 = [path stringByAppendingPathComponent:@"lygou_cc.cer"];
    
    NSArray *filePathsArray = @[certFilePath1, certFilePath2, certFilePath3];
    
    NSMutableSet *certDataSet = [NSMutableSet set];
    for (NSString *certFilePath in filePathsArray) {
        NSData *certData = [NSData dataWithContentsOfFile:certFilePath];
        SecCertificateRef secCertificateRef = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)certData);
        if (!secCertificateRef) {
            NSLog(@"Not in the correct format to read the data.Somethings wrong with cer file:\n %@", certFilePath);
            continue;
        }
        
        [certDataSet addObject:certData];
        
        if (secCertificateRef) {
            CFRelease(secCertificateRef);
        }
    }
    //ChessSSLPinningModeNone 可以抓包
    /*AFSSLPinningModeNone
     这个模式表示不做SSL pinning，
     只跟浏览器一样在系统的信任机构列表里验证服务端返回的证书。若证书是信任机构签发的就会通过，若是自己服务器生成的证书就不会通过。
     
     AFSSLPinningModeCertificate
     这个模式表示用证书绑定方式验证证书，需要客户端保存有服务端的证书拷贝，这里验证分两步，第一步验证证书的域名有效期等信息，第二步是对比服务端返回的证书跟客户端返回的是否一致。
     
     AFSSLPinningModePublicKey
     这个模式同样是用证书绑定方式验证，客户端要有服务端的证书拷贝，
     只是验证时只验证证书里的公钥，不验证证书的有效期等信息。只要公钥是正确的，就能保证通信不会被窃听，因为中间人没有私钥，无法解开通过公钥加密的数据。*/
    self.policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey withPinnedCertificates:certDataSet];
    [self.policy setValidatesDomainName:NO];
}

- (void)configHTTPSChallengeWithSessionManager:(AFHTTPSessionManager *)sessionManager
{
    [sessionManager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession * _Nonnull session,
                                                                                                           NSURLAuthenticationChallenge * _Nonnull challenge,
                                                                                                           NSURLCredential *__autoreleasing  _Nullable * _Nullable credential)
     {
         return [self hanleAuthChallengeDispositionForSession:session challenge:challenge credential:credential];
     }];
    
    [sessionManager setTaskDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLAuthenticationChallenge * _Nonnull challenge, NSURLCredential *__autoreleasing  _Nullable * _Nullable credential) {
        return [self hanleAuthChallengeDispositionForSession:session challenge:challenge credential:credential];
    }];
}

- (NSURLSessionAuthChallengeDisposition)hanleAuthChallengeDispositionForSession:(NSURLSession *)session
                                                                      challenge:(NSURLAuthenticationChallenge *) challenge
                                                                     credential:(NSURLCredential **) credential
{
//#if BUILD_EVO == 2
    
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodClientCertificate])
    {
        //双向认证, 返回客户端当前P12信息
        SecIdentityRef identity = NULL;
        SecTrustRef trust = NULL;
        
        NSString *path = [self bundlePath];
        NSString *p12 = [path stringByAppendingPathComponent:@"appv2_gank.p12"];
        NSString *keyPassword = @"btU7xqmu";

        NSData *PKCS12Data = [NSData dataWithContentsOfFile:p12];
        
        
        OSStatus result = extractIdentityAndTrust((__bridge CFDataRef)PKCS12Data, &identity, &trust, (__bridge CFStringRef) keyPassword);
        
        if (result ==  0) {
            *credential = [[self class] getCredentialFromCert:identity];
            return NSURLSessionAuthChallengeUseCredential;
        } else {
            return NSURLSessionAuthChallengeCancelAuthenticationChallenge;
        }
    }
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        if ([self.policy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
            *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            if (*credential) {
                return NSURLSessionAuthChallengeUseCredential;
            } else {
                return NSURLSessionAuthChallengePerformDefaultHandling;
            }
        } else {
            return NSURLSessionAuthChallengeCancelAuthenticationChallenge;
        }
    }
//#endif
    return NSURLSessionAuthChallengePerformDefaultHandling;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - P12
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//P12,双向认证时使用
OSStatus extractIdentityAndTrust(CFDataRef inPKCS12Data,
                                 SecIdentityRef *outIdentity,
                                 SecTrustRef *outTrust,
                                 CFStringRef keyPassword)
{
    OSStatus securityError = errSecSuccess;
    
    const void *keys[] =   { kSecImportExportPassphrase };
    const void *values[] = { keyPassword };
    CFDictionaryRef optionsDictionary = NULL;
    
    /* Create a dictionary containing the passphrase if one
     was specified.  Otherwise, create an empty dictionary. */
    optionsDictionary = CFDictionaryCreate(
                                           NULL, keys,
                                           values, (keyPassword ? 1 : 0),
                                           NULL, NULL);
    
    CFArrayRef items = NULL;
    securityError = SecPKCS12Import(inPKCS12Data,
                                    optionsDictionary,
                                    &items);
    
    if (securityError == 0) {
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex (items, 0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue (myIdentityAndTrust,
                                             kSecImportItemIdentity);
        CFRetain(tempIdentity);
        *outIdentity = (SecIdentityRef)tempIdentity;
        const void *tempTrust = NULL;
        tempTrust = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemTrust);
        
        CFRetain(tempTrust);
        *outTrust = (SecTrustRef)tempTrust;
    }
    
    if (optionsDictionary)
        CFRelease(optionsDictionary);
    
    if (items)
        CFRelease(items);
    
    return securityError;
}

+ (NSURLCredential *)getCredentialFromCert:(SecIdentityRef)identity
{
    SecCertificateRef certificateRef = NULL;
    SecIdentityCopyCertificate(identity, &certificateRef);
    
    NSArray *certificateArray = [[NSArray alloc] initWithObjects:(__bridge_transfer id)(certificateRef), nil];
    NSURLCredentialPersistence persistence = NSURLCredentialPersistenceForSession;
    
    NSURLCredential *credential = [[NSURLCredential alloc] initWithIdentity:identity
                                                               certificates:certificateArray
                                                                persistence:persistence];
    
    return credential;
}

-(NSString *)bundlePath {
    //获取路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"LDNetworkCenterBundle" ofType:@"bundle"];
    
    return path;
    
}

@end
