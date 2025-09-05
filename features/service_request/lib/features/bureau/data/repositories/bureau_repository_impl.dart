import 'dart:io';
import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:loan/features/foreclosure/data/models/get_loans_request.dart';
import 'package:loan/features/foreclosure/data/models/get_loans_response.dart';
import 'package:service_request/features/bureau/data/datasource/bureau_datasource.dart';
import 'package:service_request/features/bureau/data/models/dedupe_request.dart';
import 'package:service_request/features/bureau/data/models/dedupe_response.dart';
import 'package:service_request/features/bureau/data/models/get_preset_uri_request.dart';
import 'package:service_request/features/bureau/data/models/get_preset_uri_response.dart';
import 'package:service_request/features/bureau/data/models/loan_payment_request.dart';
import 'package:service_request/features/bureau/data/models/loan_payment_response.dart';
import 'package:service_request/features/bureau/data/models/reason_response.dart';
import 'package:service_request/features/bureau/domain/repositories/bureau_repository.dart';
import '../models/bureau_response.dart';

class BureauRepositoryImpl extends BureauRepository {
  BureauRepositoryImpl({required this.datasource});

  final BureauDataSource datasource;

  @override
  Future<Either<Failure, BureauResponse>> getBureaus() async {
    final result = await datasource.getBureaus();
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, ReasonResponse>> getReason() async {
    final result = await datasource.getReason();
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, GetPresetUriResponse>> getPresetUri(
      GetPresetUriRequest req) async {
    final result = await datasource.getPresetUri(req);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, String>> uploadDocument(
      String presetUri, File file) async {
    final result = await datasource.uploadDocument(presetUri, file);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, String>> deleteDocument(String presetUri) async {
    final result = await datasource.deleteDocuments(presetUri);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, GetLoansResponse>> getLoans(
      GetLoansRequest getLoansRequest) async {
    final result = await datasource.getLoans(getLoansRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, DedupeResponse>> getDedupeCheck(
      DedupeRequest dedupeRequest) async {
    final result = await datasource.getDedupeCheck(dedupeRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, PaymentResponse>> getLoanPayment(
      PaymentRequest paymentRequest) async {
    final result = await datasource.getLoanPayment(paymentRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }
}
