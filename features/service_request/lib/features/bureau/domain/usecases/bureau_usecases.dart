import 'dart:io';

import 'package:core/config/error/failure.dart';
import 'package:core/config/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:loan/features/foreclosure/data/models/get_loans_request.dart';
import 'package:loan/features/foreclosure/data/models/get_loans_response.dart';
import 'package:service_request/features/bureau/data/models/bureau_response.dart';
import 'package:service_request/features/bureau/data/models/dedupe_request.dart';
import 'package:service_request/features/bureau/data/models/dedupe_response.dart';
import 'package:service_request/features/bureau/data/models/get_preset_uri_request.dart';
import 'package:service_request/features/bureau/data/models/get_preset_uri_response.dart';
import 'package:service_request/features/bureau/data/models/loan_payment_response.dart';
import 'package:service_request/features/bureau/data/models/reason_response.dart';
import 'package:service_request/features/bureau/domain/repositories/bureau_repository.dart';

import '../../data/models/loan_payment_request.dart';

class BureauUseCase extends UseCase<BureauResponse, NoParams> {
  final BureauRepository repository;

  BureauUseCase({required this.repository});

  @override
  Future<Either<Failure, BureauResponse>> call(NoParams params) async {
    return await repository.getBureaus();
  }

  Future<Either<Failure, GetLoansResponse>> getLoan(
      GetLoansRequest params) async {
    return await repository.getLoans(params);
  }

  Future<Either<Failure, ReasonResponse>> getReason() async {
    return await repository.getReason();
  }

  Future<Either<Failure, GetPresetUriResponse>> getPresetUri(
      GetPresetUriRequest req) async {
    return await repository.getPresetUri(req);
  }

  Future<Either<Failure, String>> uploadDocument(
      String presetUrl, File file) async {
    return await repository.uploadDocument(presetUrl, file);
  }

  Future<Either<Failure, String>> deleteDocument(String presetUrl) async {
    return await repository.deleteDocument(presetUrl);
  }


  Future<Either<Failure, DedupeResponse>> getDedupeCheck(
      DedupeRequest params) async {
    return await repository.getDedupeCheck(params);
  }
  Future<Either<Failure, PaymentResponse>> getLoanPayment(
      PaymentRequest params) async {
    return await repository.getLoanPayment(params);
  }

}
