#include "mex.h"
#include "nnsearch.h"
#include "mexutils.h"
#include "eigenmex.h"

using namespace Eigen;
using namespace std;

typedef TrimeshSearcher<MatrixWrap,MatrixWrap> Searcher;

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){
    if(nrhs!=2){
        mexErrMsgTxt("ERROR: 'mex_nn' requires two arguments!!");
        return;
    }
    
    /// Fetch search accelerator
    Searcher* searcher = MexUtils::loadpointer<Searcher>(prhs[0]);
    /// Fetch query data
    ConstMatrixWrap queries = wrap(prhs[1]);
    
    /// Allocate output vectors
    plhs[0]=mxCreateDoubleMatrix(3,queries.cols(),mxREAL);
    plhs[1]=mxCreateDoubleMatrix(1,queries.cols(),mxREAL);
    plhs[2]=mxCreateDoubleMatrix(3,queries.cols(),mxREAL);
    MatrixWrap footpoints = wrap(plhs[0]);    
    MatrixWrap findex = wrap(plhs[1]);
    MatrixWrap barycentric = wrap(plhs[2]);
    
    /// Perform query
    searcher->closest_point(queries, footpoints, findex);
    searcher->barycentric(footpoints, findex, barycentric);
}