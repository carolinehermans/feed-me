#ifndef IMAGE_H
#define IMAGE_H

#include <cstring>

template <class T>
class image {
public:
	image(const int width, const int height, const bool init = true);
	~image();
	
	void init(const T &val);
	image<T> *copy() const;
	
	int width() const { return w; }
	int height() const { return h; }
	
	T *data;
	T **access;

private:
	int w, h;
};

#define imRef(im, x, y) (im->access[y][x])
  
#define imPtr(im, x, y) &(im->access[y][x])

template <class T>
image<T>::image(const int width, const int height, const bool init) {
  w = width;
  h = height;
  data = new T[w * h];
  access = new T*[h];
  for (int i = 0; i < h; i++)
    access[i] = data + (i * w);  
  
  if (init)
    memset(data, 0, w * h * sizeof(T));
}

template <class T>
image<T>::~image() {
  delete [] data; 
  delete [] access;
}

template <class T>
void image<T>::init(const T &val) {
  T *ptr = imPtr(this, 0, 0);
  T *end = imPtr(this, w-1, h-1);
  while (ptr <= end)
    *ptr++ = val;
}

template <class T>
image<T> *image<T>::copy() const {
  image<T> *im = new image<T>(w, h, false);
  memcpy(im->data, data, w * h * sizeof(T));
  return im;
}

#endif
  
