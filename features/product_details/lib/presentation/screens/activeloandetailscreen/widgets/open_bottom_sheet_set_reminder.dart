import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:product_details/data/models/active_loan_detail_response.dart';
import 'package:product_details/data/models/set_payemnt_reminder_request.dart';
import 'package:product_details/presentation/cubit/product_details_cubit.dart';
import 'package:product_details/utils/date_time_convert.dart';
import 'package:intl/intl.dart';

// ignore_for_file: must_be_immutable
final today = DateUtils.dateOnly(DateTime.now());

class OptionTenBottomsheet extends StatefulWidget {
  OptionTenBottomsheet({super.key, this.basicDetailsResponse});

  BasicDetailsResponse? basicDetailsResponse;

  @override
  State<OptionTenBottomsheet> createState() => _OptionTenBottomsheetState();
}

class _OptionTenBottomsheetState extends State<OptionTenBottomsheet> {
  List<DateTime?> _multiDatePickerValueWithDefaultValue = [];

  var hour = 10;
  var minute = 0;
  var timeFormat = "AM";

  var timeFormatSet = "PM";

  String remiderDurationType = "2 Days";

  DateTime? dateBeforeTwoDays;

  DateTime? dateTime;

  @override
  void initState() {
    super.initState();
    dateBeforeTwoDays = ConvertDateTime.getDateBeforeTwoDays(
        widget.basicDetailsResponse?.nextDueDate.toString());
    DateFormat dateFormat = DateFormat('yyyy-MM-dd hh:mm:ss a');
    dateTime =
        dateFormat.parse(widget.basicDetailsResponse!.nextDueDate.toString());
    _multiDatePickerValueWithDefaultValue.add(
      DateTime(dateTime!.year, dateTime!.month, dateTime!.day),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.h,
          vertical: 16.v,
        ),
        decoration: BoxDecoration(
          color: setColorBasedOnTheme(
              context: context,
              lightColor: AppColors.backgroundLight5,
              darkColor: AppColors.cardDark),
          borderRadius:BorderRadius.vertical(
            top: Radius.circular(28.h),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 2.v),
            Text(getString(lblSetReminderProductDetail),
                style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 17.v),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildToggleButton(0, getString(lbl_2_days)),
                buildToggleButton(1, getString(lbl_3_days)),
                buildToggleButton(2, getString(lbl_custom)),
              ],
            ),
            SizedBox(height: 17.v),
            Text(
                "before your due date ${ConvertDateTime.convert(widget.basicDetailsResponse!.nextDueDate.toString())}?",
                style: Theme.of(context).textTheme.labelMedium),
            selectedIndex == 2 ? SizedBox(height: 17.v) : Container(),
            selectedIndex == 2
                ? Text(getString(msg_choose_a_reminder),
                    style: Theme.of(context).textTheme.bodyMedium)
                : Container(),
            selectedIndex == 2 ? SizedBox(height: 10.v) : Container(),
            selectedIndex == 2
                ? _buildDefaultMultiDatePickerWithValue()
                : Container(),
            selectedIndex == 2
                ? Text(getString(lbl_reminder_time),
                    style: Theme.of(context).textTheme.bodyMedium)
                : Container(),
            selectedIndex == 2 ? SizedBox(height: 17.v) : Container(),
            selectedIndex == 2
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          timeFormat = "AM";
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 44.v, vertical: 16.v),
                        decoration: BoxDecoration(
                          color: brightness == Brightness.light
                              ? AppColors.primaryLight6
                              : AppColors.shadowDark,
                          borderRadius:  BorderRadius.circular(9),
                        ),
                        child: Text(hour.toString().padLeft(2, '0'),
                            style: Theme.of(context).textTheme.bodyMedium),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          timeFormat = "AM";
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 44.v, vertical: 16.v),
                        decoration: BoxDecoration(
                          color: brightness == Brightness.light
                              ? AppColors.primaryLight6
                              : AppColors.shadowDark,
                          borderRadius:  BorderRadius.circular(9),
                        ),
                        child: Text(minute.toString().padLeft(2, '0'),
                            style: Theme.of(context).textTheme.bodyMedium),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          timeFormat = "AM";
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 44.v, vertical: 16.v),
                        decoration: BoxDecoration(
                          color: brightness == Brightness.light
                              ? AppColors.primaryLight6
                              : AppColors.shadowDark,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Text(
                            timeFormat.toString().padLeft(2, '0'),
                            style: Theme.of(context).textTheme.bodyMedium),
                      ),
                    ),
                  ],
                )
                : Container(),
            selectedIndex == 2
                ? Container(
                    height: 60.v,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 16.v),
                          alignment: Alignment.topCenter,
                          child: NumberPicker(
                            minValue: 0,
                            maxValue: 23,
                            value: hour,
                            itemCount: 1,
                            zeroPad: true,
                            infiniteLoop: false,
                            itemWidth: 80,
                            itemHeight: 60.v,
                            onChanged: (value) {
                              setState(() {
                                hour = value;
                              });
                            },
                            textStyle: Theme.of(context).textTheme.bodyMedium,
                            selectedTextStyle:
                                Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.only(right: 36.v),
                            alignment: Alignment.topCenter,
                            child: NumberPicker(
                                minValue: 0,
                                maxValue: 59,
                                value: minute,
                                zeroPad: true,
                                itemCount: 1,
                                step: 15,
                                infiniteLoop: true,
                                itemWidth: 80,
                                itemHeight: 60.v,
                                onChanged: (value) {
                                  setState(() {
                                    minute = value;
                                  });
                                },
                                textStyle:
                                    Theme.of(context).textTheme.bodyMedium,
                                selectedTextStyle:
                                    Theme.of(context).textTheme.bodyMedium)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (timeFormat == "PM") {
                                    timeFormat = "AM";
                                    timeFormatSet = "PM";
                                  } else {
                                    timeFormat = "PM";
                                    timeFormatSet = "AM";
                                  }
                                  // timeFormat = "PM";
                                  // timeFormatSet = "AM";
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 40.v),
                                child: Text(timeFormatSet.toString(),
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                : Container(),
            SizedBox(height: 33.v),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).cardColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      side: BorderSide(
                                          color: brightness == Brightness.light
                                              ? AppColors.secondaryLight
                                              : AppColors.secondaryLight5)))),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(getString(lblCancel),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: brightness == Brightness.light
                                      ? AppColors.secondaryLight
                                      : AppColors.secondaryLight5))),
                ),
                SizedBox(
                  width: 16.v,
                ),
                Expanded(
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).highlightColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      side: BorderSide(
                                          color: Theme.of(context)
                                              .highlightColor)))),
                      onPressed: () {
                        List<Reminders> reminders = [];
                        reminders.add(Reminders(
                            reminderDurationType: remiderDurationType,
                            date: dateBeforeTwoDays.toString(),
                            time: "10:00:00 AM"));
                        SetPaymentReminderRequest request =
                            SetPaymentReminderRequest(
                                loanId: widget.basicDetailsResponse?.loanId,
                                loanNumber: widget.basicDetailsResponse?.loanId,
                                ucic: widget.basicDetailsResponse?.uCIC
                                    .toString(),
                                mobileNumber: widget
                                    .basicDetailsResponse?.mobileNumber
                                    .toString(),
                                deviceId: "",
                                sourceSystem:
                                    widget.basicDetailsResponse?.sourceSystem,
                                reminder: reminders);

                        BlocProvider.of<ProductDetailsCubit>(context)
                            .setPaymentReminders(request);
                      },
                      child: Text(getString(lbl_set),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppColors.white))),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  int selectedIndex = 0;

  Widget buildToggleButton(int index, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: SizedBox(
        width: 100,
        height: 35,
        child: TextButton(
          onPressed: () {
            setState(() {
              selectedIndex = index;
              if (selectedIndex == 0) {
                remiderDurationType = "2 Days";
              } else if (selectedIndex == 0) {
                remiderDurationType = "3 Days";
              } else {
                remiderDurationType = "Custom";
              }
            });
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              selectedIndex == index
                  ? setColorBasedOnTheme(
                      context: context,
                      lightColor: AppColors.secondaryLight,
                      darkColor: AppColors.secondaryLight5)
                  : setColorBasedOnTheme(
                      context: context,
                      lightColor: Colors.white,
                      darkColor: Colors.transparent),
            ),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(
                  color: setColorBasedOnTheme(
                      context: context,
                      lightColor: AppColors.secondaryLight,
                      darkColor: AppColors.secondaryLight5),
                  width: selectedIndex == index ? 0 : 1,
                ),
              ),
            ),
          ),
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: selectedIndex == index
                      ? setColorBasedOnTheme(
                          context: context,
                          lightColor: AppColors.white,
                          darkColor: AppColors.cardDark)
                      : setColorBasedOnTheme(
                          context: context,
                          lightColor: AppColors.secondaryLight,
                          darkColor: AppColors.secondaryLight5),
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultMultiDatePickerWithValue() {
    final config = CalendarDatePicker2Config(
        calendarType: CalendarDatePicker2Type.single,
        lastDate: DateTime(dateTime!.year, dateTime!.month, dateTime!.day),
        selectedDayHighlightColor: setColorBasedOnTheme(
            context: context,
            lightColor: AppColors.primaryLight,
            darkColor: AppColors.secondaryLight5),
        weekdayLabelTextStyle: Theme.of(context).textTheme.bodyMedium,
        dayTextStyle: Theme.of(context).textTheme.bodyMedium,
        controlsTextStyle: Theme.of(context).textTheme.bodyMedium);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CalendarDatePicker2(
          config: config,
          value: _multiDatePickerValueWithDefaultValue,
          onValueChanged: (dates) => setState(() {
            _multiDatePickerValueWithDefaultValue = dates;
          }),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
