library(twitteR)
library(tm)
library(wordcloud)
library(dplyr)
library(tidytext)

key<-'XXXX'
secret<-'XXXX'
access_token <- 'XXXX'
access_secret <- 'XXX'

setup_twitter_oauth(key,secret,access_token,access_secret)

get_tweets <- searchTwitter("",
                            n=1000,
                            lang="en",
                            since = toString(Sys.Date()),
                            geocode = '57.224,-4.493,250km') %>%  
  sapply(function(x) x$getText()) %>%
  iconv(to = "utf-8")

tweets <- (get_tweets[!is.na(get_tweets)])

tweetframe<-as.data.frame(tweets,stringsAsFactors=FALSE)%>%
  mutate(tweetnumber=row_number())

wordfile<-tweetframe%>%
  unnest_tokens("word","tweets")%>%
  filter(!word %in% c(stop_words$word,
                      "rt",
                      "fuck",
                      "https",
                      "t.co"))


png("wordcloud.png",
    width=640,
    height=640)

wordcloud(wordfile$word,
          max.words = 100,
          random.order = TRUE,
          control = list(removePunctuation = TRUE),
          colors=brewer.pal(8,"Dark2")
)

dev.off()

tweet("What were people in Scotland tweeting about today?",
      mediaPath = "wordcloud.png")
  
  
