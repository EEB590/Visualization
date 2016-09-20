#SpiderProject_JB_manipulating and visualization
#written by Haldre Rogers for EEB590

#we're just going to work with the second experiment (transplant experiment)

transplant2<-read.csv("transplant2.csv", header=T, as.is=T)

str(transplant2)

#Getting summary data
#using base functions

#table, ftable, tapply() 
with(transplant2, table(site, native))
#ftable makes a table with three variables more visually appealing
with(transplant2, ftable(island, netting, totaldays))
with(transplant2, ftable(island, netting, native))

#tapply 
tapply(transplant2$duration, transplant2$netting, mean) #calculates mean duration for each level of netting. Essentially, this makes a table from the first two items, and then applies a function across columns in that table. 

#using dplyr package functions
# check out this website: https://www.r-bloggers.com/dplyr-example-1/

#Arrange - Order rows by values of a column (low to high). 
arrange(transplant2, island, duration) #arrange from lowest to highest duration, for each level of island

#mutate - Compute and append one or more new columns.
mutate(transplant2, webarea = (websize/2)^2*pi) #calculate webarea column from web diameter (assuming circle); can also add/multiply two columns to create a third etc. 

#summarize and group_by 
#group_by just takes a table and converts it into a grouped table so you can perform operations by each group
sumtransplant<-summarize(group_by(transplant2, island, native, netting), mean=mean(duration), max=max(duration))

#the pipe function %>% allows you to pipe the output from one function to the input of another function. Instead of nesting functions (reading from the inside to the outside), the idea of of piping is to read the functions from left to right.  (description from http://genomicsclass.github.io/book/pages/dplyr_tutorial.html)

transplant2 %>% group_by(island, native, netting) %>% summarize (mean=mean(duration)) #same as above

#play around with this- what else might you want to summarize? 

##############################################
##############################################
######basic visualization tools ##############
##############################################

# Base graphics
#Boxplot (box-and-whisker plot, showing median, first & third quantile, extremes of whiskers)
boxplot(transplant2$duration)
boxplot(duration~island*netting, data=transplant2)

#histogram (frequency of each value of continuous variable)
hist(transplant2$duration)
hist(transplant2$websize)

#coplot - conditioning plots- how does websize related to duration, given netting status? 
coplot(duration~ websize | netting, data=transplant2)

#pairs - all column by column interactions
pairs(transplant2) #mostly nonsensical because so many factors, but you get the idea

#plot
plot(transplant2$websize, transplant2$duration) #for two continuous variables
plot(transplant2$island, transplant2$duration) #if x is categorical, this turns into a boxplot

######## ggplot #######
Resources
	# http://tutorials.iq.harvard.edu/R/Rgraphics/Rgraphics.html
	# http://zevross.com/blog/2014/08/04/beautiful-plotting-in-r-a-ggplot2-cheatsheet-3/

#aes = aesthetic means "something you can see"
#geom's: http://sape.inf.usi.ch/quick-reference/ggplot2/geom. A plot must have at least one geom; there is no upper limit.

#histogram - use only a single continuous x value
ggplot(transplant2, aes(duration))+
geom_histogram()

#boxplot
ggplot(transplant2, aes(netting, duration))+
geom_boxplot() #plot response and predictors, continuous data

#create different boxplots for each island
ggplot(transplant2, aes(netting, duration, color=island))+
  geom_boxplot() 

#geom_point for two continuous variables - scatterplot
ggplot(transplant2, aes(websize, duration))+
  geom_point()

#add facet_grid to show other variables
ggplot(transplant2, aes(websize, duration))+
  geom_point()+
  facet_grid(netting~island)


                         
