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

- keywork
	- page view 3페이지부터 봐야함


- ButtonBarPagerTabStripViewController: 실제 사용자에게 상속받아서 사용하는녀석 
- BarPagerTabStripViewController:



----

## Other Article 

- 나중에 도움될듯 Paging ViewController :https://github.com/Stackberry/Parallax-Container-View-Controller/blob/master/Parallax%20Container%20View%20Controller/View%20Controllers/ParallaxContainerViewController.swift

- CollectionView Card layout: https://github.com/qhlonger/DribbbleInvisionParallax
- CollectionView Parallax 나중에 유용할듯?: https://github.com/KhrystynaShevchuk/StretchHeaderWithCollectionViewFlowLayout
- 초기화면 만들때 유용함
	- https://github.com/WenchaoD/FSPagerView

	
---


## open source 개발 


- 사용 방법 


- 사용할 ViewControllers 설정
- Custom 할수 있는곳 
	- 상단 뷰 
	- 슬라이더 뷰 
- Delegate 재공
	- Header height 선택하게 제공 
	- 슬라이더 뷰 Height 제공  


- 사용자에게 제공되는것 
	- HeaderView Height 
	- 만약 ChildVC에 테이블뷰 or 컬렉션뷰가 있을때 VC 핸들러 
	- menuView Height 
	- menuView 이름 or 이미지 가능유무, 선택된 메뉴 색상 수정 

- 중요한것 
	- ChildVC와 scroll sync 
	- menuBar와 ContainerView, headerView의 sync..

- 개발 포인트
	- 각 VC.V를 컨테이너 스크롤뷰 안에 넣음. 이때 VC.V의 프레임을 결정하여 ScrollView에 추가. 그리고 ScrollView의 사이즈 결정. 

	
---

내일 보면 좋은것 

- https://github.com/fortmarek/SwipeViewController/blob/master/Example/SwipeViewController/ViewController.swift 
	- scrollView가 조금 간단해보임. 코드확인요망
- https://github.com/emalyak/EMPageViewController
	- 스크롤뷰 페이징 

음.. 아니면 스크롤뷰 페이징 먼저 하고 -> 그다음에 연결하는걸 만들어볼까..? 

- https://github.com/ladmini/LZViewPager: 코드가 짧은
- https://github.com/uias/Tabman/tree/master/Sources/Tabman/TabmanBar: 유명함..

- 코드가 짧은 
	- https://github.com/PageMenu/PageMenu
		- 이것도 코드 나름 깔끔함..
	- https://github.com/EndouMari/TabPageViewController
		- 코드가 진짜 깔끔..
	- https://github.com/paoloboschini/PBPagerViewController/tree/master/PBPagerViewController
		- 가장 쉽게 만든듯?
	- https://github.com/spring-media/LazyPages
		- Swift 2 지원 ㅠㅠ 
	- https://github.com/duylinh158/DLPageMenu
	- 

---

간단한 CollectionView Layout 

https://github.com/damienromito/CollectionViewCustom


---

## idea 

- UIPageViewController의 실행 순서를 아이디어로 삼자. 

### 2018.9.5 

1. 초기에 childViewController묶음을 가지고있음. 
2. setViewController같이 시작할때 보여지는 visible 영역을 Index에 따라서 정의하자 
3. 필요한것 
	- 현재 Index 추적 
	- Next Index / PrevIndex 
	- 터치 시작 -> next 인지 or Prev 인지 결정 -> setViewController 처럼 next visible 과 동시에 prev invisible

- 위를 완료한 다음에
	- TabCollectionView & ContentsScrollView & HeaderView Sync 
	- Delegate & DataSource 


	

