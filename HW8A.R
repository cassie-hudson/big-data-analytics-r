# R Code for HW8A by Nick.Evangelopoulos@unt.edu
# This code was last run sucessfully in March 2016 in this environment:
# R version 3.2.2
# Platform: windows 8 64-bit
# Package versions: twitteR 1.1.8, devtools 1.7.0, rjson 0.2.15, bit64 0.9-4, httr 0.6.1, RCurl 1.95-4.5


# install useful packages
install.packages(c("twitteR", "devtools", "rjson", "bit64", "httr", "RCurl"))
library(devtools)
library(RCurl)
options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))
require(twitteR)

# Set up your Twitter authorization. Use your own codes provided to you by Twitter!
# Using just "xxxx" and "yyyy" as shown below will, of course, produce error messages!
# XXXX = Consumer Key, YYYY = Consumer Secret, ZZZZ = Access Token, WWWW = Access Token Secret 
options(httr_oauth_cache=F)
setup_twitter_oauth("XXXX", "YYYY", "ZZZZ", "WWWW")

# Execute the first Twitter search query. You can limit the time frame of the tweets by using the options: since='2016-03-05', until='2016-03-19'
# Note that 1500 tweets is the max, and it's subject to filtering and other restrictions by Twitter
# Start by setting n=20, check the first three rows using the head() function and, if successful, repeat the search using n=1200
tweets <- searchTwitter('#gm -#vintagecar -#FOLLOW ', n=1200, lang='en', since='2016-03-05', until='2016-03-19')


# convert to data frame
df <- do.call("rbind", lapply(tweets, as.data.frame)) 
# get column names to see structure of the data
names(df) 
# look at the first three rows to check content
head(df,3) 
# save as text file on C:\temp
write.table(df, "C:\\temp\\TwitterData_#gm1.txt", sep="\t")


# Second Twitter query, after filtering out a few unwanted terms related to genetically modified food
tweets <- searchTwitter('#gm -#vintagecar -#GMO -#Releasing -#millions -Monsanto -#India -zika -salmon -mosquitoes -#Indian -#Monsantos -#food -#cotton -#FOLLOW ', n=1200, lang='en', since='2015-03-11', until='2015-03-12')


# convert to data frame
df <- do.call("rbind", lapply(tweets, as.data.frame)) 
# get column names to see structure of the data
names(df) 
# look at the first three rows to check content
head(df,3) 
# save as text file on C:\temp
write.table(df, "C:\\temp\\TwitterData_#gm2.txt", sep="\t")