install.packages('httr') #data를 GET하기 위한 패키지 설치
install.packages('jsonlite') #json 형식의 데이터 전처리를 위한 패키지
install.packages('tidyverse')
install.packages('dplyr')
install.packages("magrittr")
install.packages("data.table")

library(data.table)
library("openxlsx")
library(magrittr)
library(httr)
library(jsonlite)
library(tidyverse)
library(dplyr)

##발급받은 API키 정보
##https://www.data.go.kr/data/15000802/openapi.do
key="여기에 발급받은 API키 넣으세요"

#최종적으로 표가 담길 데이터프레임
result_df<-data.frame()
result_df=rbind(result_df,c("","","",""))
names(result_df)=c('게시일자', '공고명', '수요기관', '공고URL')

#페이지 데이터를 가져오는 함수정의
#입력 범위값 초과 에러로 인해 22년, 23년(전날까지)로 분할
getPage_df_22<-function(keyword, page){
  bidNtceNm<-URLencode(keyword)
  url <- paste0("https://apis.data.go.kr/1230000/BidPublicInfoService03/getBidPblancListInfoThngPPSSrch?serviceKey=", 
                key, 
                "&numOfRows=10&pageNo=", page,
                "&inqryDiv=1&inqryBgnDt=202201010000&inqryEndDt=202212312359&bidNtceNm=",
                bidNtceNm,
                "&bidClseExcpYn=N&intrntnlDivCd=1&type=json")
  
  res<-GET(url=url)
  res %>%
    content(as='text', encoding='UTF-8') %>% 
    fromJSON()->title
  
  df<-as.data.frame(lapply(title, function(title) if(is.character(title)|is.factor(title))stri_replace_all_regex(title, ",", "") else(title)))
  df<-df[,c("response.body.items.bidNtceDt", "response.body.items.bidNtceNm", "response.body.items.ntceInsttNm", "response.body.items.bidNtceDtlUrl")]
  colnames(df)<-c('게시일자', '공고명', '수요기관', '공고URL')
  
  result_df<<-rbindlist(list(result_df, df), use.names = TRUE)
}
getPage_df_23<-function(keyword, page){
  bidNtceNm<-URLencode(keyword)
  url <- paste0("https://apis.data.go.kr/1230000/BidPublicInfoService03/getBidPblancListInfoThngPPSSrch?serviceKey=", 
                key, 
                "&numOfRows=10&pageNo=", page,
                "&inqryDiv=1&inqryBgnDt=202301010000&inqryEndDt=",
                as.numeric(gsub("-", "", Sys.Date()))-1,
                "2359&bidNtceNm=",
                bidNtceNm,
                "&bidClseExcpYn=N&intrntnlDivCd=1&type=json")
  
  #json 포멧 읽어오기
  res<-GET(url=url)
  res %>%
    content(as='text', encoding='UTF-8') %>% 
    fromJSON()->title
  
  df<-as.data.frame(lapply(title, function(title) if(is.character(title)|is.factor(title))stri_replace_all_regex(title, ",", "") else(title)))
  df<-df[,c("response.body.items.bidNtceDt", "response.body.items.bidNtceNm", "response.body.items.ntceInsttNm", "response.body.items.bidNtceDtlUrl")]
  colnames(df)<-c('게시일자', '공고명', '수요기관', '공고URL')
  
  result_df<<-rbindlist(list(result_df, df), use.names = TRUE)
}

#설정된 범위 페이지 까지 데이터 프레임에 담는 반복문
#에러문구 출력시 콘솔에 esc로 넘어가기
for (i in 1:100) {
  tryCatch({
    getPage_df_22("인공지능", i)
  }, error = function(err) {
    print(paste(i,": ",err))
  })
  print(paste(i,": 진행 완료"))
}

#setDTthreads(8)

#완성된 데이터프레임 엑셀 추출
write.xlsx(result_df, "인공지능키워드공고22.xlsx")
