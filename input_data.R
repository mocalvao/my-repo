# the initial data for the simulations

## number of observations for each simulation:
N_obs <- 50

# number of simulations or experiments, which is equal to the number 
# of best fit models:
N_sim <- 1000

# explanatory mean values:
## minimum value:
mux_min <- -2
## maximum value:
mux_max <- 5
## the two choices above determine the following vector of explanatory mean 
## values, which are fixed for all simulations:
mux <- seq(from = mux_min, to = mux_max, length.out = N_obs)

# explanatory standard deviation values:
## minimum value:
sigmax_min <- 0.1
## maximum value:
sigmax_max <- 1.5
## the two choices above determine the vector of explanatory standard deviation 
## values, which are also fixed for all simulations:
sigmax <- seq(from = sigmax_min, to = sigmax_max, length.out = N_obs)

# parameters of the fiducial linear theoretical model for the regression of 
# the response Y upon the explanatory X:
m_fid <- 1
c_fid <- 2

# response standard deviation values:
## minimum value:
sigmay_min <- 1
## maximum value:
sigmay_max <- 1
## the two choices above determine the vector of response standard deviation 
## values, which are fixed for all simulations:
sigmay <- seq(from = sigmay_min, to = sigmay_max, length.out = N_obs)
