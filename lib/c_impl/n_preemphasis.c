#include "n_preemphasis.h"

float * preemphasize(float *data, int len, double factor, double prior) {
    double current_prior = prior;
    prior = data[len-1];
    int i;
    for (i = 0; i < len; ++i) {
        double current = data[i];
        data[i] = current - factor * current_prior;
        current_prior = current;
    }
    return data;
}
