# ICSO 2026 公式 Author Instructions 日本語メモ

出典: [ICSO 2026 Author Instructions](https://atpi.eventsair.com/icso-2026/author-instructions)

関連: [SPIE Manuscript Guidelines and Policies](https://spie.org/conferences-and-exhibitions/event-resources/manuscript-guidelines-and-policies)

## Paper Instructions and Paper Template

ICSO 2026 の論文提出では、公式の author instructions と paper template / format instructions をよく確認する必要がある。形式不備があると publication から外れる可能性がある。

特に重要な条件:

- 論文は **最低6ページ**。
- header と footer は使わない。
- 論文PDFのファイル名は `Paper Number#_FamilyName` の形式にする。
  - 例: `543_Smith`
- 最終論文は **PDF形式** でアップロードする。
- Paper template / format instructions は SPIE 提供のものを使う。

## Proceedings

ICSO 2026: International Conference on Space Optics の proceedings は、会議開始時に参加者へ公開される。

Proceedings 掲載には、電子版の論文を **2026年8月20日までに提出することが必須**。例外なし。

ICSO proceedings は SPIE Digital Library に **Open Access** として掲載される。これにより論文の可視性と引用可能性が高まる。

SPIE Digital Library には、論文に加えて以下もアップロードされる。

- 口頭発表用 PowerPoint slides
- ポスター発表用 poster file

これらの発表資料は、**2026年10月19日まで** に ESA Conference Bureau へ提出する。

## Oral Presentation Instructions

口頭発表の条件:

- 発表時間は **15分発表 + 5分質疑・交代**。
- 発表資料は MS PowerPoint または PDF 形式。
  - 受け付けられるのはこの2形式のみ。
- 発表資料は memory stick に入れて持参する。
- 画面アスペクト比は **16:9**。
- 会場の発表用PCは Windows。
- 著者は、自分の発表前に会場PCへ資料をロードしておく。
  - コーヒーブレイク中または発表当日の朝に行うのがよい。
- ファイルを渡しただけでは動作保証にならない。
  - 著者本人が、会場PCと技術スタッフのもとで動作確認する責任を持つ。
- Windowsで読めるUSBメモリにバックアップを入れておくことが推奨される。
- 発表時は Windows 上の MS PowerPoint または Adobe Acrobat Reader が使われる。
- 動画など外部ファイルを使う場合は、発表資料と同じフォルダに入れる。
  - 準備時もそのファイルを使い、フォルダごとコピーする。
- 標準フォントを使う。
  - Arial
  - Times New Roman
  - Courier New
- Macintosh や Linux PC で作った発表資料は、Windows PC で事前にテストする。
- zip / arc / tar などの圧縮ファイルや保護機能に、パスワード保護や暗号化を使わない。

## Poster Presentation Instructions

ポスター発表の条件:

- ポスターパネルは **高さ180 cm × 幅120 cm**。
- A0 portrait までのサイズならパネルに収まる。
- ポスター貼付用の材料は会場で提供される。
- パネルにはポスター番号が表示される。
- 著者自身がポスターの掲示と撤去を行う。
- 会議運営側は、会議終了後に放置・未撤去のポスターについて責任を負わない。

文字サイズの目安:

- Title: 高さ15 mm程度、font size 60程度
- Subtitles: 高さ12 mm程度、font size 48程度
- Text and figure captions: 高さ7.5 mm程度、font size 30程度

A4 や A3 の紙を複数枚貼り合わせた形式は、正式なポスターとして認められない。

## このリポジトリでの対応メモ

- `papers/ICSO/main.typ` は、公式テンプレート入手前の仮原稿として扱う。
- 公式 SPIE template / format instructions を入手したら、本文をそちらへ移植する。
- 最終PDFは最低6ページにする。
- header / footer を入れない。
- 最終PDFのファイル名は paper number が分かり次第、公式形式に合わせる。
- 発表スライドは10月19日締切を別途管理する。

## SPIE Manuscript Guidelines の要点

ICSO の paper template / format instructions は SPIE 提供のものを参照する。

SPIE Proceedings 原稿の基本条件:

- ファイル形式は **PDF**。
- SPIE 一般ルールでは 2ページ以上。ただし ICSO 2026 では **6ページ以上** が指定されているため、ICSO側の条件を優先する。
- 1カラム、single space。
- 段落間には適度な空白を入れる。
- フォントは Times New Roman または同等フォント。
- PDFにはすべてのフォントを埋め込む。
- header、footer、日付、ページ番号、著者略歴は入れない。

余白:

- US Letter:
  - left/right: 0.88 in
  - top: 1.0 in
  - bottom: 1.25 in
- A4:
  - left/right: 1.93 cm
  - top: 2.54 cm
  - bottom: 4.94 cm

原稿に含める要素:

- Title
- Author names
  - given name と family name を含む full name
  - 公式DBやindexに使われる
- Author affiliations
  - institution, department, street address, city, postal code, country
  - 著者と所属の対応は superscript letters または numbers で示す
- Corresponding author
  - 対応著者に `*` を付ける
  - 1ページ目に email address を載せる
- Abstract
- Keywords
- Sections
  - Introduction, Methods, Results など
- Acknowledgments
  - 必要な場合
- References
  - 十分かつ適切な文献を入れる
  - 本文中で引用された順に連番で並べる
  - 本文中引用は superscript または bracketed reference numbers

SPIE が提供しているテンプレート:

- Microsoft Word template
  - US Letter blank
  - US Letter with sample content
  - A4 blank
  - A4 with sample content
- PDF sample
  - US Letter sample
  - A4 sample
- LaTeX style files
- Overleaf の SPIE proceedings template

## Typst / Word / LaTeX の運用方針

現時点では SPIE 公式の Typst テンプレートは見当たらない。

このPCに LaTeX 実行環境がない場合、最も安全なのは以下の運用にする。

1. `papers/ICSO/main.typ` は日本語の構成検討・本文下書き用に使う。
2. 図表、数式、章立て、主張、参考文献を Typst 側で先に固める。
3. ICSO/SPIE の公式 Word A4 template を入手したら、本文を Word テンプレートへ移植する。
4. 最終PDFは Word から出力する。
5. PDF出力後に、フォント埋め込み、余白、ページ数、header/footerなしを確認する。

LaTeXを使いたい場合の選択肢:

- Overleaf の SPIE proceedings template を使う。
  - ローカルにLaTeX環境がなくてもブラウザ上でPDF化できる。
  - ただし図ファイルやbib管理をOverleaf側へアップロードする必要がある。
- このPCに TeX Live / MiKTeX を入れる。
  - 環境構築に時間を使う可能性があるため、ICSO直前には避けた方がよい。

現実的な推奨:

- 研究内容の作成・日本語下書き: Typst / Markdown
- 図表生成: Python
- 最終投稿版の整形: SPIE Word A4 template

この方針なら、LaTeX環境がなくても公式フォーマットに合わせやすく、提出直前の環境トラブルを避けやすい。
