#import "capture.h"

@implementation capture

- (AVCaptureDevice *)frontFacingCameraIfAvailable {
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *captureDevice = nil;
    for (AVCaptureDevice *device in videoDevices){
        if (device.position == AVCaptureDevicePositionFront){
            captureDevice = device;
            break;
        }
    }
    return captureDevice;
}

- (AVCaptureDevice *)backFacingCameraIfAvailable {
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *captureDevice = nil;
    for (AVCaptureDevice *device in videoDevices){
        if (device.position == AVCaptureDevicePositionBack){
            captureDevice = device;
            break;
        }
    }
    return captureDevice;
}

- (void)setupCaptureSession {
    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = AVCaptureSessionPresetMedium;
    
    AVCaptureDevice *device = nil;
    NSError *error = nil;
    if (self.front)
        device = [self frontFacingCameraIfAvailable];
    else
        device = [self backFacingCameraIfAvailable];

    if ((self.torch) && ([device hasTorch])) {
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOn];
        [device unlockForConfiguration];
    }

    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        // Handle the error appropriately.
        NSLog(@"ERROR: trying to open camera: %@", error);
        exit(0);
    }
    [self.session addInput:input];
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    [outputSettings release];
    [self.session addOutput:self.stillImageOutput];
    if (self.quality == 1)
        [self.session setSessionPreset:AVCaptureSessionPreset1920x1080];
    else if (self.quality == 2)
        [self.session setSessionPreset:AVCaptureSessionPreset1280x720];
    else if (self.quality == 3)
        [self.session setSessionPreset:AVCaptureSessionPreset640x480];

    [self.session startRunning];
}

- (void)captureWithBlock:(void(^)(UIImage* image))block {
    AVCaptureConnection* videoConnection = nil;
    for (AVCaptureConnection* connection in self.stillImageOutput.connections)
    {
        for (AVCaptureInputPort* port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo])
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection)
            break;
    }
    
    if (self.landscape) {
        videoConnection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
    }
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         NSData* imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage* image = [[UIImage alloc] initWithData:imageData];
         if (self.mirror) {
             image = [UIImage imageWithCGImage:image.CGImage
                                                         scale:image.scale
                                                   orientation:UIImageOrientationUpMirrored];
         }
         if (imageData) {
             if (self.filepath != NULL) {
                 printf("Saving image to %s...\n",[self.filepath UTF8String]);
                 [imageData writeToFile:self.filepath atomically:YES];
             }
         }
         block(image);
     }];
    [_stillImageOutput release];
    [_session release];
}


@end
