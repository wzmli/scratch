---
title: Exploring how generation intervals link strength and speed of epidemics
author:
- Jonathan Dushoff
- David Champredon
- Joshua Weitz
date: The end of time
---

Abstract
--------

Introduction
============

# Background and problem setup 

R and r. R is often thought of as more important; r is easier to measure earlier in an epidemic. They are linked through the generation interval, and this is usually done using the generating function approach popularized by [@WallLips07].

Much  infectious disease modeling focuses on estimating the reproductive number -- the number of new cases caused on average by each case. In the specific case where the case is introduced in a fully susceptible population, we talk about the basic reproductive number \Ro. The reproductive number provides information about the disease's potential for spread and the difficulty of control. It  is often thought of a single number: an average  [@AndeMay91] or an appropriate sort of weighted average [@DiekHees90]. But the reproductive number can also be thought of as a distribution across the population of possible infectors: different hosts may have different tendencies to transmit disease. 

The reproductive number provides information about how a disease spreads, on the scale of disease generations.  It does not, however,  contain information about the population-level rate of spread (e.g. how disease incidence increases through time, which can be critical for public health interventions).  Hence, another important quantity is the population-level \emph{rate of spread}. In disease outbreaks, the rate of spread is often  inferred from case-incidence reports and used to estimate the reproductive number.

$i(t) \approx i(0) \exp(rt)$

$T_c = 1/r$

$T_2 = \ln(2)/r$

$r_0$ can be observed early in the epidemic

$r$ can typically be measured more robustly than $\Reff$

The reproductive number and the rate of spread are linked by the \emph{generation interval} -- the interval between the time that an individual is infected by an infector, and the time that the infector was infected \cite{Sven07}. 

Whereas the rate of spread measures the speed of the disease at the population level, the generation interval measures speed at the individual level. It is typically inferred from contact tracing, sometimes in combination with clinical data. 
Like the reproductive number, the generation interval can be thought of as a single number (typically its mean), or as a distribution.

Here, we extend the work of [@WallLips07] in two ways: we re-interpret their "generating-equation approach" to calculating R as a "filtered mean", and discuss the properties and interpretations of filtered means; and we suggest an alternative, more tractable moment approximation for the relationship between r and R.

Overview
--------

We are interested in the relationship between $r$, \Rx\ and the generation-interval distribution.

We define the generation-interval distribution using a renewal-equation approach. A wide range of disease models can be described using this model:
$$i(t) = S(t)\int{K(s)i(t-s) \,ds},$$
where $t$ is time, $i(t)$ is the incidence of new infections, $S(t)$ is the \emph{proportion} of the population susceptible, and $K(s)$ is the intrinsic infectiousness of individuals who have been infected for a length of time $s$.

We then have the basic reproductive number:
$$\Ro = \int{K(s)ds},$$
and the \emph{intrinsic} generation-interval distribution:
$$g(s) = \frac{K(s)}{\Ro}$$
(the "intrinsic" interval can be distinguished from "realized" intervals, which can look "forward" or "backward" in time [@ChamDush15], see also earlier work [@

	Where:

		\Rx\ is the effective reproductive number

		$g(\tau)$ (integrates to 1)  
		is the \emph{intrinsic} generation distribution

----------------------------------------------------------------------

Euler equation 

	Model

		$$i(t) = \Rx\int{g(\tau)i(t-\tau) \,d\tau}$$

	Exponential phase

		$$i(t) = i(0) \exp(t/C)$$

	Conclusion

		$$1/\Rx = \int{g(\tau)\exp(-\tau/C) \,d\tau}$$

----------------------------------------------------------------------

Interpretation: the ``effective'' generation time

	If the generation interval were absolutely fixed at a time interval
	of $G$, then 

		$${\Rx} = \exp(G/C)$$

	\emph{Define} the effective generation time so that this remains
	true:

		$${\Rx} = \exp(\hat G/C)$$

----------------------------------------------------------------------

A filtered mean

	If:

		$${\Rx} = \exp(\hat G/C)$$

	Then

		$$1/\Rx = \int{g(\tau)\exp(-\tau/C) \,d\tau}$$

	Becomes

		$$\exp(- \hat G/C) = \int{g(\tau)\exp(-\tau/C) \,d\tau}$$
		
		or, $$\exp(-\hat G/C) = \langle \exp(-\tau/C) \rangle_g$$,

	This is a ``filtered mean" of the distribution $g$.

	Equivalent to the Wallinga and Lipsitch generating function

----------------------------------------------------------------------

Filtered means

	Many things we know about are examples of filtered means

		Geometric mean (log function)

		Harmonic mean (reciprocal function)

		Root mean square (square) 

		Heterogeneous \Rx\ calculations

Derivation

Examples

Drawbacks

Moment approximation
--------------------

Derivation

Examples

Discussion
----------

Acknowledgments
----------------

\printbibliography
