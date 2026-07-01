# ICSO full paper ストーリーメモ

## 中心となる主張

熱変形を、光通信の粗捕捉で scan center の不確かさを減らすために使える「予測可能な時変 LOS バイアス」として扱う。

この論文では、観測された指向残差から熱変形成分だけを完全に分離できる、とは主張しない。実際の粗捕捉誤差には、軌道予測誤差、姿勢決定誤差、アライメント誤差、相手機側誤差などが同時に含まれるためである。

主張の置き方は、これらの誤差が残っている状況でも、熱構造解析や軌道・熱情報から得た事前情報によって、初期指向誤差のうち予測可能な成分をどれだけ減らせるかを評価する、という形にする。

## ICSOでの最小提出ライン

ICSO full paper は、完全に一般化された飛行実証済みモデルではなく、代表ケースに基づく数値検討としてまとめる。

最低限守りたい範囲は以下。

- TD/Femap 代表ケースから STT-LCT の相対変位、相対回転、LOS 角度を作る。
- PAT 補正に使う主指標は STT-relative LOS とする。
- 感度解析は 2〜3 ケースだけに絞る。
  - 内部発熱位置変更
  - 太陽方向変更
  - 拘束条件 sanity check
- Femap/TD 結果を truth として、軽量モデルに圧縮する。
- 比較対象は no correction、static bias、Fourier feedforward、physical lightweight model、feedforward + adaptive とする。
- 評価指標は LOS 予測誤差、捕捉時間、必要 scan area とする。

## 論文構成案

1. Introduction
   - 光通信ではビームが細く、PAT の粗捕捉がリンク確立に効く。
   - 粗捕捉時は光フィードバックがまだ使えないため、初期指向誤差が scan area を決める。
   - 熱変形由来の LOS バイアスは、事前予測できる可能性がある。

2. Thermal-Deformation-Induced LOS Bias
   - LEO の日照・食、内部発熱、姿勢条件によって温度場が変わる。
   - STT と LCT の相対変位・相対回転が LOS バイアスになる。
   - Femap 結果では、重心線の傾きだけでなく LCT/STT の回転成分も重要。

3. Lightweight Thermal Bias Models
   - 高忠実度 TD/Femap 結果をそのままオンボードで使うのではなく、軽量モデルへ圧縮する。
   - まず static bias と Fourier model を実装する。
   - 次に、代表温度差または発熱・太陽方向から theta_x/theta_y を近似する簡易 physical model を作る。

4. PAT Simulation
   - 軽量モデルで予測した LOS バイアスを scan center 補正に入れる。
   - thermal LOS bias -> scan center residual -> acquisition time の流れを説明する。
   - no correction、static、Fourier、physical、adaptive を比較する。

5. Discussion and Conclusion
   - 代表ケース + 少数感度解析 + 軽量モデル + PAT 接続を一気通貫で示す。
   - 多数ケースでの汎化評価、詳細な residual decomposition、NN モデルは今後の課題に回す。

## ICSO用の図候補

- Femap の STT-relative LOS 角度時系列
- 2〜3 ケースの感度解析比較
- 軽量モデルの LOS 予測比較
- PAT シミュレータの概念図
- 補正あり/なしの捕捉時間比較

## 表現上の注意

使いやすい表現:

- 代表熱構造解析ケース
- 予備的な数値評価
- scan area の proxy
- 熱構造モデル由来の事前情報によって捕捉負荷を下げる
- 熱変形成分だけを完全分離する必要はない

避けたい表現:

- 飛行実証済み
- 全軌道条件に一般化済み
- 熱/非熱残差を完全分離
- 最適化済みオンボード実装
