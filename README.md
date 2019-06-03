
# Natural Language Processing with R

Luiz Felipe de Almeida Brito 03/06/2019

## Natural language processing - Text Mining with R

### Techniques covered in this script:

  - Sentiment Analysis
  - Frequancy: tf-idf
  - Tokenizing
  - Stemmer
  - Wordclouds

### What is the main objective? What am I trying to infer?

This dataset consists of reviews of fine foods from amazon. This allowed
us to analyze which words are used most frequenlty in reviews.
Furthermore, we can use the tools of text mining to approach the
emotional content of text programmatically to infer whether a review is
positive or negative, or perhaps characterized by some other more
nuanced emotional content like surprise or disgust.

### Data Set Information:

Amazon Fine Food Reviews The data span a period of more than 10 years.
Analyze \~500,000 food reviews from Amazon
<https://www.kaggle.com/snap/amazon-fine-food-reviews/downloads/amazon-fine-food-reviews.zip/2>

### 1º Step - Clear Workspace

### 2º Step - Clear console

### 3º Step - The packages below must be installed. Once installed, you can comment this chunk code.
  - dplyr: A Grammar of Data Manipulation
  - ggplot2: Create Elegant Data Visualisations Using the Grammar of
    Graphics
  - tidytext: Text Mining using ‘dplyr’, ‘ggplot2’, and Other Tidy Tools
  - stringr: Simple, Consistent Wrappers for Common String Operations
  - tidyr: Easily Tidy Data with ‘spread()’ and ‘gather()’ Functions
  - wordcloud: Words Clouds
  - reshape2: Flexibly Reshape Data: A Reboot of the Reshape Package
  - hunspell: High-Performace Stemmer, Tokenizer, and Spell Checker
  - SnowballC: Stemmer based on the C ‘libstemmer’ UTF-8 Library
  - xtable: Export Tables to LaTeX or HTML
  - knitr: A Genaral-Purpose Package for Dynamic Report Generation in R
  - kableExtra: Construct Complex Table with ‘kable’ and Pipe Syntax

### 4º Step - Load libraries.

### 5º Step - Set up my work directory.

### 6º Step - Reading my database.

### 7º Step - Only 2 attributes are used. Renaming columns in order to make our exploratory analysis easier.

1.  IdRow (Id)
2.  ProductId (Unique identifier for the product)
3.  UserId (Unqiue identifier for the user)
4.  ProfileName (Profile name of the user)
5.  HelpfulnessNumerator (Number of users who found the review helpful)
6.  HelpfulnessDenominator (Number of users who indicated whether they
    found the review helpful or not)
7.  ScoreRating (between 1 and 5)
8.  TimeTimestamp (for the review)
9.  SummaryBrief (summary of the review)
10. Text (Text of the review)

### 8º Step - Preprocessing Text
Sometimes, we have some structure and extra text that we do not want to
include in our analysis. 

Every raw text dataset will require different steps for data cleaning,
which will often involve some trial and error, and exploration on
unusual cases in the dataset. 

### 9º Step - Tokenization - We need to both break the text into individual tokens.
Token is a meaningful unit of text, most often a word, that we are
interested in using for further analysis, and tokenization is the
process of splitting text into tokens.

### 10º Step - Stemming Words - After tokenization, we need to analyze each word by breaking it down in it’s root (stemming) and conjugation affix.
We have split each row so that there is one token (word) in each row of
the new data frame. 

Punctuation has been stripped. The words were converted to lowercase,
which makes them easier to compare or combine with other datasets. 

### 11º Step - Stop Words - Often in text analysis, we will want to remove stop words, which are words that are not useful for an analysis, typically extremely common words such as “the”, “of”, “to”, and so forth in English.

### 12º Step - We can find the most common words in all the reviews as a whole and create a visualization of the most common words.

### 13º Step - Sentiment Analysis - We can use the tools of text mining to approach the emotional content of text programmatically.
One way to analyze the sentiment of a text is to consider the text as a
combination of its individual word, and the sentiment content of the
whole text as the sum of the sentiment content of the individual words.

### 14º Step - Most Common Positive and Negative Words. Now we can analyze word count that contribute to each sentiment.

### 15º Step - Words with the greast contributions to positive/negative sentiment scores in the Review.

### 16º Step - Word Clouds

### 17º Step - tf-idf - The statistic tf-idf is intended to mesure how important a word is to a document in a collection (corpus) of documents.
Term Frequency (tf) It is one measure of how important a word may be and
how frenquently a word occurs in a document. Inverse Document Frequency
(idf) It decreases the weight for commonly used words and increases the
weight for words that are not used very much in a collection of
documents. Calculating tf-idf attemps to find the words that are
importantin a text, but not too common.
