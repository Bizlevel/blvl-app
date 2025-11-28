#import "PMMD5Utils.h"

@implementation PMMD5Utils

static NSString *PMHexStringFromDigest(const unsigned char *digest, NSUInteger length) {
    NSMutableString *output = [NSMutableString stringWithCapacity:length * 2];
    for (NSUInteger i = 0; i < length; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return [output copy];
}

+ (NSString *)getMD5FromString:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [self.class hashFromData:data];
}

+ (NSString *)getMD5FromData:(NSData *)data {
    return [self.class hashFromData:data];
}

+ (NSString *)getMD5FromPath:(NSString *)path {
    return (__bridge_transfer NSString *)PMHashFromPath((__bridge CFStringRef)path, PMFileHashDefaultChunkSizeForReadingData);
}

+ (NSString *)hashFromData:(NSData *)data {
    if (!data || data.length == 0) {
        return @"";
    }
    unsigned char digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(data.bytes, (CC_LONG)data.length, digest);
    return PMHexStringFromDigest(digest, CC_SHA256_DIGEST_LENGTH);
}

CFStringRef PMHashFromPath(CFStringRef filePath, size_t chunkSizeForReadingData) {
    CFStringRef result = NULL;
    CFReadStreamRef readStream = NULL;

    CFURLRef fileURL =
        CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                      (CFStringRef)filePath,
                                      kCFURLPOSIXPathStyle,
                                      (Boolean)false);

    CC_SHA256_CTX hashObject;
    bool hasMoreData = true;
    bool didSucceed = false;

    if (!fileURL) goto done;

    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault, (CFURLRef)fileURL);
    if (!readStream) goto done;
    didSucceed = (bool)CFReadStreamOpen(readStream);
    if (!didSucceed) goto done;

    CC_SHA256_Init(&hashObject);

    if (!chunkSizeForReadingData) {
        chunkSizeForReadingData = PMFileHashDefaultChunkSizeForReadingData;
    }

    while (hasMoreData) {
        uint8_t buffer[chunkSizeForReadingData];
        CFIndex readBytesCount =
            CFReadStreamRead(readStream, (UInt8 *)buffer, (CFIndex)sizeof(buffer));
        if (readBytesCount == -1) break;
        if (readBytesCount == 0) {
            hasMoreData = false;
            continue;
        }
        CC_SHA256_Update(&hashObject, (const void *)buffer, (CC_LONG)readBytesCount);
    }

    didSucceed = !hasMoreData;

    unsigned char digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256_Final(digest, &hashObject);

    if (!didSucceed) goto done;

    char hash[2 * sizeof(digest) + 1];
    for (size_t i = 0; i < sizeof(digest); ++i) {
        snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
    }
    result = CFStringCreateWithCString(kCFAllocatorDefault,
                                       (const char *)hash,
                                       kCFStringEncodingUTF8);

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

@end

