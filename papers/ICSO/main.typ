#import "../master_seminar/template.typ": *

#show: project.with(
  id: "",
  title-ja: "熱変形LOSバイアス予測による光通信粗捕捉のfeedforward・adaptive補正",
  language: "ja",
  caption-separator: [ ],
  authors: (
    (
      name-ja: "高本英熙，高島一貴，草野裕紀，五十里哲，船瀬龍",
      affiliation-ja: "",
      presenting: true,
    ),
  ),
  abstract: [
    光通信ではビーム拡がり角が小さいため，Pointing, Acquisition, and Tracking (PAT) の粗捕捉段階における初期指向誤差が捕捉時間と捕捉成功率に大きく影響する．本研究では，熱変形に起因する時変 Line-of-Sight (LOS) バイアスを予測し，粗捕捉時の scan center 補正に用いる手法を検討する．低軌道衛星では，日照・食サイクル，姿勢条件，内部発熱によって衛星構体や光通信端末取付部が熱変形し，スターセンサ基準と光通信端末光軸の間に相対変位・相対回転が生じる．この変形は，光フィードバックが得られる前の粗捕捉段階では初期指向バイアスとして現れる．本研究では，TD/Femap代表ケースからSTT-relative LOS角度を作成し，その時系列を軽量モデルで近似する．さらに，予測した熱LOSバイアスをPATシミュレータに接続し，補正なし，static bias，Fourier feedforward，physical lightweight model，feedforward + adaptive の捕捉時間および必要 scan area を比較する．
  ],
  n-columns: 2,
)

= 序論

衛星光通信は，高いアンテナ利得と広い通信帯域を実現できるため，小型衛星ミッションにおける大容量通信手段として期待されている@2017-kaushal-survey．一方で，光通信ではビーム拡がり角が小さいため，通信リンクを確立するための Pointing, Acquisition, and Tracking (PAT) が重要になる．特に粗捕捉段階では，相手機からの光フィードバックがまだ得られないため，軌道予測誤差，姿勢決定誤差，アライメント誤差，熱変形，相手機側誤差などを含む初期指向誤差を考慮して探索する必要がある@2023-riesing-tbird．

粗捕捉に必要な時間は，探索すべき不確定領域の大きさに強く依存する．不確定領域の代表半径を $theta_U$ とすると，単純なラスタ走査やスパイラル走査では，探索コストはおおよそ $theta_U^2$ に比例する．したがって，初期指向誤差のうち予測可能な成分を事前に補正できれば，scan area，捕捉時間，再捕捉時間を低減できる可能性がある．

本研究では，この予測可能な成分として，衛星構体および光学系の熱変形に起因する LOS バイアスに着目する．熱変形は従来，構造設計や熱設計によって低減すべき外乱として扱われることが多い．しかし，すべての軌道条件，姿勢条件，運用モードを設計段階で吸収することは難しい．そこで本研究では，熱変形を単なる未知外乱ではなく，熱構造解析と軌道・熱情報から部分的に予測可能な時変バイアスとして扱い，粗捕捉時の scan center 補正に利用する．

= 熱変形に起因するLOSバイアス

低軌道衛星では，日照・食サイクル，太陽方向，内部発熱，運用モードに応じて温度場が時間変化する．この温度場は衛星構体，光学ベンチ，光通信端末取付構造を変形させる．光通信系では，スターセンサ (STT) の基準座標系と光通信端末 (LCT) の光軸基準系の間の相対変位・相対回転が，通信光軸の LOS バイアスとして現れる．

相対変位だけを考えると，代表長さを $L$，横方向相対変位を $Delta x$ として，熱変形LOS角度は

$ Delta theta_("LOS") approx (Delta x) / L $

と近似できる．例えば $L = 1$ m，$Delta x = 100$--$200$ um であれば，$Delta theta_("LOS")$ はおよそ 100--200 urad となる．これは小型衛星光通信で想定されるビーム拡がり角，捕捉センサ視野，姿勢決定由来のLOS誤差と同程度になり得る．

ただし，実際には相対変位だけでは不十分な場合がある．Femap結果からは，STT-LCT重心線の傾きに加えて，LCT光軸面の局所回転，およびSTT基準面の回転がLOS角度に寄与する．本研究では，PAT補正に接続する主指標としてSTT-relative LOSを用いる．これは，STT観測基準から見たLCT光軸ずれであり，以下のように整理する．

$ Delta theta_("STT-rel") = "centerline tilt" + ("LCT rotation" - "STT rotation") $

#figure(
  image("../master_seminar/figure/image_thermal_deformation_from_Shi.png", width: 88%),
  caption: [衛星構体の熱変形解析例@2023-shi-thermal],
)<fig_thermal_example>

既存の代表Femapケースでは，STT-LCT重心線の傾きの平均値は約206 uradである一方，STT基準で見たLCT相対回転成分は約460 uradとなる．その結果，STT-relative LOSの大きさは平均約665 urad，範囲として約631--694 uradとなる．この結果は，熱LOSバイアスを相対変位だけで評価すると過小評価する可能性があることを示している．

#figure(
  image("figure/femap_stt_relative_los_angles.png", width: 100%),
  caption: [代表Femapケースから得たSTT-relative LOS角度と成分分解],
)<fig_femap_los>

= 軽量モデル化

TD/Femap解析は高忠実度な熱変形・LOSバイアスの参照データを与えるが，そのまま軌道上で逐次実行することは現実的ではない．そのため，本研究ではTD/Femap結果をtruthとして扱い，軌道上で扱いやすい軽量モデルへ圧縮する．

軽量モデルの入力候補は，軌道位相，日照・食状態，太陽方向，内部発熱モード，代表温度差，STT/LCT取付位置である．出力はPAT補正に直接使うため，`stt_relative_los_angle_x_urad` および `stt_relative_los_angle_y_urad` とする．

ICSOまでの最小構成として，以下のモデルを比較する．

- static bias: 学習データの平均LOSバイアスを補正量とする．
- Fourier model: 軌道位相に対する sin/cos で時変LOSバイアスを近似する．
- physical lightweight model: 代表温度差または発熱・太陽方向から theta_x, theta_y を近似する．
- feedforward + adaptive: feedforwardモデルの残差を捕捉後観測で逐次更新する．

まずは static bias と Fourier model を実装し，次に簡易 physical lightweight model を追加する．NNモデルや詳細な thermal sensor model は，ICSOでは今後の課題に回す．

= PATシミュレータへの接続

軽量モデルで予測した熱LOSバイアスを，粗捕捉時のscan center補正に用いる．名目指向方向を $theta_("nom")(t)$，予測熱LOSバイアスを $hat(Delta theta)_("LOS")(t)$ とすると，scan center指令は

$ theta_("scan")(t) = theta_("nom")(t) + u_("FF")(t), quad u_("FF")(t) = -hat(Delta theta)_("LOS")(t) $

と書ける．補正後にscan centerから見た相手方向の残差は，

$ e_("scan")(t) = e_("nonthermal")(t) + Delta theta_("thermal,true")(t) - hat(Delta theta)_("thermal")(t) $

となる．ここで $e_("nonthermal")$ は軌道予測誤差，姿勢決定誤差，アライメント誤差など，熱変形以外の誤差を表す．本研究では，熱変形補正がすべての誤差を消すのではなく，予測可能な熱由来成分を減らすことで捕捉時間や必要scan areaを低減する，という形で評価する．

PATシミュレータでは，rectangular spiral scanを仮定し，scan点が検出半径内に入れば捕捉成功とする．評価指標は，捕捉成功率，平均捕捉時間，95 percentile捕捉時間，初期指向誤差，熱残差，必要scan areaのproxyとする．

#figure(
  image("figure/thermal_los_prediction_comparison.png", width: 100%),
  caption: [熱LOSバイアスtruthと軽量モデル予測の比較],
)<fig_los_prediction>

#figure(
  image("figure/coarse_acquisition_performance_comparison.png", width: 100%),
  caption: [粗捕捉時間と初期指向誤差の比較],
)<fig_acq_comparison>

= 数値評価の方針

感度解析は，軽量モデルとPAT評価に進む時間を確保するため，基準ケースに加えて2〜3ケースだけに絞る．具体的には，内部発熱位置変更，太陽方向変更，拘束条件 sanity check を優先する．これにより，代表1ケースだけに依存した議論を避けつつ，感度解析で止まりすぎないようにする．

#figure(
  table(
    columns: (1.8fr, 2.7fr),
    align: left,
    [項目], [目的],
    [基準ケース], [TD/FemapからSTT-relative LOS truthを作る],
    [内部発熱位置変更], [発熱方向・代表温度差がLOSに効くかを見る],
    [太陽方向変更], [日照方向に対するLOS変化を見る],
    [拘束条件確認], [拘束点の置き方でLOSが大きく壊れていないか確認する],
  ),
  caption: [ICSOまでに優先する最小ケースセット],
)<tab_case_plan>

補正ケースは，no correction，static bias，Fourier feedforward，physical lightweight model，feedforward + adaptive とする．最初にstatic/Fourierを実装してPATまで通し，その後にphysical lightweight modelを追加する．

#figure(
  table(
    columns: (1.6fr, 2.5fr, 1.8fr),
    align: left,
    [Case], [補正内容], [評価目的],
    [No correction], [熱LOSバイアスを未補正], [基準性能],
    [Static bias], [平均LOSバイアスのみ補正], [定常補正の効果],
    [Fourier feedforward], [軌道位相に対するsin/cosで補正], [時変事前モデルの効果],
    [Physical lightweight], [代表温度差や発熱・太陽方向から補正], [物理モデルの効果],
    [FF + adaptive], [捕捉後残差でモデルを更新], [モデル誤差へのロバスト性],
  ),
  caption: [PATシミュレータで比較する補正ケース],
)<tab_correction_cases>

= 考察

本研究の重要な点は，熱変形解析をLOS誤差のオーダー評価だけで終わらせず，軽量モデルを介してPAT粗捕捉性能に接続することである．TD/Femap代表ケースから得られたSTT-relative LOSは数百uradのオーダーであり，LCT/STTの回転成分が支配的である可能性が示されている．このため，軽量モデルでも相対変位だけでなく，光軸方向の変化を反映できる形が望ましい．

一方で，ICSOまでに多数ケースの網羅的な感度解析を行うと，軽量モデル実装やPAT接続に十分な時間が残らない．したがって，感度解析は基準ケースの妥当性確認と軽量モデル入力の物理的説明に必要な最小限に絞る．主成果は，代表熱構造解析からLOS truthを作り，軽量モデルで近似し，scan center補正によって捕捉時間・必要scan areaを低減できることを示す点に置く．

= 結論

本稿では，熱変形に起因する時変LOSバイアスを，光通信粗捕捉のscan center補正に利用する枠組みを検討する．TD/Femap解析によりSTT-LCT間の相対変位・相対回転からSTT-relative LOSを作成し，これをtruthとして軽量モデルへ圧縮する．さらに，軽量モデルで予測した熱LOSバイアスをPATシミュレータへ接続し，補正なし，static bias，Fourier feedforward，physical lightweight model，feedforward + adaptiveを比較する．今後は，基準ケースに加えて2〜3ケースの感度解析を行い，軽量モデルとPAT評価をICSO full paperの主結果としてまとめる．

#bibliography(
  "../master_seminar/bibliography.bib",
  title: [参考文献],
  style: "../master_seminar/bibstyle.csl",
)
