# Femap STT-LCT LOS Angle Definition

## Purpose

TDでマッピングした温度分布をFemapで熱ひずみ解析し、STTとLCTの代表節点からPAT用の熱LOS角度誤差を作る。

対象データ:

- `src/optical_comm/data_femap_deformation/260629_1505_translation_rotation.xlsx`
- `src/optical_comm/data_femap_deformation/stt_lct_node_config.json`
- `src/optical_comm/plot_stt_lct_relative_deformation.py`

座標系の前提:

- `+Z`: STT / PZ side
- `-Z`: LCT / MZ side
- nominal LOS direction: `STT -> LCT = -Z`

## Current Total LOS Definition

現在の `total_los_angle_*` は、以下の2成分を小角近似で合算している。

```text
total LOS = STT-LCT centerline tilt + LCT local-axis rotation
```

STT側の回転は、現在の `total_los_angle_*` には含めていない。

## Calculation

ひずむ前の名目LOS軸を

```text
u0 = [0, 0, -1]
```

とする。

STT/LCTの並進変位から、ひずんだ後のSTT-LCT重心線の向きを作る。

```text
centerline_change =
    unit((LCT_pos + LCT_disp) - (STT_pos + STT_disp)) - u0
```

LCTノードの `R1/R2/R3 Rotation` で、名目LOS軸 `u0` を回転させる。

```text
lct_rotation_change =
    rotate(u0, LCT_rotation) - u0
```

この2つを足して正規化したものを、現在の合算LOS方向としている。

```text
total_los_direction =
    unit(u0 + centerline_change + lct_rotation_change)

total_los_angle =
    total_los_direction - u0
```

CSV列の対応:

- `centerline_angle_x/y/z_urad`: 並進変位から来るSTT-LCT重心線の傾き
- `lct_rotation_angle_x/y/z_urad`: LCT面/LOS軸の回転から来る傾き
- `total_los_angle_x/y/z_urad`: 上記2成分の合算
- `total_los_angle_magnitude_urad`: `x-y` 成分のノルム

## STT Rotation Treatment

STTも熱ひずみによって回転する。ただし、STT観測面を基準面にする場合、STT自身の回転は基準座標系の回転として扱うため、LOS誤差には含めない解釈が自然である。

一方で、STT観測基準に対するLCT光軸ずれをより明示的に見るなら、LCT回転からSTT回転を差し引く定義も有用である。

```text
STT-relative LOS = centerline tilt + (LCT rotation - STT rotation)
```

使い分け:

- global/inertial基準のLCT光軸ずれ: `centerline tilt + LCT rotation`
- STT観測基準のLCT相対ずれ: `centerline tilt + (LCT rotation - STT rotation)`

PATや星センサ基準の補正に接続する場合は、後者も比較用に出しておくとよい。

## Current Observation

`260629_1505_translation_rotation.xlsx` の結果では、LCT面/LOS軸の回転が合算LOS角度に強く効いている。

概略値:

- STT-LCT重心線の傾き: 約 `200 urad`
- LCT回転由来の角度: 約 `475 urad`
- 現在定義の合算LOS角: 約 `680 urad`

したがって、重心点の相対変位だけでは熱LOS角度誤差を過小評価する可能性が高い。
