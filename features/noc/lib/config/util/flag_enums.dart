enum DeliveryFlags{branch,permanent,current }

 extension LeadTypeExtension on DeliveryFlags {
  String get value {
    switch (this) {
      case DeliveryFlags.branch:
        return 'B';
      case DeliveryFlags.permanent:
        return 'P';
      case DeliveryFlags.current:
        return 'C';
      default:
        return 'O';
    }
  }
}

enum nocStatusString{print,entry,cancelled}
 extension NocExtension on nocStatusString {
  String get value {
    switch (this) {
      case nocStatusString.print:
        return 'Print';
      case nocStatusString.entry:
        return 'Entry';
      case nocStatusString.cancelled:
        return 'Cancelled';
      default:
        return '';
    }
  }
}

enum nocDeliveryAddress{Branch,Permanent,Communication}
 extension nocDeliveryExtension on nocDeliveryAddress {
  String get value {
    switch (this) {
      case nocDeliveryAddress.Branch:
        return 'Deliver to Branch';
      case nocDeliveryAddress.Permanent:
        return 'Deliver to Permanent Address';
      case nocDeliveryAddress.Communication:
        return 'Deliver to Communication Address';
      default:
        return '';
    }
  }
}