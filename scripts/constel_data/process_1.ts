// deno run --allow-all latlng2xy.ts

async function run() {
  const rawLinesPath = new URL("./raw-constel-lines.txt", import.meta.url);
  const rawLinesText: string = await Deno.readTextFile(rawLinesPath);
  const rawStarsPath = new URL("./raw-constel-stars.csv", import.meta.url);
  const rawStarsText: string = await Deno.readTextFile(rawStarsPath);

  var lineRecords = rawLinesText.split("\n");
  // 空の行を削除
  lineRecords = lineRecords.filter((it) => it != "");

  const hipLines: { constel_id: string; sta: number; end: number }[] = [];
  for (const record of lineRecords) {
    const values = record.split(" ");

    // 1列目は 星座ID
    const constel_id = values[0];
    // 2列目は 線の数
    const lineCount = parseInt(values[1]);
    const lineCountRange = Array.from(Array(lineCount).keys());
    // 3列目以降は HIP 番号 (始点 終点 の交互)
    const hips = values.slice(2, values.length);

    for (const lineIndex of lineCountRange) {
      const staIndex = lineIndex * 2;
      const endIndex = lineIndex * 2 + 1;
      const sta = parseInt(hips[staIndex]);
      const end = parseInt(hips[endIndex]);
      hipLines.push({
        constel_id: constel_id,
        sta: sta,
        end: end,
      });
    }
  }

  var starRecords = rawStarsText.split("\n");
  // 空の行を削除
  starRecords = starRecords.filter((it) => it != "");
  // ループが多いため 先に分割しておく
  const starRecordValues = starRecords.map(function (star) {
    return star.split(",");
  });

  const outputLines: {
    constel_id: string;
    startLat: number;
    startLong: number;
    endLat: number;
    endLong: number;
  }[] = [];

  for (const hipLine of hipLines) {
    const staStar = starRecordValues.find(
      (values) => parseInt(values[0]) == hipLine.sta
    );
    const endStar = starRecordValues.find(
      (values) => parseInt(values[0]) == hipLine.end
    );

    if (staStar == undefined || endStar == undefined) {
      console.log("対応する星が見つかりませんでした");
    }

    // スタート赤経の時分秒
    const staH = parseFloat(staStar![1]);
    const staM = parseFloat(staStar![2]);
    const staS = parseFloat(staStar![3]);
    const staLong =
      staH * 15.0 + staM * (15.0 / 60.0) + staS * (15.0 / 3600.0) - 180.0;
    // エンド赤経の時分秒
    const endH = parseFloat(endStar![1]);
    const endM = parseFloat(endStar![2]);
    const endS = parseFloat(endStar![3]);
    const endLong =
      endH * 15.0 + endM * (15.0 / 60.0) + endS * (15.0 / 3600.0) - 180.0;

    // スタート赤緯の度分秒
    const staA = parseFloat(staStar![5]);
    const staB = parseFloat(staStar![6]);
    const staC = parseFloat(staStar![7]);
    var staLat = staA + staB / 60.0 + staC / 3600.0;
    if (parseInt(staStar![4]) === 0) {
      staLat = staLat * -1;
    }
    // スタート赤緯の度分秒
    const endA = parseFloat(endStar![5]);
    const endB = parseFloat(endStar![6]);
    const endC = parseFloat(endStar![7]);
    var endLat = endA + endB / 60.0 + endC / 3600.0;
    if (parseInt(endStar![4]) === 0) {
      endLat = endLat * -1;
    }

    outputLines.push({
      constel_id: hipLine.constel_id,
      startLat: staLat,
      startLong: staLong,
      endLat: endLat,
      endLong: endLong,
    });
  }

  // write file
  const outputText = JSON.stringify(outputLines, null, 2);
  const outputPath = new URL(
    "./output/constel-lines-latlong.json",
    import.meta.url
  );
  const outputOption = { append: false, create: true };
  await Deno.writeTextFile(outputPath, outputText, outputOption);
}

await run();
