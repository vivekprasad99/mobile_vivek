enum LeadType { pl, mibl, vl, sme, fd, rhl }

extension LeadTypeExtension on LeadType {
  String get value {
    switch (this) {
      case LeadType.pl:
        return 'PL';
      case LeadType.mibl:
        return 'MIBL';
      case LeadType.vl:
        return 'common';
      case LeadType.sme:
        return 'SME';
      case LeadType.fd:
        return "FD";
      case LeadType.rhl:
        return "RHL";
      default:
        return 'common';
    }
  }
}
