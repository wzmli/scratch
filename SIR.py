import numpy as np
import numpy.random as npr
import matplotlib.pyplot as plt

#No Vital Dynamics

def infectionrate(S0, probI):
	"""takes a probability(probS) in decimal form and finds the distribution of states over TotalPop
	random trials (the chain binomial), return the number of S individuals at a given infection prob
	after infection is allowed to occur"""
	inf = 0
	for x in range(S0):
		bi = npr.uniform(0, 1)
		if bi < probI:
			inf += 1
		else:
			inf += 0
	return inf

def recoveryrate(I0, probR):
	""" using the amount of infected it calculates the amount of people that recover from
	the infection
	:param IR: infected population
	:param probR: recovery probability
	:return: recovered individuals
	"""
	rec = 0
	for x in range(I0):
		bi = npr.uniform(0, 1)
		if bi < probR:
			rec += 1
		else:
			rec += 0
	return rec

def cb_gen(S0, I0, R0, probInf, probRe):
	"""find the number of infected and succeptible individuals in a population over 1 generation under
	the chain binomial epidemic model given a probability of infection(prob), the initial number of
	 succeptible individuals(S)and the initial number of infected individuals (I0). It returns
	 the new number of succeptible and infected individuals."""

	PI = 1- (1 - probInf) ** (I0)
	PR = 1- (1 - probRe) ** (R0)
	new_S = S0 - infectionrate(S0, PI)
	new_R = recoveryrate(I0, PR) + R0
	new_I = I0 + S0 - new_S - new_R + R0
	if new_I + new_S + new_R != S0 + I0 + R0:
		raise ValueError
	return new_S, new_I, new_R

#cb_gen(20, 5, 7, 0.2, 0.4)

def cb_sim(S0, I0, R0, probSuc, probRec, nmax = 10):
	"""simulates the chain binomial epidemic model (cb_gen) for nmax generations (10 by default) and returns the number of
	infected individuals in each generation in a tuple (IG)"""
	SG = []
	IG = []
	RG = []
	SG.append(S0)
	IG.append(I0)
	RG.append(R0)
	Snew, Inew, Rnew = cb_gen(S0, I0, R0, probSuc, probRec)
	SG.append(Snew)
	IG.append(Inew)
	RG.append(Rnew)
	for i in range(nmax - 1):
		Snew, Inew, Rnew = cb_gen(Snew, Inew, Rnew, probSuc, probRec)
		SG.append(Snew)
		IG.append(Inew)
		RG.append(Rnew)
		if Inew == 0:
			return tuple(SG), tuple(IG), tuple(RG)
	return tuple(SG), tuple(IG), tuple(RG)

def update_cb_dict(d,k):
	"""updates a dictionary d. If key k is already a key, adds one to d[k], if not initializes d[k] = 1"""
	#for z in (k):
	if k in d:
		d[(k)] += 1
	else:
		d[(k)] = 1

#THIS IS THE FUNCTION I AM HAVING AN ISSUE WITH
def runSims(Suc = 40, Inf = 2, Rec = 4, ProbI = 0.1, ProbR =0.2, nmax = 10, reps=10000):
	""" Runs 10000 simulations of the binomial epidemic model using cb_sim() and updates
	 the dictionaries S1, I1, R1 (using update_cb_dict) with each simulation's tuples of succeptibles, infected and
	 recovered as a key and the number of occurences as the value. Then the average number of individals for each class
	  of individuals"""
	probiterate = 0
	MeanlistS = []
	MeanlistI = []
	MeanlistR = []

	while probiterate <= 1.0:
		S1 = {}
		I1 = {}
		R1 = {}
		lens, leni, lenr = 0, 0, 0
		for x in range(reps):
			a, b, c = cb_sim(Suc, Inf, Rec, probiterate,ProbR, nmax)
			update_cb_dict(S1, a)
			update_cb_dict(I1, b)
			update_cb_dict(R1, c)

		temp = 0
		lenses = [lens, leni, lenr]
		dicts = [S1, I1, R1]
		meanlists = [MeanlistS, MeanlistI, MeanlistR]
		for t in range(3):
			u = dicts[t]
			for x in u.keys():
				for y in x:
					for i in range(u[x]):
						temp += y
						lenses[t] += 1
			meanlists[t].append(temp / lenses[t])

		SS = np.array(MeanlistS)
		II = np.array(MeanlistI)
		RR = np.array(MeanlistR)
		probiterate += 0.05

	print(SS, II, RR)

np.random.seed(233)
runSims(reps=20)
