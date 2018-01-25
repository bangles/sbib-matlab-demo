#pragma once
#include <Eigen/Dense>

namespace Eigen{
    typedef double Scalar; ///< matlab uses double 
    typedef Eigen::Matrix<Scalar, Eigen::Dynamic, Eigen::Dynamic> MatrixDyn;
    typedef Eigen::Map<MatrixDyn> MatrixWrap;
    typedef Eigen::Map<const MatrixDyn> ConstMatrixWrap;

    ConstMatrixWrap wrap(const mxArray* in){
        double* data = mxGetPr(in);
        size_t rows = mxGetM(in);
        size_t cols = mxGetN(in);
        ConstMatrixWrap wrapped(data,rows,cols);       
        return wrapped;
    }

    MatrixWrap wrap(mxArray* in){
        double* data = mxGetPr(in);
        size_t rows = mxGetM(in);
        size_t cols = mxGetN(in);
        MatrixWrap wrapped(data,rows,cols);       
        return wrapped;
    }
};