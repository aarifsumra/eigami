# eigami


[![codecov](https://codecov.io/gh/aarifsumra/eigami/branch/develop/graph/badge.svg)](https://codecov.io/gh/aarifsumra/eigami)

eigami(映画見) is a simple movie database application that harnesses the power of TMDbApi to display search results from over 28,000 entries.

for API Go To -> https://developers.themoviedb.org/3/getting-started/introduction

It may seem simple on the surface, but this app uses some of the most cutting edge frameworks in iOS development today. Things like RxSwift, Alamofire, and Kingfisher...just to name a few.

### Installation:
1. Download the zip file.
2. Navigate to the folder in Terminal
3. Run `carthage bootstrap --platform iOS`
4. Run the app

### How to use:
1. Search for a movie
2. Tap on a movie poster to learn more about the film
(It's just that easy!)

### Ways to make it better:
(you can add your ideas here)


### 日本語
eigami(映画見)は、28,000以上項目入力のデータベースから検索結果を表示するTheMovieDBのAPIを利用する簡単な映画データベースアプリケーションである。

TMDb開発用設計書リンク－>https://developers.themoviedb.org/3/getting-started/introduction

それは表面で簡単であるようであるかもしれないけれども、
このアプリは、RxSwift, RxMoya, Alamofire, Kingfisherなどを利用してあります。

インストール：
- zipファイルをダウンロード。
- Terminalでのフォルダに移動して`carthage bootstrap --platform iOS`
- アプリをビルドして起動してください

使い方:
検索バーに映画の名前を入力する
検索結果の映画ポスターをタップすると映画の詳しいを見える


TODO:
- Swift genericを利用して映画ではなく別のpaginatedデータも連携できるように
- API 4 を利用してユーザーをログインと映画をwatchlistに追加できるように
