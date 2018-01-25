#include <math.h>
#include <matrix.h>
#include <mex.h>
#include <Eigen/Dense>
#include <Eigen/Sparse>

typedef Eigen::Triplet<double, int> ETriplet;
typedef Eigen::SparseMatrix<double> SpMat;

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	// Input
    double* G = mxGetPr(prhs[0]);
    mxLogical* mask = mxGetLogicals(prhs[1]);
	
	//figure out dimensions
    const mwSize* dims = mxGetDimensions(prhs[0]);
    const int S = (int) dims[0];
    const int size = S * S;
	
	const int neighborhood[13] = {0, 1, -1, S, -S, -S-1, S-1, S+1, -S+1, 2, -2, 2*S, -2*S}; // Neighborhood indices
	const double kernel[13] = {20.0, -8.0, -8.0, -8.0, -8.0, 2.0, 2.0, 2.0, 2.0, 1.0, 1.0, 1.0, 1.0};
	
	Eigen::VectorXd b(size);
    Eigen::VectorXd x(size);
	std::vector<ETriplet> tripletList;
	//tripletList.reserve(n / 2); TODO

    for (int i = 0; i < size; i++)
    {
		if (mask[i])
		{
			tripletList.push_back(ETriplet(i, i, 1.0));
			b[i] = G[i];
		}
		else
		{
			for (int j = 0; j < 13; j++)
			{
				tripletList.push_back(ETriplet(i, i + neighborhood[j], kernel[j]));
			}
			b[i] = 0.0;
		}
    }
    
    // Sparse init
    SpMat L(size, size);
    L.setFromTriplets(tripletList.begin(), tripletList.end());
    
    // Solve
	Eigen::SparseLU<SpMat> llt;
	llt.compute(L);
    x = llt.solve(b);
	
    // Output
    plhs[0] = mxCreateDoubleMatrix(S, S, mxREAL);
    double* Gs = mxGetPr(plhs[0]);
	
	// Extract
	for (int i = 0; i < size; i++)
	{
		Gs[i] = x[i];
	}
}
