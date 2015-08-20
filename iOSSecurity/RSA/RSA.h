//
//  RSA.h
//  iOSSecurity
//
//  Created by 吴湧霖 on 15/8/19.
//  Copyright (c) 2015年 吴湧霖. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSA : NSObject {
    SecKeyRef publicKey;
    SecCertificateRef certificate;
    SecPolicyRef policy;
    SecTrustRef trust;
    size_t maxPlainLen;
}

/**
 *  设置公钥
 *
 *  @param data
 *
 *  @return 
 */
- (instancetype)initWithPublicKeyData:(NSData *)keyData;

/**
 *  加密NSData类型的数据，返回加密后的NSData
 *
 *  @param content NSData类型的明文数据
 *
 *  @return 加密成功返回NSData类型的密文数据，加密失败返回nil
 */
- (NSData *) encryptWithData:(NSData *)content;

/**
 *  加密字符串，返回加密后并经过Base64编码的字符串
 *
 *  @param content 明文字符串
 *
 *  @return 加密成功返回经过Base64编码的密文字符串，加密失败返回nil
 */
- (NSString *) encryptWithString:(NSString *)content;

@end
