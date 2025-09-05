class WelcomeNotifyRequest {
  String? contactKey;
  String? eventDefinitionKey;
  String? superAppId;
  String? ucic;
  String? sfmcDeviceId;
  String? smsStatus;
  String? emailStatus;
  String? pushNotificationStatus;
  String? whatsappStatus;
  String? notificationCategory;
  String? loginType;
  String? cta;
  String? smsRedirectUrl;
  String? emailRedirectUrl;
  String? pushRedirectUrl;
  String? mobileNumber;
  String? emailId;
  String? name;
  String? lan;
  bool? registrationStatusFlag;
  String? registrationTime;
  String? registrationDate;

  WelcomeNotifyRequest({
    this.contactKey,
      this.eventDefinitionKey,
      this.superAppId,
      this.ucic,
      this.sfmcDeviceId,
      this.smsStatus,
      this.emailStatus,
      this.pushNotificationStatus,
      this.whatsappStatus,
      this.notificationCategory,
      this.loginType,
      this.cta,
      this.smsRedirectUrl,
      this.emailRedirectUrl,
      this.pushRedirectUrl,
      this.mobileNumber,
      this.emailId,
      this.name,
      this.lan,
      this.registrationStatusFlag,
      this.registrationTime,
      this.registrationDate,
  });

   WelcomeNotifyRequest.fromJson(Map<String, dynamic> json) {
    contactKey = json['contactKey'];
    eventDefinitionKey = json['eventDefinitionKey'];
    superAppId = json['superAppId'];
    ucic = json['ucic'];
    sfmcDeviceId = json['sfmcDeviceId'];
    smsStatus = json['smsStatus'];
    emailStatus = json['emailStatus'];
    pushNotificationStatus = json['pushNotificationStatus'];
    whatsappStatus = json['whatsappStatus'];
    notificationCategory = json['notificationCategory'];
    loginType = json['loginType'];
    cta = json['cta'];
    smsRedirectUrl = json['smsRedirectUrl'];
    emailRedirectUrl = json['emailRedirectUrl'];
    pushRedirectUrl = json['pushRedirectUrl'];
    mobileNumber = json['mobileNumber'];
    emailId = json['emailId'];
    name = json['name'];
    lan = json['lan'];
    registrationStatusFlag = json['registrationStatusFlag'];
    registrationTime = json['registrationTime'];
    registrationDate = json['registrationDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['contactKey'] = contactKey;
    data['eventDefinitionKey'] = eventDefinitionKey;
    data['superAppId'] = superAppId;
    data['ucic'] = ucic;
    data['sfmcDeviceId'] = sfmcDeviceId;
    data['smsStatus'] = smsStatus;
    data['emailStatus'] = emailStatus;
    data['pushNotificationStatus'] = pushNotificationStatus;
    data['whatsappStatus'] = whatsappStatus;
    data['notificationCategory'] = notificationCategory;
    data['loginType'] = loginType;
    data['cta'] = cta;
    data['smsRedirectUrl'] = smsRedirectUrl;
    data['emailRedirectUrl'] = emailRedirectUrl;
    data['pushRedirectUrl'] = pushRedirectUrl;
    data['mobileNumber'] = mobileNumber;
    data['emailId'] = emailId;
    data['name'] = name;
    data['lan'] = lan;
    data['registrationStatusFlag'] = registrationStatusFlag;
    data['registrationTime'] = registrationTime;
    data['registrationDate'] = registrationDate;
    return data;
  }
}
