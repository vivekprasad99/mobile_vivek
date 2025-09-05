// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
sealed class PaymentWebViewState extends Equatable {}

final class PaymentWebViewInitial extends PaymentWebViewState {
  @override
  List<Object?> get props => [];
}


class PaymentErrorState extends PaymentWebViewState {
  final bool showError;

  PaymentErrorState({required this.showError});

  @override
  List<Object?> get props => [showError];
}
