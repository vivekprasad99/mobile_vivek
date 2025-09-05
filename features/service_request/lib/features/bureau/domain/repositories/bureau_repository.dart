import 'dart:io';
import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:loan/features/foreclosure/data/models/get_loans_request.dart';
import 'package:loan/features/foreclosure/data/models/get_loans_response.dart';
import 'package:service_request/features/bureau/data/models/bureau_response.dart';
import 'package:service_request/features/bureau/data/models/dedupe_request.dart';
import 'package:service_request/features/bureau/data/models/dedupe_response.dart';
import 'package:service_request/features/bureau/data/models/get_preset_uri_request.dart';
import 'package:service_request/features/bureau/data/models/get_preset_uri_response.dart';
import 'package:service_request/features/bureau/data/models/loan_payment_request.dart';
import 'package:service_request/features/bureau/data/models/loan_payment_response.dart';
import 'package:service_request/features/bureau/data/models/reason_response.dart';

abstract class BureauRepository {
  Future<Either<Failure, BureauResponse>> getBureaus();

  Future<Either<Failure, ReasonResponse>> getReason();

  Future<Either<Failure, GetPresetUriResponse>> getPresetUri(
      GetPresetUriRequest req);

  Future<Either<Failure, String>> uploadDocument(String presetUri, File file);

  Future<Either<Failure, String>> deleteDocument(String presetUri);

  Future<Either<Failure, GetLoansResponse>> getLoans(
      GetLoansRequest getLoansRequest);

  Future<Either<Failure, DedupeResponse>> getDedupeCheck(
     DedupeRequest dedupeRequest);
  Future<Either<Failure, PaymentResponse>> getLoanPayment(
     PaymentRequest paymentRequest);
}
