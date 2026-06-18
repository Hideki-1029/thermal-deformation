#import "template.typ": *

#show: project.with(
  id: "",
  title-ja: "レポートテーマ",
  authors: (
    (
      name-ja: "37-256364 高本英熙（2026/1/21）",
      affiliation-ja: "",
      presenting: true,
    ),
  ),
  n-columns: 2,
)

= 序論
== 研究背景
深宇宙探査を担う超小型宇宙機のミッションは現在増加傾向にある@2019-creech-sls． 現在深宇宙探査ミッションでは無線通信（Radio Frequency; RF）による通信が主流だが，RF通信のみで将来ミッションの大容量・高速通信要求を満足することは困難である．

#figure(
  image("figure/system_PAT.png"),
  caption: [IRカメラ捕捉追尾系概要図@2025-takamoto-ists ],
)<system_PAT>\

== 状態量と状態方程式
状態量は，x,y各軸共通で，外角の指向誤差およびその角速度，FPMの機械角およびその角速度，IR/GAPのオフセットバイアス，光学クロストーク係数である．
$ x = vec( theta_s, omega_s, theta_f, omega_f, b_c, b_g ) $
  
- 入力: 誤差の交差駆動を踏襲し，x誤差は y鏡で制御，y誤差は x鏡で制御．入力 $u$ はFPM駆動指令（PID出力）．\
  

\


#figure(
  table(
    columns: (auto, auto),
    align: left,
    [FPM $omega_n$, $zeta$, $k_u$], [$339$ Hz, 0.015, $0.25 omega_n^2 $],
    [$T_s$], [$50e-6$ (20 kHz)],
    [IR rate], [$1.2$ kHz (mode)],
    [$Q$], [$q_s = 1e-5, q_f = 1e-4, q_("bc") = q_("bg") = 1e-11$],
    [$R$], [$R_g = (1e-6)^2, R_c = (5e-6)^2$],
    [$alpha$], [$alpha_("xy") = 2.0, alpha_("yx") = sqrt(2)$],
  ),
  caption: [主パラメータ一覧],
)



#bibliography(
  "bibliography.bib",
  title: [参考文献],
  style: "bibstyle.csl",
)
