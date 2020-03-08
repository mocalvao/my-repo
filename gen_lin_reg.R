source("input_data.R")

# the theoretical linear model function:
muy_mod <- function(x, slope, intercept){
  slope*x + intercept
}

# the simulations:
output <- data.frame()
for (j in 1:N_sim) {
## a vector of realized explanatory values for $x_i$:
x <- rnorm(n = N_obs, mean = mux, sd = sigmax)
## the corresponding vector of response values according to the theoretical 
## fiducial model:
muy_fid <- muy_mod(x, m_fid, c_fid)
## the corresponding vector of response variates $y_i$:
y <- rnorm(n = N_obs, mean = muy_fid, sd = sigmay)


## the so-called total variance:
vartot <- function(slope, sigmax, sigmay){
  sigmay**2 + slope**2*sigmax**2
}

## the (incomplete) usual chi-square function:
L_dat <- function(slope, intercept, x, y, sigmax, sigmay){
  (y - muy_mod(x, slope, intercept))**2/vartot(slope, sigmax, sigmay)
}

## the summand of the loglikelihood:
loglik_summand <- function(slope, intercept, x, y, sigmax, sigmay){
  (1/2)*(log(vartot(slope, sigmax, sigmay)) + L_dat(slope, intercept, x, y, sigmax, sigmay))
}

## the loglikelihood:
loglik <- function(slope, intercept, x, y, sigmax, sigmay){
  summ <- 0
  for (i in 1:N_obs) {
    summ <- summ + loglik_summand(slope, intercept, x[i], y[i], sigmax[i], sigmay[i])
  }
  return(summ)
}

negll <- function(params){
  loglik(params[1], params[2], x, y, sigmax, sigmay)
}

best_fit_out <- optim(par = c(m_fid, c_fid), fn = negll)

output <- rbind(output, data.frame(slope = best_fit_out$par[1], intercept = best_fit_out$par[2]))

}

library(readr)
write_tsv(output, path = "output.txt")


#plot(output)
#points(m_fid , c_fid, pch = 19, col = "red")

library(ggExtra)
library(ggplot2)

plt1 <- ggplot(output, aes(slope, intercept)) + geom_point() + theme_bw()
plt2 <- ggMarginal(plt1, type = "histogram")
show(plt2)
#fid_point <- data.frame(slope = m_fid, intercept = c_fid)
#plt3 <- plt2 + geom_point(data = fid_point, col = "red", size = 10)
#show(plt3)

sp1 <- ggplot(data = output, aes(slope, intercept)) +
  geom_point(color = "lightgray")
sp2 <- sp1 + geom_density_2d() + geom_point(data = data.frame(slope = m_fid, intercept = c_fid), aes(slope, intercept), col = "red", size = 3)
show(sp2)


library(ggstatsplot)
ggstplt1 <- ggscatterstats(
  data = output,
  x = slope,
  y = intercept,
  type = "bayes", # type of test that needs to be run
  method = "",
  xlab = "Slope m", # label for x axis
  ylab = "Intercept c", # label for y axis
  #label.var = "title", # variable for labeling data points
  #label.expression = "rating < 5 & budget > 100", # expression that decides which points to label
  title = "Model best fit parameters", # title text for the plot
  #caption = expression(paste(italic("Note"), ": IMDB stands for Internet Movie DataBase")),
  ggtheme = hrbrthemes::theme_ipsum_ps(), # choosing a different theme
  ggstatsplot.layer = FALSE, # turn off ggstatsplot theme layer
  marginal.type = "densigram", # type of marginal distribution to be displayed
  xfill = "orange", # color fill for x-axis marginal distribution
  yfill = "#009E73", # color fill for y-axis marginal distribution
  centrality.para = "mean", # central tendency lines to be displayed
  messages = FALSE, # turn off messages and notes
  bf.message = FALSE
)
show(ggstplt1)
