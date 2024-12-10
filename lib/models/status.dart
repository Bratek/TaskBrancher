enum Status { none, inprogress, verify, completed, calceled, hidden }

extension StatusExtension on Status {
  String get title {
    switch (this) {
      case Status.none:
        return "НОВАЯ";
      case Status.inprogress:
        return "В РАБОТЕ";
      case Status.verify:
        return "НА ПРОВЕРКЕ";
      case Status.completed:
        return "ЗАВЕРШЕНА";
      case Status.calceled:
        return "ОТМЕНЕНА";
      case Status.hidden:
        return "СКРЫТА";
    }
  }

  Status get nextStatus {
    switch (this) {
      case Status.none:
        return Status.inprogress;
      case Status.inprogress:
        return Status.verify;
      case Status.verify:
        return Status.completed;
      case Status.completed:
        return Status.hidden;
      case Status.calceled:
        return Status.hidden;
      case Status.hidden:
        return Status.hidden;
    }
  }

  String get nextStatusButtonText {
    switch (this) {
      case Status.none:
        return "В РАБОТУ";
      case Status.inprogress:
        return "НА ПРОВЕРКУ";
      case Status.verify:
        return "ЗАВЕРШИТЬ";
      case Status.completed:
        return "СКРЫТЬ";
      case Status.calceled:
        return "СКРЫТЬ";
      case Status.hidden:
        return "В НОВЫЕ";
    }
  }

  String get columnStatusText {
    switch (this) {
      case Status.none:
        return "НОВЫЕ";
      case Status.inprogress:
        return "В РАБОТЕ";
      case Status.verify:
        return "НА ПРОВЕРКЕ";
      case Status.completed:
        return "ЗАВЕРШЕННЫЕ";
      case Status.calceled:
        return "ОТМЕНЕННЫЕ";
      case Status.hidden:
        return "СКРЫТЫЕ";
    }
  }
}
