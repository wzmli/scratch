## hacked version of
slice2D <- function (params, fun, nt = 31,
                     lower = -Inf, upper = Inf, cutoff = 10, 
                     verbose = TRUE, tranges = NULL,  ...) 
{
    npv <- length(params)
    if (is.null(pn <- names(params))) 
        pn <- seq(npv)
    if (is.null(tranges)) {
        tranges <- bbmle:::get_all_trange(
            params, fun, rep(lower, length.out = npv), 
            rep(upper, length.out = npv),
            cutoff = cutoff,...)
    }
    slices <- list()
    for (i in 1:(npv - 1)) {
        slices[[i]] <- vector("list", npv)
        for (j in (i + 1):npv) {
            if (verbose) 
                cat("param", i, j, "\n")
            t1vec <- seq(tranges[i, 1], tranges[i, 2], length = nt)
            t2vec <- seq(tranges[j, 1], tranges[j, 2], length = nt)
            mtmp <- matrix(nrow = nt, ncol = nt)
            for (t1 in seq_along(t1vec)) {
                for (t2 in seq_along(t2vec)) {
                  mtmp[t1, t2] <- fun(bbmle:::mkpar(params, c(t1vec[t1], 
                    t2vec[t2]), c(i, j)), ...)
                }
            }
            slices[[i]][[j]] <- data.frame(var1 = pn[i], var2 = pn[j], 
                expand.grid(x = t1vec, y = t2vec), z = c(mtmp))
        }
    }
    r <- list(slices = slices, ranges = tranges, params = params, 
        dim = 2)
    class(r) <- "slice"
    r
}

splom.slice <- function (x, data, scale.min = TRUE, at = NULL, which.x = NULL, 
    which.y = NULL, dstep = 4, contour = FALSE, log="", ...) 
{
    logz <- grepl("z",log)
    ## dst
    if (x$dim == 1) 
        stop("can't do splom on 1D slice object")
    smat <- t(x$ranges[, 1:2])
    if (scale.min) {
        all.z <- unlist(sapply(x$slices, function(x) {
            sapply(x, function(x) if (is.null(x)) 
                NULL
            else x[["z"]])
        }))
        min.z <- min(all.z[is.finite(all.z)])
        if (is.na(dstep)) {
            ## failsafe
            dstep <- diff(range(all.z[is.finite(all.z)]))/10
        }
        max.z <- dstep * ((max(all.z[is.finite(all.z)]) - min.z)%/%dstep + 
                              1)
        if (missing(at)) {
            at <- seq(0, max.z, by = dstep)
        }
        scale.z <- function(X) {
            X$z <- X$z - min.z
            X
        }
        x$slices <- bbmle:::slices_apply(x$slices, scale.z)
    }
    if (logz) {
        x$slices <- bbmle:::slices_apply(x$slices,
               function(X) transform(X,z=log(z)))
    }
        
    up0 <- function(x1, y, groups, subscripts, i, j, ...) {
        ## browser()
        sl <- x$slices[[j]][[i]]
        with(sl, panel.levelplot(x = x, y = y, z = z, contour = contour, 
            at = if (!is.null(at)) 
                at
            else pretty(z), subscripts = seq(nrow(sl))))
        panel.points(x$params[j], x$params[i], pch = 16)
        mm <- matrix(sl$z, nrow = length(unique(sl$x)))
        wmin <- which(mm == min(mm), arr.ind = TRUE)
        xmin <- unique(sl$x)[wmin[1]]
        ymin <- unique(sl$y)[wmin[2]]
        panel.points(xmin, ymin, pch = 1)
    }
    lp0 <- function(...) {
    }
    splom(smat, lower.panel = lp0, diag.panel = diag.panel.splom, 
        upper.panel = up0, ...)
}

range.slice <- function(object,na.rm=FALSE, finite=FALSE) {
    dropv <- lapply(object$slice, function(x) x[!sapply(x,is.null)])
    flatv <- lapply(dropv,function(x) do.call(rbind,x))
    flatv2 <- do.call(rbind,flatv)
    range(flatv2$z,na.rm=na.rm,finite=finite)
}
