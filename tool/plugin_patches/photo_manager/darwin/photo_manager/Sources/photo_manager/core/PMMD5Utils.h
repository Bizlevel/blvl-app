#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

#define PMFileHashDefaultChunkSizeForReadingData 1024*8 // 8K

@interface PMMD5Utils : NSObject

// Maintains the historical API surface but now uses SHA256 under the hood.
+ (NSString *)getMD5FromData:(NSData *)data;
+ (NSString *)getMD5FromString:(NSString *)string;
+ (NSString *)getMD5FromPath:(NSString *)path;

@end

