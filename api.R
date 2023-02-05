install.packages('httr') #data를 GET하기 위한 패키지 설치
install.packages('jsonlite') #json 형식의 데이터 전처리를 위한 패키지
install.packages('tidyverse')
install.packages('dplyr')
install.packages("magrittr")
install.packages("rjson")
install.packages("openxlsx")

library("openxlsx")
library(rjson)
library(magrittr)
library(httr)
library(jsonlite)
library(tidyverse)
library(dplyr)

##기본 API 정보
key="발급받은 API키"

#최종적으로 표가 담길 변수
result_df<-data.frame()
result_df=rbind(result_df,c("","","",""))
names(result_df)=c('게시일자', '공고명', '수요기관', '공고URL')

#1부터 200페이지 까지 데이터 프레임에 담는 반복문
for(i in 1:200){
  getPage_df("정보화",i)
}

getPage_df<-function(keyword, page){
  bidNtceNm<-URLencode(keyword)
  url <- paste0("https://apis.data.go.kr/1230000/BidPublicInfoService03/getBidPblancListInfoThngPPSSrch?serviceKey=", 
                key, 
                "&numOfRows=10&pageNo=", page,
                "&inqryDiv=1&inqryBgnDt=202201010000&inqryEndDt=202212312359&bidNtceNm=",
                bidNtceNm,
                "&bidClseExcpYn=N&intrntnlDivCd=1&type=json")
  
  #json 포멧 읽어오기
  res<-GET(url=url)
  res %>%
    content(as='text', encoding='UTF-8') %>% 
    fromJSON()->title
  
  df<-as.data.frame(lapply(title, function(title) if(is.character(title)|is.factor(title)) gsub(',', '', title) else(title)))
  df<-df[,c("response.body.items.bidNtceDt", "response.body.items.bidNtceNm", "response.body.items.ntceInsttNm", "response.body.items.bidNtceDtlUrl")]
  colnames(df)<-c('게시일자', '공고명', '수요기관', '공고URL')
  rm(title)
  
  result_df=rbind(result_df,df)
}
