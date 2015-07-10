#import <AVFoundation/AVFoundation.h>

@interface capture:NSObject {
    NSString *filepath;
}

@property (nonatomic,strong) AVCaptureSession *session;
@property (readwrite, retain) AVCaptureStillImageOutput *stillImageOutput;

- (AVCaptureDevice *)frontFacingCameraIfAvailable;
- (AVCaptureDevice *)backFacingCameraIfAvailable;

- (void)setupCaptureSession:(BOOL)isfront;
- (void)captureWithBlock:(void(^)(UIImage* block))block;
- (void)setfilename:(NSString *)filename;
@end

