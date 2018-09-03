/*
Created 07-09-2015
Updated 9-2-2018
Lucas Jackson (http://lucasjackson.io/repo)
*/
#import "capture.h"
#import <AVFoundation/AVFoundation.h>

void takepicture(BOOL front,BOOL landscape,BOOL mirror,char* filename,int quality);
void usage(char* cmd);

int main(int argc, char **argv, char **envp) {
    int opt;
    bool front = false;
    bool landscape = false;
    bool mirror = false;
    int quality = 1;
    char *outputFile = NULL;
    while ((opt = getopt (argc, argv, "q:o:flhm")) != -1)
    {
        switch (opt)
        {
            case 'q':
                quality = atoi(optarg);
                printf ("quality: \"%d\"\n", quality);
                break;
            case 'o':
                printf ("Output file: \"%s\"\n", optarg);
                outputFile = optarg;
                break;
            case 'f':
                front = true;
                break;
            case 'l':
                landscape = true;
                break;
            case 'm':
                mirror = true;
                break;
            case 'h':
                landscape = true;
                usage(argv[0]);
                return 0;
        }
    }
    takepicture(front,landscape,mirror,outputFile,quality);
    return 0;
}

void usage(char* cmd) {
    printf("Usage: %s -l(toggle landscape) -q(specify quality [highest 1 - lowest 3]) -o(specify output file) -f(toggle front facing)\n",cmd);
}

void takepicture(BOOL front,BOOL landscape,BOOL mirror,char* filename,int quality) {
    capture *cam = [[capture alloc] init];
    cam.mirror = mirror;
    cam.front = front;
    cam.filepath = [NSString stringWithFormat:@"%s",filename];
    cam.landscape = landscape;
    cam.quality = quality;
    [cam setupCaptureSession];
    [NSThread sleepForTimeInterval:0.2];
    //wait to finish
    __block BOOL done = NO;
    [cam captureWithBlock:^(UIImage *image)
     {done = YES;}];
    while (!done)
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    [cam release];
}
