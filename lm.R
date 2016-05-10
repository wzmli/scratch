> lm 
function (formula, data, subset, weights, na.action, method = "qr", 
    model = TRUE, x = FALSE, y = FALSE, qr = TRUE, singular.ok = TRUE, 
    contrasts = NULL, offset, ...) 
{
    ret.x <- x
    ret.y <- y
    cl <- match.call()
    mf <- match.call(expand.dots = FALSE)
    m <- match(c("formula", "data", "subset", "weights", "na.action", 
        "offset"), names(mf), 0L)
    mf <- mf[c(1L, m)]
    mf$drop.unused.levels <- TRUE
    mf[[1L]] <- quote(stats::model.frame)
    mf <- eval(mf, parent.frame())
    if (method == "model.frame") 
        return(mf)
    else if (method != "qr") 
        warning(gettextf("method = '%s' is not supported. Using 'qr'", 
            method), domain = NA)
    mt <- attr(mf, "terms")
    y <- model.response(mf, "numeric")
    w <- as.vector(model.weights(mf))
    if (!is.null(w) && !is.numeric(w)) 
        stop("'weights' must be a numeric vector")
    offset <- as.vector(model.offset(mf))
    if (!is.null(offset)) {
        if (length(offset) != NROW(y)) 
            stop(gettextf("number of offsets is %d, should equal %d (number of observations)", 
                length(offset), NROW(y)), domain = NA)
    }
    if (is.empty.model(mt)) {
        x <- NULL
        z <- list(coefficients = if (is.matrix(y)) matrix(, 0, 
            3) else numeric(), residuals = y, fitted.values = 0 * 
            y, weights = w, rank = 0L, df.residual = if (!is.null(w)) sum(w != 
            0) else if (is.matrix(y)) nrow(y) else length(y))
        if (!is.null(offset)) {
            z$fitted.values <- offset
            z$residuals <- y - offset
        }
    }
    else {
	 		return(list(mt, mf, contrasts))
        x <- model.matrix(mt, mf, contrasts)
        z <- if (is.null(w)) 
            lm.fit(x, y, offset = offset, singular.ok = singular.ok, 
                ...)
        else lm.wfit(x, y, w, offset = offset, singular.ok = singular.ok, 
            ...)
    }
    class(z) <- c(if (is.matrix(y)) "mlm", "lm")
    z$na.action <- attr(mf, "na.action")
    z$offset <- offset
    z$contrasts <- attr(x, "contrasts")
    z$xlevels <- .getXlevels(mt, mf)
    z$call <- cl
    z$terms <- mt
    if (model) 
        z$model <- mf
    if (ret.x) 
        z$x <- x
    if (ret.y) 
        z$y <- y
    if (!qr) 
        z$qr <- NULL
    z
}

> lm.fit
function (x, y, offset = NULL, method = "qr", tol = 1e-07, singular.ok = TRUE, 
    ...) 
{
    if (is.null(n <- nrow(x))) 
        stop("'x' must be a matrix")
    if (n == 0L) 
        stop("0 (non-NA) cases")
    p <- ncol(x)
    if (p == 0L) {
        return(list(coefficients = numeric(), residuals = y, 
            fitted.values = 0 * y, rank = 0, df.residual = length(y)))
    }
    ny <- NCOL(y)
    if (is.matrix(y) && ny == 1) 
        y <- drop(y)
    if (!is.null(offset)) 
        y <- y - offset
    if (NROW(y) != n) 
        stop("incompatible dimensions")
    if (method != "qr") 
        warning(gettextf("method = '%s' is not supported. Using 'qr'", 
            method), domain = NA)
    chkDots(...)
    z <- .Call(C_Cdqrls, x, y, tol, FALSE)
    if (!singular.ok && z$rank < p) 
        stop("singular fit encountered")
    coef <- z$coefficients
    pivot <- z$pivot
    r1 <- seq_len(z$rank)
    dn <- colnames(x)
    if (is.null(dn)) 
        dn <- paste0("x", 1L:p)
    nmeffects <- c(dn[pivot[r1]], rep.int("", n - z$rank))
    r2 <- if (z$rank < p) 
        (z$rank + 1L):p
    else integer()
    if (is.matrix(y)) {
        coef[r2, ] <- NA
        if (z$pivoted) 
            coef[pivot, ] <- coef
        dimnames(coef) <- list(dn, colnames(y))
        dimnames(z$effects) <- list(nmeffects, colnames(y))
    }
    else {
        coef[r2] <- NA
        if (z$pivoted) 
            coef[pivot] <- coef
        names(coef) <- dn
        names(z$effects) <- nmeffects
    }
    z$coefficients <- coef
    r1 <- y - z$residuals
    if (!is.null(offset)) 
        r1 <- r1 + offset
    if (z$pivoted) 
        colnames(z$qr) <- colnames(x)[z$pivot]
    qr <- z[c("qr", "qraux", "pivot", "tol", "rank")]
    c(z[c("coefficients", "residuals", "effects", "rank")], list(fitted.values = r1, 
        assign = attr(x, "assign"), qr = structure(qr, class = "qr"), 
        df.residual = n - z$rank))
}

> poly
function (x, ..., degree = 1, coefs = NULL, raw = FALSE, simple = FALSE) 
{
    dots <- list(...)
    if (nd <- length(dots)) {
        if (nd == 1 && length(dots[[1L]]) == 1L) 
            degree <- dots[[1L]]
        else return(polym(x, ..., degree = degree, coefs = coefs, 
            raw = raw))
    }
    if (is.matrix(x)) {
        m <- unclass(as.data.frame(cbind(x, ...)))
        return(do.call(polym, c(m, degree = degree, raw = raw, 
            list(coefs = coefs))))
    }
    if (degree < 1) 
        stop("'degree' must be at least 1")
    if (raw) {
        Z <- outer(x, 1L:degree, "^")
        colnames(Z) <- 1L:degree
    }
    else {
        if (is.null(coefs)) {
            if (anyNA(x)) 
                stop("missing values are not allowed in 'poly'")
            if (degree >= length(unique(x))) 
                stop("'degree' must be less than number of unique points")
            xbar <- mean(x)
            x <- x - xbar
            X <- outer(x, 0L:degree, "^")
            QR <- qr(X)
            if (QR$rank < degree) 
                stop("'degree' must be less than number of unique points")
            z <- QR$qr
            z <- z * (row(z) == col(z))
            Z <- qr.qy(QR, z)
            norm2 <- colSums(Z^2)
            alpha <- (colSums(x * Z^2)/norm2 + xbar)[1L:degree]
            norm2 <- c(1, norm2)
        }
        else {
            alpha <- coefs$alpha
            norm2 <- coefs$norm2
            Z <- matrix(1, length(x), degree + 1L)
            Z[, 2] <- x - alpha[1L]
            if (degree > 1) 
                for (i in 2:degree) Z[, i + 1] <- (x - alpha[i]) * 
                  Z[, i] - (norm2[i + 1]/norm2[i]) * Z[, i - 
                  1]
        }
        Z <- Z/rep(sqrt(norm2[-1L]), each = length(x))
        colnames(Z) <- 0L:degree
        Z <- Z[, -1, drop = FALSE]
        if (!simple) 
            attr(Z, "coefs") <- list(alpha = alpha, norm2 = norm2)
    }
    if (simple) 
        Z
    else structure(Z, degree = 1L:degree, class = c("poly", "matrix"))
}
