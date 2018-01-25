#include "mex.h"
#include "nnsearch.h"
#include "mexutils.h"
#include "eigenmex.h"

using namespace Eigen;
using namespace std;

typedef TrimeshSearcher<MatrixWrap,MatrixWrap> Searcher;

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){
    if(nrhs!=1){
        mexErrMsgTxt("one arguments required");
        return;
    }
    Searcher* searcher = MexUtils::loadpointer<Searcher>(prhs[0]);
    delete searcher;
}