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
	- https://github.com/EndouMari/TabPageViewController
	- https://github.com/paoloboschini/PBPagerViewController/tree/master/PBPagerViewController
		- 가장 쉽게 만든듯?
	- https://github.com/spring-media/LazyPages
	- https://github.com/duylinh158/DLPageMenu

---

간단한 CollectionView Layout 

https://github.com/damienromito/CollectionViewCustom


---

## Container ViewContoller 개발시 필요한것들 

[https://developer.apple.com/documentation/uikit/uiviewcontroller](https://developer.apple.com/documentation/uikit/uiviewcontroller)<br>

UIKit app을 위한 뷰계층구조를 관리하는 하나의 객체이다.

## Overrive 

UIViewController 클레스는 모든 뷰 콘트롤러들에 대한 공유된 행동을 정의합니다. UIViewCOntroller 클레스를 직접적으로 생성하는것은 드뭅니다. 대신 UIViewController를 서브 클레싱 하고, 매소드를 추가하고 ViewController의 뷰 계층에 관리하려고하는 속소들을 추가합니다. 

다음은 뷰컨트롤러의 주요한 행동들입니다. 

- 뷰의 콘텐츠, 데이터 변경에 기초하여 변하는 응답을 `업데이트합니다.`
- 뷰의 유저인터렉션에 응답합니다
- 뷰의 사이즈 재설정, 전체 인터페이스 레이아웃의 관리
- 앱에서 다른 뷰컨트롤러를 포함하고, 다른객체를 조정합니다

뷰 컨트롤러는 매니지되는 뷰와 붙어있고 뷰 계층의 이벤트들의 처리 부분을 취합니다. 명확하게 뷰 컨트롤러는 UIResponder 객체이고 `뷰컨트롤러의 루트뷰와 뷰의 슈퍼뷰` 사이의 응답체인을 추가하고, 전형적으로 다른 뷰 컨트롤러에 속합니다. 뷰컨트롤러의 뷰가 없을때 이벤트를 핸들하려면, 뷰 컨트롤러는 이벤트 처리 또는 슈퍼뷰에 그것을 보내는 선택을 할수 있습니다. 

뷰 컨트롤러는 드물게 격리되어 사용됩니다. 대신 종종 여러개의 뷰컨트롤러들을 사용하고, 앱의 유저인터페이스의 부분으로도 사용됩니다. 예를 들면 하나의 뷰컨트롤러는 다른 뷰컨트롤러에서 테이블에서 선택된 아이템이 표시되는 동안 아이템의 하나의 테이블을 표시할수 있습니다. 보통, 하나의 뷰컨트롤러에서 뷰들은 동시에 보여집니다. 하나의 뷰컨트롤러는 다른 뷰컨트롤러의 새롭개 구성된 뷰들을 표시할수 있고, 다른뷰컨트롤러의 컨텐츠를 위한 하나의 컨테이너로 행동할수 있고, 원한다면 뷰들을 애니메이션화 할수 있습니다.

## Subclassing Notes 

모든 앱은 최소한 한개의 UIViewController를 서브클래싱한 사용자화한 뷰 컨트롤러를 포함합니다. 좀더 종종 앱은 많은 사용자화된 뷰 컨트롤러들을 포함합니다. 커스텀 뷰컨트롤러는 앱의 전체행동, 앱의 외형을 포함하고 어떻게 유저에 응답할지를 정의합니다. 다음 색션을 사용자화 하는 서브클레싱 행동 의 내용을 포함합니다. 더 자세히 알고 싶다면 View Controller Programming Guide for iOS 를 참조해주세요

## View Managemnet 

각 뷰컨트롤러는 뷰 계층, 해당 클레스의 뷰 속성에 저장된 루트 뷰를 관리 합니다. 이 루트 뷰(The root view)는 뷰 계층의 중간 지점(?)을 포함하는 것을 첫번째 행동으로 합니다. 루트 뷰의 사이즈와 위치는 자신의 객체 또는 , 부모 뷰 컨트롤러 또는 앱의 윈도우에 의해서 결정됩니다. 윈도우(the window)에 의해서 소유되어진 뷰 컨트롤러는 앱의 루트 뷰 컨트롤러 이고 해당 뷰 컨트롤러의 뷰는 윈도우에 채워집니다. 

뷰 컨트롤러는 자신의 뷰들을 게으르게 로드합니다. 첫번째 로드 시간동안 `view` 속성에 접근하고 뷰 컨트롤러의 뷰로 생성합니다. 뷰 컨트롤러를 위한 뷰를 명시하는 몇개의 방법이 있습니다. 

- 앱의 스토리보드에서 뷰 컨트롤러와 해당 뷰컨트롤러의 뷰를 명시합니다. 스토리 보드는보기를 지정하는 기본 방법입니다. 스토리 보드를 사용하여보기 컨트롤러에 대한보기 및 해당 연결을 지정합니다. 또한 뷰 컨트롤러 사이의 관계와 연결을 지정하면 앱의 동작을보고 수정하기가 더 쉽습니다
	- 스토리 보드에서보기 컨트롤러를로드하려면 해당 객체 의 메소드를 호출하십시오. 스토리 보드 객체는 뷰 컨트롤러를 생성하여 코드에 반환합니다. `instantiateViewController(withIdentifier:) `
- Nib 파일을 사용하여 뷰 컨트롤러에 대한 뷰를 지정하세요. nib 파일을 사용하면 단일 뷰 컨트롤러의 뷰를 정의할수 있지만, 뷰 컨트롤러 사이의 방향 또는 관계를 정의할수 없습니다. nib 파일은 뷰 컨트롤러 자체에 대한 최소한의 정보만 저장합니다 
	- nib 파일을 사용하여 뷰 컨트롤러 개체를 초기화하려면 뷰 컨트롤러 클래스를 프로그래밍 방식으로 만들고이 메서드를 사용하여 초기화하십시오 . 뷰가 요청되면 뷰 컨트롤러는 nib 파일에서 뷰를 로드합니다. `init(nibName:bundle:)`
- `loadView()`매소드를 뷰컨트롤러의 뷰를 명시합니다. 이 메소드에서 프로그래밍적으로 뷰 계층구조를 생성하고 해당 `계층 루트 뷰`를 뷰 컨트롤러의 속성에 할당합니다. 

이러한 모든 기법은 적절한 결과 집합을 만들어 해당 뷰 집합을 만들어 view 속성을 통해 노출합니다

> Important: 뷰 컨트롤러는 해당 뷰 컨트롤러 뷰의 단일한 소유자 이고, 생성한 어떤 서브뷰 입니다. 뷰 컨트롤러 자체가 해제 될 때와 같이 해당 뷰를 생성하고 해당 뷰의 소유권을 포기하는 책임이 있습니다. stoyboard 또는 nib파일을 사용하여 뷰 객체를 사용한다면, 뷰 컨트롤러가 그들에게 요청할때 각 뷰 컨트롤러 객체는 자동으로 그들 자체의 뷰들의 복사본을 얻습니다. 하지만 뷰들을 수동으로 생성한다면 각 뷰컨트롤러는 그들 자체의 유니크한 뷰들의 세팅을 가져야합니다. 뷰컨트롤러들 사이의 뷰들을 공유할수 없습니다. 

뷰 컨트롤러의 루트보기는 항상 할당 된 공간에 맞게 크기가 조정됩니다. 뷰 계층 구조의 다른 뷰의 경우 인터페이스 빌더를 사용하여 각 뷰가 수퍼 뷰의 범위 내에서 배치되고 크기가 조정되는 방식을 제어하는 ​​자동 레이아웃 제한 조건을 지정하십시오. 또한 제약 조건을 프로그래밍 방식으로 생성하고 적절한 시간에보기에 추가 할 수 있습니다. 제약 조건을 만드는 방법에 대한 자세한 내용은 Autolayout guide를 참조하십시오.

## Handling View-Related Notifications

뷰 컨트롤러의 뷰들변경이 보여질때, 각 뷰 컨트롤러는 자동으로 그들 자신의 매소드를 호출합니다. 서브클래싱들은 변경에 응답할수 있습니다. `viewWillAppear(_:)` 같은 매소드를 사용하는것은 스크린에 출현하기 이전에 뷰를 준비합니다. `viewWillDisappear(_:)` 매소드를 사용하는것은 변경 또는 다른 상태의 정보를 저장합니다. 

도표1은 뷰 컨트롤러의 뷰에대한 보여지는것이 가능한 상태 와 발생할수 있는 상태전환을 보여줍니다. 모든 `will` 콜백 메소드가 `did` 콜백 메소드와 쌍을 이루는것은 아닙니다. `will` 콜백 메소드로 프로세스를 시작하면 해당 `did`와 반대 `will`콜백 메소드 모두에서 프로세스를 종료해야합니다.

<center><img src="/img/posts/UIViewController.png" width="500" height="350"></center> <br>

## Handling View Rotations 

## Implementing a Container View Controller 

사용자화 UIViewController 서브클래스는 또한 하나의 컨테이너 뷰 컨트롤러로 행동할수 있습니다. container view controller는 컨테이너 뷰컨트롤러 자신의 다른 뷰 컨트롤러의 컨텐츠의 표시를 관리하고, 또한 그것의 자식 뷰컨트롤러들을 알고 있습니다. 자식의 뷰는 그대로 또는 컨테이너 뷰 컨트롤러가 소유한 뷰와 함께 표시될수 있습니다. 

컨테이너 뷰컨트롤러 서브클레스는 자신의 자식들과 연관된 공동(public) 인터페이스를 정의해야합니다. 이러한 메소드의 특성은 사용자가 결정하며 작성중인 컨테이너의 의미에 따라 달라집니다. 한번에 뷰 컨트롤러(여기서는 컨테이너 뷰 컨트롤러에 대해서 얘기하는것 같음)에 의해서 얼마나 많은 자식들이 보여질지, 뷰 컨트롤러들의 자식들이 화면에 보여졌을때, 뷰 컨트롤러의 뷰 계층에 나타난곳을 결정해야 합니다. View Controlelr 클레스는 무엇과 관계되고, 어떤 것인지, 자식에 의해서 공유되어 지는것을 정의 해야합니다. 컨테이너에 대한 깨끗한 공용 인터페이스를 설정함으로써 컨테이너가 비헤이비어를 구현하는 방법에 대한 너무 많은 개인 정보에 액세스하지 않고도 자식이 기능을 논리적으로 사용하도록 할 수 있습니다.

ViewControllerProgrammingGuide_6.png



















