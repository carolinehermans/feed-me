#ifndef SEGMENT_GRAPH
#define SEGMENT_GRAPH

#include <algorithm>
#include <cmath>
#include "disjoint-set.h"

#define THRESHOLD(size, c) (c / size)

typedef struct {
	float w;
	int a, b;
} edge;

bool operator<(const edge &a, const edge &b) {
	return a.w < b.w;
}

universe* segment_graph(int num_vertices, int num_edges, edge* edges, float c) {
	std::sort(edges, edges + num_edges);
	
	universe* u = new universe(num_vertices);
	
	float* threshold = new float[num_vertices];
	for(int i = 0; i < num_vertices; i++) {
		threshold[i] = THRESHOLD(1,c);
	}
	
	for(int i = 0; i < num_edges; i++) {
		edge* pedge = &edges[i];
		
		int a = u->find(pedge->a);
		int b = u->find(pedge->b);
		
		if(a != b) {
			if((pedge->w <= threshold[a]) && (pedge->w <= threshold[b])) {
				u->join(a,b);
				a = u->find(a);
				threshold[a] = pedge->w + THRESHOLD(u->size(a), c);
			}
		}
	}
	delete threshold;
	return u;
}

#endif