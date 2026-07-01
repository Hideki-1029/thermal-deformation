# ICSO レビュー・修正チェックリスト

## レビューに出すファイル

- `papers/ICSO/main.pdf`
- `papers/ICSO/main.typ`
- `papers/ICSO/full_paper_story.md`
- `results/icso/femap_los_summary.csv`
- `results/icso/pat_performance_summary.csv`

## 先生への確認依頼文案

件名: ICSO full paper 草稿の確認依頼

五十里先生

ICSO full paper の初期草稿を作成しました。

現状では、熱変形に起因する LOS バイアスを光通信粗捕捉の scan center 補正に使う、という主張でまとめています。TD/Femap 代表ケースから STT-relative LOS を作り、軽量モデルで近似し、PAT シミュレータで no correction / static / feedforward / adaptive を比較する構成を想定しています。

特に以下をご確認いただけると助かります。

- 現在の解析成熟度に対して、主張の強さが適切か。
- TD/Femap 代表ケースと少数感度解析という見せ方で十分か。
- 軽量モデルと PAT シミュレータの接続を主成果として置いてよいか。
- 著者順・貢献の書き方に問題がないか。
- ICSO 提出前に弱めるべき表現、追加すべき解析、削るべき内容があるか。

よろしくお願いいたします。

高本

## 修正時の優先順位

1. 主張の強さ
   - 代表ケース、予備評価、preliminary であることを必要に応じて明記する。
   - 飛行実証や全条件への一般化のような強い言い方を避ける。

2. 結果の一貫性
   - 本文中の数値が `results/icso/*.csv` と一致しているか確認する。
   - シミュレーションを変えたら `python scripts/generate_icso_results.py` を再実行する。
   - PDF は `typst compile --root . papers/ICSO/main.typ papers/ICSO/main.pdf` で再ビルドする。

3. 図の品質
   - 2カラムで読める軸ラベル、単位、凡例になっているか確認する。
   - 仮図、低解像度図、英語表記が揺れている図は差し替える。

4. 用語の統一
   - STT-relative LOS
   - feedforward correction
   - adaptive correction
   - coarse acquisition
   - physical lightweight model

5. 投稿フォーマット
   - ICSO 公式テンプレートに差し替える。
   - ページ数、図表、参考文献形式、著者所属を確認する。
   - 投稿フォームに必要な title、abstract、keywords を確認する。

## 最終確認

- title と abstract が投稿フォームと本文で一致している。
- 本文中の引用が bibliography に存在する。
- すべての図表が本文で参照されている。
- PDF を別環境で開いても崩れていない。
- 結果を解析内容以上に強く言いすぎていない。
