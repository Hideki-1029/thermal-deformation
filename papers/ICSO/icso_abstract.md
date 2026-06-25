Ver.2　4/15 22:00 提出版
Title：
Feedforward and Adaptive Correction of Time-Varying Thermal Bias for Coarse Acquisition in Optical Communication Systems
光通信システムにおける粗捕捉のための時変熱バイアスのフィードフォワードおよび適応補正
 
Co-auther：
Kazuki Takashima, Yuki Kusano, Satoshi Ikari, Ryu Funase　
※Wiki的に上記の順番
 
Abstract：
In optical communication systems, the performance of pointing, acquisition, and tracking (PAT) is critical for reliable link establishment. During the coarse acquisition phase, initial pointing error is a dominant factor determining acquisition success probability and scan time. While residual errors can be compensated through feedback in the fine tracking phase, systematic pointing biases remain uncorrected at the beginning of acquisition. This issue is particularly critical in LEO systems, where narrow beam divergence and rapidly varying thermal environments associated with compact satellite platforms make initial pointing errors a critical contributor to acquisition performance.
This study addresses time-varying line-of-sight (LOS) bias errors induced by thermal distortion. In LEO satellites, periodic and irregular temperature variations caused by repeated eclipse cycles lead to structural deformation, resulting in LOS biases that vary with orbital phase. Thermo-structural analysis using Thermal Desktop and Femap indicates that deformations on the order of 100–200 µm can occur in meter-scale satellite structures, corresponding to LOS biases on the order of tens to hundreds of microradians. This magnitude is comparable to the beam divergence and LOS errors caused by attitude determination accuracy, and thus has a non-negligible impact on acquisition performance.
Conventional approaches primarily rely on observation-based corrections, while the integration of physics-based thermal modeling with on-orbit adaptive correction has not been sufficiently explored.
To address this issue, this study proposes a two-layer correction framework that integrates physics-based prediction with adaptive correction using on-orbit observations. First, a feedforward model is constructed based on thermo-structural analysis using Thermal Desktop and Femap to predict LOS bias as a function of orbital conditions and operational states, and is applied to correct the initial pointing direction at the start of coarse acquisition. Second, pointing error and received optical power information obtained from PAT sensors, such as quadrant detectors or focal plane modules, are used to iteratively adjust the correction based on the discrepancy between prediction and observation, thereby compensating for model errors and temporal variations.
The proposed method is evaluated through high-fidelity numerical simulations incorporating representative LEO thermal environments. Performance is assessed in terms of acquisition success rate, acquisition time, and required scan area, and compared with conventional approaches such as no correction, static bias compensation, and feedback-only methods based solely on observational data, thereby explicitly evaluating the benefit of incorporating a priori thermal models.
The novelty of this work lies in explicitly treating thermally induced pointing bias as a predictable, time-varying component and directly linking it to acquisition performance improvement. By reducing initial pointing uncertainty and required scan area in coarse acquisition, the proposed framework improves acquisition efficiency and robustness, particularly in LEO optical communication systems for small and micro satellites.

438 words


日本語版 Abstract
光通信システムにおいて，Pointing, Acquisition, and Tracking（PAT）の性能は，安定した通信リンク確立のために極めて重要である。特に粗捕捉（coarse acquisition）フェーズでは，初期指向誤差が捕捉成功確率およびスキャン時間を支配する主要因となる。微細追尾（fine tracking）フェーズでは残留誤差をフィードバック制御によって補償可能である一方，系統的な指向バイアスは捕捉開始時点では未補正のままとなる。この問題は，ビーム拡がり角が狭く，小型衛星特有の急激に変化する熱環境にさらされるLEO（低軌道）システムにおいて特に深刻であり，初期指向誤差が捕捉性能に大きく影響する。
本研究では，熱変形によって生じる時変的なLine-of-Sight（LOS）バイアス誤差に着目する。LEO衛星では，繰り返される日照・蝕サイクルに起因する周期的かつ不規則な温度変動により構造変形が発生し，その結果として軌道位相に応じて変化するLOSバイアスが生じる。Thermal DesktopおよびFemapを用いた熱構造解析の結果，メートル級衛星構造では100〜200 µm程度の変形が生じ得ることが示され，これは数十〜数百 µrad規模のLOSバイアスに相当する。この大きさは，ビーム拡がり角や姿勢決定精度に起因するLOS誤差と同程度であり，捕捉性能に無視できない影響を与える。
従来手法では主として観測ベースの補正に依存しており，物理ベースの熱モデルと軌道上適応補正を統合したアプローチは十分に検討されていない。
この課題に対し，本研究では，物理モデルに基づく予測と軌道上観測による適応補正を統合した二層構造の補正フレームワークを提案する。第一に，Thermal DesktopおよびFemapによる熱構造解析に基づき，軌道条件および運用状態の関数としてLOSバイアスを予測するフィードフォワードモデルを構築し，粗捕捉開始時の初期指向方向補正に適用する。第二に，四分割検出器や焦点面モジュールなどのPATセンサから得られる指向誤差および受信光強度情報を用いて，予測値と観測値の差分に基づき補正量を逐次更新することで，モデル誤差や時間変動を補償する。
提案手法は，代表的なLEO熱環境を考慮した高忠実度数値シミュレーションにより評価される。性能評価指標として，捕捉成功率，捕捉時間，および必要スキャン領域を用い，無補正手法，静的バイアス補正手法，および観測データのみに基づくフィードバック手法と比較することで，事前熱モデルを導入する利点を明示的に評価する。
本研究の新規性は，熱起因の指向バイアスを「予測可能な時変成分」として明示的に扱い，それを捕捉性能向上へ直接結び付けた点にある。粗捕捉における初期指向不確かさおよび必要スキャン領域を低減することで，提案フレームワークは，特に小型・超小型衛星向けLEO光通信システムにおいて，捕捉効率およびロバスト性を向上させる。
