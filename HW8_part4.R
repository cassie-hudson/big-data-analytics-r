# code for HW8 -- part4
#
# Sentiment analysis code based on Ben Marwick's code at: https://github.com/benmarwick/AAA2011-Tweets/blob/master/AAA2011.R
# Requires data to be previously collected and stored in a csv file with "text" as the column heading of the 
# column containing the data
#
# Information: https://github.com/benmarwick/AAA2011-Tweets/
# Licence: http://creativecommons.org/licenses/by-nc-sa/2.0/

# install useful packages
install.packages(c("ggplot2", "gridExtra", "igraph", "Matrix", "plyr", "pvclust", "RColorBrewer", "rJava", "slam", "sna", "SnowballC", "stringr", "tm", "topicmodels", "wordcloud"))


library(tm)
library(wordcloud)
library(RColorBrewer)
library(ggplot2)
library(plyr)
library(stringr)
library(gridExtra)
library(Matrix)


# The following four lines will read in a TXT/CSV file
# On the RDWeb, use dir <- "\\\\tsclient\\C\\temp"
# If R is installed on your PC, use dir <- "C:\\temp", dir <- "H:\\RApps", etc.   

dir <- "C:\\temp"
setwd("C:/temp")
file <- "TwitterData_#gm3.csv"
df <- read.csv(paste(dir, file, sep = "/"), stringsAsFactors = FALSE)

# first clean the twitter messages by removing odd characters
df$text <- sapply(df$text,function(row) iconv(row,to = 'UTF-8'))
df$text<- tolower(df$text)

######  -  -  -  -  -  -  - Sentiment Analysis -  -  -  -  -  -  -  -

RunBreenSentimentAnalysis = TRUE
if(RunBreenSentimentAnalysis == TRUE) {

	# Upload sentiment library

		hu.liu.pos=scan('C:/temp/positive-words.txt',what='character',comment.char=';') #load +ve sentiment word list
		hu.liu.neg=scan('C:/temp/negative-words.txt',what='character',comment.char=';') #load -ve sentiment word list
		pos.words=c(hu.liu.pos) # can add terms here e.g. c(hu.liu.pos, 'newterm', 'newterm2')
		neg.words=c(hu.liu.neg)
	
		score.sentiment = function(sentences, pos.words, neg.words, .progress='none')
			{
    		
    		# we got a vector of sentences. plyr will handle a list or a vector as an "l" for us    
		# we want a simple array ("a") of scores back, so we use "l" + "a" + "ply" = "laply":    

			scores = laply(sentences, function(sentence, pos.words, neg.words) 
				{
				word.list = str_split(sentence, '\\s+') # split into words. str_split is in the stringr package            
				words = unlist(word.list)  # sometimes a list() is one level of hierarchy too much       
				# compare our words to the dictionaries of positive & negative terms        
				pos.matches = match(words, pos.words)        
				neg.matches = match(words, neg.words)             
				# match() returns the position of the matched term or NA. we just want a TRUE/FALSE:        
				pos.matches = !is.na(pos.matches)        
				neg.matches = !is.na(neg.matches)         
				# and conveniently enough, TRUE/FALSE will be treated as 1/0 by sum():        
				score = sum(pos.matches) - sum(neg.matches)        
				return(score)   
 			}, pos.words, neg.words, .progress=.progress )     
	
			scores.df = data.frame(score=scores, text=sentences)    
			return(scores.df)
		}

		scores <- score.sentiment(df$text,pos.words, neg.words, .progress = 'text')
		hist(scores$score)
		ggplot(scores, aes(x=score)) + geom_histogram(binwidth=1) + xlab("Sentiment score") + ylab("Frequency") + theme_bw()  + theme(axis.title.x = element_text(vjust = -0.5, size = 14)) + theme(axis.title.y=element_text(size = 14, angle=90, vjust = -0.25)) + theme(plot.margin = unit(c(1,1,2,2), "cm")) # plots nice histogram
		ggsave(file = "OverallSentimentHistogram1.pdf") # export the plot to a PDF file

		# Extract documents by sentiment category neutral, positive, negative, very positive, and very negative 

			scores.neutral<-subset(scores,scores$score==0) # get documents with only neutral scores
			scores.pos<-subset(scores,scores$score>=1) # get documents with only positive scores
			scores.neg<-subset(scores,scores$score<=-1) # get documents with only negative scores
			scores.verypos<-subset(scores,scores$score>=2) # get documents with only very positive scores
			scores.veryneg<-subset(scores,scores$score<=-2) # get documents with only very negative scores


		# Export data

			write.csv(scores,file = "SentimentScores1.csv")
			write.csv(scores.neutral,file = "SentimentScores_Neutral1.csv")
			write.csv(scores.pos,file = "SentimentScores_Positive1.csv")
			write.csv(scores.neg,file = "SentimentScores_Negative1.csv")
			write.csv(scores.verypos,file = "SentimentScores_VeryPositive1.csv")
			write.csv(scores.veryneg,file = "SentimentScores_VeryNegative1.csv")

}


### -  -  -  End Breen Sentiment Analysis  -  -  -  

