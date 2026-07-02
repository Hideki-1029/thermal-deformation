# Femap STT-LCT LOS Angle Definition

## Purpose

TDでマッピングした温度分布をFemapで熱ひずみ解析し、STTとLCTの代表節点からPAT用の熱LOS角度誤差を作る。

対象データ:

- `inputs/data_femap_deformation/260629_1505_translation_rotation.xlsx`
- `inputs/data_femap_deformation/stt_lct_node_config.json`
- `src/thermal_deformation/plot_stt_lct_relative_deformation.py`

座標系の前提:

- `+Z`: STT / PZ side
- `-Z`: LCT / MZ side
- nominal LOS direction: `STT -> LCT = -Z`

## LOS Definitions

遠方通信のPAT、特に初期捕捉のscan center補正に効くLOS誤差は、STTで決まる姿勢基準に対してLCTの外向き光軸がどれだけ傾いたかで定義する。

衛星姿勢の基準がSTT依存である場合、主に効く量はSTT座標系とLCT座標系の相対回転である。したがって、PAT用の主LOS誤差は以下とする。

```text
PAT / far-field outgoing LOS error
    = LCT local optical-axis rotation - STT attitude-frame rotation
```

コード上では、これは `relative_rotation_angle_*` および `relative_rotation_angle_magnitude_urad` に対応する。

一方で、STT-LCT代表点間の相対並進から作る

```text
centerline tilt
    = unit((LCT_pos + LCT_disp) - (STT_pos + STT_disp)) - u0
```

は、構造変形の補助指標として扱う。これは代表点同士を結ぶ内部構造線の傾きであり、遠方に出るLCT光軸そのものの角度ではない。有限距離ターゲットへの視差としては並進が効くが、衛星間などの遠方通信では `Delta x / target range` となるため、通常は `Delta x / STT-LCT baseline` をそのまま外向きLOS誤差には入れない。

過去の暫定定義として、コードには次の合成量も残している。

```text
global LOS bookkeeping
    = STT-LCT centerline tilt + LCT local-axis rotation

STT-relative LOS bookkeeping
    = STT-LCT centerline tilt + (LCT local rotation - STT local rotation)
```

`global_los_angle_*` と `stt_relative_los_angle_*` は、centerline tiltと回転項を足した角度バジェット確認用の量である。PATシミュレータやICSO本文で遠方通信の初期捕捉誤差として使う主値は、原則として `relative_rotation_angle_*` を用いる。

## Calculation

ひずむ前の名目LOS軸を

```text
u0 = [0, 0, -1]
```

とする。

LCTノードとSTTノードの `R1/R2/R3 Rotation` から、STT姿勢基準に対するLCT外向き光軸誤差を作る。

```text
relative_rotation_change =
    rotate(u0, LCT_rotation - STT_rotation) - u0
```

これを遠方通信PAT用の主LOS誤差とする。

```text
far_field_los_angle =
    relative_rotation_change
```

STT/LCTの並進変位からは、ひずんだ後のSTT-LCT代表点間centerlineの向きを作る。これは構造変形の補助指標として残す。

```text
centerline_change =
    unit((LCT_pos + LCT_disp) - (STT_pos + STT_disp)) - u0
```

また、過去の角度バジェット確認用として、centerline tiltと回転項を合成した量も出力している。

```text
global_los_direction =
    unit(u0 + centerline_change + lct_rotation_change)

stt_relative_los_direction =
    unit(u0 + centerline_change + relative_rotation_change)
```

CSV列の対応:

- `centerline_angle_x/y/z_urad`: 並進変位から来るSTT-LCT代表点間centerlineの傾き
- `stt_rotation_angle_x/y/z_urad`: STT面/LOS軸をSTT回転DOFで回したときの傾き
- `lct_rotation_angle_x/y/z_urad`: LCT面/LOS軸の回転から来る傾き
- `relative_rotation_angle_x/y/z_urad`: STT基準で見たLCT面/LOS軸の相対回転。遠方通信PAT用の主LOS誤差。
- `global_los_angle_x/y/z_urad`: `centerline + LCT rotation`。角度バジェット確認用。
- `global_los_angle_magnitude_urad`: `global_los_angle` の `x-y` 成分ノルム
- `stt_relative_los_angle_x/y/z_urad`: `centerline + (LCT rotation - STT rotation)`。角度バジェット確認用。
- `stt_relative_los_angle_magnitude_urad`: `stt_relative_los_angle` の `x-y` 成分ノルム

## STT Rotation Treatment

STTも熱ひずみによって回転する。ただし、衛星姿勢基準がSTT依存である場合、STT自身の回転は基準座標系の回転として扱うため、遠方通信PAT用のLOS誤差には含めない解釈が自然である。

STT観測基準に対するLCT光軸ずれを見るなら、LCT回転からSTT回転を差し引く。

```text
far-field outgoing LOS = LCT rotation - STT rotation
```

使い分け:

- 遠方通信PAT用の主LOS誤差: `LCT rotation - STT rotation`
- STT-LCT代表点間の構造傾き: `centerline tilt`
- 角度バジェット確認用の合成量: `centerline tilt + rotation term`

PATや星センサ基準の補正に接続する場合は、`relative_rotation_angle_*` を主定義にする。`global_los_angle_*` や `stt_relative_los_angle_*` も残しておくと、代表点間の相対並進やSTT自身の回転が角度バジェット上どれだけ見えるかを確認できる。

## Current Observation

`260629_1505_translation_rotation.xlsx` の結果では、LCT面/LOS軸の回転が合算LOS角度に強く効いている。

概略値:

- STT-LCT代表点間centerlineの傾き: 約 `200 urad`
- STT回転由来の角度: 約 `24 urad`
- LCT回転由来の角度: 約 `475 urad`
- global基準の合算LOS角: 約 `680 urad`
- STT観測基準の合算LOS角: 約 `665 urad`

この観察では、centerline tiltを足した合成量は600 urad級になる。一方、遠方通信PAT用の主LOS誤差を `relative_rotation_angle_magnitude_urad` と定義すると、値はLCT-STT相対回転由来の約460 urad級である。

したがって、代表点の相対変位から作る `Delta x / L` 型のcenterline tiltは、構造変形の説明には有用だが、遠方通信の外向き光軸誤差としては主値に足し込まない方が自然である。
