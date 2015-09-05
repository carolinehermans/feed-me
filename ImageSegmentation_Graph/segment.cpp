#include <cstdio>
#include <cstdlib>
#include <image.h>
#include <misc.h>
#include <pnmfile.h>
#include "segment-image.h"

int main(int argc, char** argv) {
    if(argc != 6) {
        fprintf(stderr, "usage: %s sigma k min input output", argv[0]);
        return 1;
    }
    
    float sigma = atof(argv[1]);
    float k = atof(argv[2]);
    int min_size = atoi(argv[3]);
    
    //printf("Loading input image!\n");
    image<rgb>* input = loadPPM(argv[4]);
    
    //printf("Processing...\n");
    int num_clusters;
    image<rgb>* seg = segment_image(input, sigma, k, min_size, &num_clusters);
    savePPM(seg, argv[5]);
    
    //printf("Got %d clusters!\n", num_clusters);
    return 0;
}