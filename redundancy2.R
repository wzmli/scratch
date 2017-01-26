
## Given a formula, and a list of rows with structural NAs for a variable, 
## fit a model by setting them either to baseline or mean
## Later break this into more functions so we can call the hard one and use it for things other than lm

structFill <- function(mm, NArows, varNum, me="mean"){
  
  modAssign <- attr(mm, "assign")
  fillcols <- which(modAssign==varNum)
  
  # dcheck <- na.omit(mm[NArows, fillcols])
  # if (length(dcheck)>0){stop("Not all structural NAs are really NA")}
  
  if(me=="base")
    mm[NArows, fillcols] <- 0
  else if (me=="mean"){
    mm[NArows, fillcols] <- matrix(
      colMeans(mm[!NArows,fillcols])
      , nrow=sum(NArows)
      , ncol=length(fillcols)
      , byrow=TRUE
    )
  }
  else stop("Unrecognized me")
  
  return(mm)
}

lmerFill <- function (formula, data = NULL, NArows, fillvar, me="mean",REML = TRUE, control = lmerControl(), 
                      start = NULL, verbose = 0L, subset, weights, na.action, offset, 
                      contrasts = NULL, devFunOnly = FALSE, ...) 
{
  mc <- mcout <- match.call()
  missCtrl <- missing(control)
  if (!missCtrl && !inherits(control, "lmerControl")) {
    if (!is.list(control)) 
      stop("'control' is not a list; use lmerControl()")
    warning("passing control as list is deprecated: please use lmerControl() instead", 
            immediate. = TRUE)
    control <- do.call(lmerControl, control)
  }
  if (!is.null(list(...)[["family"]])) {
    warning("calling lmer with 'family' is deprecated; please use glmer() instead")
    mc[[1]] <- quote(lme4::glmer)
    if (missCtrl) 
      mc$control <- glmerControl()
    return(eval(mc, parent.frame(1L)))
  }
  mc$control <- control
  mc[[1]] <- quote(lme4::lFormula)
  lmod <- eval(mc, parent.frame(1L))
  mcout$formula <- lmod$formula
  lmod$formula <- NULL
  varNum <- which(attr(attr(lmod$fr, "terms"), "term.labels")==fillvar)
  lmod$X <- structFill(lmod$X, NArows, varNum, me)
  devfun <- do.call(mkLmerDevfun, c(lmod, list(start = start, 
                                               verbose = verbose, control = control)))
  if (devFunOnly) 
    return(devfun)
  opt <- if (control$optimizer == "none") 
    list(par = NA, fval = NA, conv = 1000, message = "no optimization")
  else {
    optimizeLmer(devfun, optimizer = control$optimizer, restart_edge = control$restart_edge, 
                 boundary.tol = control$boundary.tol, control = control$optCtrl, 
                 verbose = verbose, start = start, calc.derivs = control$calc.derivs, 
                 use.last.params = control$use.last.params)
  }
  cc <- checkConv(attr(opt, "derivs"), opt$par, ctrl = control$checkConv, 
                  lbound = environment(devfun)$lower)
  mkMerMod(environment(devfun), opt, lmod$reTrms, fr = lmod$fr, 
           mc = mcout, lme4conv = cc)
}