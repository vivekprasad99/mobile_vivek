


import 'package:core/config/network/certificate_pinning.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

class LiveDomainPinning extends CertificatePinning {

  @override
  loadCertificate(Dio dio) async {
    ByteData bytes = await rootBundle.load('assets/certify/certificateone.pem');
    super.certificatePin(dio, bytes);
  }
}



