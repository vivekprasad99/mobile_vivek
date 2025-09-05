
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/services.dart';


abstract class CertificatePinning{

  loadCertificate(Dio dio);

  certificatePin(Dio dio,ByteData cerData)
  {
    (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate  = (client) {
      SecurityContext sc =SecurityContext();
      sc.setTrustedCertificatesBytes(cerData.buffer.asUint8List());
      HttpClient httpClient =HttpClient(context: sc);
      return httpClient;
    };
  }

}