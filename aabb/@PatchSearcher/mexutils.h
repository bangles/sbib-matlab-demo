#pragma once
#include "mex.h"

namespace MexUtils{
    template< class TYPE > 
    mxArray* savepointer(TYPE* pointer){
        mxArray* retval = mxCreateNumericMatrix(1, 1, mxUINT64_CLASS, mxREAL);
        *((uint64_t *)mxGetData(retval)) = reinterpret_cast<uint64_t>(pointer);
        return retval;
    }
    
    template<class TARGETTYPE> 
    TARGETTYPE* loadpointer(const mxArray *in){
        if (mxGetNumberOfElements(in) != 1 || mxGetClassID(in) != mxUINT64_CLASS || mxIsComplex(in))
            mexErrMsgTxt("Input must be a real uint64 scalar.");
        TARGETTYPE* ptr = reinterpret_cast<TARGETTYPE*>(*((uint64_t *)mxGetData(in)));
        return ptr;
    }
}