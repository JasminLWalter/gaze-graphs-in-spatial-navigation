####################### mean_performance_models.R ##############################

# --------------------script written by Jasmin L. Walter-------------------
# -----------------------jawalter@uni-osnabrueck.de------------------------

'Purpose: 
Regress PTB performance on FRS questionnaire scales and graph properties; fit simple
and full linear models; inspect residual diagnostics; and estimate unique contributions
by drop-one-factor ΔR².

Usage:
- Adjust: savepath (and setwd) to your analysis directory.
- Update paths to required CSV overviews.
- Run the script in R/RStudio.

Inputs:
  - overview_FRS_Data.csv (columns include: Mean_egocentric_global, Mean_survey, Mean_cardinal)
- overviewGraphMeasures.csv (columns include: Participants, meanPerformance, nrViewedHouses,
                             nrEdges, density, diameter, hierarchyIndex)
- overviewTable_P2B_Prep_complete.csv (columns include: SubjectID, RecalculatedAngle; used to fit
                                       a SubjectID-only model on trial-level performance)

Outputs:
  - Console: summaries for linear models (participant ID model; FRS-only; individual FRS regressions;
                                          full graph-properties model; simple one-predictor graph models; drop-one ΔR² calculations)
- Plots (displayed, not saved by default): residual histogram, residual vs. fitted, QQ plot,
scale–location, Cook’s distance, ACF of residuals; additional ggplot diagnostics

Dependencies:
  - R >= 4.x
- Packages: ggplot2

License: GNU General Public License v3.0 (GPL-3.0) (see LICENSE)'


################################################################################

rm(list = ls())

# load the required package

library(ggplot2)

################################################################################
##################### adjust following variables

savepath <- "....\\Analysis\\P2B_controls_analysis\\performanceModels\\"
setwd(savepath)

# load FRS overview
dataFRS <- read.csv("..../Analysis/P2B_controls_analysis/overview_FRS_Data.csv")

# load graph measure overview
dataGraphMeasures <- read.csv("..../Analysis/P2B_controls_analysis/performance_graph_properties_analysis/overviewGraphMeasures.csv")

dataGraphMFRS <- cbind(dataGraphMeasures, dataFRS[, c(2,5,8)])
dataGraphMFRS$Participants <- as.factor(dataGraphMFRS$Participants)

# load full performance data frame
dataP2B <- read.csv("..../Analysis/P2B_controls_analysis/overviewTable_P2B_Prep_complete.csv")
dataP2B$SubjectID <- as.factor(dataP2B$SubjectID)

################################################################################
################ modeling #####################

# only subject id

# participant ID in lm

model_lm_participantID <- lm(RecalculatedAngle ~ as.factor(SubjectID), data = dataP2B)

summary(model_lm_participantID)



#######################################
# frs data

modelFRS <- lm(meanPerformance ~ Mean_egocentric_global + Mean_survey +
                 Mean_cardinal  ,data = dataGraphMFRS)
summary(modelFRS)

# individual regressions

modelFRS2 <- lm(meanPerformance ~ Mean_egocentric_global ,data = dataGraphMFRS)
summary(modelFRS2)


modelFRS3 <- lm(meanPerformance ~ Mean_survey ,data = dataGraphMFRS)
summary(modelFRS3)


modelFRS4 <- lm(meanPerformance ~ Mean_cardinal,data = dataGraphMFRS)
summary(modelFRS4)


#########################################
# general graph properties

modelGraphM_full <- lm(meanPerformance ~ nrViewedHouses + nrEdges + density + diameter +
                       hierarchyIndex,data = dataGraphMFRS)
summary(modelGraphM_full)

# -----------------
# residual plots

hist(resid(modelGraphM_full))

# check for normality of residuals
ggplot(data.frame(residuals = residuals(modelGraphM_full), fitted = fitted(modelGraphM_full)), aes(x = fitted, y = residuals)) +
  geom_point() +
  geom_smooth() +
  ggtitle("Residuals vs Fitted") +
  xlab("Fitted Values") +
  ylab("Residuals")

# check for outliers
qqnorm(resid(modelGraphM_full))
qqline(resid(modelGraphM_full))

# create scale-location plot of residuals
plot(fitted(modelGraphM_full), sqrt(abs(resid(modelGraphM_full))))

# create Cook's distance plot
plot(cooks.distance(modelGraphM_full))


# check for homoscedasticity
ggplot(data.frame(residuals = residuals(modelGraphM_full), fitted = fitted(modelGraphM_full)), aes(x = fitted, y = residuals)) +
  geom_point() +
  ggtitle("Residuals vs Fitted") +
  xlab("Fitted Values") +
  ylab("Residuals") +
  scale_y_continuous(limits = c(-3, 3)) +
  geom_hline(yintercept = 0, color = "red") +
  geom_smooth(se = FALSE)

# check for linearity
ggplot(data.frame(y = dataGraphMFRS$meanPerformance, fitted = fitted(modelGraphM_full)), aes(x = fitted, y = y)) +
  geom_point() +
  geom_smooth() +
  ggtitle("Actual vs Fitted") +
  xlab("Fitted Values") +
  ylab("Actual Values")

# check for independence
acf(residuals(modelGraphM_full))



###------------------------------------

# simple models

modelNo <- lm(meanPerformance ~ nrViewedHouses, data = dataGraphMFRS)
summary(modelNo)

modelE <- lm(meanPerformance ~ nrEdges, data = dataGraphMFRS)
summary(modelE)

modelDe <- lm(meanPerformance ~ density,data = dataGraphMFRS)
summary(modelDe)

modelDi <- lm(meanPerformance ~ diameter, data = dataGraphMFRS)
summary(modelDi)

modelH <- lm(meanPerformance ~ hierarchyIndex, data = dataGraphMFRS)
summary(modelH)


#####---------------------------------------------
# uniquely explained variances.... remove fixed effects 1 by 1
fullR2 <- summary(modelGraphM_full)[["r.squared"]]

# remove viewed buildings/nodes
modelGGraph2 <- lm(meanPerformance ~ nrEdges + density + 
                     diameter + hierarchyIndex ,data = dataGraphMFRS)
summary(modelGGraph2)

fullR2 - summary(modelGGraph2)[["r.squared"]]

# remove edges
modelGGraph3 <- lm(meanPerformance ~ nrViewedHouses + density + 
                     diameter + hierarchyIndex ,data = dataGraphMFRS)
summary(modelGGraph3)

fullR2 - summary(modelGGraph3)[["r.squared"]]

# remove density

modelGGraph4 <- lm(meanPerformance ~ nrViewedHouses + nrEdges + 
                     diameter + hierarchyIndex ,data = dataGraphMFRS)
summary(modelGGraph4)

fullR2 - summary(modelGGraph4)[["r.squared"]]


# remove diameter
modelGGraph5 <- lm(meanPerformance ~ nrViewedHouses + nrEdges + density + 
                     hierarchyIndex ,data = dataGraphMFRS)
summary(modelGGraph5)

fullR2 - summary(modelGGraph5)[["r.squared"]]


# remove hierarchy index
modelGGraph6 <- lm(meanPerformance ~ nrViewedHouses + nrEdges + density + diameter,data = dataGraphMFRS)
summary(modelGGraph6)

fullR2 - summary(modelGGraph6)[["r.squared"]]




















