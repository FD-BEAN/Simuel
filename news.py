# -*- coding: UTF-8 -*-
import requests as req
import re
from bs4 import BeautifulSoup
import json
from urllib.parse import quote
from time import strftime,time,localtime
from time import sleep
import pandas as pd
import os.path
# import lxml.html as lh

# def getTable(url):
# 	page = requests.get(url)
# 	doc = lh.fromstring(page.content)
# 	tr_elements = doc.xpath('//tr')
# 	print([len(T) for T in tr_elements[:]])

tr_elements = doc.xpath('//tr')
def procWeb(header,url):
	req_reply = req.get(url, headers = header)
	req_text = req_reply.text
	req_text = req_text.replace('\n','')
	req_text = req_text.replace('\t','')
	return req_text

def appendArticles(data,newsNum,header,url,library):
	text = procWeb(header,url)
	for element in re.findall(r'<article class="story ">(.*?)</article>',text,re.S):
		if any(keyword in element.upper() for keyword in library):
			data.append(element)
			newsNum += 1
			if newsNum > 1:
				break
	return newsNum, data

def filterArticles(data,header,url,library):
	idx = 2
	newsNum = 1
	newsNum, data = appendArticles(data,newsNum,header,url,library)
	while newsNum < 2: # change this constant to control how many news to fetch for each sector
		urlNew = url + '?view=page&page=' + str(idx) + '&pageSize=10'
		newsNum, data = appendArticles(data,newsNum,header,urlNew,library)
		idx += 1
	return data

def selectENurl(numUrl):
	urlAsian = 'https://www.reuters.com/news/archive/asia'
	urlUS = 'https://www.reuters.com/news/archive/usMktRpt'
	urlEur = 'https://www.reuters.com/news/archive/eurMktRpt'
	urlBond = 'https://www.reuters.com/news/archive/bondsNews'
	urlForex = 'https://www.reuters.com/news/archive/GCA-ForeignExchange'
	urlOil = 'https://www.reuters.com/news/archive/GCA-Commodities'
	urlGold = 'https://www.reuters.com/news/archive/goldMktRpt'
	url = [urlAsian,urlUS,urlEur,urlBond,urlForex,urlOil,urlGold]
	return url[numUrl]

def selectENlib(numLib):
	libAsian = ["COVID","VIRUS","COVID19","COVID-19","CORONA","CORONAVIRUS","PANDEMIC"]
	libUS = ["COVID","VIRUS","COVID19","COVID-19","CORONA","CORONAVIRUS","PANDEMIC"]
	libEur = ["COVID","VIRUS","COVID19","COVID-19","CORONA","CORONAVIRUS","PANDEMIC"]
	libBond = ["COVID","VIRUS","COVID19","COVID-19","CORONA","CORONAVIRUS","PANDEMIC"]
	libForex = ["COVID","VIRUS","COVID19","COVID-19","CORONA","CORONAVIRUS","PANDEMIC"]
	libOil = ["COVID","VIRUS","COVID19","COVID-19","CORONA","CORONAVIRUS","PANDEMIC"]
	libGold = ["COVID","VIRUS","COVID19","COVID-19","CORONA","CORONAVIRUS","PANDEMIC"]
	lib = [libAsian,libUS,libEur,libBond,libForex,libOil,libGold]
	return lib[numLib]


def createDocEN(data,daily_news_header,docTitle,newpath):
	dt = strftime("%Y-%m-%d-%H",localtime(time()))
	daily_news_body = '<HR>'.join(data)
	data = bytes(daily_news_body,'utf-8')
	soup = BeautifulSoup(data,'html5lib')
	news = soup.find_all(class_='story-content')

	title = list()
	content = list()
	link = list()
	for idx in range(0,len(news)):
		t = '*' + news[idx].find('a').get_text() + '*'
		c = news[idx].find('p').get_text()
		l = "https://www.reuters.com/" + news[idx].find('a')['href'] + '\n'
		title.append(t)
		content.append(c)
		link.append(l)
	df = pd.DataFrame(columns=['Asian','US','EU','Bond','Forex','Oil','Gold'], data=[title,content,link])
	df.to_csv(newpath + dt + docTitle + '.csv',index=False)

	daily_news_body = daily_news_body.replace('a href="/','a href="https://www.reuters.com/')
	daily_news_header = daily_news_header.replace('\n','')
	daily_news = daily_news_header.replace('CONTENT',daily_news_body)
	daily_news = daily_news.replace('DocTitle',docTitle)
	with open(newpath + dt + docTitle + ".html","w",encoding = "utf-8") as Html_file:
		Html_file.write(daily_news)


def main():
	print()
	print("Fetching News Articles...")
	print()
	data1 = list()
	data2 = list()
	header = {
			'Sec-Fetch-Mode': 'navigate',
			'Sec-Fetch-User': '?1',
			'Upgrade-Insecure-Requests': '1',
			'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko'
			}
	daily_news_header =  '''
	<!DOCTYPE html>
	<html>
	<head>
	<meta charset="utf-8">
	<title>Daily Abstract</title>
	<div align="center">
	<p><font size="30" color="black" align="center">DocTitle</font></p>
	</div>
	<HR style="border:3 double #987cb9" width="80%" color=#987cb9 SIZE=3>
	</head>
 
	<body>
	CONTENT
	</body>
 	
	</html>
	'''
	per = 16
	for idx in range(0,7):
		data1 = filterArticles(data1,header,selectENurl(idx),selectENlib(idx))
		for percent in range(0,6*(idx+2)):
			print("-",end = '')
		for percent in range(0,45-6*(idx+2)):
			print("*",end = '')
		print(" ",per,"%",end = "\r")
		per += 14
		# print()
	homedir = os.path.expanduser("~")
	newpath = str(homedir)+"/Desktop/newsArchive/"
	if not os.path.exists(newpath):
		os.makedirs(newpath)

	createDocEN(data1,daily_news_header,'Daily Abstract',newpath)

	print("\n\nFetching Completed! Files saved in Desktop/newsArchive folder.")
	print("Closing Program...")
	return

if __name__ == "__main__":
	main()



