# python3 process_2.py

import quick_proj
import quick_io
import numpy as np

# 前の処理で作成した output ファイルからも入力する
constelIds = quick_io.read('input/constel-ids.json')
rawNames = quick_io.read('input/raw-constel-names.json')
rawLatlongLines = quick_io.read('output/constel-lines-latlong.json')

# filter
# x = [it for it in _LIST_ if it["xxx"] == xxx]
# map
# x = list(map(lambda it: it["xxx"], _LIST_))

outputLines = []
outputStars = []
outputNames = []

for constelId in constelIds:
    latlongLines = [it for it in rawLatlongLines if it["abbr"] == constelId]

    # 経度 -90より 西の星たち
    westernA = [it for it in latlongLines if float(it["startLong"]) < -90]
    westernB = [it for it in latlongLines if float(it["endLong"]) < -90]
    westarn = westernA + westernB
    # 経度 90より 東の星たち
    easternA = [it for it in latlongLines if float(it["startLong"]) > 90]
    easternB = [it for it in latlongLines if float(it["endLong"]) > 90]
    eastern = easternA + easternB
    # 東西に星が分裂しているとき どちらかに寄せる移動が必要
    needMove = (len(westarn) > 0) and (len(eastern) > 0)

    points = []
    lines = []
    for lll in latlongLines:
        staLat = float(lll["startLat"])
        staLong = float(lll["startLong"])
        endLat = float(lll["endLat"])
        endLong = float(lll["endLong"])

        # 地上からの見え方へ直すため 反転させる
        staLat = -staLat
        staLong = -staLong
        endLat = -endLat
        endLond = -endLong

        if (needMove):
            if (constelId == "Psc"):
                # うお座のみ特別に処理
                # 東へ移動
                if (staLong < 0):
                    staLong = staLong + 360
                if (endLond < 0):
                    endLond = endLond + 360
            else:
                # 西へ移動
                if (staLong > 0):
                    staLong = staLong - 360
                if (endLond > 0):
                    endLond = endLond - 360

        # Lat,Long --> X,Y
        staX, staY = quick_proj.proj_to_moll(staLat, staLong)
        endX, endY = quick_proj.proj_to_moll(endLat, endLond)

        # 見栄えのため縦に伸ばす
        staY = staY * 2
        endY = endY * 2

        # 点を記録
        points.append(staX, staY)
        points.append(endX, endY)

        # 線を記録
        lines.append({
            "constel_id": constelId,
            "start_x": np.round(staX, 4),
            "start_y": np.round(staY, 4),
            "end_x": np.round(endX, 4),
            "end_y": np.round(endY, 4),
        })

    # 点の重複削除
    points = list(set(points))

    # アプトプットに線を追加
    outputLines = outputLines + lines

    stars = []
    for point in points:
        # 星を作成
        stars.append({
            "constel_id": constelId,
            "x": np.round(point[0], 4),
            "y": np.round(point[1], 4),
            "grade": 1,
            "name": "",
        })

    # 星を追加
    outputStars = outputStars + stars

    # 最大最小のxyを探す
    xList = list(map(lambda it: float(it[0]), points))
    yList = list(map(lambda it: float(it[1]), points))
    minX = min(xList)
    maxX = max(xList)
    minY = min(yList)
    maxY = max(yList)
    cenX = (minX + maxX) / 2.
    cenY = (minY + maxY) / 2.
    inName = [it for it in rawNames if it["constel_id"] == constelId][0]

    # 星座を追加
    outputNames.append({
        "constel_id": constelId,
        "x": np.round(cenX, 4),
        "y": np.round(cenY, 4),
        "jp": inName["jp"],
    })

quick_io.write('output/constel-names.json', outputNames)
quick_io.write('output/constel-lines.json', outputLines)
quick_io.write('output/constel-stars.json', outputStars)
