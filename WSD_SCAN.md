# Сканирование Kyocera через WSD/SOAP — находки и рабочие рецепты

Дата: 2026-09-24, дополнено 30.09.2026 (ADF/дуплекс, извлечение JPEG),
07.10.2026 (каприз №11: перестановка Width/Height для ADF — полный A4).
Устройства: **Kyocera ECOSYS M2040dn** (192.168.0.247),
**Kyocera ECOSYS M3550idn** (192.168.0.135), **Kyocera ECOSYS M2735dn** (192.168.0.249).

Сетевая карта устройств (WS-Discovery, 30.09.2026): 192.168.0.90 = M2035dn,
192.168.0.188 = M3145dn, 192.168.0.40 = P5026cdn (принтер без сканера),
192.168.0.249 = M2735dn, 192.168.0.135 = M3550idn.
**M2735dn: двустороннее сканирование НЕ работает** (проверено 30.09 живым тестом
дважды: AdfDuplex и Adf+MediaSides — заявки принимаются, MediaBackImageInfo
присутствует в ответе, но оборот листа не сканируется, PDF всегда 1 страница).
Согласуется с офиц. спецификацией Kyocera (у M2735dn нет дуплекс-строки скорости
сканирования; у старого M2035dn и у M2040dn — есть). Для дуплекса использовать
M2040dn (192.168.0.247). Профиль WSD M2735dn тот же фиксированный (200 dpi, PDF/A). Цель: сканирование документов в архив
с автоматизацией (D-приложение / скрипты).

---

## 1. Сравнение каналов сканирования

| Канал | M2040dn | M3550idn | Комментарий |
|---|---|---|---|
| TWAIN (Kyocera TWAIN Driver 3.2.0512 + VueScan) | ✅ работает | ✅ | DS: `C:\Windows\twain_32\KMTWAIN\kcTwain03DS.ds`; настройка сети: `C:\Windows\twain_32\twn_drvr_sttngs\TwainDriverSettings.exe` (поиск/добавление по IP) |
| WIA поверх WSD (классический драйвер Windows) | ❌ «устройство занято» | ❌ тот же глюк | Встроенный WSD-драйвер Windows некорректно работает с Kyocera — устройство задания принимает, а драйвер отчитывается «занято». **Не лечится** перезапуском stisvc/МФУ |
| eSCL (`http://ip/eSCL/...`) | ❌ HTTP 500 | ✅ работает | На M2040dn eSCL не работает (прошивка); на M3550idn — работает, первый вызов может дать 500 («прогрев»), со второго — ок |
| **Прямой WSD/SOAP (WS-Scan)** | ✅ **работает**, ADF/дуплекс ✅ | ✅ | Три HTTP-запроса, без драйверов и COM. **Рекомендуемый путь** |

**Вывод:** для автоматизации используем прямой WSD/SOAP. WIA не подходит
(глючный драйвер Windows для обоих Kyocera).

## 2. Настройки M2040dn (Command Center RX, http://192.168.0.247)

Что было включено (применяется только после перезагрузки МФУ!):

- **Сеть → Протоколы**: SSL = Вкл; WSD = Вкл; **WSD-Сканирование = Вкл**; eSCL = Вкл.
- **Сеть → Безопасность (SSL)**: TLS1.2, AES, SHA2; «Базов. HTTP» = «HTTP или HTTPS»
  (чтобы веб-морда не уехала на самоподписанный сертификат); «Enhanced WSD» = «SSL и Enhanced WSD».
- **Система → Энергосбережение**: **Уровень сна = «Быстрое восстан.»** (НЕ «Эконом. энергии» —
  в глубоком сне служба WSD отвечает на SOAP, но отказывает в заданиях «NotAcceptingJobs»);
  Счетчик режима ожидания = 60 мин.
- **Панель МФУ → Системное меню → Функция** → включить **«Сканирование WSD»**
  (без этого служба анонсируется, но задания блокируются — включали в последнюю очередь,
  после этого CreateScanJob стал проходить).

Диагностические признаки состояний:

- Спящий МФУ: WSD UDP-проба (3702) молчит, WIA = «занято», но ping/HTTP/SOAP могут отвечать.
- «Функция WSD» выключена: UDP-проба отвечает `scan:ScanDeviceType`, SOAP жив,
  но CreateScanJob → `scan:ServerErrorNotAcceptingJobs`.

## 3. Рабочая цепочка WSD-сканирования (проверена, PDF получен)

Служба сканера: `http://192.168.0.247:5358/WSDScanner` (WS-Scan,
namespace `http://schemas.microsoft.com/windows/2006/08/wdp/scan`).
Адрес на M3550idn аналогичный (порт 5358). UUID устройства берётся из
`Get-PnpDevice` (`SWD\DAFWSDPROVIDER\UUID:...`), для M2040dn:
`4509a320-0054-0070-00e0-0025074f740d`.

### Шаг 0 (опционально) — метаданные устройства

`POST http://192.168.0.247:5358/DeviceService/`, WS-Transfer Get,
`wsa:To = uuid:4509a320-0054-0070-00e0-0025074f740d`
(если To = URL — будет Fault `DestinationUnreachable`).
В ответе `<devprof:Hosted>` → XAddr службы сканера.

### Шаг 1 — CreateScanJob

`POST http://192.168.0.247:5358/WSDScanner`:

```xml
<s:Envelope xmlns:s="http://www.w3.org/2003/05/soap-envelope"
            xmlns:wsa="http://schemas.xmlsoap.org/ws/2004/08/addressing"
            xmlns:scan="http://schemas.microsoft.com/windows/2006/08/wdp/scan">
  <s:Header>
    <wsa:Action>http://schemas.microsoft.com/windows/2006/08/wdp/scan/CreateScanJob</wsa:Action>
    <wsa:MessageID>urn:uuid:...уникальный...</wsa:MessageID>
    <wsa:To>http://192.168.0.247:5358/WSDScanner</wsa:To>
  </s:Header>
  <s:Body>
    <scan:CreateScanJobRequest>
      <scan:ScanTicket>
        <scan:JobDescription>
          <scan:JobName>ArchScan</scan:JobName>
          <scan:JobOriginatingUserName>sqlm</scan:JobOriginatingUserName>
        </scan:JobDescription>
        <scan:DocumentParameters>
          <scan:Format>scan:Jpeg</scan:Format>            <!-- устройство может переопределить -->
          <scan:ImagesToTransfer>1</scan:ImagesToTransfer>
          <scan:InputSource>Platen</scan:InputSource>      <!-- Adf для автоподатчика -->
          <scan:ContentType>Auto</scan:ContentType>
          <scan:InputSize>
            <scan:InputMediaSize>
              <scan:Width>8270</scan:Width><scan:Height>11690</scan:Height>  <!-- A4, 1/1000 дюйма -->
            </scan:InputMediaSize>
            <scan:DocumentSizeAutoDetect>true</scan:DocumentSizeAutoDetect>
          </scan:InputSize>
          <scan:Resolution><scan:Width>300</scan:Width><scan:Height>300</scan:Height></scan:Resolution>
        </scan:DocumentParameters>
      </scan:ScanTicket>
    </scan:CreateScanJobRequest>
  </s:Body>
</s:Envelope>
```

Ответ: `JobId` (int), `JobToken` (GUID), `DocumentFinalParameters` — **устройство
может переопределить параметры** (M2040dn вернул Format=pdf-a, 200 dpi, ColorProcessing=RGB24).

### Шаг 2 — пауза (~15 с)

Планшетное сканирование занимает несколько секунд; RetrieveImage до готовности —
не проверено, безопасно подождать 15 с.

### Шаг 3 — RetrieveImage  ← КЛЮЧЕВОЙ МОМЕНТ

`POST` на тот же endpoint. **Обязательны JobId + JobToken + DocumentDescription**
— без `DocumentDescription` устройство возвращает Fault `scan:InvalidArgs`
(это было причиной неудач, пока не добавили):

```xml
<scan:RetrieveImageRequest>
  <scan:JobToken>GUID-из-CreateScanJob</scan:JobToken>
  <scan:JobId>268435463</scan:JobId>
  <scan:DocumentDescription>
    <scan:DocumentName>scan</scan:DocumentName>
  </scan:DocumentDescription>
</scan:RetrieveImageRequest>
```

Ответ: HTTP 200, **multipart/related**: первая часть — SOAP-конверт
(`RetrieveImageResponse`), вторая часть — `application/octet-stream` — само изображение
(в нашем случае PDF/A: искать `%PDF` … `%%EOF`).

### Шаг 4 — автоподатчик: многостраничный PDF и страничные JPG (30.09.2026)

**Ключевое свойство M2040dn: одно задание = весь лоток = один многостраничный PDF.**
`RetrieveImage` отдаёт сразу весь документ (все страницы всех листов). Проверено:
2 двусторонних листа → один PDF на 4 страницы (по 1 JPEG 1700×1654 RGB на страницу).

Запуск (утилита `apps/wsd_scan/scan.exe`, префикс файлов — второй аргумент):

```
scan.exe 192.168.0.247 D:\batch\doc AdfDuplex    # двусторонне, весь лоток
scan.exe 192.168.0.247 D:\batch\doc Adf          # односторонне
```

Результат: **`D:\batch\doc_001.pdf` — многостраничный PDF со всеми страницами лотка.**
(Утилита затем пытается создать второе задание и получает `NotAcceptingJobs` —
это «откат» после задания, см. каприз №9; сообщение «ИТОГО: 1 страниц» означает
«1 файл = весь лоток», а не одну страницу.)

**Страничные JPG из многостраничного PDF** — модульная функция `pdfExtractJpegs`
(Kyocera кладёт страницы в PDF как потоки `/Subtype /Image` + `/Filter /DCTDecode`,
т.е. обычные JPEG, их можно вытащить без декодирования):

```d
import std.file : read, write;
import wsd_scan;

auto pdf = cast(ubyte[]) read("D:/batch/doc_001.pdf");
int n = pdfExtractJpegs(pdf, "D:/batch/doc");
// → D:/batch/doc_001.jpg ... doc_00N.jpg (по одному JPEG на страницу)
```

Проверено вживую: 4-страничный PDF → 4 валидных JPEG 1700×1654; unittest на
синтетическом PDF есть (`build.bat test`).

В XML задания для дуплекса добавляется `<scan:InputSource>AdfDuplex</scan:InputSource>`
и блок `<scan:MediaSides>` (MediaFront + MediaBack с ScanRegion) — пример в
`wsd_scan.d` (`wsdCreateScanJob`). `InputSource` устройство ЧЕСТНО применяет
(в отличие от dpi/формата, см. каприз №7).

### Прочие операции WS-Scan

- `GetActiveJobs` — список заданий (пусто, даже когда служа «заблокирована»; для
  диагностики малоинформативно).
- `GetScannerElements` (ScannerStatus/ScannerDescription) — **M2040dn возвращает
  пустой `<scan:ScannerElements/>`** — не использовать для опроса готовности.
- WS-Discovery-проба (UDP 3702 → 239.255.255.250) — на M2040dn работает только
  «на свежую» загрузку; в рабочем режиме устройство на неё не отвечает, на связность
  не ориентироваться. Юникаст-проба на порт 3702 устройства — молчит всегда.

## 4. Известные капризы M2040dn

1. **Sleep**: глубокий сон («Эконом. энергии») = отказ в заданиях. Режим «Быстрое
   восстан.» обязателен для автоматизации.
2. **Таймер задания WSD** (настройка «Таймер сканирования веб-служб…» = 140 с по
   умолчанию) — задание отменяется, если RetrieveImage не успел; получать сразу.
3. **Формат вывода определяет устройство (вернуло PDF/A).**
4. eSCL на этой прошивке мёртв (500) — не использовать.
5. Классический WIA-драйвер Windows для него бесполезен («устройство занято» всегда).
6. Если после серии экспериментов «всё сломалось» (включая TWAIN) — помогает
   перезагрузка МФУ (зависание подсистемы сканирования).
7. **WSD-сканирование — почти фиксированный профиль (проверено 29–30.09.2026).**
   Устройство игнорирует: dpi (всегда 200), Scaling (всегда 100%), ContentType
   (Auto/Photo), Format (`scan:ExifJpeg`/`scan:PdfA`/`scan:Jpeg` — всегда PDF/A).
   **ИСКЛЮЧЕНИЕ: `InputSource` ЧЕСТНО применяется** — `Platen` / `Adf` / `AdfDuplex`
   работают как запрошено (для дуплекса нужен блок `MediaSides` в билете).
   Максимум устройства (600 dpi) доступен ТОЛЬКО через TWAIN-драйвер Kyocera.
8. **Одно задание = весь лоток.** При `ImagesToTransfer=999` устройство сканирует
   весь автоподатчик и отдаёт ВСЁ одним многостраничным PDF в одном RetrieveImage.
   `ImagesToTransfer=0` трактуется как «одна страница».
9. **«Откат» после задания:** следующий CreateScanJob в течение ~20–60 с после
   завершения предыдущего получает `scan:ServerErrorNotAcceptingJobs`. Для серии
   пакетов — пауза между заданиями ~60 с.
10. Конец лотка при заборе страниц (если задание всё же закончилось): RetrieveImage
    → `scan:ClientErrorNoImagesAvailable` («The server has no images available»).
11. **ADF: устройство трактует Width/Height области НАОБОРОТ** (живые пробы 2026-10,
    M2040dn). Билет с A4 «как положено» (`InputMediaSize`/`ScanRegion` = 8270×11690)
    даёт скан **216×210 мм** (MediaBox 612.0×595.44 pt) — ширина прижимается к
    максимуму автоподатчика 8.5″, высота обрезается до 8.27″. Билет с
    **переставленными** размерами (11690×8270) даёт полный **A4 210×297 мм**
    (MediaBox 595.2×841.68 pt). VueScan/TWAIN обрезает так же — это прошивка,
    а не софт. В `wsd_scan.d` перестановку делает `ScanSettings.swapAdfWH`
    (по умолчанию вкл, только для Adf/AdfDuplex). Флаг `DocumentSizeAutoDetect`
    устройство игнорирует в обоих положениях (проверено теми же пробами).

## 5. Артефакты

- `apps/wsd_scan/` — **готовый D-модуль сканирования**: `wsd_scan.d` (WinINet,
  без зависимостей; функции `wsdCreateScanJob` / `wsdRetrieveImage` / `wsdScanToFile` /
  `wsdScanBatch` / `pdfExtractJpegs` / `wsdExtForFormat`), `scan_main.d` (утилита `scan.exe`),
  `build.bat` (`build.bat test` — unittest'ы).
  Проверено вживую на M2040dn: планшет → PDF (29.09), ADF-дуплекс → многостраничный PDF
  + извлечение 4 JPEG (30.09).
- `D:\batch\doc_001.pdf` — многостраничный ADF-дуплекс-результат (4 стр., 30.09);
  `D:\batch\doc_001..004.jpg` — те же страницы отдельными JPEG (1700×1654 RGB).
- `D:\scan_wia.vbs` — скрипт WIA-сканирования (работает на M3550idn через eSCL-запись
  WIA: `cscript scan_wia.vbs "M3550idn (2)" D:\out.jpg`; на M2040dn не работает —
  см. п.1).
- `D:\wsd_createjob.xml`, `wsd_retrieve.xml`, `wsd_jobs.xml`, `wsd_get.xml`,
  `wsd_status.xml` — шаблоны SOAP-запросов.
- `D:\scan_2040_wsd.pdf` — результат WSD-сканирования через curl (PDF/A, 132 КБ).
- `D:\scan_d_module.pdf` — результат сканирования модулем `wsd_scan.d` (99 КБ).
- `D:\scan_3550.jpg` — результат WIA/eSCL со M3550idn.

## 6. Следующие шаги (не сделано)

- [x] ADF-режим (`Adf` / `AdfDuplex`) — работает: одно задание = весь лоток =
      один многостраничный PDF (см. «Шаг 4»). Проверено 30.09.
- [ ] CLI-флаг для `scan.exe`: извлечение JPG из PDF после пакета (сейчас — только API `pdfExtractJpegs`)
      и рефакторинг `wsdScanBatch` под схему «одно задание → PDF → JPG».
- [x] D-модуль `wsd_scan.d` — **готов** (`apps/wsd_scan/`), HTTP через WinINet,
      без COM/OLE/WIA. Проверен на M2040dn.
- [ ] Плёнка 35 мм: только TWAIN-путь (макс. 600 dpi оптических; кадр ≈570×850 px)
      + инверсия негатива программно. VueScan для этого подходит идеально
      (встроенные профили цветных негативов). Автоматизация — через D-клиент
      TWAIN (большая задача) или CLI-обёртку.
