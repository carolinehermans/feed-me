#ifndef SEGMENT_IMAGE
#define SEGMENT_IMAGE

#include <cstdlib>
#include <stdio.h>
#include <image.h>
#include <misc.h>
#include <filter.h>
#include <unordered_set>
#include "segment-graph.h"

rgb random_rgb() {
    rgb c;
    double r;
    c.r = (uchar) random();
    c.g = (uchar) random();
    c.b = (uchar) random();
    
    return c;
}

//The dissimilarity measure used l2-norm in (Z/255Z)^3 with basis rgb
static inline float diff(image<float>* r, image<float>* g, image<float>* b, 
						 int x1, int y1, int x2, int y2) {
	return sqrt(square(imRef(r, x1, y1) - imRef(r, x2, y2)) +
				square(imRef(g, x1, y1) - imRef(g, x2, y2)) +
				square(imRef(b, x1, y1) - imRef(b, x2, y2)));
}

bool compare(const std::pair<int,std::pair<int, std::pair<int, int> > >&i, const std::pair<int,std::pair<int, std::pair<int, int> > >&j)
{
	if(i.first == j.first) {
		if(i.second.first == j.second.first) {
			if(i.second.second.first == j.second.second.first) {
				return i.second.second.second < j.second.second.second;
			}
			return i.second.second.first < i.second.second.first;
		}
		return i.second.first < j.second.first;
	}
    return i.first < j.first;
}

image<rgb>* segment_image(image<rgb>* im, float sigma, float c, int min_size, 						  int* num_clusters) {
	int width = im->width();
	int height = im->height();
	
	image<float>* r = new image<float>(width, height);
	image<float>* g = new image<float>(width, height);
	image<float>* b = new image<float>(width, height);
	
	//Smooth the inidividual color channels
	for(int y = 0; y < height; y++) {
		for(int x = 0; x < width; x++) {
			imRef(r, x, y) = imRef(im, x, y).r;
			imRef(g, x, y) = imRef(im, x, y).g;
			imRef(b, x, y) = imRef(im, x, y).b;
		}
	}
	
	image<float>* smooth_r = smooth(r, sigma);
	image<float>* smooth_g = smooth(g, sigma);
	image<float>* smooth_b = smooth(b, sigma);
	
	delete r; delete g; delete b;
	
	//Constuct G=(V,E) where each pixel is a vertex and neigbors form edges
	edge* edges = new edge[width * height * 4];
	int num = 0;
	for(int y = 0; y < height; y++) {
		for(int x = 0; x < width; x++) {
			if(x < width - 1) {
				edges[num].a = y * width + x;
				edges[num].b = y * width + (x + 1);
				edges[num].w = diff(smooth_r, smooth_g, smooth_b, x, y, x+1, y);
				num++;
			}
			
			if(y < height - 1) {
				edges[num].a = y * width + x;
				edges[num].b = (y+1) * width + x;
				edges[num].w = diff(smooth_r, smooth_g, smooth_b, x, y, x, y+1);
				num++;
			}
			
			if((x < width - 1) && (y < height - 1)) {
				edges[num].a = y * width + x;
				edges[num].b = (y+1) * width + (x+1);
				edges[num].w = diff(smooth_r, smooth_g, smooth_b, x, y, x+1, y+1);
				num++;
			}
			
			if((x < width - 1) && (y > 0)) {
				edges[num].a = y * width + x;
				edges[num].b = (y-1) * width + (x+1);
				edges[num].w = diff(smooth_r, smooth_g, smooth_b, x, y, x+1, y-1);
				num++;
			}
		}
	}
	delete smooth_r; delete smooth_g; delete smooth_b;
	
	//Segment the graph
	universe* u = segment_graph(width * height, num, edges, c);
	
	//Post-process to join together connected sements that are too small
	for(int i = 0; i < num; i++) {
		int a = u->find(edges[i].a);
		int b = u->find(edges[i].b);
		if((a != b) && ((u->size(a) < min_size) || (u->size(b) < min_size))) {
			u->join(a,b);
		}
	}
	
	delete [] edges;
	*num_clusters = u->num_sets();
	
	image<rgb>* output = new image<rgb>(width,height);
	rgb* colors = new rgb[width * height];
	for(int i = 0; i < width * height; i++) {
		colors[i] = random_rgb();
	}
	
	
	std::unordered_set<int> classes;
	for(int y = 0; y < height; y++) {
		for(int x = 0; x < width; x++) {
			int comp = u->find(y * width + x);
			classes.insert(comp);
			imRef(output, x, y) = colors[comp];
		}
	}
	
	std::string ret = "";
	std::vector<std::pair<int,std::pair<int, std::pair<int, int> > > > clusters;
	for (auto it = classes.begin(); it != classes.end(); ++it) {
		int cl = *it;
		
		int minX = width;
		int minY = height;
		int maxX = 0;
		int maxY = 0;
		
		for(int y = 0; y < height; y++) {
			for(int x = 0; x < width; x++) {
				if(imRef(output, x, y) == colors[cl]) {
					minX = fmin(minX,x);
					maxX = fmax(maxX,x);
					minY = fmin(minY,y);
					maxY = fmax(maxY,y);
				}
			}
		}
		std::pair<int, std::pair< int, std::pair<int, int> > > boundary = std::pair<int, std::pair<int, std::pair<int, int> > >(minX, std::pair<int, std::pair<int, int> > (minY, std::pair<int,int>(maxX, maxY)));
		clusters.push_back(boundary);
	} 
	std::sort(clusters.begin(),clusters.end(),compare);
	for(int w = 0; w < clusters.size(); w++) {
		char tmp[25];
		std::pair<int,std::pair<int, std::pair<int, int> > > c = clusters.at(w);
		int n = sprintf(tmp,"(%d,%d,%d,%d)",c.first,c.second.first,c.second.second.first,c.second.second.second);
		ret += tmp;
		ret += ";";
	}
	ret.erase(ret.size() - 1);
	printf("%s\n",ret.c_str());
	
	delete [] colors;
	delete u;
	
	return output;
}

#endif