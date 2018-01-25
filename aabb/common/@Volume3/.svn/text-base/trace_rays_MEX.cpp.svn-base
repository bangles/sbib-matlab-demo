#include <mex.h>
#include <math.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//--- ONLY ONE OF THE TWO MUST BE ACTIVE!!!
#define MINIMIZING
// #define AVERAGING

// Macro to get the index of an element in a 3D vector
#define indx(i,j,k) ( i +j*dims[0] +k*dims[0]*dims[1] )

int pos2off(double p, int axis);
double off2pos(double p, int axis);
bool trace_ray_fast(double *p, double *d, double startat, double slack, double type);
void project_on_ray(int Pos0, int Pos1, int Pos2, double* p, double* d, double& pt, double& pw);

// Global variables to reduce #parameters
double* pmin;
double* pmax;
double  delta;
int ndims;
int dims[4];
double* f;
double* w;

// Core
void mexFunction(int nlhs, mxArray *plhs[],int nrhs, const mxArray *prhs[]) {
    //--------------------------------------------------------------------------------//
    //                             INPUT PARAMETERS
    // function(this, rays_o, rays_d, startat, slack, field, delta, pmin, pmax)
    //--------------------------------------------------------------------------------//
    if(nrhs != 10) mexErrMsgTxt("10 parameters required! (including object pointer)");
    //--- rays_o
    const mxArray* rays_o_mxa = prhs[1];
    double* rays_o = mxGetPr(rays_o_mxa);
    int nrays = mxGetDimensions(rays_o_mxa)[0]; //mxGetM(rays_o_mxa);
    //--- rays_d
    const mxArray* rays_d_mxa = prhs[2];
    double* rays_d = mxGetPr(rays_d_mxa);
    //--- rays_t (type: 0 means origin is not a scanpoint)
    const mxArray* rays_t_mxa = prhs[3];
    double* rays_t = mxGetPr(rays_t_mxa);
    //--- startat
    const mxArray* startat_mxa = prhs[4];
    double startat = mxGetScalar(startat_mxa);
    //--- slack
    const mxArray* slack_mxa = prhs[5];
    double slack = mxGetScalar(slack_mxa);
    //--- field
    const mxArray* f_mxa = prhs[6];
    f = mxGetPr(f_mxa);
    ndims = mxGetNumberOfDimensions(f_mxa);
    const mwSize* dims_mxa = mxGetDimensions(f_mxa);
    dims[0] = (ndims>0) ? dims_mxa[0] : 1;
    dims[1] = (ndims>1) ? dims_mxa[1] : 1;
    dims[2] = (ndims>2) ? dims_mxa[2] : 1;
    dims[3] = dims[0]*dims[1]*dims[2];
    ndims = 3; // always set 3D
    // mexPrintf("%d %d %d\n",dims[0],dims[1],dims[2]);
    //--- delta
    const mxArray* delta_mxa = prhs[7];
    delta = mxGetScalar(delta_mxa);
    // mexPrintf("delta: %.2f\n",delta);
    //--- pmin
    const mxArray* pmin_mxa = prhs[8];
    pmin = mxGetPr(pmin_mxa);
    //--- pmax
    const mxArray* pmax_mxa = prhs[9];
    pmax = mxGetPr(pmax_mxa);

    //--------------------------------------------------------------------------------//
    //                         LOCAL MEMORY ALLOCATION
    //--------------------------------------------------------------------------------//
    #ifdef AVERAGING
        // Allocate space for averaging weights
        mxArray* w_mxa = mxCreateNumericArray(ndims, dims, mxDOUBLE_CLASS, mxREAL);
        w = mxGetPr( w_mxa );
        //--- Zero the F_i
        for(int I=0; I<dims[0]*dims[1]*dims[2]; I++){
            f[I]=0;
            w[I]=0;
        }
    #endif
    #ifdef MINIMIZING    
        //--- Upper bound distance field
        for(int I=0; I<dims[0]*dims[1]*dims[2]; I++)
            f[I]=+FLT_MAX;
    #endif

    //--------------------------------------------------------------------------------//
    //                               RUN TRACING
    //--------------------------------------------------------------------------------//
    double* xo = rays_o+0*nrays;
    double* yo = rays_o+1*nrays;
    double* zo = rays_o+2*nrays;
    double* xd = rays_d+0*nrays;
    double* yd = rays_d+1*nrays;
    double* zd = rays_d+2*nrays;
    bool success = false;
    int skipcount = 0;
    for(int n = 0; n < nrays; n++) {
        //--- Retrieve ray
        double o[3] = {xo[n],yo[n],zo[n]};
        double d[3] = {xd[n],yd[n],zd[n]};
        //--- Background ray? (starts on BBOX)
        double type = rays_t[n];

        //--- Debug display
        // mexPrintf("ray #%d: [%.2f %.2f %.2f] [%.2f %.2f %.2f] type: %.2f\n", n, o[0],o[1],o[2], d[0],d[1],d[2], type);
        // if( type==0 ){
        //    // mexPrintf("skipped!!\n");
        //    // continue;
        // }

        //--- Trace ray
        success = trace_ray_fast(o, d, startat, slack, type);
        if(!success) {
            skipcount++;
            // mexPrintf("Skipped ray #%d\n",n);
            // mexPrintf("ray #%d: [%.2f %.2f %.2f] [%.2f %.2f %.2f] type: %.2f\n", n, o[0],o[1],o[2], d[0],d[1],d[2], type);
        }
    }
    if( skipcount>0 )
        mexPrintf("    (skipped %d)\n",skipcount);

    //--------------------------------------------------------------------------------//
    //                            NORMALIZE TRACING
    //--------------------------------------------------------------------------------//
    // Normalize weighted average
    #ifdef AVERAGING
        for(int I=0; I<dims[0]*dims[1]*dims[2]; I++)
            f[I] = ( w[I] > 0 ) ? f[I] / w[I] : 0;
        mxDestroyArray( w_mxa );
    #endif            
    #ifdef MINIMIZING
        for(int I=0; I<dims[0]*dims[1]*dims[2]; I++)
            f[I] = ( f[I] == +FLT_MAX ) ? 0 : f[I];
    #endif
    return;
}

const float HALFCUBEDIAG = (sqrt(3.0)/4.0)/2.0;

/* Trace a single ray */
bool trace_ray_fast(double *p, double *d, double startat, double slack, double type) {

    // Space carving ray (not associated with surface sample)
    // We want to start 1 pixel inside bbox and however
    // we want to avoid having a zero crossing so we give it some slack
    if( type==0 ) {
        startat = +delta;
        slack   = 0;
    }

    // mexPrintf("startat: %.2f\n", startat);
    float rayT = 1e-20;

    /* We want to test intersections "startat" distance behind the ray as well */
    p[0] += startat*d[0];
    p[1] += startat*d[1];
    p[2] += startat*d[2];

    /* Set up 3D DDA for current ray
     * NOTE: The -.5*delta is the only difference w.r.t. PBRT as they were using a
     * slightly different indexing method:
     *
     *   - PBRT: integer offsets are cells lower-left corner
     *   - MATL: integer offsets are cells centers
     *
     * Also note that the -.5*delta causes a bug in the sign of NextCrossingT
     * (which should always positive) thus we can correct it by simply taking
     * the absolute value. */
//     mexPrintf("start\n");
    float NextCrossingT[3], DeltaT[3];
    int Step[3], Out[3], Pos[3];
    /* Iterate through all the axes */
    for (int axis = 0; axis < ndims; ++axis) {
        /* Compute current voxel for this axis */
        Pos[axis] = pos2off(p[axis], axis);

        // Skip ray!
        if( Pos[axis]==-1 )
            return false;

//         mexPrintf("Pos[%d] = %d\n",axis,Pos[axis]);
        if (d[axis] >= 0) {
            NextCrossingT[axis] = fabs( rayT + (off2pos(Pos[axis]+1, axis)-p[axis]-.5*delta) / d[axis] );
            DeltaT[axis] = delta / d[axis];
            Step[axis] = 1;
            Out[axis] = dims[axis];
        }
        else {
            /* Handle ray with negative direction for voxel stepping */
            NextCrossingT[axis] = fabs( rayT + (off2pos(Pos[axis], axis)-p[axis]-.5*delta) / d[axis] );
            DeltaT[axis] = -delta / d[axis];
            Step[axis] = -1;
            Out[axis] = -1;
        }
    }

    // Restore offset (otherwise we modify values in matlab too!!)
    p[0] -= startat*d[0];
    p[1] -= startat*d[1];
    p[2] -= startat*d[2];

    /* Walk ray through voxel grid */
    double pt=0; // distance from origina of ray
    double pw=0; // distance projection between ray and voxel
    int I=0;     // index to access vol1,vol2
    int i,j,k;   // ???
    // int ntouched = 0; debug
    for (;;) {
        //--- Mark in fields
        // ntouched++; debug
        // mexPrintf("step\n");

        i = Pos[0];
        j = Pos[1];
        k = Pos[2];
        I = indx(i, j, k);
        if( I<0 || I>dims[3] ) {
            mexPrintf("0 <= [%d %d %d] < [%d %d %d]\n", i,j,k, dims[0], dims[1], dims[2]);
            mexErrMsgTxt("error here");
        }

        project_on_ray(i,j,k,p,d,pt,pw);
        pt += slack;
        
        // This could be done much better!!
        #ifdef AVERAGING
            
            // If this is the first guess
            if( w[I]==0 ){
                // ... and it's far
                if( pt>delta ){
                    f[ I ] = pt;
                    w[ I ] = 1;
                }
                // ... and it's close
                else if( pt<=delta ){
                    pw = 1-HALFCUBEDIAG*(pw/delta);
                    pw = (pw<=0) ? 0 : pw;
                    f[ I ] = pw*pt;
                    w[ I ] = pw;
                }
            } 
            // If it is not the first guess
            else if( w[I]>0 ){
                // Compute current distance guess
                double CF = f[I]/w[I];
                
                // If we are close to zero and receive far from zero
                if( CF<=delta && pt>delta ){
                    // ignore
                }
                // If we are close to zero and receive another close zero (w-average)
                else if( CF<=delta && pt<=delta ){
                    pw = 1-HALFCUBEDIAG*(pw/delta);
                    pw = (pw<=0) ? 0 : pw;
                    f[ I ] += pw*pt;
                    w[ I ] += pw;
                }
                // If we are away from zero and receive another away from zero (minimize)
                else if( CF> delta && pt>delta ){
                    f[I] = pt<f[I] ? pt:f[I];
                }
                // If we are away from zero and receive a new close to zero (init w-average)
                else if( CF> delta && pt<= delta ){
                    pw = 1-HALFCUBEDIAG*(pw/delta);
                    pw = (pw<=0) ? 0 : pw;
                    f[ I ] = pw*pt;
                    w[ I ] = pw;
                }
            } 
            else
                mexErrMsgTxt("something gone wrong");
        #endif
        
        #ifdef MINIMIZING
            f[I] = pt<f[I] ? pt:f[I];
        #endif

        //--- Advance to next voxel
        int bits = ((NextCrossingT[0] < NextCrossingT[1]) << 2) +
                   ((NextCrossingT[0] < NextCrossingT[2]) << 1) +
                   ((NextCrossingT[1] < NextCrossingT[2]));
        const int cmpToAxis[8] = { 2, 1, 2, 1, 2, 2, 0, 0 };
        int stepAxis = cmpToAxis[bits];
        Pos[stepAxis] += Step[stepAxis];
        if (Pos[stepAxis] == Out[stepAxis]) {
            // mexPrintf("OUTING at Out[stepAxis]: %d after #%d\n", Out[stepAxis], ntouched);
            break;
        }
        NextCrossingT[stepAxis] += DeltaT[stepAxis];
    }

    return true;
}

// Project on line and compute distance from origin + distance from line
void project_on_ray(int Pos0, int Pos1, int Pos2, double* p, double* d, double& pt, double& pw) {
    // mexPrintf("p=[%.2f %.2f %.2f];\n", off2pos( p_min, p_max, sz1, delta, Pos0, 0 ), off2pos( p_min, p_max, sz1, delta, Pos1, 1 ), off2pos( p_min, p_max, sz1, delta, Pos2, 2 ) );
    // mexPrintf("o=[%.2f %.2f %.2f]\n", p[0],p[1],p[2]);
    // mexPrintf("d=[%.2f %.2f %.2f]\n", d[0],d[1],d[2]);

    double cvp[3]= {0,0,0}; // calculation buffer
    cvp[0] = off2pos( Pos0, 0 ) - p[0];
    cvp[1] = off2pos( Pos1, 1 ) - p[1];
    cvp[2] = off2pos( Pos2, 2 ) - p[2];
    pt = cvp[0]*d[0] + cvp[1]*d[1] + cvp[2]*d[2];
    cvp[0] -= (d[0]*pt);
    cvp[1] -= (d[1]*pt);
    cvp[2] -= (d[2]*pt);
    pw = sqrt( cvp[0]*cvp[0] + cvp[1]*cvp[1] + cvp[2]*cvp[2] );
}

/* These two functions are independent of the dimension */
int pos2off(double p, int axis) {
    int ret = (int) roundf( (p - pmin[axis])/delta );
    /* Return -1 if out of the volume */
    if ((ret < 0) || (ret >= dims[axis])) {
        return -1;
        // mexPrintf("axis: %d, p %.2f, ret: %d, bounds: %d", axis, p, ret, dims[axis]);
        // mexErrMsgTxt("offsetted ray goes out of bounds!!");
    }
    return ret;
}
double off2pos(double p, int axis) {
    return (p)*delta + pmin[axis];
}
