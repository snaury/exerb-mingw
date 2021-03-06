=begin

$Id: inside.ja.rd,v 1.17 2003/11/01 17:24:27 yuya Exp $

= Inside Exerb

((*注意：このドキュメントは2.6.2をベースに記述されています。*))

* ((<1. 概要>))
* ((<2. 実行ファイルの構成要素>))
  * ((<2.1. コア>))
    * ((<"2.1.1. 1.6系/1.8系">))
    * ((<"2.1.2. CUI版/GUI版">))
    * ((<"2.1.3. mswin32版/mingw32版/cygwin版">))
    * ((<"2.1.4. スタンドアロン版/ランタイムライブラリ版">))
  * ((<2.2. アーカイブ>))
  * ((<2.3. アーカイブヘッダ>))
  * ((<2.4. 名前テーブル>))
  * ((<2.5. 名前ヘッダ>))
  * ((<2.6. エントリテーブル>))
  * ((<2.7. エントリヘッダ>))
* ((<3. 実行ファイルの生成過程>))
  * ((<3.1. アーカイブの生成>))
  * ((<3.2. アーカイブとコアのリンク>))
* ((<4. 実行ファイルの実行過程>))
  * ((<4.1. Windowsによる実行ファイルのロード>))
  * ((<4.2. Exerbランタイムコードの実行>))
    * ((<4.2.1. アーカイブのロードと展開>))
    * ((<4.2.2. 各種テーブルの構築>))
    * ((<4.2.3. スタートアップスクリプトの実行>))
* ((<5. ライブラリの読み込み過程>))
    * ((<5.1. Rubyスクリプトの読み込み過程>))
    * ((<5.2. bRubyバイナリコードの読み込み過程>))
    * ((<5.3. 拡張ライブラリの読み込み過程>))
      * ((<5.3.1. インポートライブラリの書き換え処理>))
      * ((<5.3.2. インポート関数の書き換え処理>))

== 1. 概要

Exrebの動作原理について詳しく解説します。

== 2. 実行ファイルの構成要素

Exerbで生成された実行ファイルは、アーカイブとコアによって構成されています。

* コア
* アーカイブ
  * アーカイブヘッダ
  * 名前テーブル
    * 名前ヘッダ
    * 名前プール
  * エントリテーブル
    * エントリヘッダ
    * エントリプール

アーカイブにはRubyスクリプトやbRubyバイナリコード、拡張ライブラリなどが含まれて
おり、コアにはRubyインタプリタとExerbランタイムコードが含まれています。

  +------------+
  |    コア    |
  +------------+
  |            |
  | アーカイブ |
  |            |
  +------------+

=== 2.1. コア

コアは通常の実行ファイルです。
拡張子をexeに変更すると実行することができます（アーカイブが見つからないという
エラーが表示される）。

コアはアーカイブと結合し、MS-DOSヘッダの一部を書き換えるだけで動作するように
なっています。

コアには、1.6系/1.8系、CUI版/GUI版、mswin32版/mingw32版/cygwin版、
スタンドアロン版/ランタイムライブラリ版などの種類があります。

==== 2.1.1. 1.6系/1.8系

コアには採用しているRubyのバージョンにより1.6系と1.8系があり、それぞれのRubyの
バージョンは下記の通りです。

: 1.6系
    2002年12月24日にリリースされたRuby 1.6.8。

: 1.8系
    2002年12月24日にリリースされたRuby 1.8.0 preview1。

==== 2.1.2. CUI版/GUI版

コアにはCUI版とGUI版があり、それぞれの特徴は下記の通りです。

: CUI版
    実行時にコンソール（コマンドプロンプト）が表示されます、
    標準入出力が使用できます。
    例外発生時には、例外メッセージがコンソールに出力されます。

: GUI版
    実行時にコンソールは表示されません。
    標準入出力は使用できません。
    例外発生時には、例外ダイアログが表示されます。

==== 2.1.3. mswin32版/mingw32版/cygwin版

コアには構築環境によってmswin32版/mingw32版/cygwin版があり、それぞれの特徴は
下記の通りです。

: mswin32版
    Microsoft VisualC++によってコンパイルされています。
    標準添付のコアはmswin32版です。

: mingw32版
    MinGW環境によってコンパイルされています。

: cygwin版
    Cygwin環境によってコンパイルされています。
    forkなど、Unix系の関数を使用することができますが、CygwinのDLLが必要に
    なります。
    cygwin版のコアを使用する場合、そのソフトウェアは自動的にGPLになりますので
    ご注意ください。

==== 2.1.4. スタンドアロン版/ランタイムライブラリ版

コアにはファイル構成によってスタンドアロン版とランタイムライブラリ版があり、
それぞれの特徴は下記の通りです。

: スタンドアロン版
    スタンドアロン版コアを使用して生成された実行ファイルは、単体で実行可能です。
    各実行ファイルにRubyインタプリタが含まれているので、生成された実行ファイルの
    サイズは大きく、複数の実行ファイルを配布・実行する場合に低効率です。

: ランタイムライブラリ版
    ランタイムライブラリ版コアを使用して生成された実行ファイルは、実行時に
    ランタイムライブラリが必要です。
    各実行ファイルにはRubyインタプリタが含まれていないので、生成された実行
    ファイルのサイズは小さく、複数の実行ファイルを配布・実行する場合に高効率
    です。

=== 2.2. アーカイブ

アーカイブは、アーカイブヘッダ、名前テーブル、エントリテーブルによって構成
されています。

  +------------------+
  | アーカイブヘッダ |
  +------------------+
   | |
   | +-> +------------------+
   |     | 名前テーブル     |
   |     +------------------+
   |
   +---> +------------------+
         | エントリテーブル |
         +------------------+

=== 2.3. アーカイブヘッダ

アーカイブヘッダは、シグネチャ、名前テーブルの情報、エントリテーブルの情報など
から構成されています。

  +--------------------------------+
  | シグネチャ                     |
  +--------------------------------+
  | タイムスタンプ                 |
  +--------------------------------+
  | 名前テーブルへのオフセット     |
  +--------------------------------+
  | 名前テーブルのアイテム数       |
  +--------------------------------+
  | エントリテーブルへのオフセット |
  +--------------------------------+
  | エントリテーブルのアイテム数   |
  +--------------------------------+
  | オプション                     |
  +--------------------------------+

=== 2.4. 名前テーブル

名前テーブルは複数の名前ヘッダと、名前プールから構成されています。
各名前ヘッダの情報を用いて、名前プールから名前文字列を取り出します。

  +----------------+
  | 名前ヘッダ1    |---+
  +----------------+   |
  | 名前ヘッダ2..n |---|--+
  +----------------+   |  |
                       |  |
  +----------------+   |  |
  |                | <-+  |
  | 名前プール     | <----+
  |                |
  +----------------+

=== 2.5. 名前ヘッダ

名前ヘッダは、エントリID、名前文字列へのオフセット、名前文字列のサイズを保持
しています。
オフセットは、名前テーブルの先頭からのオフセットです。

  +------------+
  | ID         |
  +------------+
  | オフセット |
  +------------+
  | サイズ     |
  +------------+

=== 2.6. エントリテーブル

エントリテーブルは複数のエントリヘッダと、エントリプールから構成されています。
各エントリヘッダの情報を用いて、エントリプールからファイルを取り出します。

  +--------------------+
  | エントリヘッダ1    |---+
  +--------------------+   |
  | エントリヘッダ2..n |---|--+
  +--------------------+   |  |
                           |  |
  +--------------------+   |  |
  |                    | <-+  |
  | エントリプール     | <----+
  |                    |
  +--------------------+

=== 2.7. エントリヘッダ

エントリヘッダは、エントリID、ファイルへのオフセット、ファイルのサイズを保持
しています。
オフセットは、エントリテーブルの先頭からのオフセットです。

  +------------+
  | ID         |
  +------------+
  | タイプ     |
  +------------+
  | オフセット |
  +------------+
  | サイズ     |
  +------------+

== 3. 実行ファイルの生成過程

実行ファイルの生成過程は、

* アーカイブの生成
* アーカイブとコアのリンク

の2段階です。

=== 3.1. アーカイブの生成

アーカイバはレシピファイルに記述された情報を元にアーカイブを生成します。
ファイル名を格納した名前テーブルと、各ファイルを格納したエントリテーブルを生成
します。
また、必要があればアーカイブを圧縮します。

=== 3.2. アーカイブとコアのリンク

リンカはアーカイブとコアを結合し、コアのヘッダの一部を書き換えます。

== 4. 実行ファイルの実行過程

実行ファイルの実行過程は、

* Windowsによる実行ファイルのロード
* Exerbランタイムコードの実行

の2段階です。

=== 4.1. Windowsによる実行ファイルのロード

Windowsの実行ファイルローダは、コアの部分を通常の実行ファイルと同じようにメモリ
にロードし、実行します。
この際、アーカイブの部分はロードされません。

=== 4.2. Exerbランタイムコードの実行

コアが実行されると、Exerbランタイムコードが実行されます。
Exerbランタイムコードの実行過程は、

* アーカイブのロードと展開
* 各種テーブルの構築
* スタートアップスクリプトの実行

の3段階です。

==== 4.2.1. アーカイブのロードと展開

Exerbランタイムコードにより、Windowsの実行ファイルローダではロードされない
アーカイブをロードし、アーカイブが圧縮されていれば展開します。

==== 4.2.2. 各種テーブルの構築

メモリにロードされたアーカイブの元に、各種テーブルを構築します。
名前とIDの相互変換を行うハッシュテーブル、IDからタイプ、オフセット、サイズを
取得するハッシュテーブルが構築されます。

==== 4.2.3. スタートアップスクリプトの実行

各種テーブルの構築が完了すると、テーブルの先頭にあるRubyスクリプトを検索し、
実行します。
bRubyがリンクされている場合は、bRubyバイナリコードも検索します。

== 5. ライブラリの読み込み過程

プログラムの実行中にrequire関数が呼ばれると、Exerbはその呼び出しをフックし、
アーカイブ内を検索します。

アーカイブ内にライブラリが見つかった場合は、ライブラリを読み込み、
見つからなかった場合は実行ファイル外部を検索します。
実行ファイル外部にも見つからなかった場合、例外が発生します。

=== 5.1. Rubyスクリプトの読み込み過程

Rubyスクリプトを読み込む場合は、単純にeval関数で実行します。

=== 5.2. bRubyバイナリコードの読み込み過程

bRubyバイナリコードを読み込む場合は、バイナリコードをbRubyで実行します。

=== 5.3. 拡張ライブラリの読み込み過程

拡張ライブラリを読み込む場合は、インポートテーブルの書き換え処理を行った後、
Win32APIのLoadLibrary関数で読み込み、初期化関数を実行します。

インポートテーブルの書き換え処理は、

* インポートライブラリの書き換え処理
* インポート関数の書き換え処理

の2つから構成されています。

==== 5.3.1. インポートライブラリの書き換え処理

通常、mswin32版の拡張ライブラリをコンパイルすると、mswin32-ruby16.dllなどの
Ruby DLLにリンクされます。
実行環境にはRuby DLLは存在しないため、そのままLoadLibrary関数でロードすると、
ダイナミックリンクに失敗します。

そこでインポートテーブルを書き換え、Ruby DLLをリンクしている部分を自分自身の
実行ファイルにリンクするように変更します。
コアはRuby DLLと同じ関数をエクスポートしているので、ダイナミックリンクが成功
します。

foo.exe内にbar.dllという拡張ライブラリを含む場合の、インポートテーブルの
書き換え前と書き換え後の図を示します。

インポートテーブル書き換え前：

  +-------------+
  | foo.exe     |
  | +---------+ |       +--------------------+
  | | bar.dll |-|-----> | mswin32-ruby16.dll |
  | +---------+ |       +--------------------+
  +-------------+

インポートテーブル書き換え後：

  +-------------+
  | foo.exe     |<--+
  | +---------+ |   |   +--------------------+
  | | bar.dll |-|---+   | mswin32-ruby16.dll |
  | +---------+ |       +--------------------+
  +-------------+

==== 5.3.2. インポート関数の書き換え処理

インポートライブラリの書き換え処理を行った後、インポート関数の書き換え処理を
行います。

Rubyレベルのrequire関数をフックするのは容易ですが、それだけではRuby APIの
rb_require関数やrb_f_require関数によるrequireをフックできません。

そこでインポート関数テーブルを書き換え、rb_require関数とrb_f_require関数の
インポート関数名をそれぞれex_require関数とex_f_require関数に書き換えます。
これにより、本来の関数ではなくex_require関数、ex_f_require関数が呼ばれることで、
requireのフックを行うことができます。

インポート関数テーブル書き換え前：

  +--------------+
  | rb_str_new   |
  +--------------+
  | rb_require   |
  +--------------+
  | rb_f_require |
  +--------------+
  | ...          |
  +--------------+

インポート関数テーブル書き換え後：

  +--------------+
  | rb_str_new   |
  +--------------+
  | ex_require   |
  +--------------+
  | ex_f_require |
  +--------------+
  | ...          |
  +--------------+

=end
