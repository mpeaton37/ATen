#ifndef THCS_GENERIC_FILE
#define THCS_GENERIC_FILE "generic/THCSTensorMath.cu"
#else

#define ROW_PTR2(t, r) (THCTensor_(data)(THCState *state, t) + (r) * (t)->stride[0])
#define COL_PTR2(t, c) (THCTensor_(data)(THCState *state, t) + (c) * (t)->stride[1])

THCudaLongTensor *THCSTensor_(toCSR)(THCState *state, long const *indices, long dim, long nnz) {
  THError("WARNING: Sparse Cuda Tensor op toCSR is not implemented");
  // TODO hook up with cusparse
  return NULL;
}

void THCSTensor_(zero)(THCState *state, THCSTensor *self) {
  self->nnz = 0;
}

void THCTensor_(spaddcmul)(THCState *state, THCTensor *r_, THCTensor *t, real value, THCSTensor *src1, THCSTensor *src2) {
  THError("WARNING: Sparse Cuda Tensor op spaddcmul is not implemented");
}

void THCTensor_(spaddcdiv)(THCState *state, THCTensor *r_, THCTensor *t, real value, THCSTensor *src1, THCSTensor *src2) {
  THError("WARNING: Sparse Cuda Tensor op spaddcdiv is not implemented");
}

void THCSTensor_(spaddmm)(THCState *state, THCTensor *r_, real beta, THCTensor *t, real alpha, THCSTensor *sparse, THCTensor *dense) {
  THError("WARNING: Sparse Cuda Tensor op spaddmm is not implemented");
  // TODO This is just a cusparse call (gemm?)
}

void THCSTensor_(sspaddmm)(THCState *state, THCSTensor *r_, real beta, THCSTensor *t, real alpha, THCSTensor *sparse, THCTensor *dense) {
  THError("WARNING: Sparse Cuda Tensor op sspaddmm is not implemented");
  // TODO Write some kernels
}

void THCSTensor_(spcadd)(THCState *state, THCTensor *r_, THCTensor *dense, real value, THCSTensor *sparse) {
  THError("WARNING: Sparse Cuda Tensor op spcadd is not implemented");
  // TODO pretty sure this is also just a cusparse call (axpyi)
}

void THCSTensor_(mul)(THCState *state, THCSTensor *r_, THCSTensor *t, real value) {
  if (r_ == t) {
    THCTensor *r_values_ = THCSTensor_(values)(state, r_);
    THCTensor_(mul)(state, r_values_, r_values_, value);
    THCTensor_(free)(state, r_values_);
  } else {
    THCSTensor_(resizeAs)(state, r_, t);

    THCIndexTensor *r_indices_ = THCSTensor_(indices)(state, r_);
    THCTensor *r_values_ = THCSTensor_(values)(state, r_);
    THCIndexTensor *t_indices_ = THCSTensor_(indices)(state, t);
    THCTensor *t_values_ = THCSTensor_(values)(state, t);

    THCIndexTensor_(resizeAs)(state, r_indices_, t_indices_);
    THCIndexTensor_(copy)(state, r_indices_, t_indices_);
    THCTensor_(mul)(state, r_values_, t_values_, value);
    r_->nnz = t->nnz;
    r_->contiguous = t->contiguous;

    THCIndexTensor_(free)(state, r_indices_);
    THCTensor_(free)(state, r_values_);
    THCIndexTensor_(free)(state, t_indices_);
    THCTensor_(free)(state, t_values_);
  }
}

void THCSTensor_(div)(THCState *state, THCSTensor *r_, THCSTensor *t, real value) {
  if (r_ == t) {
    THCTensor *r_values_ = THCSTensor_(values)(state, r_);
    THCTensor_(mul)(state, r_values_, r_values_, value);
    THCTensor_(free)(state, r_values_);
  } else {
    THCSTensor_(resizeAs)(state, r_, t);

    THCIndexTensor *r_indices_ = THCSTensor_(indices)(state, r_);
    THCTensor *r_values_ = THCSTensor_(values)(state, r_);
    THCIndexTensor *t_indices_ = THCSTensor_(indices)(state, t);
    THCTensor *t_values_ = THCSTensor_(values)(state, t);

    THCIndexTensor_(resizeAs)(state, r_indices_, t_indices_);
    THCIndexTensor_(copy)(state, r_indices_, t_indices_);
    THCTensor_(div)(state, r_values_, t_values_, value);
    r_->nnz = t->nnz;
    r_->contiguous = t->contiguous;

    THCIndexTensor_(free)(state, r_indices_);
    THCTensor_(free)(state, r_values_);
    THCIndexTensor_(free)(state, t_indices_);
    THCTensor_(free)(state, t_values_);
  }
}

void THCSTensor_(cadd)(THCState *state, THCSTensor *r_, THCSTensor *t, real value, THCSTensor *src) {
  THError("WARNING: Sparse Cuda Tensor op cadd is not implemented");
}

void THCSTensor_(csub)(THCState *state, THCSTensor *r_, THCSTensor *t, real value, THCSTensor *src) {
  THError("WARNING: Sparse Cuda Tensor op csub is not implemented");
}

void THCSTensor_(cmul)(THCState *state, THCSTensor *r_, THCSTensor *t, THCSTensor *src) {
  THError("WARNING: Sparse Cuda Tensor op cmul is not implemented");
}

#undef ROW_PTR2
#undef COL_PTR2

#endif
