# Femap STT-LCT LOS Angle Definition

## Purpose

TDでマッピングした温度分布をFemapで熱ひずみ解析し、STTとLCTの代表節点からPAT用の熱LOS角度誤差を作る。

対象データ:

- `src/thermal_deformation/data_femap_deformation/260629_1505_translation_rotation.xlsx`
- `src/thermal_deformation/data_femap_deformation/stt_lct_node_config.json`
- `src/thermal_deformation/plot_stt_lct_relative_deformation.py`

座標系の前提:

- `+Z`: STT / PZ side
- `-Z`: LCT / MZ side
- nominal LOS direction: `STT -> LCT = -Z`

## LOS Definitions

コードでは、LOS角度を2つの基準で分けて出す。

```text
global LOS
    = STT-LCT centerline tilt + LCT local-axis rotation

STT-relative LOS
    = STT-LCT centerline tilt + (LCT local rotation - STT local rotation)
```

`global_los_angle_*` は、ひずむ前のglobal/CAD座標系でLCT光軸がどれだけずれたかを見る定義である。

`stt_relative_los_angle_*` は、STT観測面を基準座標系として、その基準からLCT光軸がどれだけ相対的にずれたかを見る定義である。PATや星センサ基準の補正に接続する場合は、こちらを主に使う可能性が高い。

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

この2つを足して正規化したものを、global基準のLOS方向としている。

```text
global_los_direction =
    unit(u0 + centerline_change + lct_rotation_change)

global_los_angle =
    global_los_direction - u0
```

STT観測基準で見る場合は、LCT回転からSTT回転を差し引いた相対回転を使う。

```text
relative_rotation_change =
    rotate(u0, LCT_rotation - STT_rotation) - u0

stt_relative_los_direction =
    unit(u0 + centerline_change + relative_rotation_change)

stt_relative_los_angle =
    stt_relative_los_direction - u0
```

CSV列の対応:

- `centerline_angle_x/y/z_urad`: 並進変位から来るSTT-LCT重心線の傾き
- `stt_rotation_angle_x/y/z_urad`: STT面/LOS軸をSTT回転DOFで回したときの傾き
- `lct_rotation_angle_x/y/z_urad`: LCT面/LOS軸の回転から来る傾き
- `relative_rotation_angle_x/y/z_urad`: STT基準で見たLCT面/LOS軸の相対回転
- `global_los_angle_x/y/z_urad`: `centerline + LCT rotation`
- `global_los_angle_magnitude_urad`: `global_los_angle` の `x-y` 成分ノルム
- `stt_relative_los_angle_x/y/z_urad`: `centerline + (LCT rotation - STT rotation)`
- `stt_relative_los_angle_magnitude_urad`: `stt_relative_los_angle` の `x-y` 成分ノルム

## STT Rotation Treatment

STTも熱ひずみによって回転する。ただし、STT観測面を基準面にする場合、STT自身の回転は基準座標系の回転として扱うため、LOS誤差には含めない解釈が自然である。

STT観測基準に対するLCT光軸ずれを見るなら、LCT回転からSTT回転を差し引く。

```text
STT-relative LOS = centerline tilt + (LCT rotation - STT rotation)
```

使い分け:

- global/inertial基準のLCT光軸ずれ: `centerline tilt + LCT rotation`
- STT観測基準のLCT相対ずれ: `centerline tilt + (LCT rotation - STT rotation)`

PATや星センサ基準の補正に接続する場合は、後者を主定義にする可能性が高い。ただし、global基準の値も残しておくと、STT自体の回転でどれだけ相殺されるかを確認できる。

## Current Observation

`260629_1505_translation_rotation.xlsx` の結果では、LCT面/LOS軸の回転が合算LOS角度に強く効いている。

概略値:

- STT-LCT重心線の傾き: 約 `200 urad`
- STT回転由来の角度: 約 `24 urad`
- LCT回転由来の角度: 約 `475 urad`
- global基準の合算LOS角: 約 `680 urad`
- STT観測基準の合算LOS角: 約 `665 urad`

したがって、重心点の相対変位だけでは熱LOS角度誤差を過小評価する可能性が高い。
