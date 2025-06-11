import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  // Barcode? result;
  // QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.

  // BarcodeCapture? barcode;
  // late final MobileScannerController controller;
  bool isStarted = true;

  @override
  void initState() {
    super.initState();
    /*  controller = MobileScannerController(
      torchEnabled: false,
      // formats: [BarcodeFormat.qrCode]
      // facing: CameraFacing.front,
      // detectionSpeed: DetectionSpeed.normal
      // detectionTimeoutMs: 1000,
      // returnImage: false,
    );*/
    // controller.start();
  }

  @override
  void reassemble() {
    super.reassemble();
    // if (Platform.isAndroid) {
    //   controller!.pauseCamera();
    // }
    // controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    var size = (MediaQuery.of(context).size.width < 300 ||
            MediaQuery.of(context).size.height < 300)
        ? 200.0
        : 300.0;
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(Offset.zero),
      width: size,
      height: size,
    );
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            // _buildQrView(context, scanWindow),
            InkWell(
                onTap: () {
                  Get.back();
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(14, 18, 0, 0),
                  child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white38,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      width: 32,
                      height: 32,
                      child: const Icon(
                        Icons.close,
                        size: 24,
                      )),
                )),
            /*  ValueListenableBuilder(
              valueListenable: controller,
              builder: (context, value, child) {
                if (!value.isInitialized ||
                    !value.isRunning ||
                    value.error != null) {
                  return const SizedBox();
                }

                return CustomPaint(
                  painter: ScannerOverlay(scanWindow: scanWindow),
                );
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: PrimaryTextView(
                  text: 'scan_barcode_note'.tr,
                  color: Colors.white,
                  fontSize: 13,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
            )*/
          ],
        ),
      ),
    );
  }

/*Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 400.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }*/

/*  Widget _buildQrView(BuildContext context, Rect scanWindow) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 300 ||
            MediaQuery.of(context).size.height < 300)
        ? 200.0
        : 300.0;

    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return MobileScanner(
      controller: controller,
      scanWindow: scanWindow,
      errorBuilder: (
        BuildContext context,
        MobileScannerException error,
        Widget? child,
      ) {
        return ScannerErrorWidget(error: error);
      },
      fit: BoxFit.cover,
      onDetect: (BarcodeCapture barcode) {
        print("onDetect");
        this.controller.dispose();
        setState(() {
          final barcodes = barcode.barcodes;
          String code = "";
          if (barcodes.isNotEmpty) {
            code = barcodes[0].rawValue ?? "";
            print("barcode_list:${barcodes[0].rawValue ?? ""}");
          }
          // controller.dispose();
          // this.barcode_list = barcode_list;
          Get.back(result: code);
        });
      },
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      // this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      Get.back(result: scanData.code);
      this.controller.dispose();
      // setState(() {
      //   result = scanData;
      // });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    print('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class ScannerErrorWidget extends StatelessWidget {
  const ScannerErrorWidget({super.key, required this.error});

  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    String errorMessage;

    switch (error.errorCode) {
      case MobileScannerErrorCode.controllerUninitialized:
        errorMessage = 'Controller not ready.';
        break;
      case MobileScannerErrorCode.permissionDenied:
        errorMessage = 'Permission denied';
        break;
      default:
        errorMessage = 'Generic Error';
        break;
    }

    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Icon(Icons.error, color: Colors.white),
            ),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class ScannerOverlay extends CustomPainter {
  const ScannerOverlay({
    required this.scanWindow,
    this.borderRadius = 8.0,
  });

  final Rect scanWindow;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: use `Offset.zero & size` instead of Rect.largest
    // we need to pass the size to the custom paint widget
    final backgroundPath = Path()..addRect(Rect.largest);

    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          scanWindow,
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      );

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    final borderPaint = Paint()
      ..color = defaultAccentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final borderRect = RRect.fromRectAndCorners(
      scanWindow,
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
      bottomLeft: Radius.circular(borderRadius),
      bottomRight: Radius.circular(borderRadius),
    );

    // First, draw the background,
    // with a cutout area that is a bit larger than the scan window.
    // Finally, draw the scan window itself.
    canvas.drawPath(backgroundWithCutout, backgroundPaint);
    canvas.drawRRect(borderRect, borderPaint);
  }

  @override
  bool shouldRepaint(ScannerOverlay oldDelegate) {
    return scanWindow != oldDelegate.scanWindow ||
        borderRadius != oldDelegate.borderRadius;
  }*/
}
