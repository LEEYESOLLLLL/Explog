## _EXPLOG

EXPLOG in Code Version 

---

## developing Time line 

1. 해야할것 
2. 완료한것 
3. 다음날 해야할것 


### 2018.8.30

### 해야하는 것 

1. MainFeedView 
	- Parallax 적용 
	- CollectionView 내부에 TableView 적용 

2. MainFeedView 상/하 스크롤 & 스크롤 싱크 계산 

3. Parallax 적용 

### 2018.8.31 


1. MainFeedView 
	- Parallax 적용
	- CollectionView 내부에 TableView 적용 

2. MainFeedView 적용시 문제점 확인
	- MainFeedView의 CollectionView Cell 에 있는 TableView를 다룰때. Parallax 적용시 문제점 발생. 각 CollectionView Cell의 ContentsOffest이 싱크하게 움직여야하는데, 싱크하게 움직이지도 않을뿐더라, 오프셋적용이 이상하게됨

3. MainFeedView 다시 개발해야함. 
	- Open Source 그냥 자체제작하자
		- Pageing Scroll ViewController 
		- TableView & CollectionView parallax 
	- 내일 검색 키워드 Multiple Parallax, Paginig ViewController, Container ViewController ...
	- 여러개의 테이블뷰를 다룰때 Parallax시 여러개의 TableView의 ScrollView Offset이 싱크하게 조절하는 방법 찾아야함..

내일 분석해야할것 찾음

- https://github.com/ngominhtrint/ParallaxHeader
- https://github.com/xxxAIRINxxx/ViewPagerController

- Container ViewController 추상화 방법 한번 참조하면 좋을것 같음: https://github.com/fortmarek/SwipeViewController
- ViewControlelr Pager: https://github.com/hwj4477/ViewControllerPager
- TabBarViewController: https://github.com/uias/Tabman
	- 잘만든것같음








----

## Other Article 

- 나중에 도움될듯 Paging ViewController :https://github.com/Stackberry/Parallax-Container-View-Controller/blob/master/Parallax%20Container%20View%20Controller/View%20Controllers/ParallaxContainerViewController.swift

- CollectionView Card layout: https://github.com/qhlonger/DribbbleInvisionParallax
- CollectionView Parallax 나중에 유용할듯?: https://github.com/KhrystynaShevchuk/StretchHeaderWithCollectionViewFlowLayout
- 초기화면 만들때 유용함
	- https://github.com/WenchaoD/FSPagerView