#include "mex.h"
#include "eigenmex.h"
#include "nnsearch.h"
#include "mexutils.h"

using namespace Eigen;
using namespace std;

typedef TrimeshSearcher<MatrixWrap,MatrixWrap> Searcher;

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){
    if(nrhs!=2){
        mexErrMsgTxt("two arguments required");
        return;
    }
    ConstMatrixWrap vertices = wrap(prhs[0]);
    ConstMatrixWrap faces = wrap(prhs[1]);
    Searcher* searcher = new Searcher();
    plhs[0] = MexUtils::savepointer(searcher);
    searcher->build(vertices, faces);
}