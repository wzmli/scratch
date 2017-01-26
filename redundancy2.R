
## Given a formula, and a list of rows with structural NAs for a variable, 
## fit a model by setting them either to baseline or mean
## Later break this into more functions so we can call the hard one and use it for things other than lm

structFill <- function(mm, NArows, varNum, method="mean"){
  
  modAssign <- attr(mm, "assign")
  fillcols <- which(modAssign==varNum)
  
  dcheck <- na.omit(mm[NArows, fillcols])
  if (length(dcheck)>0){stop("Not all structural NAs are really NA")}
  
  if(method=="base")
    mm[NArows, fillcols] <- 0
  else if (method=="mean"){
    mm[NArows, fillcols] <- matrix(
      colMeans(mm[!NArows,fillcols])
      , nrow=sum(NArows)
      , ncol=length(fillcols)
      , byrow=TRUE
    )
  }
  else stop("Unrecognized method")
  
  return(mm)
}
  
lmFill <- function(formula, data, NArows, fillvar, method="mean"){
  
  mf <- model.frame(formula, data=data, na.action=NULL)
  mt <- attr(mf, "terms")
  mm <- model.matrix(mt, mf)
  
  varNum <- which(attr(attr(mf, "terms"), "term.labels")==fillvar)
  
  mm <- structFill(mm, NArows, varNum, method)
  
  mr <- model.response(mf)
  mfit <- lm.fit(mm, mr)
  mfit$call <- match.call()
  class(mfit) <- "lm"
  mfit$terms <- terms(mf)
  
  return(mfit)
}
