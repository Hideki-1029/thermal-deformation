# ICSO 投稿パッケージメモ

## 現在のファイル

- 仮原稿ソース: `papers/ICSO/main.typ`
- 仮PDF: `papers/ICSO/main.pdf`
- 図フォルダ: `papers/ICSO/figure/`
- 結果要約:
  - `results/icso/femap_los_summary.csv`
  - `results/icso/pat_performance_summary.csv`

## 注意

現在の `main.typ` は、ICSO公式テンプレートが来るまでの仮原稿である。

公式テンプレートを入手したら、本文内容をそちらへ移す。現時点では、英語完成稿ではなく、日本語で研究内容・章立て・結果の流れを固めるための作業ファイルとして扱う。

## ビルド手順

図と数値要約を再生成する。

```powershell
python scripts/generate_icso_results.py
```

仮PDFを作る。

```powershell
typst compile --root . papers/ICSO/main.typ papers/ICSO/main.pdf
```

## 投稿メタデータ案

Title:

Feedforward and Adaptive Correction of Time-Varying Thermal Bias for Coarse Acquisition in Optical Communication Systems

Authors:

Hideki Takamoto, Kazuki Takashima, Yuki Kusano, Satoshi Ikari, Ryu Funase

Keywords:

- Optical communication
- Pointing, acquisition, and tracking
- Thermal deformation
- Line-of-sight bias
- Feedforward correction
- Adaptive correction

## 日本語abstract案

光通信ではビーム拡がり角が小さいため、Pointing, Acquisition, and Tracking (PAT) の粗捕捉段階における初期指向誤差が捕捉時間と捕捉成功率に大きく影響する。本研究では、熱変形に起因する時変 Line-of-Sight (LOS) バイアスを予測し、粗捕捉時の scan center 補正に用いる手法を検討する。低軌道衛星では、日照・食サイクル、姿勢条件、内部発熱によって衛星構体や光通信端末取付部が熱変形し、スターセンサ基準と光通信端末光軸の間に相対変位・相対回転が生じる。この変形は、光フィードバックが得られる前の粗捕捉段階では初期指向バイアスとして現れる。

本研究では、TD/Femap 代表ケースから STT-relative LOS 角度を作成し、その時系列を軽量モデルによって近似する。軽量モデルとして、static bias、Fourier feedforward、簡易 physical lightweight model を検討し、必要に応じて捕捉後の残差に基づく adaptive correction を加える。さらに、予測された熱 LOS バイアスを PAT シミュレータに接続し、no correction、static bias、feedforward、physical lightweight model、feedforward + adaptive の捕捉時間および必要 scan area を比較する。

## 最終提出前チェック

- ICSO公式テンプレートへ移植した。
- 著者順と所属を確認した。
- ページ数、ファイルサイズ、参考文献形式を確認した。
- 図表番号と本文参照が一致している。
- 本文中の数値が再生成されたCSVと一致している。
- PDFを開いてレイアウト崩れがない。
- 投稿締切時刻とタイムゾーンを確認した。
- 投稿完了メールまたはスクリーンショットを保存した。

## 現時点の限界として書くこと

- Femap結果は代表ケースであり、全ケースの汎化評価ではない。
- 感度解析は2〜3ケースに絞る。
- 軽量モデルはまず static / Fourier / 簡易 physical までを主対象にする。
- adaptive correction は理想化した残差更新として扱い、完全な残差分解は今後の課題にする。
