import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/Strings.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:product/data/models/product_feature_response.dart';
import 'package:product/presentation/utils/emi_calculation.dart';

class EmiCalculator extends StatefulWidget {
  const EmiCalculator(this.emiDetails, {super.key});

  final EmiDetails emiDetails;

  @override
  State<EmiCalculator> createState() => _EmiCalculatorState();
}

class _EmiCalculatorState extends State<EmiCalculator> {
  double sliderval1 = 100000;
  double slidervalMin = 100000;
  double slidervalMax = 2500000;
  double sliderval2 = 6;
  double sliderval3 = 12;
  final double _interval = 50000;

  RangeValues range = const RangeValues(100000, 2500000);

  double loanamountsliderval = 1;
  double interestRatesliderval = 1;
  double loanTenuresliderval = 1;

  double emi = 976;

  int tenure = 0;
  double totalAmount = 140522;
  double totalInterest = 0.0;

  @override
  Widget build(BuildContext context) {
    return _buildEMICalculator(context);
  }

  Widget _buildEMICalculator(BuildContext context) {
    return Column(
      children: [
        _buildFrame(
          context,
          measurement: getString(lblProductFeatureLoanAmount),
          measurement1: "₹${sliderval1.toInt()}",
        ),
        SizedBox(
          height: 8.v,
        ),
        SliderTheme(
          data: SliderThemeData(
            overlayShape: RoundSliderOverlayShape(overlayRadius: 8.h),
            trackShape: const RoundedRectSliderTrackShape(),
            activeTrackColor: Theme.of(context).highlightColor,
            inactiveTrackColor: AppColors.sliderColor,
            thumbColor: Theme.of(context).highlightColor,
            thumbShape: const RoundSliderThumbShape(),
            inactiveTickMarkColor: Colors.transparent,
          ),
          child: Slider(
            value: sliderval1,
            min: slidervalMin,
            max: slidervalMax,
            divisions: (slidervalMax - slidervalMin) ~/ _interval,
            onChangeEnd: (value) {
              setState(() {
                loanamountsliderval = (value / _interval).round() * _interval;
                sliderval1 = (value / _interval).round() * _interval;
              });
            },
            onChanged: (value) {
              setState(() {
                loanamountsliderval = value.roundToDouble();
                sliderval1 = value.roundToDouble();

                double principal = sliderval1;
                double rate = sliderval2;
                double periodInMonths = sliderval3;

                tenure = ((0 * 12) + periodInMonths).toInt();

                emi = EmiCalculation.calculateEMI(principal, rate, tenure);

                totalAmount = EmiCalculation.calculateTotalAmount(emi, tenure);

                totalInterest = EmiCalculation.calculateTotalInterest(
                    principal, totalAmount);
              });
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 10.h,
            top: 3.v,
          ),
          child: Row(
            children: [
              Text(
                widget.emiDetails.minLoanAmount.toString(),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontSize: 11.adaptSize,
                    fontWeight: FontWeight.w400),
              ),
              Padding(
                padding: EdgeInsets.only(left: 272.h),
                child: Text(
                  widget.emiDetails.maxLoanAmount.toString(),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontSize: 11.adaptSize,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 22.v),
        _buildFrame(
          context,
          measurement: getString(rateOfInterest),
          measurement1: "${sliderval2.toInt()}%",
        ),
        SizedBox(
          height: 8.v,
        ),
        SliderTheme(
          data: SliderThemeData(
            overlayShape: RoundSliderOverlayShape(overlayRadius: 8.h),
            trackShape: const RoundedRectSliderTrackShape(),
            activeTrackColor: Theme.of(context).highlightColor,
            inactiveTrackColor: AppColors.sliderColor,
            thumbColor: Theme.of(context).highlightColor,
            thumbShape: const RoundSliderThumbShape(),
          ),
          child: Slider(
            value: sliderval2,
            min: 6,
            max: 26,
            onChanged: (value) {
              setState(() {
                interestRatesliderval = value.roundToDouble();
                sliderval2 = value.roundToDouble();

                double principal = sliderval1;
                double rate = sliderval2;

                double periodInMonths = sliderval3;

                tenure = ((0 * 12) + periodInMonths).toInt();

                emi = EmiCalculation.calculateEMI(principal, rate, tenure);

                totalAmount = EmiCalculation.calculateTotalAmount(emi, tenure);

                totalInterest = EmiCalculation.calculateTotalInterest(
                    principal, totalAmount);
              });
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 8.h,
            top: 3.v,
          ),
          child: Row(
            children: [
              Text(
                widget.emiDetails.minRateOfInterest.toString(),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontSize: 11.adaptSize,
                    fontWeight: FontWeight.w400),
              ),
              Padding(
                padding: EdgeInsets.only(left: 280.h),
                child: Text(
                  widget.emiDetails.maxRateOfInterest.toString(),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontSize: 11.adaptSize,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 22.v),
        _buildFrame(
          context,
          measurement: getString(lblProductFeatureTenure),
          measurement1: "${sliderval3.toInt()}",
        ),
        SizedBox(
          height: 8.v,
        ),
        SliderTheme(
          data: SliderThemeData(
            overlayShape: RoundSliderOverlayShape(overlayRadius: 8.h),
            trackShape: const RoundedRectSliderTrackShape(),
            activeTrackColor: Theme.of(context).highlightColor,
            inactiveTrackColor: AppColors.sliderColor,
            thumbColor: Theme.of(context).highlightColor,
            thumbShape: const RoundSliderThumbShape(),
          ),
          child: Slider(
            value: sliderval3,
            min: 12,
            max: 60,
            onChanged: (value) {
              setState(() {
                loanTenuresliderval = value;
                sliderval3 = value;
                double principal = sliderval1;
                double rate = sliderval2;

                double periodInMonths = sliderval3;

                tenure = ((0 * 12) + periodInMonths).toInt();

                emi = EmiCalculation.calculateEMI(principal, rate, tenure);

                totalAmount = EmiCalculation.calculateTotalAmount(emi, tenure);

                totalInterest = EmiCalculation.calculateTotalInterest(
                    principal, totalAmount);
              });
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 8.h,
            top: 3.v,
          ),
          child: Row(
            children: [
              Text(
                widget.emiDetails.minTenure.toString(),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontSize: 11.adaptSize,
                    fontWeight: FontWeight.w400),
              ),
              Padding(
                padding: EdgeInsets.only(left: 292.h),
                child: Text(
                  widget.emiDetails.maxTenure.toString(),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontSize: 11.adaptSize,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 19.v),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 1.v),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getString(principalAmount),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 5.v),
                  Text(
                    "₹${sliderval1.toStringAsFixed(2)}",
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getString(lblProductFeatureTotalAmount),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 6.v),
                  Text(
                    "₹${totalAmount.roundToDouble().toStringAsFixed(2)}",
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10.v),
        const Divider(
          thickness: 0.5,
          color: AppColors.sliderColor,
        ),
        SizedBox(height: 10.v),
        _buildFrame(
          context,
          measurement: getString(lblProductFeatureMonthlyEmi),
          measurement1: "₹${emi.roundToDouble().toStringAsFixed(2)}",
        ),
      ],
    );
  }

  Widget _buildFrame(
    BuildContext context, {
    required String measurement,
    required String measurement1,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          measurement,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600),
        ),
        Text(
          measurement1,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
