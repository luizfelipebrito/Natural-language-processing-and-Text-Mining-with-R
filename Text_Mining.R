#http://rpubs.com/LuizFelipeBrito/NLP_Text_Mining_001
# -----------------------------------------------------------------------------------
# 1º Step - Clear Workspace
# -----------------------------------------------------------------------------------
rm(list = ls())   

# -----------------------------------------------------------------------------------
# 2º Step - Clear console
# -----------------------------------------------------------------------------------
cat("\014")      

# -----------------------------------------------------------------------------------
# 3º Step - The packages below must be installed.
#           Once installed, you can comment this chunk code.
# -----------------------------------------------------------------------------------
#install.packages("dplyr")           # A Grammar of Data Manipulation
#install.packages("ggplot2")         # Create Elegant Data Visualisations Using the Grammar of Graphics
#install.packages("tidytext")        # Text Mining using 'dplyr', 'ggplot2', and Other Tidy Tools
#install.packages("stringr")         # Simple, Consistent Wrappers for Common String Operations
#install.packages("tidyr")           # Easily Tidy Data with 'spread()' and 'gather()' Functions
#install.packages("wordcloud")       # Words Clouds
#install.packages("reshape2")        # Flexibly Reshape Data: A Reboot of the Reshape Package
#install.packages("hunspell")        # High-Performace Stemmer, Tokenizer, and Spell Checker
#install.packages("SnowballC")       # Stemmer based on the C 'libstemmer' UTF-8 Library

# -----------------------------------------------------------------------------------
# 4º Step - Load libraries.
# -----------------------------------------------------------------------------------
library(dplyr)           # A Grammar of Data Manipulation
library(ggplot2)         # Create Elegant Data Visualisations Using the Grammar of Graphics
library(tidytext)        # Text Mining using 'dplyr', 'ggplot2', and Other Tidy Tools
library(stringr)         # Simple, Consistent Wrappers for Common String Operations
library(tidyr)           # Easily Tidy Data with 'spread()' and 'gather()' Functions
library(wordcloud)       # Words Clouds
library(reshape2)        # Flexibly Reshape Data: A Reboot of the Reshape Package
library(hunspell)        # High-Performace Stemmer, Tokenizer, and Spell Checker
library(SnowballC)       # Stemmer based on the C 'libstemmer' UTF-8 Library

# -----------------------------------------------------------------------------------
# 5º Step - Set up my work directory.
# -----------------------------------------------------------------------------------
setwd("D:\\Text_Mining")

# -----------------------------------------------------------------------------------
# 6º Step - Reading my database.
# -----------------------------------------------------------------------------------
raw_text <- read.csv("Reviews.csv", header = TRUE)

# -----------------------------------------------------------------------------------
# 7º Step - Only 2 attributes are used.
#           Renaming columns in order to make our exploratory analysis easier.
# -----------------------------------------------------------------------------------
#1.  #IdRow 		             (Id)
#2.  #ProductId         	   (Unique identifier for the product)
#3.  #UserId                 (Unqiue identifier for the user) 
#4.  #ProfileName            (Profile name of the user) 
#5.  #HelpfulnessNumerator   (Number of users who found the review helpful) 
#6.  #HelpfulnessDenominator (Number of users who indicated whether they found the review helpful or not) 
#7.  #ScoreRating            (between 1 and 5) 
#8.  #TimeTimestamp          (for the review) 
#9.  #SummaryBrief           (summary of the review) 
#10. #Text                   (Text of the review)

names(raw_text)[names(raw_text) == "Id"]      <- "id_review"
names(raw_text)[names(raw_text) == "Summary"] <- "summary_review"
names(raw_text)[names(raw_text) == "Text"]    <- "text_review"

raw_text <- raw_text %>% select(id_review, summary_review, text_review)

# -----------------------------------------------------------------------------------
# 8º Step - Preprocessing Text
#           Sometimes, we have some structure and extra text that we do not want to
#           include in our analysis. Every raw text dataset will require different
#           steps for data cleaning, which will often involve some trial and error,
#           and exploration on unusual cases in the dataset.
# -----------------------------------------------------------------------------------
cleaned_text <- raw_text %>%
  filter(str_detect(text_review, "^[^>]+[A-Za-z\\d]") | text_review !="") 

cleaned_text$text_review <- gsub("[_]", "", cleaned_text$text_review)
cleaned_text$text_review <- gsub("<br />", "", cleaned_text$text_review)

# -----------------------------------------------------------------------------------
# 9º Step -  Tokenization - We need to both break the text into individual tokens.
#             and transform it to a tidy data structure.
#             Token is a meaningful unit of text, most often a word, that we are 
#             interested in using for further analysis, and tokenization is the 
#             process of splitting text into tokens.
# -----------------------------------------------------------------------------------
text_df <- tibble(id_review = cleaned_text$id_review , text_review = cleaned_text$text_review)

text_df <- text_df %>%  unnest_tokens(word, text_review)

# -----------------------------------------------------------------------------------
# 10º Step - Stemming Words - After tokenization, we need to analyze each word by 
#            breaking it down in it's root (stemming) and conjugation affix.
#            We have split each row so that there is one token (word) in each row of 
#            the new data frame. 
#            Punctuation has been stripped.
#            The words were converted to lowercase, which makes them easier to 
#            compare or combine with other datasets.
# -----------------------------------------------------------------------------------
#View(getStemLanguages())

text_df$word <- wordStem(text_df$word,  language = "english")

View(table(text_df$word))

# -----------------------------------------------------------------------------------
# 11º Step - Stop Words - Often in text analysis, we will want to remove stop words, 
#            which are words that are not useful for an analysis, typically extremely
#            common words such as "the", "of", "to", and so forth in English.         
# -----------------------------------------------------------------------------------
data(stop_words)

text_df <- text_df %>% 
  anti_join(stop_words, "word")

# -----------------------------------------------------------------------------------
# 12º Step - We can find the most common words in all the reviews as a whole and 
#            create a visualization of the most common words.
# -----------------------------------------------------------------------------------
View(text_df %>% 
       count(word, sort = TRUE))

png('plot_01_word_count.png')

text_df %>% 
  count(word, sort = TRUE) %>% 
  filter(n > 3000) %>% 
  mutate(word = reorder(word, n)) %>% 
  ggplot(aes(word, n)) + 
  geom_col() + 
  xlab(NULL) + 
  coord_flip()

dev.off()                # But this will clear your plot history.

# -----------------------------------------------------------------------------------
# 13º Step - Sentiment Analysis - We can use the tools of text mining to approach the
#            emotional content of text programmatically. One way to analyze the 
#            sentiment of a text is to consider the text as a combination of its 
#            individual word, and the sentiment content of the whole text as the sum
#            of the sentiment content of the individual words.
# -----------------------------------------------------------------------------------
Sentiment_Analysis <- text_df %>% 
  inner_join(get_sentiments("bing"), "word") %>% 
  count(id_review, sentiment) %>% 
  spread(sentiment, n, fill = 0) %>% 
  mutate(sentiment = positive - negative)

head(View(Sentiment_Analysis))

# -----------------------------------------------------------------------------------
# 14º Step - Most Common Positive and Negative Words.
#            Now we can analyze word count that contribute to each sentiment.
# -----------------------------------------------------------------------------------
Sentiment_Analysis_Word_Count <- text_df %>% 
  inner_join(get_sentiments("bing"), "word") %>% 
  count(word, sentiment, sort = TRUE) %>% 
  ungroup()

png('plot_02_word_count.png')

Sentiment_Analysis_Word_Count %>% 
  group_by(sentiment) %>% 
  top_n(12, n) %>%
  ungroup() %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n, fill = sentiment)) + 
  geom_col(show.legend = FALSE) + 
  facet_wrap(~sentiment, scales = "free_y") + 
  labs(y = "Contribution to Sentiment", x = NULL) + 
  coord_flip()

dev.off()                # But this will clear your plot history.

# -----------------------------------------------------------------------------------
# 15º Step - Words with the greast contributions to positive/negative sentiment
#            scores in the Review.
# -----------------------------------------------------------------------------------
Sentiment_Analysis_Word_Contribution <- text_df %>% 
  inner_join(get_sentiments("afinn"), by = "word") %>% 
  group_by(word) %>% 
  summarize(occurences = n(), contribution = sum(score))

png('plot_03_word_contribution.png')

Sentiment_Analysis_Word_Contribution %>% 
  top_n(50, abs(contribution)) %>%
  mutate(word = reorder(word, contribution)) %>%
  ggplot(aes(word, contribution, fill = contribution > 0)) + 
  geom_col(show.legend = FALSE) + 
  coord_flip()

dev.off()                # But this will clear your plot history.

# -----------------------------------------------------------------------------------
# 16º Step - Word Clouds
# -----------------------------------------------------------------------------------
png('plot_04_word_cloud.png')

text_df %>% 
  anti_join(stop_words, "word") %>%
  count(word) %>% 
  with(wordcloud(word, n, max.words = 100))

dev.off()                # But this will clear your plot history.

png('plot_05_word_cloud.png')

text_df %>% 
  inner_join(get_sentiments("bing"), "word") %>%
  count(word, sentiment, sort = TRUE) %>% 
  acast(word ~ sentiment, value.var = "n", fill = 0) %>% 
  comparison.cloud(colors = c("gray20", "gray80"), max.words = 100)

dev.off()                # But this will clear your plot history.

# -----------------------------------------------------------------------------------
# 17º Step - tf-idf - The statistic tf-idf is intended to mesure how important a word
#            is to a document in a collection (corpus) of documents .
#            Term Frequency (tf) It is one measure of how important a word may be and           
#            how frenquently a word occurs in a document.
#            Inverse Document Frequency (idf) It decreases the weight for commonly 
#            used words and increases the weight for words that are not used very 
#            much in a collection of documents.
#            Calculating tf-idf attemps to find the words that are important
#            in a text, but not too common.
# -----------------------------------------------------------------------------------
term_frequency_review <- text_df %>% count(word, sort = TRUE)

term_frequency_review$total_words <- as.numeric(term_frequency_review %>% summarize(total = sum(n)))

term_frequency_review$document <- as.character("Review")

term_frequency_review <- term_frequency_review %>% 
  bind_tf_idf(word, document, n)

png('plot_06_tf_idf.png')

term_frequency_review %>% 
  arrange(desc(tf)) %>% 
  mutate(word = factor(word, levels = rev(unique(word)))) %>% 
  group_by(document) %>% 
  top_n(15, tf) %>% 
  ungroup() %>% 
  ggplot(aes(word, tf, fill = document)) + 
  geom_col(show.legend = FALSE) + 
  labs(x = NULL, y = "tf-idf") + 
  facet_wrap(~document, ncol = 2, scales = "free") + 
  coord_flip()

dev.off()                # But this will clear your plot history.

