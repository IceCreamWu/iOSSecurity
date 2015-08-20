//
//  RSA.m
//  iOSSecurity
//
//  Created by 吴湧霖 on 15/8/19.
//  Copyright (c) 2015年 吴湧霖. All rights reserved.
//

#import "RSA.h"

@implementation RSA

- (void)dealloc {
    CFRelease(certificate);
    CFRelease(trust);
    CFRelease(policy);
    CFRelease(publicKey);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSString *publicKeyPath = [[NSBundle mainBundle] pathForResource:@"public_key" ofType:@"der"];
        if (publicKeyPath == nil) {
            NSLog(@"Can not find pub.der");
            return nil;
        }
        
        NSData *publicKeyFileContent = [NSData dataWithContentsOfFile:publicKeyPath];
        if (publicKeyFileContent == nil) {
            NSLog(@"Can not read from public_key.der");
            return nil;
        }
        
        return [self initWithPublicKeyData:publicKeyFileContent];
        
    }
    return self;
}

- (instancetype)initWithPublicKeyData:(NSData *)keyData {
    certificate = SecCertificateCreateWithData(kCFAllocatorDefault, ( __bridge CFDataRef)keyData);
    if (certificate == nil) {
        NSLog(@"Can not read certificate!");
        return nil;
    }
    
    policy = SecPolicyCreateBasicX509();
    OSStatus returnCode = SecTrustCreateWithCertificates(certificate, policy, &trust);
    if (returnCode != 0) {
        NSLog(@"SecTrustCreateWithCertificates fail. Error Code: %d", (int)returnCode);
        return nil;
    }
    
    SecTrustResultType trustResultType;
    returnCode = SecTrustEvaluate(trust, &trustResultType);
    if (returnCode != 0) {
        NSLog(@"SecTrustEvaluate fail. Error Code: %d", (int)returnCode);
        return nil;
    }
    
    publicKey = SecTrustCopyPublicKey(trust);
    if (publicKey == nil) {
        NSLog(@"SecTrustCopyPublicKey fail");
        return nil;
    }
    
    maxPlainLen = SecKeyGetBlockSize(publicKey) - 12;
    return self;
}

- (NSData *)encryptWithData:(NSData *)content {
    
    NSMutableData *result = [[NSMutableData alloc] init];
    // 分段加密
    size_t count = ([content length] - 1) / maxPlainLen + 1;
    for (size_t i = 0; i < count; i++) {
        size_t plainLen = (i + 1 == count) ? [content length] % maxPlainLen : maxPlainLen;
        
        NSData* subContent = [content subdataWithRange:NSMakeRange(i * maxPlainLen, plainLen)];
        
        void *plain = malloc(plainLen);
        [subContent getBytes:plain length:plainLen];
        
        size_t cipherLen = SecKeyGetBlockSize(publicKey); // 当前RSA的密钥长度是128字节
        void *cipher = malloc(cipherLen);
        
        OSStatus returnCode = SecKeyEncrypt(publicKey, kSecPaddingPKCS1, plain, plainLen, cipher, &cipherLen);
        
        if (returnCode != 0) {
            NSLog(@"SecKeyEncrypt fail. Error Code: %d", (int)returnCode);
            free(plain);
            free(cipher);
            return nil;
        }
        else {
            NSData *subResult = [NSData dataWithBytes:cipher length:cipherLen];
            [result appendData:subResult];// 添加分段密文
            free(plain);
            free(cipher);
        }
    
    }
    
    return result;
}

- (NSString *)encryptWithString:(NSString *)content {
    NSData *data = [self encryptWithData:[content dataUsingEncoding:NSUTF8StringEncoding]];
    if (data == nil) {
        return nil;
    } else {
        return [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    }
}

@end
